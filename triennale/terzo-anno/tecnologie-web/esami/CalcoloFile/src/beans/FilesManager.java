package beans;

import java.security.KeyStore.Entry;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class FilesManager {

    private final List<Map<Integer, String>> files;
    
    public FilesManager() {
        this.files = new ArrayList<>();
        
        Map<Integer, String> file1 = new HashMap<>();
        file1.put(0, "");
        file1.put(1, "");
        file1.put(2, "La prima riga è...");
        file1.put(3, "La sconda riga è questa");
        file1.put(4, "Del primo file");
        file1.put(5, "E contiene 3 righe");
        
        Map<Integer, String> file2 = new HashMap<>();
        file2.put(0, "");
        file2.put(1, "");
        file2.put(2, "Sbagliato tutto");
        file2.put(3, "Bro hai");
        file2.put(4, "nelle tue 412 vite");
        file2.put(5, "Ciao");
        
        files.add(file1);
        files.add(file2);
        
        System.out.println("Istanzio la classe FilesManager...");
        
    }

    public synchronized void setNumCaratteriAlfabetici(String fileName, int num) {
    	Map<Integer, String > file = getFileByName(fileName);
    	if (file != null ) {
    		file.put(0, "Il numero di caratteri alfabetici del file è uguale a " + num);
    	}
    }
    
    public synchronized void setNumCaratteriNumerici(String fileName, int num) {
    	Map<Integer, String > file = getFileByName(fileName);
    	if (file != null ) {
    		file.put(1, "Il numero di caratteri numerici del file è uguale a " + num);
    	}
    }
    
    public synchronized boolean hasNumCaratteriNumerici(String fileName) {
    	System.out.println("Controllo se il file " + fileName + " ha i caratteri alfabetici...");
    	Map<Integer, String > file = getFileByName(fileName);
    	if (file != null ) {
    		return ( !file.get(1).isEmpty());
    	} else {
    		return false;
    	}
    }
    
    public synchronized boolean hasNumCaratteriAlfabetici(String fileName) {
    	System.out.println("Controllo se il file " + fileName + " ha i caratteri numerici...");
    	Map<Integer, String > file = getFileByName(fileName);
    	if (file != null ) {
    		return ( !file.get(0).isEmpty());
    	} else {
    		return false;
    	}
    }
    
    public synchronized String getNumCaratteriNumerici(String fileName) {
    	System.out.println("Il file " + fileName + " ha i caratteri...");
    	Map<Integer, String > file = getFileByName(fileName);
    	if (file != null ) {
    		return file.get(0);
    	} else {
    		return null;
    	}
    }
    
    public synchronized String getNumCaratteriAlfabetici(String fileName) {
    	System.out.println("Il file " + fileName + " ha i caratteri...");
    	Map<Integer, String > file = getFileByName(fileName);
    	if (file != null ) {
    		return file.get(1);
    	} else {
    		return null;
    	}
    }
    
    public synchronized String contaCaratteriAlfabetici(String fileName) {
    	Map<Integer, String > file = getFileByName(fileName);
    	if (file == null )
    		return null;
    	else {
    		int numCaratteri = 0;
    		for (java.util.Map.Entry<Integer, String> fileEntry : file.entrySet()) {
    			if (fileEntry.getKey() != 0 && fileEntry.getKey() != 1 ) {
    				String riga = fileEntry.getValue();
    				System.out.println("Analizzo la riga: " + riga);
    				for (int i = 0; i < riga.length(); i++) {
						if ( !Character.isDigit(riga.charAt(i))) {
							numCaratteri++;
						}
					}
    			}
			}
    		this.setNumCaratteriAlfabetici(fileName, numCaratteri);
    		return "Il numero di caratteri alfabetici del file è uguale a " + numCaratteri;
    	}
    }
    
    public synchronized String contaCaratteriNumerici(String fileName) {
    	Map<Integer, String > file = getFileByName(fileName);
    	if (file == null )
    		return null;
    	else {
    		int numCaratteri = 0;
    		for (java.util.Map.Entry<Integer, String> fileEntry : file.entrySet()) {
    			if (fileEntry.getKey() != 0 && fileEntry.getKey() != 1 ) {
    				String riga = fileEntry.getValue();
    				System.out.println("Analizzo la riga: " + riga);
    				for (int i = 0; i < riga.length(); i++) {
						if ( Character.isDigit(riga.charAt(i))) {
							numCaratteri++;
						}
					}
    			}
			}
    		this.setNumCaratteriNumerici(fileName, numCaratteri);
    		return "Il numero di caratteri numerici del file è uguale a " + numCaratteri;
    	}
    }
    
    public synchronized boolean eliminaRiga(String fileName, int riga) {
    	System.out.println("Admin chiede l'eliminazione della riga " + riga + " dal file " + fileName);
    	
    	Map<Integer, String > oldFile = getFileByName(fileName);
    	if (oldFile == null )
    		return false;
    	else {
    		Map<Integer, String> newFile = new HashMap<>();
    		for (java.util.Map.Entry<Integer, String> fileEntry : oldFile.entrySet()) {
    			if (fileEntry.getKey() == 0) {
    				newFile.put(0, "");
    			} else if (fileEntry.getKey() == 1) {
    				newFile.put(1, "");
    			} else {
    				if (fileEntry.getKey() < riga ) {
    					newFile.put(fileEntry.getKey(), fileEntry.getValue());
    				} else if (fileEntry.getKey() > riga) {
    					newFile.put(fileEntry.getKey() - 1, fileEntry.getValue());
    				}
    			}
			}
    		
    		System.out.println("Nuovo file: " + newFile.toString());
    		
    		this.setFileByName(fileName, newFile);
    		return true;
    	}
    }
    
    public synchronized Map<Integer, String> getFileByName(String fileName) {
    	if (fileName.equalsIgnoreCase("file1")) {
    		return files.get(0);
    	}else if (fileName.equalsIgnoreCase("file2")) {
    		return files.get(1);
    	} else return null;
    }
    
    private void setFileByName(String fileName, Map<Integer, String> newFile) {
    	if (fileName.equalsIgnoreCase("file1")) {
    		files.set(0, newFile);
    	}else if (fileName.equalsIgnoreCase("file2")) {
    		files.set(1, newFile);
    	}
    }

}
