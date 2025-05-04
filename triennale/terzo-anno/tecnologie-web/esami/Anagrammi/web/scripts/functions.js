// ==== FUNZIONI UTENTI NON AUTENTICATI ====

// Seleziona l'input e definisce il simbolo
const numTimes = 2;
const input = document.getElementById('inputText');
const result = document.getElementById('result');
let word;
const symbol = "%";

// Funzione per controllare la validità della stringa
function checkText(word) {
    // Controlla che la stringa non sia nulla
    if (!word || word.trim() === "") {
        console.error("La stringa è vuota o nulla.");
        return false;
    }

    // Controlla se la stringa è alfabetica e minuscola
    let isAlphabetic = true;
    let isMinuscola = true;

    for (let char of word) {
        if ((char < 'A' || char > 'Z') && (char < 'a' || char > 'z')) {
            isAlphabetic = false;
        }
    }
    
    if ( word.toLowerCase() !== word )
    	isMinuscola = false;


    if (!isMinuscola || !isAlphabetic || word.length > 8) {
        console.error("La stringa deve essere minuscola, alfabetica e minore di 8.");
        return false;
    }

    return true;
}

// Aggiunge l'evento all'input
input.addEventListener('input', () => {
    word = input.value;
    console.log(word);

    if (word.includes(symbol)) {
        // Rimuove il simbolo
        word = word.replace(symbol, "");

        // Esegue il controllo
        if (checkText(word)) {
            // Invio la parola alle due servlet
            sendWord();
        }
    }
});


function sendWord() {
	
    const body = JSON.stringify({
        word: word,
    });
        
    for (let i = 1; i <= numTimes; i++) {
        
        const url = "S"+i;
        fetch(url, {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: body
        })
        .then(response => response.text())
        .then(data => {
            // Ottengo la risposta
            console.log("Risposta dal server:", data);
            result.innerHTML += "<li>Risultato della servlet " + url + ": " +data + "</li>";
        })
        .catch(error => {
            console.error("Errore durante l'invio dei dati:", error);
            result.innerText = "<li>Errore durante l'invio dei dati.</li>";
        });
    }
}

function setTrovata( status ) {
    fetch( "setSession.jsp?status=" + status, {
        method: "GET"
    })
    .then(data => {
        console.log("Risposta dal server:", data);
    })
}

