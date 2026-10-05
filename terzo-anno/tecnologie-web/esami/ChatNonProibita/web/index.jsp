<%--
  Nome Cognome - Matricola 0000000000

  Tecnologie Web T - A.A. 2024-2025
  Template non ufficiale (unibo-computer-eng-toolkit): sostituisci i tuoi dati
  e verifica che il contenuto sia ancora valido per il tuo anno accademico.
--%>

<!DOCTYPE html>

<!-- Inizio codice html -->

<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Esame Nome Cognome</title>
</head>

<body>

<!-- Sezione utenti non autenticati WEBSOCKET -->

<div id="webSocket">
	<h1>Chat</h1>
	<ul id="chat"></ul>
	
	<input type="text" id="message">
	<button onclick="actionHandler()" >Invia messaggio</button>
</div>

<script src="scripts/websocket.js"></script>

</body>
</html>
