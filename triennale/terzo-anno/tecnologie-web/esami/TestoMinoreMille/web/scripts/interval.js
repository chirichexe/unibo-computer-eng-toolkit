// Intervallo dichiarato ogni 1000 millisecondi
const intervalDuration = 1000;

let interval = setInterval(() => {
    const list = document.getElementById("data");
    
    fetch("dataServlet", {
        method: "GET",
    })
    .then(response => response.text())
    .then(data => {
        console.log("Risposta dal server:", data);
        list.innerHTML = data;
    })
    .catch(error => {
        console.error("Errore durante l'invio dei dati:", error);
    });
}, intervalDuration);

