/*
 * Nome Cognome - Matricola 0000000000
 *
 * Tecnologie Web T - A.A. 2024-2025
 * Template non ufficiale: sostituisci i tuoi dati
 * e verifica che il contenuto sia ancora valido per il tuo anno accademico.
 */

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

