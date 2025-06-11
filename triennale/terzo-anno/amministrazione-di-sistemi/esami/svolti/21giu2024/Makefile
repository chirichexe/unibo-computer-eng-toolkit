TARNAME = 0001071414.tar
DATE ?= $(shell date +%d-%m-%Y)

.PHONY: all consegna run reset clear provision

all: consegna

consegna:
	
	tar -cf $(TARNAME)  --transform="s|^esame|$(DATE)|"  esame

clear:
	rm -f $(TARNAME)

