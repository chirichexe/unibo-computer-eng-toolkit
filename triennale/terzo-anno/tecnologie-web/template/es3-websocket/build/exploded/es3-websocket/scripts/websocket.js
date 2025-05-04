const socket = new WebSocket("ws://localhost:8080/es3-websocket/actions");

// Ricezione dati dalla socket
socket.onmessage = function (event) {
    //const data = JSON.parse(event.data);
    //if (data.type === "number") {

    document.getElementById("numbers").innerHTML += `<p>${event.data}</p>`;

};

// Invio dati alla socket
function actionHandler() {
    socket.send(JSON.stringify({ type: "action" }));
}

function leaveHandler() {
   socket.send(JSON.stringify({ type: "leave" }));
}
