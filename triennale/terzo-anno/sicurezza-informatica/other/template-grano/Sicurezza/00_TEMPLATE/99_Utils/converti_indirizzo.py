def converti_in_little_endian(indirizzo):
    # Passo 1: Rimuovi il prefisso "0x" se presente
    if indirizzo.startswith("0x"):
        indirizzo = indirizzo[2:]
    
    # Passo 2: Assicurati che la lunghezza della stringa sia un multiplo di 2
    if len(indirizzo) % 2 != 0:
        indirizzo = "0" + indirizzo
    
    # Passo 3 e 4: Dividi in gruppi di due e inverti l'ordine
    bytes_invertiti = [indirizzo[i:i+2] for i in range(0, len(indirizzo), 2)][::-1]
    
    # Passo 5 e 6: Aggiungi "\x" davanti a ogni gruppo e unisci in una stringa
    risultato = "\\x" + "\\x".join(bytes_invertiti)  # Modifica qui
    
    return risultato

# Chiedi all'utente di inserire l'indirizzo come stringa
indirizzo = input("Inserisci l'indirizzo come stringa: ")

indirizzo_little_endian = converti_in_little_endian(indirizzo)
print(indirizzo_little_endian)