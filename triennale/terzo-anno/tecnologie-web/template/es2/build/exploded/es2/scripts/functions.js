const numTimes = 3;
const resultDiv = document.getElementById("result");
let risultato = [];

function sendFile() {
    const fileInput = document.getElementById("fileInput");
    const file = fileInput.files[0];

    if (fileInput.files.length === 0) {
        resultDiv.innerHTML = "Per favore, seleziona un file.";
        return;
    }

    // Usa FileReader per leggere il contenuto del file
    const reader = new FileReader();
    reader.onload = async function (event) {
        try {
			
			
            // Analizza il contenuto come JSON
            const fileContent = JSON.parse(event.target.result);
            
            // Dichiaro le variabili necessarie
            const matrix1 = fileContent.matrix1;
            const matrix2 = fileContent.matrix2;

            // Divido entrambe le matrici in 3 parti
            const matrix1Chunks = divideMatrix(matrix1, numTimes);
            const matrix2Chunks = divideMatrix(matrix2, numTimes);
            
            // Inizializzo il testo
            resultDiv.innerHTML = "Risultato: ";

            // Invia le parti delle matrici tramite AJAX
            for (let i = 0; i < numTimes; i++) {
                // Preparo il corpo del messaggio con le parti delle matrici
                const body = JSON.stringify({
                    matrix1Part: matrix1Chunks[i],
                    matrix2Part: matrix2Chunks[i],
                    requestId: i
                });

                await fetch("JSONServlet", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json"
                    },
                    body: body
                })
                .then(response => response.text())
                .then(data => {
                    // Ottengo la risposta
                    console.log("Risposta dal server:", data);
                    resultDiv.innerHTML += data;
                    risultato += parseInt(data);
                })
                .catch(error => {
                    console.error("Errore durante l'invio dei dati:", error);
                    resultDiv.innerText = "Errore durante l'invio dei dati.";
                });
            }
                
        } catch (error) {
            resultDiv.innerHTML = `<p>Errore nel parsing del file JSON: ${error.message}</p>`;
        }
    };

    reader.onerror = function () {
        resultDiv.innerHTML = "<p>Errore nella lettura del file.</p>";
    };

    // Leggi il file come testo
    reader.readAsText(file);
}

// Funzione per dividere una matrice in parti uguali (approssimativamente)
function divideMatrix(matrix, numParts) {
    const chunkSize = Math.ceil(matrix.length / numParts);
    const chunks = [];
    for (let i = 0; i < numParts; i++) {
        chunks.push(matrix.slice(i * chunkSize, (i + 1) * chunkSize));
    }
    return chunks;
}

function mostraElencoRichieste() {
    // Ottieni i valori
    const resultDiv = document.getElementById('elencoRichieste');
            
    fetch("JSONServlet", {
        method: "GET"
    })
    .then(response => response.text())
    .then(data => {
        console.log("Risposta dal server:", data);
        resultDiv.innerText = data;
    })
    .catch(error => {
        console.error("Errore durante l'invio dei dati:", error);
        resultDiv.innerText = "Errore durante la ricerca dei dati.";
    });
}
