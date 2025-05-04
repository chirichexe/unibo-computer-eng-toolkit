const numTimes = 4;

async function sendMatrix() {
	const A = [];
	const B = [];
	
	for(let i = 0; i < 4 ; i++ ){
		const row = [];
		for(let j = 0; j < 4 ; j++ ){
			const el = parseInt(document.getElementById("A" + i + j ).value);
			row.push(el);
			
			if (el >= 500 || el === null){
				alert("Errore: Un numero è mancante o maggiore di 500");
				return;
			}
		}
		A.push(row);
	}
	
	for(let i = 0; i < 4 ; i++ ){
		const row = [];
		for(let j = 0; j < 4 ; j++ ){
			const el = parseInt(document.getElementById("B" + i + j ).value);
			row.push(el);
			
			if (el >= 500 || el === null){
				alert("Errore: Un numero è mancante o maggiore di 500");
				return;
			}
		}
		B.push(row);
	}

    const resultDiv = document.getElementById("result");
    
    // Inizializzo il testo e le variabili
    resultDiv.innerHTML = "Risultato: ";
	risultato = [];
	tempo = 0;

    // Invia le parti delle matrici tramite AJAX
    for (let i = 0; i < numTimes; i++) {
		
        // Preparo il corpo del messaggio con le parti delle matrici
        const body = JSON.stringify({
            A: A[i],
            B: B[i]
        });

        await fetch("JSONServlet", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: body
        })
        .then(response => response.json())
        .then(data => {
            // Ottengo la risposta
            console.log("Risposta dal server:", data);
            
            risultato.push(data.result);
            tempo += data.time;
        })
        .catch(error => {
            console.error("Errore durante l'invio dei dati:", error);
            resultDiv.innerText = "Errore durante l'invio dei dati.";
        });
    }
    
    console.log(risultato);
    
    resultDiv.innerHTML += "Risultato = " + risultato;
    resultDiv.innerHTML += "Tempo totale impiegato in millis. = " + tempo;
}


function mostraElencoRichieste() {
    // Ottieni i valori
    const resultDiv = document.getElementById('elencoRichieste');
            
    fetch("JSONServlet", {
        method: "GET"
    })
    .then(response => response.text())
    .then(data => {
        console.log("Risposta dal server:", data);
        resultDiv.innerText = data;
    })
    .catch(error => {
        console.error("Errore durante l'invio dei dati:", error);
        resultDiv.innerText = "Errore durante la ricerca dei dati.";
    });
}
