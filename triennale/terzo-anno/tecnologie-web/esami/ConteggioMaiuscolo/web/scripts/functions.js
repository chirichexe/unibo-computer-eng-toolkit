// prende una funzione al cambio di input
const input = document.getElementById('nomeFile');
input.addEventListener('input', () => {
	console.log(input.value);
	if (input.value.includes('%')){
		document.getElementById('fileForm').submit();
	}
});

