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