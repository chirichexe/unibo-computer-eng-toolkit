<%@ page contentType="text/html; charset=US-ASCII" %>
<%@ page isErrorPage="true" %>

<html>

<head>
	<meta name="Author" content="pisi79">
	<title>Error JSP</title>
	<link rel="stylesheet" href="<%= request.getContextPath() %>/styles/default.css" type="text/css"/>
</head>

<body>

	<div id="err" class="clear">
		<p>
			<b>An exception was raised!</b><br/>
			<%= exception.toString() %>
		</p>
		<p>
			<b>Exception message is:</b><br/>
			<%= exception.getMessage() %>
		</p>
		<p>
			<b>Stacktrace is:</b><br/>
<%
			// this will send trace to the browser's screen
			exception.printStackTrace(new java.io.PrintWriter(out));
			// this will send it to the log file
			exception.printStackTrace();
%>
		</p>

	</div>

</body>
</html>