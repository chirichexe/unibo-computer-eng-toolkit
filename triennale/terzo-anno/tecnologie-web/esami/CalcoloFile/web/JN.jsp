<%@page import="java.util.*" %>
<%@page import="java.io.*" %>
<%@ page language="java" %>
<jsp:useBean id="filesManager" class="beans.FilesManager" scope="application" />

<%
	System.out.println("JN: Sono in esecuzione...");
	
	// ---- Parametri in ingresso ---- 
	
	String fileName = (String) request.getAttribute("fileName");
    String esito1 = (String) request.getAttribute("esitoConteggio1");

	// ---- Esecuzione programma ----- 
	
   	String esito2 = "";
   	
   	if (filesManager.hasNumCaratteriNumerici(fileName)){
   		esito2 = filesManager.getNumCaratteriNumerici(fileName);
   		System.out.println("Li aveva!" + esito2);
   	} else {
   		esito2 = filesManager.contaCaratteriNumerici(fileName);
   		System.out.println("Non li aveva!" + esito2);
   	}
	
    // ---- Stampa in uscita ---------
    out.println(esito1);
    out.println(esito2);
%>
