// prende una funzione al cambio di input
const inputServlet = document.getElementById('inputServlet');
inputServlet.addEventListener('input', () => {
	
	console.log(inputServlet.value);
	if (inputServlet.value.includes('%%%')){
		
		// invia alla servlet
		sendWithAjax();
	}
});

// Invio dati matrice con ajax
async function sendWithAjax() {
    // Ottieni i valori
    const fileName = document.getElementById("inputServlet").value.replace("%%%", "");
    const resultDiv = document.getElementById("result");
    
    // Stampa i valori
    const payload = {
	    fileName: fileName,
	};
    console.log("File:", payload);
    
    // Li invio alla servlet
    await fetch("S1", {
    	method: "POST",
	    headers: {
			"Content-Type": "application/json"
		},
	    body: JSON.stringify(payload)
    })
    .then(response => response.text())
    .then(data => {
        console.log("Risposta dal server:", data);
        resultDiv.innerText = data;
    })
    .catch(error => {
        console.error("Errore durante l'invio dei dati:", error);
        resultDiv.innerText = "Errore durante l'invio dei dati.";
    });
}

