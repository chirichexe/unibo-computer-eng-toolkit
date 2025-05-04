const numTimes = 2;

function sendFile() {
    const fileInput = document.getElementById("fileInput");
    const file = fileInput.files[0];
    const resultDiv = document.getElementById("result");

    if (fileInput.files.length === 0) {
        resultDiv.innerHTML = "Per favore, seleziona un file.";
        return;
    }

    // Usa FileReader per leggere il contenuto del file
    const reader = new FileReader();
    reader.onload = async function (event) {
        try {
			let a = 0;
			let b = 0;
			let occorrenze = 0;
			
            // Analizza il contenuto come JSON
            const fileContent = JSON.parse(event.target.result);

            // Divido il contenuto in 2 parti
            const contentChunks = divideJSON(fileContent, numTimes);
            
            // Inizializzo il testo
            resultDiv.innerHTML = "Risultato: ";

            // Invia le parti delle matrici tramite AJAX
            for (let i = 0; i < numTimes; i++) {
                // Preparo il corpo del messaggio con le parti delle matrici
                const body = JSON.stringify({
                    contentPart: contentChunks[i],
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
                    occorrenze += parseInt(data);
                    if (i === 0){
						a = data;
					} else if ( i === 1 ){
						b = data;
						resultDiv.innerHTML = "Sono state trovae " +  a + " + " + b + " = " + occorrenze + "occorrenze di Ugo Bassi negli indirizzi"
					}
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

// Funzione per dividere un json in parti uguali (approssimativamente)
function divideJSON(content, numParts) {
    const chunkSize = Math.ceil(content.length / numParts);
    const chunks = [];
    for (let i = 0; i < numParts; i++) {
        chunks.push(content.slice(i * chunkSize, (i + 1) * chunkSize));
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
