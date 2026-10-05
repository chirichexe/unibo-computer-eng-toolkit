<%--
  Nome Cognome - Matricola 0000000000

  Tecnologie Web T - A.A. 2024-2025
  Template non ufficiale (unibo-computer-eng-toolkit): sostituisci i tuoi dati
  e verifica che il contenuto sia ancora valido per il tuo anno accademico.
--%>

<%@page import="beans.Carrello"%>
<jsp:useBean id="carrello" class="beans.Carrello" scope="application" />
<%
    synchronized (carrello) {
        carrello.setPresente(false);
    }
%>
