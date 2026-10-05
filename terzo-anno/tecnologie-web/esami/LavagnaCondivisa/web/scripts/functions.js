/*
 * Nome Cognome - Matricola 0000000000
 *
 * Tecnologie Web T - A.A. 2024-2025
 * Template non ufficiale (unibo-computer-eng-toolkit): sostituisci i tuoi dati
 * e verifica che il contenuto sia ancora valido per il tuo anno accademico.
 */

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

