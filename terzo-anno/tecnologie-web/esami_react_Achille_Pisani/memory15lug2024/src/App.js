/*
 * Nome Cognome - Matricola 0000000000
 *
 * Tecnologie Web T - A.A. 2024-2025
 * Template non ufficiale: sostituisci i tuoi dati
 * e verifica che il contenuto sia ancora valido per il tuo anno accademico.
 */

import React, { Component } from "react";
import Sezione2 from "./Sezione2";
import Sezione3 from "./Sezione3";

class App extends Component {
    constructor(props) {
        super(props);
        this.state = {
            sectionNames: [ "1", "Gioco", "Punteggio" ],
            // Dati in input per l'app
            panelMatrix: null,

            // Gestione elemento corrente
            currentElement: null, //TEMPLATE
            target: 1,
            numFallimenti: 0,
            numFallimentiConsecutivi: 0,
            maxNumFallimentiConsecutivi: 0,
            isInStreak: false,
            // Gestioni sezione finale
            revealedElements: [], //TEMPLATE
            end: false,
        };
    }

    componentDidMount() {
        this.creaMatrix();
    }

    // Sezione1 passa gli input, App.js li memorizza nello stato e li passa a Sezione2
    // Dopo aver generato la matrice
    creaMatrix = () => {
        const panelMatrix = [];

        const numeri = [1,2,3,4,5,6,7,8,9];
        //Mischia l’array (shuffle)
        numeri.sort(() => Math.random() - 0.5);

        // Altri parametri di configurazione della matrice qui...
        let index=0;
        for (let i = 0; i < 3; i++) {
            const panelRow = [];
            for (let j = 0; j < 3; j++) {
                    panelRow.push({ number: numeri[index++], revealed: false });
            }
            panelMatrix.push(panelRow);
        }

        this.setState({ panelMatrix });
    };

    // Sezione2 viene mostrata quando ci sono gli input
    // Appena viene eseguita l'azione li passa alla Sezione3
    handleAction = (row, col) => {
        if (!this.state.end) {
            // Ottengo la matrice del pannello
            const { panelMatrix, end, target, numFallimenti, numFallimentiConsecutivi, maxNumFallimentiConsecutivi, isInStreak } = this.state;
            let tmptarg = target;
            let tmpfall = numFallimenti;
            let tmpStreak = numFallimentiConsecutivi;
            let tmpMax = maxNumFallimentiConsecutivi;
            let isIn = isInStreak;
            if (!end && panelMatrix) {
                
                // Setto l'elemento in posizione [row,col] come revealed
                let updatedMatrix = panelMatrix.map((panelRow, i) => (
                    panelRow.map((cell, j) => (
                        i === row && j === col ? { ...cell, revealed: true } : cell
                    ))
                ));

                // Condizioni sulla fine partita
                let newRevealedElements = this.state.revealedElements;
                let currentElement = updatedMatrix[row][col];
                let isEnd = false;
                
                if ( currentElement.number === tmptarg){
                    isIn=false;
                    if(tmptarg===9)
                    {    
                        isEnd = true;
                    } else {
                        tmptarg++;
                    }
                } else {
                    //newRevealedElements.push(currentElement)
                    updatedMatrix = updatedMatrix.map((panelRow, i) =>
                        panelRow.map((cell, j) =>  
                            i === row && j === col ? { ...cell, revealed: false } : cell
                        )
                    );
                    isIn=true;
                    alert("Sbagliato, qua sotto c'e' il: "+currentElement.number);
                    tmpfall++;
                    tmpStreak++;
                    if(tmpStreak>tmpMax)
                    {
                        tmpMax=tmpStreak;
                    }
                }

                if(!isIn)
                {
                    tmpStreak=0;
                }
                
                this.setState({
                    panelMatrix: updatedMatrix,
                    revealedElements: newRevealedElements,
                    currentElement: currentElement,
                    target: tmptarg,
                    numFallimenti: tmpfall,
                    numFallimentiConsecutivi: tmpStreak,
                    maxNumFallimentiConsecutivi: tmpMax,
                    isInStreak: isIn,
                    end: isEnd,
                });
            }
        }
    };

    handleResettaPartita = () => {
        this.setState({
            panelMatrix: null,
            currentElement: null,
            revealedElements: [],
            end: false,
        })
    }

    render() {
        const { sectionNames, panelMatrix, end, revealedElements, currentElement, maxNumFallimentiConsecutivi, numFallimenti } = this.state;

        return (
            <div>

                <h1>Esame Achille Pisani</h1>
                
                    <div>
                        <Sezione2
                            name={sectionNames[1]}

                            panelMatrix={panelMatrix}
                            end={end}

                            onAction={this.handleAction}
                        />
                        <Sezione3
                            name={sectionNames[2]}
                            
                            currentElement={currentElement}
                            revealedElements={revealedElements}

                            totFallimenti={numFallimenti}
                            topStreak={maxNumFallimentiConsecutivi}

                            end={end}
                            
                            onResettaPartita={this.handleResettaPartita}
                        />
                    </div>
                
            </div>
        );
    }
}

export default App;

/*
// 1. Aggiungere un elemento a un array
    const aggiungiElemento = () => {
        setItems([...items, "Pera"]); // Usa lo spread operator per aggiungere un nuovo elemento
    };
    
    // 2. Rimuovere un elemento da un array (es. "Banana")
    const rimuoviElemento = () => {
        setItems(items.filter(item => item !== "Banana")); // Filtra l'array escludendo "Banana"
    };
    
    // 3. Aggiornare un elemento nell'array (es. cambiare "Arancia" in "Limone")
    const aggiornaElemento = () => {
        setItems(items.map(item => (item === "Arancia" ? "Limone" : item))); // Sostituisce "Arancia" con "Limone"
    };
    
    // 4. Ordinare un array in ordine alfabetico
    const ordinaArray = () => {
        setItems([...items].sort()); // Crea una copia ordinata per evitare di modificare l'array originale
    };
    
    // 5. Riempire un array con un valore specifico
    const riempiArray = () => {
        setItems(new Array(5).fill("Default")); // Crea un array di lunghezza 5, riempito con "Default"
    };
    
    // 6. Trovare un elemento specifico (es. "Banana")
    const trovaElemento = () => {
        const trovato = items.find(item => item === "Banana");
        console.log("Elemento trovato:", trovato);
    };
    
    // 7. Filtrare elementi che soddisfano una condizione (es. lunghezza > 5 caratteri)
    const filtraElementi = () => {
        setItems(items.filter(item => item.length > 5)); // Mantiene solo gli elementi con lunghezza > 5
    };
    
    // 8. Unire due array
    const unisciArray = () => {
        const nuoviElementi = ["Ananas", "Uva"];
        setItems([...items, ...nuoviElementi]); // Combina gli array con lo spread operator
    };
    
    // 9. Ridurre un array a un singolo valore (es. concatenare elementi in una stringa)
    const riduciArray = () => {
        const concatenato = items.reduce((acc, item) => `${acc}, ${item}`, "Elementi:");
        console.log(concatenato);
    };
    
    // 10. Controllare se un array contiene un elemento specifico
    const contieneElemento = () => {
        const contiene = items.includes("Mela");
        console.log("Contiene 'Mela':", contiene);
    };
*/