const numTimes = 2;

function sendFile() {
	const n = document.getElementById('n').value;
    const fileInput = document.getElementById("fileInput");
    const file = fileInput.files[0];
    const resultDiv = document.getElementById("result");
	let max = null;
	let min = null;
	let completedRequests = 0;
    
    if (n <= 100){
        resultDiv.innerHTML = "La dimensione deve essere > 100.";
        return;
	}

    if (fileInput.files.length === 0) {
        resultDiv.innerHTML = "Per favore, seleziona un file.";
        return;
    }

    // Usa FileReader per leggere il contenuto del file
    const reader = new FileReader();
    
    reader.onload = function (event) {
        try {
            // Analizza il contenuto come JSON
            const fileContent = JSON.parse(event.target.result);
            
            // Dichiaro le variabili necessarie

            const matrix = fileContent.matrix

            // Divido entrambe le matrici in 3 parti
            const matrixChunks = divideMatrix(matrix, numTimes);

            // Invia le parti delle matrici tramite AJAX
            for (let i = 0; i < numTimes; i++) {
                // Preparo il corpo del messaggio con le parti delle matrici
                const body = JSON.stringify({
                    matrixPart: matrixChunks[i],
                    n: n
                });

                fetch("JSONServlet", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json"
                    },
                    body: body
                })
                .then(response => response.json())
                .then(data => {
                    // Ottengo la risposta
                    console.log("Risposta dal server:", data);
                    max = max === null ? data.max : Math.max(max, data.max)
                    min = min === null ? data.min : Math.min(min, data.min)
                    
                    completedRequests++;
                    
                    if (completedRequests == 2){
    					resultDiv.innerHTML = `<p>Massimo: ${max} - Minimo : ${min}</p>`;
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
