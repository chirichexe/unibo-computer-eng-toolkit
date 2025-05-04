const socket = new WebSocket("ws://localhost:8080/DispositiviIOT/actions");
const dati = [];

// Misurazione mock di dati ogni n secondi
const intervalDuration = 10 * 1000;

let interval = setInterval(() => {
	const dato = Math.round((Math.random() * 10) + 15);
	
	// lo aggiungo alla lista e ne calcolo la media
	dati.push(dato);
	console.log("Nuovo dato: ", dato, dati.length, dati.indexOf(0));
	
	let datiSum = 0;
	dati.forEach((el) => {
		datiSum += el;
	})
	let media = (datiSum / dati.length);
	
	document.getElementById("status").innerHTML = "<h2>Dati misurati:</h2>" + dati + ", media dati attuali:  " + media;
	socket.send(JSON.stringify({ type: "misuration", dato: dato, media: media }));
	
}, intervalDuration);

// Ricezione dati dalla socket
socket.onmessage = function (event) {
    document.getElementById("globalStatus").innerHTML = "<h2>Media dati da tutti i dispositivi: </h2>" + event.data;
}

// metodo admin
function handleDisattiva(){
	const id = document.getElementById("dispositivo").value;
	socket.send(JSON.stringify({ type: "disattiva", id: id }));
}
