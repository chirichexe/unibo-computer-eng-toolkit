<%@page import="com.google.gson.Gson"%>
<%@page import="java.util.regex.Matcher"%>
<%@page import="java.util.*" %>
<%@page import="java.io.*" %>
<%@page import="beans.TestoContenuto" %>
<%@ page language="java" %>

<%
	System.out.println("J2: Sono in esecuzione...");
	
	// ---- Parametri in ingresso ---- 
	
    String processedText = (String) request.getAttribute("processedText");
    String target = request.getParameter("target");
    System.out.println("Devo cercare: " + target);

	// ---- Esecuzione programma ----- 
	
    int numOccorrenze = 0;
	
	TestoContenuto t = new TestoContenuto( processedText, numOccorrenze);
	Gson gson = new Gson();
	String resultJson = gson.toJson(t);
	
    // ---- Stampa in uscita ---------
    out.print(resultJson);
%>
