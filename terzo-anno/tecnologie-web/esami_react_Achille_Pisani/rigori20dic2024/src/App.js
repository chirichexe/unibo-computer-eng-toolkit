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
            sectionNames: [ "Benvenuto, giocatore", "Calcia", "Punteggio" ],
            // Dati in input per l'app
            inputData: null,
            panelMatrix: null,
            panelMatrix2: null,
            isPremibile: true,
            tiriCPU: [],
            golCPU: 0,
            golUSR: 0,
            turno: 0,
            giaDetto: 0,
            // Gestione elemento corrente
            currentElement: null, //TEMPLATE

            // Gestioni sezione finale
            revealedElements: [],
            revealedElements2: [], //TEMPLATE
            end: false,
        };
    }

    // Sezione1 passa gli input, App.js li memorizza nello stato e li passa a Sezione2
    // Dopo aver generato la matrice
    handleInputData = (data) => {
        const panelMatrix = [];
        const panelMatrix2 = [];

        // Altri parametri di configurazione della matrice qui...

        let portiere1=[];
        portiere1[0]=Math.round(Math.random() * 5);
        portiere1[1]=portiere1[0];
        while (portiere1[1]===portiere1[0])
        {
            portiere1[0]=Math.round(Math.random() * 5);
        }

        let portiere2=[];
        portiere2[0]=Math.round(Math.random() * 5);
        portiere2[1]=portiere2[0];
        while (portiere2[1]===portiere2[0])
        {
            portiere2[0]=Math.round(Math.random() * 5);
        }


        let ind=0;

        for (let i = 0; i < data.lunghezza; i++) {
            const panelRow = [];
            const panelRow2 = [];

            for (let j = 0; j < data.larghezza; j++) {
                if (portiere1[0]===ind || portiere1[1]===ind)
                    panelRow.push({ number: "X", revealed: false });
                else 
                    panelRow.push({ number: "O", revealed: false });

                if (portiere2[0]===ind || portiere2[1]===ind)
                    panelRow2.push({ number: "X", revealed: false });
                else
                    panelRow2.push({ number: "O", revealed: false });
                
                ind++;
            }
            
            panelMatrix.push(panelRow);
            panelMatrix2.push(panelRow2);
        }

        this.setState({ inputData: data ,panelMatrix, panelMatrix2 });
    };

    // Sezione2 viene mostrata quando ci sono gli input
    // Appena viene eseguita l'azione li passa alla Sezione3
    handleAction = (row, col) => {
        if (!this.state.end && this.state.isPremibile) {
            
            // Ottengo la matrice del pannello
            const { panelMatrix, end, inputData, turno } = this.state;

            if (!end && panelMatrix && inputData) {
                
                // Setto l'elemento in posizione [row,col] come revealed
                const updatedMatrix = panelMatrix.map((panelRow, i) => (
                    panelRow.map((cell, j) => (
                        i === row && j === col ? { ...cell, revealed: panelMatrix[row][col].number } : cell
                    ))
                ));


                if(updatedMatrix[row][col].revealed==="O")
                {
                    const {golUSR}=this.state;
                    let tmp=golUSR+1;
                    this.setState({ golUSR: tmp});
                }

                // Condizioni sulla fine partita
                let newRevealedElements = this.state.revealedElements;
                let currentElement = updatedMatrix[row][col];
                let isEnd = false;
                
                if ( turno===5 ){
                    isEnd = true;
                } else {
                    newRevealedElements.push(currentElement)
                }
                
                this.setState({
                    panelMatrix: updatedMatrix,
                    revealedElements: newRevealedElements,
                    currentElement: currentElement,
                    isPremibile: false,
                    end: isEnd,
                });


                setTimeout(() => {
                    if (!this.state.end) {
                        this.tiroCPU();
                    }
                }, 3000);

                
            }
        }
    };

    tiroCPU = () => {
        const { panelMatrix2, tiriCPU, turno, revealedElements2 }=this.state;
        let tiriCPUcp = tiriCPU;
        let str="";
        let row,col;
        let re2= revealedElements2;
        
        do {
             row=Math.round(Math.random() * 1);
             col=Math.round(Math.random() * 2);
             str=""+row+""+col;
        } while (tiriCPUcp.includes(str));
        
        tiriCPUcp.push(""+row+""+col);

        

        const updatedMatrix = panelMatrix2.map((panelRow, i) => (
                    panelRow.map((cell, j) => (
                        i === row && j === col ? { ...cell, revealed: panelMatrix2[row][col].number } : cell
                    ))
                ));

                re2.push(updatedMatrix[row][col]);

                if(updatedMatrix[row][col].revealed==="O")
                {
                    const {golCPU}=this.state;
                    let tmp=golCPU+1;
                    this.setState({ golCPU: tmp});
                }

                let tmpturno=turno;
                tmpturno++;

                console.log("finito il turno "+tmpturno);

                let isEnd = false;
                
                if ( tmpturno===5 ){
                    isEnd = true;
                }

                setTimeout(() => {
                   this.setState({ isPremibile: true});
                }, 3000);

                this.setState({
                    panelMatrix2: updatedMatrix,
                    tiriCPU: tiriCPUcp,
                    turno: tmpturno,
                    end: isEnd,
                    revealedElements2: re2,
                });
    }

    handleResettaPartita = () => {
        this.setState({
            inputData: null,
            panelMatrix: null,
            currentElement: null,
            revealedElements: [],
            revealedElements2: [],
            isPremibile:true,
            turno:0,
            golCPU: 0,
            golUSR: 0,
            end: false,
            giaDetto: 0,
        })
    }

    render() {
        const { sectionNames, panelMatrix, panelMatrix2, end, revealedElements,revealedElements2, currentElement, golCPU, golUSR , giaDetto} = this.state;

        return (
            <div>
                <h1>Esame Achille Pisani</h1>
                <Sezione1
                    name={this.state.sectionNames[0]}

                    onInputSubmit={this.handleInputData}
                />
                { panelMatrix && panelMatrix2 && (
                    <div>
                        <Sezione2
                            name={sectionNames[1]}

                            panelMatrix={panelMatrix}
                            panelMatrix2={panelMatrix2}
                            end={end}

                            onAction={this.handleAction}
                        />
                        <Sezione3
                            name={sectionNames[2]}
                            
                            currentElement={currentElement}
                            revealedElements={revealedElements}
                            revealedElements2={revealedElements2}
                            golUSR={golUSR}
                            golCPU={golCPU}
                            end={end}
                            giaDetto={giaDetto}
                            
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