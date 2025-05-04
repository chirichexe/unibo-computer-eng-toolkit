const resultText = document.getElementById('tempo')
// Apertura
const socket = new WebSocket("ws://localhost:8080/UfficioPostale/actions");

// Ricezione dato JSON
socket.onmessage =  function (event){
	console.log(event.data);
	resultText.innerText += event.data;
}

function rinnovoCarta() {
	fetch("dataServlet", {
	    method: "POST",
	    body: new URLSearchParams({ "servizio" : "R" })
	})
	.then(response => response.text())
	.then(data => {
	    console.log("Risposta dal server:", data);
	    resultText.innerText = data;
	})
	.catch(error => {
	    console.error("Errore durante l'invio dei dati:", error);
	    resultText.innerText = "Errore durante l'invio dei dati.";
	});
}

function cambioResidenza() {
	fetch("dataServlet", {
	    method: "POST",
	    body: new URLSearchParams({ "servizio" : "C" })
	})
	.then(response => response.text())
	.then(data => {
	    console.log("Risposta dal server:", data);
	    resultText.innerText = data;
	})
	.catch(error => {
	    console.error("Errore durante l'invio dei dati:", error);
	    resultText.innerText = "Errore durante l'invio dei dati.";
	});
}