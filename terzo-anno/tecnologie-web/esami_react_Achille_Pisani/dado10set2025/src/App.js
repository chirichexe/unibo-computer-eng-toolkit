/*
 * Nome Cognome - Matricola 0000000000
 *
 * Tecnologie Web T - A.A. 2024-2025
 * Template non ufficiale: sostituisci i tuoi dati
 * e verifica che il contenuto sia ancora valido per il tuo anno accademico.
 */

import React, { Component } from "react";
import Sezione1 from "./Sezione1";
import Sezione2 from "./Sezione2";
import Sezione3 from "./Sezione3";

class App extends Component {
    constructor(props) {
        super(props);
        this.state = {
            sectionNames: [ "Inserimento numero di lanci", "Visualizza grafico", "Risultati:" ],
            // Dati in input per l'app
            inputData: null,
            panelMatrix: null,
            ultimoEstratto: "",
            lanciFatti: 0,
            // Gestione elemento corrente
            currentElement: null, //TEMPLATE
            uscite: [0, 0, 0, 0, 0, 0],
            // Gestioni sezione finale
            revealedElements: [], //TEMPLATE
            end: false,
        };
    }

    // Sezione1 passa gli input, App.js li memorizza nello stato e li passa a Sezione2
    // Dopo aver generato la matrice
    handleInputData = (data) => {
        const panelMatrix = [];

        // Altri parametri di configurazione della matrice qui...

        for (let i = 0; i < 6; i++) {
            const panelRow = [];
            for (let j = 0; j < data.numLanci; j++) {
                if(j===0)
                {
                    panelRow.push({ number: i+1, revealed: false});
                } else {
                    panelRow.push({ number: "", revealed: false});
                }
                
            }
            panelMatrix.push(panelRow);
        }

        this.setState({ inputData: data, panelMatrix });
    };

    // Sezione2 viene mostrata quando ci sono gli input
    // Appena viene eseguita l'azione li passa alla Sezione3
    handleAction = (row, col) => {
        if (!this.state.end) {

            
            
            // Ottengo la matrice del pannello
            const { panelMatrix, end, inputData, lanciFatti, uscite } = this.state;

            let lancio = Math.floor(Math.random() * 5) + 1;
            let tmpuscite=uscite;
            tmpuscite[lancio-1]=uscite[lancio-1]+1;

            if (!end && panelMatrix && inputData) {
                    const updatedMatrix = panelMatrix.map((panelRow, i) => (
                    panelRow.map((cell, j) => (
                        i === lancio-1 && j === tmpuscite[lancio-1]-1 ? { ...cell, revealed: lancio } : cell
                    ))
                    ));

                // Condizioni sulla fine partita
                let newRevealedElements = this.state.revealedElements;
                let currentElement = updatedMatrix[lancio-1][tmpuscite[lancio-1]];
                let isEnd = false;
                let tempLanciFatti = lanciFatti+1;
                if ( tempLanciFatti === this.state.inputData.numLanci ){
                    isEnd = true;
                } else {
                    newRevealedElements.push(currentElement)
                }
                
                this.setState({
                    panelMatrix: updatedMatrix,
                    revealedElements: newRevealedElements,
                    currentElement: currentElement,
                    end: isEnd,
                    uscite: tmpuscite,
                    ultimoEstratto: lancio,
                    lanciFatti: tempLanciFatti,
                });
            }
        }
    };

    handleResettaPartita = () => {
        this.setState({
            inputData: null,
            panelMatrix: null,
            currentElement: null,
            uscite: [0, 0, 0, 0, 0, 0],
            revealedElements: [],
            end: false,
            ultimoEstratto: "",
            lanciFatti: 0,
        })
    }

    render() {
        const { sectionNames, inputData, panelMatrix, end, revealedElements, currentElement, ultimoEstratto,lanciFatti,uscite } = this.state;

        return (
            <div>
                <h1>Esame Achille Pisani</h1>
                <Sezione1
                    name={this.state.sectionNames[0]}

                    onInputSubmit={this.handleInputData}
                />
                {inputData && panelMatrix && (
                    <div>
                        <Sezione2
                            name={sectionNames[1]}
                            ultimoEstratto={ultimoEstratto}
                            panelMatrix={panelMatrix}
                            end={end}

                            onEstrai={this.handleAction}
                        />
                        <Sezione3
                            name={sectionNames[2]}
                            
                            currentElement={currentElement}
                            revealedElements={revealedElements}
                            lanciFatti={lanciFatti}
                            uscite= {uscite}
                            end={end}
                            
                            onResettaPartita={this.handleResettaPartita}
                        />
                    </div>
                )}
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