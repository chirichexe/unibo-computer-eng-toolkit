package servlets;

import java.time.LocalTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;


public class SessionListener implements HttpSessionListener {


    @Override
    public void sessionCreated(HttpSessionEvent se) {
        ServletContext context = se.getSession().getServletContext();
        
        // Contesto per le sessioni e le relative azioni completate
        synchronized (context) {
            @SuppressWarnings("unchecked")
			HashMap<HttpSession, List<Integer>> activeSessions = (HashMap<HttpSession, List<Integer>>) context.getAttribute("activeSessions");
            if (activeSessions == null) {
                activeSessions = new HashMap<>();
                context.setAttribute("activeSessions", activeSessions);
            }
            System.out.println("Nuovo utente in sessione: " + se.getSession().getId() + "\n"
            		+ "Orario corrente: " + LocalTime.now());
            
            List<Integer> iniziale = new ArrayList<>();
            iniziale.add(0);
            iniziale.add(0);
            iniziale.add(0);
            activeSessions.put(se.getSession(), iniziale);
        }
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        ServletContext context = se.getSession().getServletContext();
        synchronized (context) {
        	@SuppressWarnings("unchecked")
			HashMap<HttpSession, List<Integer>> activeSessions = (HashMap<HttpSession, List<Integer>>) context.getAttribute("activeSessions");
            if (activeSessions != null) {
            	System.out.println("Terminata la sessione: " + se.getSession().getId());
                activeSessions.remove(se.getSession());
            }
            
        }
    }
}