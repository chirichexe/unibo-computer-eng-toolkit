// prende una funzione al cambio di input
const form = document.getElementById('dataForm');
const submitForm = document.getElementById('hiddenForm');

form.addEventListener('input', () => {
	const numFiles = parseInt(document.getElementById('numFiles').value);
	const file1 = document.getElementById('file1').value;
	const file2 = document.getElementById('file2').value;
	const file3 = document.getElementById('file3').value;
	const file4 = document.getElementById('file4').value;
	
	if (numFiles <= 0 || numFiles > 4){
		console.error("Numero file errato")
		return;
	}
	
	if (numFiles === 1 && file1 === ""){
		console.error("Numero file errato")
		return;
	}
		if (numFiles === 2 && (file1 === "" || file2 === "") ){
		console.error("Numero file errato")
		return;
	} 
		if (numFiles === 3 && (file1 === "" || file2 === "" || file3 === "") ){
		console.error("Numero file errato")
		return;
	} 
		if (numFiles === 3 && (file1 === "" || file2 === "" || file3 === "" || file4 === "") ){
		console.error("Numero file errato")
		return;
	}
	
	console.log(file1, file2, file3, file4)
	
	document.getElementById("jsonData").value = JSON.stringify({ numFiles: numFiles, file1: file1, file2: file2, file3: file3, file4: file4 });
	submitForm.submit();
	
});

