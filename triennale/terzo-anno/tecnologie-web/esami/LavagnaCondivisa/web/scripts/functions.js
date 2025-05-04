
function fetchLavagna(){
    fetch("dataServlet", {
        method: "GET",
    })
    .then(response => response.text())
    .then(data => {
        console.log("Risposta dal server:", data);
        document.getElementById('spazioLavagna').innerHTML = data;
    })
    .catch(error => {
        console.error("Errore durante l'invio dei dati:", error);
    });
}

