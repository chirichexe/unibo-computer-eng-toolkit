# "$recursive_command" "$str" "$dir"

cd "$2"
echo "Mi trovo sulla directory `pwd`"
n=0

for file in * ; do
    if [[ -f "$file" ]] ; then
        #Lavoro sul file
        if [[ "$file" = *"$1" ]] ; then
            echo Trovato il file $file con estensione .str nella directory $2
            n=`expr $n + 1`
            
            #UTILI
            #n_occorrenze_stringa=`grep -o StringaDaRicercare $file | wc -l`
            #proprietario=`ls -l $file | awk '{print $3}'`
            #dim=`ls -l $file | awk '{print $5}'`

        fi
    elif [[ -d "$file" ]] ; then
        #echo "Inizio ricorsione dir `pwd`/$file"
        "$0" "$1" "$file"
    fi
done

#stampo sul report
echo "La directory `pwd` ne contiene $n" >> $HOME/report
