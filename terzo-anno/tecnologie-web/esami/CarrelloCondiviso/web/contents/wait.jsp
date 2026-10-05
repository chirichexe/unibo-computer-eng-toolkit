<%--
  Nome Cognome - Matricola 0000000000

  Tecnologie Web T - A.A. 2024-2025
  Template non ufficiale: sostituisci i tuoi dati
  e verifica che il contenuto sia ancora valido per il tuo anno accademico.
--%>

<%
int wait = Integer.parseInt(request.getParameter("wait"));
StringBuffer output = new StringBuffer();
output.append("Ecco il risultato");
for ( int i = 0 ; i < wait ; i++ ) { 
	output.append("!"); 
	Thread.sleep(1000);
}
%>
<%= output + " (attesa = " + wait + " secondi)" %>
