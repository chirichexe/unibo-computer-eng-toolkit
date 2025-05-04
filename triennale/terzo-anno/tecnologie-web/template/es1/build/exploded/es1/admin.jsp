<%@page import="java.util.Map.Entry"%>
<%@page import="java.util.Optional"%>
<%@page import="java.util.HashMap"%>
<%@page import="classes.Utente"%>
<%
	Utente user = (Utente) session.getAttribute("user");
	
	if (user == null || !user.isAdmin() ) {
	    response.sendRedirect("index.jsp?error=invalid+action");
	    return;
	}
%>

<%
	// Ottiene l'elenco delle sessioni attive dal contesto
	ServletContext context = getServletContext();
	HashMap<HttpSession, Optional<Utente>> activeSessions = (HashMap<HttpSession, Optional<Utente>>) context.getAttribute("activeSessions");
	String message = "Non c'è nessuna sessione attiva";
	
    // ========= GESTORE AZIONE SULLA SESSIONE =========
    // Interrompere una richiestain corso
    // Controllato con ( request.getSession().getAttribute("inattiva") == null )
    
	if ( activeSessions != null ){
    message = "";

    // Controlla se è stato inviato un ID sessione da invalidare
    String sessionIdToInvalidate = request.getParameter("sessionId");
    if (sessionIdToInvalidate != null && !sessionIdToInvalidate.isEmpty()) {
        HttpSession sessionToInvalidate = null;

        // Trova la sessione corrispondente
        for (Entry<HttpSession, Optional<Utente>> entry : activeSessions.entrySet()) {
            if (entry.getKey().getId().equals(sessionIdToInvalidate)) {
                sessionToInvalidate = entry.getKey();
                break;
            }
        }

        // Azione sulla sessione se trovata
        if (sessionToInvalidate != null) {
        	
        	// ---- AZIONE ---------
            sessionToInvalidate.setAttribute("inattiva", true);
            message = "Sessione con ID " + sessionIdToInvalidate + " invalidata con successo.";
            // ---- FINE AZIONE ----
            
        } else {
            message = "Sessione non trovata.";
        }
 	// ========= FINE GESTORE AZIONE SULLA SESSIONE =========
    }   
}
	
%>
	
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Home</title>
</head>
<body>
    <h2>Benvenuto, Admin: <%= user.getUsername() %>!</h2>
    
	<!-- Azioni ADMIN -->
	
	<!-- Messaggio feedback -->
    <% if (!message.isEmpty()) { %>
        <p style="color: green;"><%= message %></p>
    <% } %>

	<!-- Elenco utenti attivi -->
    <h2>Elenco Utenti Attivi</h2>
    <ul>
        <%  if (activeSessions != null) {
            for (Entry<HttpSession, Optional<Utente>> entry : activeSessions.entrySet()) {
        %>
            <li>ID Sessione: <%= entry.getKey().getId() %> </li>
        <% }} %>
    </ul>
    
    <!-- Azione sugli utenti attivi -->
    <h2>Azioni su Sessione</h2>
    <form method="POST" action="admin.jsp">
        <label for="sessionId">ID Sessione:</label>
        <input type="text" id="sessionId" name="sessionId" required />
        <button type="submit">Invalidare</button>
    </form>
	
	<!-- fine azioni ADMIN -->
	
	<hr>
    <a href="index.jsp">Torna al login</a>
    <script src="scripts/functions.js"></script>
</body>
</html>
