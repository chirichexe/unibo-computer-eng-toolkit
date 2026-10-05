/*
 * Nome Cognome - Matricola 0000000000
 *
 * Tecnologie Web T - A.A. 2024-2025
 * Template non ufficiale: sostituisci i tuoi dati
 * e verifica che il contenuto sia ancora valido per il tuo anno accademico.
 */

const socket = new WebSocket("ws://localhost:8080/ChatNonProibita/actions");

// Ricezione dati dalla socket
socket.onmessage = function (event) {
    const data = JSON.parse(event.data);
    if (data.type === "load") {
    	document.getElementById("chat").innerHTML = data.chat;
	} else if (data.type === "receivedMessage") {
		document.getElementById("chat").innerHTML += `<li>${data.message}</li>`;
	}
};

// Invio dati alla socket
function actionHandler() {
	const message = document.getElementById("message").value;
    socket.send(JSON.stringify({ type: "message", message : message }));
}
