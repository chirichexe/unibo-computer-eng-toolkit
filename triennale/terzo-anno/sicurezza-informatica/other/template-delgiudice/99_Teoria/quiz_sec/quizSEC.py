import random
import time  # Passo 1

def esegui_quiz(file_quiz):
    print("- Benvenuto al quiz di Sicurezza Informatica!\n- Il quiz è formato da 36 domande.\n- Rispondi con 'v' per vero e 'f' per falso.\n- Ogni risposta corretta vale 1 punto, ogni errore ti costa 0.75 punti.")
    
    numero_domande = 0
    risposte_corrette = 0
    domande = []

    with open(file_quiz, 'r') as file:
        for line in file:
            line = line.strip()
            if ',' not in line:
                continue  # Ignora le righe che non contengono una virgola
            domanda, _, risposta_corretta = line.rpartition(',')
            domande.append((domanda, risposta_corretta))

    random.shuffle(domande)
    domande = domande[:36]  # Seleziona solo le prime 36 domande

    tempo_inizio = time.time()  # Passo 2

    for i, (domanda, risposta_corretta) in enumerate(domande, start=1):
        numero_domande += 1
        if domanda.startswith('x'):
            print("\nDomanda non verificata:")
            domanda = domanda[1:]
        risposta_utente = input(f"\n{i}. {domanda} (v/f): ").lower()

        while risposta_utente != 'v' and risposta_utente != 'f':
            print("Risposta non valida. Inserisci 'v' per vero o 'f' per falso.")
            risposta_utente = input(f"{i}. {domanda} (v/f): ").lower()

        if (risposta_utente == 'v' and risposta_corretta == '1') or (risposta_utente == 'f' and risposta_corretta == '0'):
            print("Corretto!")
            risposte_corrette += 1
        else:
            risposte_corrette -= 0.75
            print("Sbagliato!")
            # Chiedi all'utente se vuole aggiungere una nota
            nota = input("Vuoi aggiungere una nota a questa domanda? (lascia vuoto per non aggiungere): ")
            # Apri il file in modalità append
            with open("./domandeSbagliate.txt", "a") as file_domande_sbagliate:
                # Scrivi la domanda e la nota (se presente) nel file
                file_domande_sbagliate.write(f"Domanda: {domanda}\n")
                if nota:
                    file_domande_sbagliate.write(f"Nota: {nota}\n")
                file_domande_sbagliate.write("\n")  # Aggiungi una riga vuota per separare le domande

    tempo_fine = time.time()  # Passo 3
    tempo_impiegato = tempo_fine - tempo_inizio  # Passo 4
    minuti, secondi = divmod(tempo_impiegato, 60)  # Passo 5
    print(f"\n\nHai completato il quiz in {int(minuti)} minuti e {int(secondi)} secondi.")  # Passo 6
    print(f"Il tuo punteggio è {risposte_corrette}.")

# Sostituisci 'SECquestions.txt' con il percorso corretto del file
esegui_quiz('SECquestions.txt')
