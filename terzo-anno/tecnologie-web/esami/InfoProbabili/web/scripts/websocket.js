/*
 * Nome Cognome - Matricola 0000000000
 *
 * Tecnologie Web T - A.A. 2024-2025
 * Template non ufficiale: sostituisci i tuoi dati
 * e verifica che il contenuto sia ancora valido per il tuo anno accademico.
 */

const socket = new WebSocket("ws://localhost:8080/InfoProbabili/actions");

// Ricezione dati dalla socket
socket.onmessage = function (event) {
    const data = JSON.parse(event.data);
    console.log(event.data)
    if (data.type === "message") {
    	document.getElementById("conversation").innerHTML += `<li>${data.data}</li>`;
	} else if (data.type === "push") {
		document.getElementById("conversation").innerHTML += `<li>${data.messages}</li>`;
	}
};

// Invio dati alla socket
function actionHandler() {
	const text = document.getElementById("inputArea").value;
	
    socket.send(JSON.stringify({ type: "message", data: text }));
}

// solo admin
function pushHandler() {
   socket.send(JSON.stringify({ type: "push" }));
}
