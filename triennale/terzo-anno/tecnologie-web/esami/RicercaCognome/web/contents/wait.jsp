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
