package beans;

import java.util.ArrayList;
import java.util.List;

public class SessionData {
	private List<Long> duration;
	private int numCompletate;
	
	public SessionData() {
		super();
		this.duration = new ArrayList<>();
		this.numCompletate = 0;
	}

	public String getDuration() {
		return duration.toString();
	}

	public void addDuration(long duration) {
		this.duration.add(duration);
	}


	public int getNumCompletate() {
		return numCompletate;
	}

	public void addCompletate() {
		this.numCompletate++;
	}
	
	@Override
	public String toString() {
		return "[durata=" + duration + ", numCompletate=" + numCompletate + "]";
	}
}
