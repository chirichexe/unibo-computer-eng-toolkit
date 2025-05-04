// Intervallo dichiarato ogni XXX secondi
const intervalDuration = 1000;

let interval = setInterval(() => {
    const list = document.getElementById("data");
    
    fetch("S2", {
        method: "GET",
    })
    .then(response => response.text())
    .then(data => {
        console.log("Risposta dal server:", data);
        
        // Splittare la stringa per creare una lista (supponendo elementi separati da virgole)
        const items = data.split(",");
        
        // Pulire la lista esistente	
        list.innerHTML = "";

        // Aggiornare la lista con i nuovi elementi
        items.forEach(item => {
            const li = document.createElement("li");
            li.textContent = item.trim();
            list.appendChild(li);
        });
    })
    .catch(error => {
        console.error("Errore durante l'invio dei dati:", error);
    });
}, intervalDuration);

