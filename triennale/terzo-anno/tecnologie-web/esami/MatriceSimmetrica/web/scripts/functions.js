const numTimes = 2;
const a = 6;
const b = 6;

const resultDiv = document.getElementById("result");

async function sendMatrix() {
	
	const matrix = [];
	let result = false;
	
    for (let i = 0; i < a; i++){
		const row = [];
	    for (let j = 0; j < b; j++){
			const element = document.getElementById(i + "" + j).value;
			console.log(element)
			if (isNaN(element) || element === ""){
				resultDiv.innerHTML = "<p>Un numero non è intero o è vuoto</p>"
				return;
			}
			row.push(parseInt(element));
		}
		matrix.push(row)
	}
	
	console.log("Pronto a mandare:", matrix )
	
 for (let i = 1; i <= numTimes; i++) {
        const body = JSON.stringify({
            matrixPart: matrix
        });
		
		const urlName = "S" + i
		
        await fetch( urlName , {
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
            
            if (data === "-1"){
				resultDiv.innerHTML = "<p>Un amministratore ha invalidato la tua richiesta</p>"
				return;
			}
            
            if ( i === 1){
				result = data === "true";
			} else {
				const newResult = data === "true" && result;
				result = newResult;
            	resultDiv.innerHTML += result;
			}
            
        })
        .catch(error => {
            console.error("Errore durante l'invio dei dati:", error);
            resultDiv.innerText = "Errore durante l'invio dei dati.";
        });
	}
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
