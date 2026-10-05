<%--
  Nome Cognome - Matricola 0000000000

  Tecnologie Web T - A.A. 2024-2025
  Template non ufficiale: sostituisci i tuoi dati
  e verifica che il contenuto sia ancora valido per il tuo anno accademico.
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="filesManager" class="beans.FilesManager" scope="application" />

<%
	System.out.println("J1: Sono in esecuzione...");
	
	// ---- Parametri in ingresso ---- 
    
	String fileName = (String) request.getAttribute("fileName");
    
   	// ---- Esecuzione programma ----- 

   	String esito1 = "";
   	
   	if (filesManager.hasNumCaratteriAlfabetici(fileName)){
   		esito1 = filesManager.getNumCaratteriAlfabetici(fileName);
   		System.out.println("Li aveva!" + esito1);
   	} else {
   		esito1 = filesManager.contaCaratteriAlfabetici(fileName);
   		System.out.println("Non li aveva!" + esito1);
   	}


   	// ---- Stampa in uscita --------- 
   		request.setAttribute ("esitoConteggio1", esito1);
       RequestDispatcher dispatcher = request.getRequestDispatcher("JN.jsp");
       dispatcher.forward(request, response);
%>
