def rimuovi_righe_duplicate_e_conflitti(file_path):
    domande_uniche = {}
    try:
        with open(file_path, 'r') as file:
            righe = file.readlines()

        for riga in righe:
            riga = riga.strip()
            if ',' not in riga or len(riga.rsplit(',', 1)[1].strip()) != 1:
                print(f"Formato non valido: {riga}")
                continue
            domanda, risposta = riga.rsplit(',', 1)
            risposta = risposta.strip()
            if domanda in domande_uniche:
                if domande_uniche[domanda] != risposta:
                    print(f"Conflitto trovato per: '{domanda}'. Risposte: {domande_uniche[domanda]} vs {risposta}")
                    scelta = input("Quale risposta vuoi mantenere? (inserisci il numero): ").strip()
                    if scelta in ['0', '1']:
                        domande_uniche[domanda] = scelta
                    else:
                        print("Scelta non valida. Mantenuta la risposta originale.")
            else:
                domande_uniche[domanda] = risposta

        with open(file_path.replace('.txt', '_modificato.txt'), 'w') as file_modificato:
            for domanda, risposta in domande_uniche.items():
                file_modificato.write(f"{domanda},{risposta}\n")
        print("File modificato creato con successo.")
    except Exception as e:
        print(f"Si è verificato un errore: {e}")

# Sostituisci 'percorso_del_tuo_file.txt' con il percorso effettivo del tuo file
rimuovi_righe_duplicate_e_conflitti('SECquestions.txt')