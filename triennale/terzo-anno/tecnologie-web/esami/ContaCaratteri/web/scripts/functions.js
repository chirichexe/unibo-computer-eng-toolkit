const  numTimes = 3;

async function sendFile() {
    const fileInput1 = document.getElementById("fileInput1");
    const fileInput2 = document.getElementById("fileInput2");
    const resultDiv = document.getElementById("result");
    
    let maiuscolefile1 = 0;
    let maiuscolefile2 = 0;
    let minuscolefile1 = 0;
    let minuscolefile2 = 0;

    if (fileInput1.files.length === 0 || fileInput2.files.length === 0) {
        resultDiv.innerHTML = "Per favore, seleziona un file.";
        return;
    }

    const file1 = fileInput1.files[0];
    const file2 = fileInput2.files[0];

    try {
        // Leggi i file in parallelo
        const [file1Content, file2Content] = await Promise.all([
            readFileAsText(file1),
            readFileAsText(file2),
        ]);

        // Dividi il contenuto
        const file1parts = divideText(file1Content, numTimes);
        const file2parts = divideText(file2Content, numTimes);

        // Invia le parti al server
        for (let i = 0; i < numTimes; i++) {
            const body = JSON.stringify({
                file1part: file1parts[i],
                file2part: file2parts[i],
                requestId: i,
            });

            await fetch("TXTServlet", {
                method: "POST",
                body: body,
            })
                .then((response) => response.json())
                .then((data) => {
                    console.log("Risposta dal server:", data);
                    maiuscolefile1 += data.maiuscole1;
                    maiuscolefile2 += data.maiuscole2;
                    minuscolefile1 += data.minuscole1;
                    minuscolefile2 += data.minuscole2;
                })
                .catch((error) => {
                    console.error("Errore durante l'invio dei dati:", error);
                    resultDiv.innerText = "Errore durante l'invio dei dati.";
                });
        }
    } catch (error) {
        console.error("Errore:", error);
        resultDiv.innerText = "Errore durante la lettura dei file.";
    }
    
    resultDiv.innerText = "Risultato: Maiuscole totali file1: " + maiuscolefile1 + 
    					"\nMinuscole totali file1" + minuscolefile1 + 
    					"\nMaiuscole totali file2" + maiuscolefile2 + 
    					"\nMinuscole totali file2" + minuscolefile2;
}

// Funzione helper per leggere un file come testo
function readFileAsText(file) {
    return new Promise((resolve, reject) => {
        const reader = new FileReader();
        reader.onload = (event) => resolve(event.target.result);
        reader.onerror = (error) => reject(error);
        reader.readAsText(file);
    });
}

// Funzione per dividere il testo
function divideText(fileText, numParts) {
    const chunkSize = Math.ceil(fileText.length / numParts);
    const chunks = [];
    for (let i = 0; i < numParts; i++) {
        chunks.push(fileText.slice(i * chunkSize, (i + 1) * chunkSize));
    }
    return chunks;
}
