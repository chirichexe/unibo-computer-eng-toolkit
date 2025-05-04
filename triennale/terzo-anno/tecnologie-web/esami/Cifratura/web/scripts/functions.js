const numTimes = 2;
let word = "";
const resultDiv = document.getElementById("result");
let results = [];

const input = document.getElementById('userText');
input.addEventListener('input', () => {
	word = input.value;
	console.log(word)
	if (word.includes('%')){
		word = word.replace('%', "");
		if ( checkData(word)  )
			sendWord();
		else 
			resultDiv.innerText = "Errore: testo sbagliato"
	}
});

function checkData(word){
	let numVocali = 0;
	let numConsonanti = 0;
	if (!isMinuscola(word))
		return false;
	for (let i = 0; i  < word.length ; i++){
		if ( isVocale(word.charAt(i)) ){
			numVocali ++;
		} else {
			numConsonanti ++;
		}
	}
	
	console.log("Esito: ", numConsonanti, numVocali, " maiuscola ", word.toUpperCase());
	
	if (numConsonanti === 0 || numVocali === 0)
		return false;
	else
		return true;
	
}

function isVocale(carattere){
	console.log("Controllo se", carattere, "è vocale")
	return (carattere === 'a' || carattere === 'e' || carattere === 'i' || carattere === 'o' || carattere === 'u' );
}

function isMinuscola(parola){
	console.log("Controllo se", parola, "è minuscola")
	if (parola.toLowerCase()  === parola){
		return true	
	}
	return false;
}

function sendWord() {
	for (let i = 1 ; i <= numTimes; i++){
		let endpoint = "S" + i;
	    fetch(endpoint, {
	        method: "POST",
	        headers: {
	            "Content-Type": "application/json"
	        },
	        body: JSON.stringify({ word: word })
	    })
	    .then(response => response.text())
	    .then(data => {
	        // Ottengo la risposta
	        console.log("Risposta dal server:", data);
	        if (results.length === 0){
		        results.push(data)
		        resultDiv.innerHTML += data + " - Arrivata per prima S" + i;
			}
	    })
	    .catch(error => {
	        console.error("Errore durante l'invio dei dati:", error);
	        resultDiv.innerText = "Errore durante l'invio dei dati.";
	    });
	}
}
