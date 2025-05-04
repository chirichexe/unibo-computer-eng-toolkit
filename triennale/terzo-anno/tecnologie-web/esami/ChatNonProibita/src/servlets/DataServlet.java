package servlets;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.websocket.Session;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;

public class DataServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final int MAX_SESSIONS = 2;
    private static final List<Session> sessions = new ArrayList<>();
    private static final long WAIT_TIME = 1 * 60 * 1000;

    @Override
    protected synchronized void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        if (sessions.size() < MAX_SESSIONS) {
            sessions.add((Session) req.getSession());
            if (sessions.size() == MAX_SESSIONS) {
                startGame();
            } else {
                scheduleGameStart();
            }
            resp.getWriter().write("Joined successfully");
        } else {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Tavolo pieno");
        }
    }

    private void scheduleGameStart() {
        new Timer().schedule(new TimerTask() {
            @Override
            public void run() {
                if (sessions.size() > 0) {
                    startGame();
                }
            }
        }, WAIT_TIME);
    }

    private void startGame() {
        System.out.println("Partita iniziata...");
    }
}
