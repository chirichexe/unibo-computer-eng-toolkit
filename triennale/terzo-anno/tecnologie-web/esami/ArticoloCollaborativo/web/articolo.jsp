<!DOCTYPE html>
<%@page import="beans.Articolo"%>
<%@page import="beans.ArticoliManager"%>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Home</title>
</head>
<body>
    <% 
        // Ottieni l'oggetto Articolo dalla sessione
        Articolo myArticolo = (Articolo) request.getSession().getAttribute("articolo");
        String articoloString = myArticolo.getContenuto();
    %>
    
    <h2>Modifica il tuo articolo!</h2>
    
    <!-- Visualizzazione di toString in una textarea -->
    <textarea id="articoloText" disabled ><%= articoloString %></textarea>
    
    <!-- Azioni USER -->
    <button onclick="handleModifica(true)">Richiedi modifica</button>
    <button onclick="handleModifica(false)">Revoca modifica</button>
    <!-- Fine azioni USER -->
    
    <hr>
    
    <a href="index.jsp">Torna all'inizio</a>
    <script src="scripts/articolo.js"></script>
</body>
</html>
