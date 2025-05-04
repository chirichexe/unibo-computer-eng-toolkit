<%
    String username = (String) session.getAttribute("username");
	boolean isPrenotato = false;
	
    if (username != null  ) {
    	isPrenotato = (boolean) session.getAttribute("isPrenotato");
    	if (isPrenotato) {
    		response.sendRedirect("user.jsp");
    	}
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
    <% if (!isPrenotato) {%>
    <form id="fileForm" method="POST" action="letturaServlet">
        <input type="datetime-local" name="inizio">
        <button type="submit">Invia prenotazione</button>
    </form>
    <%} else { %>
    <h1>Sei prenotato:</h1>
    <%} %>
    <a href="user.jsp">Torna alla home</a>
    <script>

    </script>
</body>
</html>
