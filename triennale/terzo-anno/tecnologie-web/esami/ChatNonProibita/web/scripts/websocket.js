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
