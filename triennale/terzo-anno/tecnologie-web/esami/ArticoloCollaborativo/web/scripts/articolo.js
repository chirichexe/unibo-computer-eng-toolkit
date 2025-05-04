const articolo = document.getElementById('articoloText');
articolo.addEventListener('input', () => {
	const url = "dataServlet?text=" + articolo.value;
	fetch(url, {
        method: "GET"
    })
    .catch(error => {
        console.error("Errore durante l'invio dei dati:", error);
        resultDiv.innerText = "Errore durante l'invio dei dati.";
    });
});

function handleModifica(flag){
	const url = "dataServlet?flag=" + flag;
	fetch(url, {
        method: "GET"
    })
    .then(response => response.text())
    .then(data => {
        console.log("Risposta dal server:", data);
        if (data === "false" || data === ""){
			articolo.disabled = true;
		} else {
			articolo.disabled = false;
		}
    })
    .catch(error => {
        console.error("Errore durante l'invio dei dati:", error);
        resultDiv.innerText = "Errore durante l'invio dei dati.";
    });
}
