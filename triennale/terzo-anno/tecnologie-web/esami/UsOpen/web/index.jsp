<!DOCTYPE html>

<!-- Utilizzo dei javaBean per la "persistenza" -->
<jsp:useBean id="dati" class="beans.Dati" scope="application" />

<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Esame Davide Chirichella</title>
</head>

<!-- Richiesta ajax -->
<body>

<!-- Sezione per utenti NON AUTENTICATI -->
    <input type="text" id="nameInput">
	<button onclick="sendName()">Invia il nome</button>
	
	<br><br>
	
	<div id="result">Il risultato verrà mostrato qui...</div>
	
	<br><br><hr/>
	
	<script src="scripts/functions.js"></script>

</body>
</html>
