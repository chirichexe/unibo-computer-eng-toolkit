<%@page import="beans.Carrello"%>
<jsp:useBean id="carrello" class="beans.Carrello" scope="application" />
<%
    synchronized (carrello) {
        carrello.setPresente(false);
    }
%>
