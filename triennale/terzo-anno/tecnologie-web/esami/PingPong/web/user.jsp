
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
    <h2>Benvenuto , Utente: <%= username %>!</h2>
    <% if (!isPrenotato) {%>
	<a href="scrittura.jsp">vai a Scrittura</a>
    <%} else { %>
    <h1>Sei prenotato:</h1>
    <%} %>
    <a href="lettura.jsp">vai a Lettura</a>
    <a href="index.jsp">Torna al login</a>
    <script>

    </script>
</body>
</html>
