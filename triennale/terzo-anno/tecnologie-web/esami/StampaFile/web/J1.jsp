<%@page import="beans.Utente"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="beans.Dati"%>
<%@page import="beans.ElencoFile"%>
<jsp:useBean id="dati" class="beans.Dati" scope="session" />
<jsp:useBean id="elencoFile" class="beans.ElencoFile" scope="session" />
<%
    int numFile = Integer.valueOf(request.getParameter("numFile"));
    Utente utenteAttuale = (Utente) request.getSession().getAttribute("user");

    if (numFile > 4 || numFile <= 0) {
        response.sendRedirect("user.jsp");
    } else {
        for (int i = 0; i < numFile; i++) {
        	        	
            String nome = request.getParameter("file" + i);
            System.out.println(nome);

            if (!elencoFile.getDimFile(nome).isEmpty()) {
                int numByte = elencoFile.getDimFile(nome).get();
                int numPagine = numByte / 100;
                
                if ( ! elencoFile.aggiungiByteStampati(utenteAttuale.getUserType(), numPagine)){
                	System.out.println("Num pagine non va bene...");
                	response.sendRedirect("user.jsp");
                	return;
                }

                if (numByte > 1000) {

                    RequestDispatcher dispatcher = request.getRequestDispatcher("S2?nomeFile=" + nome + "&numPagine=" + (numByte / 100));
                    dispatcher.forward(request, response);
                } else {
                    RequestDispatcher dispatcher = request.getRequestDispatcher("S1?nomeFile=" + nome + "&numPagine=" + (numByte / 100));
                	dispatcher.forward(request, response);
                }
            } else {
                System.out.println(nome + " NON TROVATO");
                response.sendRedirect("user.jsp");
                return;
            }
        }
    }
%>
