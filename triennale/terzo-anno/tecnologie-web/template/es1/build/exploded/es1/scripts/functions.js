// ==== FUNZIONI UTENTI NON AUTENTICATI ====

// Variabili "globali" dell'applicazione
const input = document.getElementById('inputText');
const inputForm = document.getElementById('inputForm');
const resultDiv = document.getElementById('resultDiv');
const symbol = "%";

// Funzione per controllare la validità della stringa
function checkText(word) {
    // Controlla che la stringa non sia nulla
    if (!word || word.trim() === "") {
        console.error("La stringa è vuota o nulla.");
        return false;
    }

    // Controlla se la stringa è numerica o alfabetica
    let isNumeric = true;
    let isAlphabetic = true;

    for (let char of word) {
        if (char < '0' || char > '9') {
            isNumeric = false;
        }
        if ((char < 'A' || char > 'Z') && (char < 'a' || char > 'z')) {
            isAlphabetic = false;
        }
    }

    if (!isNumeric && !isAlphabetic) {
        console.error("La stringa deve essere solo numerica o alfabetica.");
        return false;
    }

    return true;
}

// Aggiunge l'evento all'input
input.addEventListener('input', () => {
    let word = input.value;
    console.log(word);

    if (word.includes(symbol)) {
        // Rimuove il simbolo
        word = word.replace(symbol, "");

        // Esegue il controllo
        if (checkText(word)) {
            // Invio il form
            inputForm.submit();
        }
    }
});

// ==== FUNZIONI UTENTI AUTENTICATI ==== 
// =============== USER ================

function sendData(tipo, testo){
	
	const body = JSON.stringify({
		type: tipo,
		content: testo
	});
	
	fetch("dataServlet", {
    method: "POST",
    headers: {
        "Content-Type": "application/json",
    },
    body: body,
	})
	.then(response => response.json())
	.then(data => {
	    console.log("Risposta dal server:", data);
	    if (data.error){
			resultDiv.innerText = "Errore: " + data.error;
		} else if ( data.success ){
		    resultDiv.innerText = "Successo: " + data.success;
		}
	})
	.catch(error => {
	    console.error("Errore durante l'invio dei dati:", error);
	    resultDiv.innerText = "Errore durante l'invio dei dati.";
	})
}

// =============== ADMIN ===============

// Fetch con GET e POST verso dataServlet
/*
// Parametri
const resultDiv = document.getElementById("result");
const textValue = "Esempio di testo";

// Richiesta GET con parametro "text"
fetch(`dataServlet?text=${encodeURIComponent(textValue)}`, {
    method: "GET",
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

// Richiesta POST con parametro "text"
const params = new URLSearchParams();
params.append("text", textValue);

fetch("dataServlet", {
    method: "POST",
    headers: {
        "Content-Type": "application/x-www-form-urlencoded",
    },
    body: params.toString(),
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

*/

