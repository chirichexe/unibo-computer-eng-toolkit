let cache = [];
const resultDiv = document.getElementById("result");

async function sendName() {
    const surname = document.getElementById("nameInput").value;
    
    // 1. lo cerco nella cache
	fetchCache(surname)	
	
	console.log("Miss nella fetch...")

	// 2. Se non c'è faccio fetch
    await fetch("JSONServlet", {
        method: "POST",
        body: new URLSearchParams({ "cognome" : surname })
    })
    .then(response => response.json())
    .then(data => {
        // Ottengo la risposta
        console.log("Risposta dal server:", data);
        
        if (data.error) {	
        	resultDiv.innerHTML = data.error;
		} else {
			cache.push(data);
			fetchCache(surname);
		}
    })
    .catch(error => {
        console.error("Errore durante l'invio dei dati:", error);
        resultDiv.innerText = "Errore durante l'invio dei dati.";
    });
}

function fetchCache(surname){
	    cache.forEach( tab => {
		tab.forEach( giocatore => {
			console.log("analizzo il giocatore", giocatore)
			if (giocatore.cognome === surname ){
				console.log("Hit nella fetch...", giocatore)
				renderGiocatore(giocatore);
				return;
			}
		})
	});
}

function renderGiocatore(giocatore){
	resultDiv.innerHTML = "<ul>" + 
	 "<li>" + giocatore.cognome + "</li>" +
	 "<li>" + giocatore.rankingATP + "</li>" +
	 "<li>" + giocatore.titoliVinti + "</li>" +
	 "<li>" + giocatore.numPartiteVinte + "</li>" +
	 "<li>" + giocatore.numPartitePerse + "</li>"
	 + "</ul>"
}

