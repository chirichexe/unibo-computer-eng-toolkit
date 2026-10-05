/*
 * Nome Cognome - Matricola 0000000000
 *
 * Tecnologie Web T - A.A. 2024-2025
 * Template non ufficiale (unibo-computer-eng-toolkit): sostituisci i tuoi dati
 * e verifica che il contenuto sia ancora valido per il tuo anno accademico.
 */

// prende una funzione al cambio di input
const resultDiv = document.getElementById('result');

function richiediPrezzoPersonale(){
	fetch("tavoloServlet", {
    method: "POST",
})
.then(response => response.text())
.then(data => {
    console.log("Risposta dal server:", data);
    resultDiv.innerText = data;
})
.catch(error => {
    console.error("Errore durante l'invio dei dati:", error);
    resultDiv.innerText = "Errore durante l'invio dei dati.";
});
}

function richiediPrezzoTavolo(){
	fetch("tavoloServlet", {
    method: "GET"
})
.then(response => response.text())
.then(data => {
    console.log("Risposta dal server:", data);
    resultDiv.innerText = data;
})
.catch(error => {
    console.error("Errore durante l'invio dei dati:", error);
    resultDiv.innerText = "Errore durante l'invio dei dati.";
});
}


