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
