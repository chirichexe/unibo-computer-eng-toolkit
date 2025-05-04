const http = require('http');

const hostname = '127.0.0.1';
const port = 3000;

const server = http.createServer( (req, res) => {
	res.statusCode = 200;
	res.setHeader('Content-Type', 'text/plain');
	
	
	const url = require('node:url');
	const parsedUrl = new URL(req.url, `http://${req.headers.host}`);
	const file1 = parsedUrl.searchParams.get('file1');
	const file2 = parsedUrl.searchParams.get('file2');

	const username = parsedUrl.searchParams.get('username');
	const password = parsedUrl.searchParams.get('password');
	const deleteFile = parsedUrl.searchParams.get('deleteFile');
	
	// Parametro presente
	if ( file1 && file2) {
		const numOccorrenze1 = contaOccorrenzeNumericheFile(file1);
		const numOccorrenze2 = contaOccorrenzeNumericheFile(file2);

		res.end("Numero occorrene file1: " + numOccorrenze1 + " | file2: " + numOccorrenze2)
		
		// Parametro non presente
	} else if ( username && password && deleteFile ) {
		if (username === "admin" && password === "1234"){
			const fs = require('node:fs');
			try {
				fs.rmSync(deleteFile);
				res.end("Eliminato il file: " + deleteFile);
			} catch (error) {
				res.end("Errore: " + error.message);
			}
		} else {
			res.end("Username o password non corretti")
		}
	} else {
		res.end('Parametri non trovati');
	}


});

server.listen(port, hostname, () => {
  	console.log(`Server running at http://${hostname}:${port}/`);
});

function contaOccorrenzeNumericheFile(fileName) {
	const fs = require('node:fs');
	let numOccorrenze = 0;

	try {
		const data = fs.readFileSync(fileName, 'utf8');
		const parole = data.split(" ");
		parole.forEach(parola => {
			for (let i = 0; i < parola.length; i++) {
				if (parola.charAt(i) >= '0' && parola.charAt(i) <= '9') {
					numOccorrenze++;
				}
			}
		});
	} catch (err) {
		console.error(err);
	}

	console.log("Trovato " + numOccorrenze);
	return numOccorrenze;
}
