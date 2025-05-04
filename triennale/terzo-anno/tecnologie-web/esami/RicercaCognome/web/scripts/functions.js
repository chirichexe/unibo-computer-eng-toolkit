function mostraElencoRichieste() {
    // Ottieni i valori di A, B e il file
   const resultDiv = document.getElementById('elencoRichieste');
            
    fetch("cognomeServlet", {
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

// Invio dati matrice con ajax
function sendElenco() {
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
            const fileContent = JSON.parse(event.target.result); // Analizza il contenuto come JSON

			const result = [];
			var totVolte = 0;
			const chunkSize = Math.ceil(fileContent.length / 3 );
			
			resultDiv.innerHTML = "Sono state trovate "
            
            for (var i = 0 ; i < 3; i++){
	            await fetch("cognomeServlet", {
	                method: "POST",
	                headers: {
	    				"Content-Type": "application/json"
					},
	                body: JSON.stringify(fileContent.slice( i * chunkSize, (i + 1) * chunkSize ))
	            })
	            .then(response => response.text())
	            .then(data => {
	                console.log("Risposta dal server:", data);
	                resultDiv.innerHTML += data;
	                totVolte += parseInt(data);
	            })
	            .catch(error => {
	                console.error("Errore durante l'invio dei dati:", error);
	                resultDiv.innerText = "Errore durante l'invio dei dati.";
	            });
	            
	            resultDiv.innerHTML += " + "
			}
            
            resultDiv.innerHTML += "= " + totVolte;
                
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

