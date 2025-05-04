<%@page import="java.time.LocalDateTime"%>
<%@page import="beans.Utente"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="beans.Dati"%>
<%@page import="beans.ElencoFile"%>
<jsp:useBean id="dati" class="beans.Dati" scope="session" />
<jsp:useBean id="elencoFile" class="beans.ElencoFile" scope="session" />
<%
    int numDot = Integer.valueOf(request.getParameter("numDot"));
	int numProf = Integer.valueOf(request.getParameter("numProf"));
	elencoFile.setMaxPagineDottorandi(numDot);
	elencoFile.setMaxPagineDottorandi(numProf);
%>
