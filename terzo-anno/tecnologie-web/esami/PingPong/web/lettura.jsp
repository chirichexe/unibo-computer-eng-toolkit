<%--
  Nome Cognome - Matricola 0000000000

  Tecnologie Web T - A.A. 2024-2025
  Template non ufficiale: sostituisci i tuoi dati
  e verifica che il contenuto sia ancora valido per il tuo anno accademico.
--%>

<%
    String username = (String) session.getAttribute("username");
	boolean isPrenotato = false;
	
    if (username != null  ) {
    	isPrenotato = (boolean) session.getAttribute("isPrenotato");
    } else {
        response.sendRedirect("index.jsp?error=invalid+type");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Home</title>
</head>
<body>
<script src="scripts//functions.js"></script>
	<ul id="list">
	</ul>
    <a href="user.jsp">Torna alla home</a>
</body>
</html>


