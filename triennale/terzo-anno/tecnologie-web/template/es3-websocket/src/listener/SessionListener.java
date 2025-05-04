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
    	System.out.println("Nuovo utente in sessione: " + se.getSession().getId());
    	
    	/*
        ServletContext context = se.getSession().getServletContext();
        synchronized (context) {
            HashMap<HttpSession, Optional<Utente>> activeSessions = (HashMap<HttpSession, Optional<Utente>>) context.getAttribute("activeSessions");
            if (activeSessions == null) {
                activeSessions = new HashMap<>();
                context.setAttribute("activeSessions", activeSessions);
            }
            activeSessions.put(se.getSession(), Optional.empty());
        }
        */
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
    	System.out.println("Terminata la sessione: " + se.getSession().getId());
    	
    	/*
        ServletContext context = se.getSession().getServletContext();
        synchronized (context) {
        	HashMap<HttpSession, Optional<Utente>> activeSessions = (HashMap<HttpSession, Optional<Utente>>) context.getAttribute("activeSessions");
            if (activeSessions != null) {
                activeSessions.remove(se.getSession());
            }
            
        }
        */
    }
}