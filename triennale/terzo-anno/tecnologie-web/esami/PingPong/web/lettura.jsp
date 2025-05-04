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


