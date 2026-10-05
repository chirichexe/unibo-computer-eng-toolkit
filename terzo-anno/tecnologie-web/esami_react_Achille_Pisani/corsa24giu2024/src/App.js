/*
 * Nome Cognome - Matricola 0000000000
 *
 * Tecnologie Web T - A.A. 2024-2025
 * Template non ufficiale (unibo-computer-eng-toolkit): sostituisci i tuoi dati
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
            sectionNames: [ "Configurazione", "Pista", "Classifica" ],
            // Dati in input per l'app
            inputData: null,
            panelMatrix: null,

            numCorridori: null,
            
            // Gestione elemento corrente
            currentElement: null, //TEMPLATE
            posizioni: [],
            vincitori: [],
            numVincitori: 0,
            // Gestioni sezione finale
            revealedElements: [], //TEMPLATE
            end: false,
        };
    }

    // Sezione1 passa gli input, App.js li memorizza nello stato e li passa a Sezione2
    // Dopo aver generato la matrice
    handleInputData = (data) => {

        console.log("numCorridori: "+data.numCorridori)

        const panelMatrix = [];
        const posizioni = [];
        const vincitori=[];

        // Altri parametri di configurazione della matrice qui...

        for (let i = 0; i < data.numCorridori; i++) {
            const panelRow = [];
            for (let j = 0; j < 11; j++) {
                if(j===0)
                {
                    panelRow.push({
                    // Parametri da passare alle celle
                    number: "PARTENZA",
                    revealed: true
                });
                }else if(j===10)
                {
                    panelRow.push({
                    // Parametri da passare alle celle
                    number: "ARRIVO "+i,
                    revealed: false
                });
                } else{
                panelRow.push({
                    // Parametri da passare alle celle
                    number: j,
                    revealed: false
                });}
                
            }
            panelMatrix.push(panelRow);
            posizioni.push(0);
            vincitori.push(0);
        }

        this.setState({ inputData: data, panelMatrix, numCorridori: data.numCorridori, posizioni,vincitori });
    };


    
    handleAction = () => {
    const { posizioni, panelMatrix, numCorridori, vincitori } = this.state;
    let postmp = [...posizioni]; // copia dell'array
    let newMatrix = [...panelMatrix]; // copia del pannello
    const { numVincitori } =this.state;
    let conteggioVincitori=numVincitori;

    console.log("gara avviata");

    for (let i = 0; i < numCorridori; i++) {
        let temp = Math.floor(Math.random() * 3) + 1;
        postmp[i] += temp;

        if (postmp[i] < 11) {
            newMatrix[i] = newMatrix[i].map((cell, index) =>
                index < postmp[i] ? { ...cell, revealed: true } : cell
            );
        } else{
             newMatrix[i] = newMatrix[i].map((cell, index) =>
                index < 12 ? { ...cell, revealed: true } : cell
            );
            if(vincitori[i]===0)
            {
                conteggioVincitori++;
                vincitori[i]=conteggioVincitori;
                console.log("giocatore: ",i," posizione: ",vincitori[i]);
            }
                 
        }
    }

    let isEnd = false;
    
    if(conteggioVincitori===numCorridori)
    {
        isEnd = true;
    }

    this.setState({ posizioni: postmp, panelMatrix: newMatrix, end:isEnd, numVincitori: conteggioVincitori });
    return isEnd;
}

handleAuto = () => {
    this.garaInterval = setInterval(() => {
        const isEnd = this.handleAction();
        if (isEnd) {
            clearInterval(this.garaInterval); // ferma il timer
            console.log("Gara terminata!");
        }
    }, 4000);
}

    handleResettaPartita = () => {
        this.setState({
            inputData: null,
            panelMatrix: null,
            currentElement: null,
            numVincitori: 0,
            revealedElements: [],
            vincitori: [],
            posizioni: [],
            end: false,
        })
    }

    render() {
        const { sectionNames, inputData, panelMatrix, end, revealedElements, currentElement, vincitori } = this.state;

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

                            panelMatrix={panelMatrix}
                            end={end}

                            onAction={this.handleAuto}
                        />
                        <Sezione3
                            name={sectionNames[2]}
                            
                            currentElement={currentElement}
                            revealedElements={revealedElements}

                            vincitori={vincitori}

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