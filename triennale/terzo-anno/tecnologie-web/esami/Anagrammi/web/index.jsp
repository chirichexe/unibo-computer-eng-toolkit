<!DOCTYPE html>

<!-- Utilizzo dei javaBean  -->
<%@page import="beans.Dati"%>
<jsp:useBean id="dati" class="beans.Dati" scope="application" />

<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Esame Davide Chirichella</title>
</head>

<body onload="setTrovata(false)">

<!-- Sezione per utenti NON AUTENTICATI -->
    <input type="text" id="inputText" >
	
	<br><br>
	
	<ul id="result"><li>Il risultato verrà mostrato qui...</li></ul>
	<button onclick="setTrovata(true)">Dichiara parola trovata</button>
	
	<br><br><hr/>
	
	<script src="scripts/functions.js"></script>
</body>
</html>
