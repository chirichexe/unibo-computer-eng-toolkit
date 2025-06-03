TARNAME = 0001071414.tar
DATE ?= $(shell date +%d-%m-%Y)

.PHONY: all consegna run reset clear provision

all: consegna

consegna:
	
	tar -cf $(TARNAME) --exclude='./esame/.vagrant'  --transform="s|^esame|$(DATE)|"  esame

run:
	cd esame && vagrant up

provision:
	cd esame && vagrant up --provision

reset:
	cd esame && vagrant destroy -f && vagrant up

clear:
	rm -f $(TARNAME)
