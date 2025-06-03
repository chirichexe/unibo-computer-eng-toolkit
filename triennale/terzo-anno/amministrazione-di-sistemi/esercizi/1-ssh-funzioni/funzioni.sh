#!/bin/bash

# VARIABILI
name="Davide"
number=5
# Accesso variabili
echo "Ciao, $name"
#-----

# IF / ELSE / ELIF
if [ "$number" -gt 10 ]; then
  echo "Maggiore di 10"
elif [ "$number" -eq 10 ]; then
  echo "Uguale a 10"
else
  echo "Minore di 10"
fi
#-----

# CASE
read -p "Comando (start/stop): " cmd
case $cmd in
  start) echo "Avvio...";;
  stop) echo "Stop...";;
  *) echo "Comando sconosciuto";;
esac
#-----

# FOR (array)
fruits=("mela" "banana")
for fruit in "${fruits[@]}"; do
  echo "Frutto: $fruit"
done
#-----

# FOR ((...)) stile C
for (( i=0; i<3; i++ )); do
  echo "i: $i"
done
#-----

# WHILE
n=0
while [ $n -lt 2 ]; do
  echo "n: $n"
  ((n++))
done
#-----

# UNTIL
m=0
until [ $m -ge 2 ]; do
  echo "m: $m"
  ((m++))
done
#-----

# FUNZIONE
greet() {
  echo "Ciao $1"
}
greet "Davide"
#-----

# FUNZIONE CON OUTPUT
square() {
  echo $(( $1 * $1 ))
}
res=$(square 4)
echo "Quadrato: $res"
#-----

# SUBSTITUTION
oggi=$(date)
echo "Data: $oggi"
#-----

# READ FILE
file="file.txt"
if [ -f "$file" ]; then
  while IFS= read -r line; do
    echo "Linea: $line"
  done < "$file"
fi
#-----

# PARAMETRI SCRIPT
echo "Arg 1: $1"
echo "Tutti: $@"
#-----

# EXIT STATUS
ls /nonexistent
if [ $? -ne 0 ]; then
  echo "Errore comando"
fi
#-----

# TRAP
trap "echo 'CTRL+C premuto'; exit" SIGINT
# sleep 30
#-----


# GENERAZIONE NUMERO CASUALE
echo $((RANDOM % 40))

