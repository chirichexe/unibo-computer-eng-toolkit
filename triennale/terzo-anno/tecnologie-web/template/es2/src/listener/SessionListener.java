package listener;

import java.time.LocalTime;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Optional;
import java.util.Set;
import java.util.Map.Entry;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

import classes.Utente;

public class SessionListener implements HttpSessionListener {

    @Override
    public void sessionCreated(HttpSessionEvent se) {
        ServletContext context = se.getSession().getServletContext();
        
        // Contesto per le sessioni e le relative azioni completate
        synchronized (context) {
            HashMap<HttpSession, Integer> activeSessions = (HashMap<HttpSession, Integer>) context.getAttribute("activeSessions");
            if (activeSessions == null) {
                activeSessions = new HashMap<>();
                context.setAttribute("activeSessions", activeSessions);
            }
            System.out.println("Nuovo utente in sessione: " + se.getSession().getId());
            activeSessions.put(se.getSession(), 0);
        }
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        ServletContext context = se.getSession().getServletContext();
        synchronized (context) {
        	HashMap<HttpSession, Integer> activeSessions = (HashMap<HttpSession, Integer>) context.getAttribute("activeSessions");
            if (activeSessions != null) {
            	System.out.println("Terminata la sessione: " + se.getSession().getId());
                activeSessions.remove(se.getSession());
            }
            
        }
    }
}