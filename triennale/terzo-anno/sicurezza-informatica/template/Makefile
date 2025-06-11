ZIP_NAME = 0001071414.zip
DATE_FOLDER = $(shell date +%F)
DIRS = $(filter-out consegna,$(MAKECMDGOALS))

consegna:
	@if [ -z "$(DIRS)" ]; then \
		echo "Errore: specifica almeno una directory da includere."; \
		exit 1; \
	fi
	@echo "Preparazione archivio $(ZIP_NAME) con cartella $(DATE_FOLDER)..."
	rm -f $(ZIP_NAME)
	mkdir -p $(DATE_FOLDER)
	@# Copia tutte le directory richieste in $(DATE_FOLDER), escludendo utils
	@for dir in $(DIRS); do \
		rsync -a --exclude 'utils/' $$dir $(DATE_FOLDER)/ ; \
	done
	zip -r $(ZIP_NAME) $(DATE_FOLDER)
	rm -rf $(DATE_FOLDER)
	@echo "Archivio creato con successo: $(ZIP_NAME)"

clear:
	rm -f $(ZIP_NAME)
	@echo "Archivio $(ZIP_NAME) eliminato."

# Per evitare errori con nomi directory come target
%:
	@true
