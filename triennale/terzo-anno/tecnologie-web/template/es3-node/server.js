const http = require('http');

const hostname = '127.0.0.1';
const port = 3000;

const server = http.createServer((req, res) => {
	res.statusCode = 200;
	res.setHeader('Content-Type', 'text/plain');
	
	// Utilizzo modulo fs sincrono
	/*
		const fs = require('node:fs');
		try {
			const data = fs.readFileSync(fileName, 'utf8');
			const parole = data.split(" ");
		} catch (err) {
			console.error(err);
		}
	*/

	/* 
 	// Versione 1: conteggio caratteri con fs

		const fs = require('node:fs');
		fs.readFile('The_Sound_Of_Silence.txt', 'utf8', (err, data) => {
			if (err) {
				console.error(err);
				return;
			}
				const parole = data.split("");
				let numParole = 0;
				parole.forEach( w => {
				numParole++;
			});

			res.end("Numero parole: " + numParole )
		});
	*/

	// -----------------------------------------------------------------

	/*  // Versione 2: conteggio caratteri con readline  

		let numCaratteri = 0;
		const fs = require('node:fs');
		const readline = require('node:readline');
		var rl = readline.createInterface({
			input: fs.createReadStream('The_Sound_Of_Silence.txt'),
			output: process.stdout,
			reminal: false
		})

		// Conta i caratteri mentre leggi il file riga per riga
		rl.on('line', (line) => {
			numCaratteri += line.length;
		});

		rl.on('close', () => {
			res.end(`Numero caratteri: ${numCaratteri}`);
		});
	
	*/

	// -----------------------------------------------------------------

	/* // Versione 3: Prende i dati dall'url
	
		const url = require('node:url');
		const fs = require('node:fs');
		const parsedUrl = new URL(req.url, `http://${req.headers.host}`);
		const word = parsedUrl.searchParams.get('word');
		
		// Parametro presente
		if ( word) {
		
		fs.readFile("The_Sound_Of_Silence.txt", 'utf8', (err, data) => {
			if (err) {
				console.error(err);
				res.statusCode = 500;
				res.end('Errore nella lettura del file');
				return;
			}
			
			// Dividi il contenuto del file in parole
			const parole = data.split(" ");
			let numOccorrenze = 0;
			
			// Conta le occorrenze della parola nel testo
			parole.forEach(parola => {
				numOccorrenze += contaOccorrenze(parola, word);
			});
			
			// Invia la risposta al client con il numero di occorrenze
				res.end(`Numero occorrenze della parola "${word}": ${numOccorrenze}`);
			});
			
				// Parametro non presente
			} else {
				res.end('Parametro word non trovati nella query');
		}
	
	*/

	/* // Versione 4: Elimino le occorrenze di una parola di un file e numOccorrenze > 5
	
	const url = require('node:url');
	const fs = require('node:fs');
	const parsedUrl = new URL(req.url, `http://${req.headers.host}`);
	const word = parsedUrl.searchParams.get('word');
	
	// Parametro presente
	if ( word) {
		fs.readFile("myFile.txt", 'utf8', (err, data) => {
		if (err) {
			console.error(err);
			res.statusCode = 500;
			res.end('Errore nella lettura del file');
			return;
		}
		
		// Dividi il contenuto del file in parole
		const parole = data.split(" ");
		let numOccorrenze = 0;
		
		// Conta le occorrenze della parola nel testo
		parole.forEach(parola => {
			numOccorrenze += contaOccorrenze(parola, word);
		});

		
		if ( numOccorrenze >= 5 ) {
			const newContent =  data.replace(new RegExp(`\\b${word}\\b`, 'gi'), '');
			console.log(`Elimino occorrenze della parola "${word}"...`);
			fs.writeFile("myFile.txt", newContent, (err) => {
				if (err) throw err;
				console.log('File salvato!');
			});

		}
		
		// Invia la risposta al client con il numero di occorrenze
			res.end(`Numero occorrenze della parola "${word}": ${numOccorrenze}`);
		});
	
	// Parametro non presente
	} else {
		res.end('Parametro word non trovati nella query');
	}
  */
  
});

server.listen(port, hostname, () => {
  	console.log(`Server running at http://${hostname}:${port}/`);
});

function contaOccorrenze(parola, stringa) {
	let count = 0;
	let posizione = 0;

	while (posizione < stringa.length) {
		posizione = stringa.indexOf(parola, posizione);
		if (posizione === -1) {
			break;
		}
		
		count++;
		posizione += parola.length;
	}

	return count;
}