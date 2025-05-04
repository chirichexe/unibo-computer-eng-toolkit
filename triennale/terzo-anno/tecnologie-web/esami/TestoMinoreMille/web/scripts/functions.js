// ==== FUNZIONI UTENTI NON AUTENTICATI ====

// Seleziona l'input e definisce il simbolo
const input = document.getElementById('inputText');
const inputForm = document.getElementById('inputForm');
let word;

// Funzione per controllare la validità della stringa
function checkText() {
    if ( word.length < 100 || word.length > 1000) {
        console.error("La stringa è maggiore o minore di 100/1000.");
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
    word = input.value;
    console.log(word);
    
    if (word.length > 100){
    	document.getElementById("buttonDiv").innerHTML = "<button onclick=\"sendText()\" >Invia testo </button>"
	} else {
		document.getElementById("buttonDiv").innerHTML = "";
	}
        
});

function sendText() {
    if (checkText()){
	    const body = JSON.stringify({
	        word: word
	    });
	    
	    var xhr = new XMLHttpRequest();  // Crea un nuovo oggetto XMLHttpRequest

		// Imposta il metodo (GET, POST, etc.) e l'URL
		xhr.open('POST', 'S1', true);
		xhr.setRequestHeader('Content-Type', 'application/json');  // Imposta il tipo di contenuto come JSON
		
		// Imposta una funzione da eseguire quando la richiesta cambia stato
		xhr.onreadystatechange = function() {
		    if (xhr.readyState === 4 && xhr.status === 200) {
		        // La risposta è pronta e il codice di stato HTTP è 200 (OK)
		        console.log(xhr.responseText);  // Elenco della risposta del server
		    }
		};
		
		// Invia la richiesta con dati JSON
		xhr.send(body);
	}        
}



// ==== FUNZIONI UTENTI AUTENTICATI ==== 
// =============== USER ================
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

