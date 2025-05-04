function getCarrello(carrelloId){
    const carrelloDiv = document.getElementById("carrello");

    // Costruzione dell'URL con il parametro query string
    const url = "carrelloServlet?idCarrello=" + encodeURIComponent(carrelloId);

    fetch(url, {
        method: "GET",
    })
    .then(response => response.text())
    .then(data => {
        console.log("Risposta dal server:", data);
        carrelloDiv.innerHTML = data;
    })
    .catch(error => {
        console.error("Errore durante l'invio dei dati:", error);
    });
}

function getCarrelloEditabile(carrelloId){
    const carrelloDiv = document.getElementById("carrello");

    // Costruzione dell'URL con il parametro query string
    const url = "carrelloServlet?idCarrello=" + encodeURIComponent(carrelloId);

    fetch(url, {
        method: "GET",
    })
    .then(response => response.json()) // Supponendo che la risposta sia in formato JSON
    .then(data => {
        console.log("Risposta dal server:", data);
        
        // Costruzione dell'HTML per ogni elemento del carrello
        let carrelloHTML = '';
        data.forEach(item => {
            carrelloHTML += `
                <div class="carrello-item">
                    <span>${item}</span>
                </div>
            `;
        });

        // Aggiungi il carrelloHTML alla div "carrello"
        carrelloDiv.innerHTML = carrelloHTML;
    })
    .catch(error => {
        console.error("Errore durante l'invio dei dati:", error);
    });
}


function sendWithAjax() {
    // Ottieni i valori di A, B e il file
    const a = document.getElementById("A").value;
    const b = document.getElementById("B").value;
    const fileInput = document.getElementById("fileInput");
    const file = fileInput.files[0];
    const resultDiv = document.getElementById("result");
    
    // Stampa i valori
    console.log("A:", a, "B:", b, "File:", file);

    if (fileInput.files.length === 0) {
        resultDiv.innerHTML = "Per favore, seleziona un file.";
        return;
    }

    // Usa FileReader per leggere il contenuto del file
    const reader = new FileReader();
    reader.onload = function (event) {
        try {
            const fileContent = JSON.parse(event.target.result); // Analizza il contenuto come JSON

            // Accedi ai campi "matrix1" e "matrix2"
            const matrix1 = fileContent.matrix1;
            const matrix2 = fileContent.matrix2;

            console.log("Matrix1:", matrix1);
            console.log("Matrix2:", matrix2);

            // Converte l'intero JSON in stringa per inviarlo
            const fileContentString = JSON.stringify(fileContent);

            // Invia i dati al backend
			const payload = {
			    fileContent: fileContentString,
			    A: a,
			    B: b
			};
            
            fetch("matrixServlet", {
                method: "POST",
                headers: {
    				"Content-Type": "application/json"
				},
                body: JSON.stringify(payload)
            })
            .then(response => response.json())
            .then(data => {
                console.log("Risposta dal server:", data);
                resultDiv.innerText = JSON.stringify(data);
            })
            .catch(error => {
                console.error("Errore durante l'invio dei dati:", error);
                resultDiv.innerText = "Errore durante l'invio dei dati.";
            });
                
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

