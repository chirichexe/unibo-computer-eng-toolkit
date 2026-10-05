/*
 * Nome Cognome - Matricola 0000000000
 *
 * Tecnologie Web T - A.A. 2024-2025
 * Template non ufficiale (unibo-computer-eng-toolkit): sostituisci i tuoi dati
 * e verifica che il contenuto sia ancora valido per il tuo anno accademico.
 */

const articolo = document.getElementById('articoloText');
articolo.addEventListener('input', () => {
	const url = "dataServlet?text=" + articolo.value;
	fetch(url, {
        method: "GET"
    })
    .catch(error => {
        console.error("Errore durante l'invio dei dati:", error);
        resultDiv.innerText = "Errore durante l'invio dei dati.";
    });
});

function handleModifica(flag){
	const url = "dataServlet?flag=" + flag;
	fetch(url, {
        method: "GET"
    })
    .then(response => response.text())
    .then(data => {
        console.log("Risposta dal server:", data);
        if (data === "false" || data === ""){
			articolo.disabled = true;
		} else {
			articolo.disabled = false;
		}
    })
    .catch(error => {
        console.error("Errore durante l'invio dei dati:", error);
        resultDiv.innerText = "Errore durante l'invio dei dati.";
    });
}
