/*
 * Nome Cognome - Matricola 0000000000
 *
 * Tecnologie Web T - A.A. 2024-2025
 * Template non ufficiale (unibo-computer-eng-toolkit): sostituisci i tuoi dati
 * e verifica che il contenuto sia ancora valido per il tuo anno accademico.
 */

// prende una funzione al cambio di input
const input = document.getElementById('userText');
input.addEventListener('input', () => {
	console.log(input.value);
	if (input.value.length > 64){
		console.error("Troppo grande");
		return;
	}
	if (input.value.includes('%')){
		document.getElementById('textForm').submit();
	}
});