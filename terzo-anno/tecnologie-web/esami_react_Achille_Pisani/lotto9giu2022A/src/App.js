import React, { Component } from "react";
import Sezione1 from "./Sezione1";
import Sezione2 from "./Sezione2";
import Sezione3 from "./Sezione3";

class App extends Component {
    constructor(props) {
        super(props);
        this.state = {
            sectionNames: [ "Compilazione", "Visualizzazione", "Estrazione" ],
            // Dati in input per l'app
            inputData: null,
            panelMatrix: null,
            panelMatrix2: null,
            // Gestione elemento corrente
            currentElement: null, //TEMPLATE
            estratto:false,

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

        for (let i = 0; i < 1; i++) {
            const panelRow = [];
            for (let j = 0; j < 5; j++) {
                let ind=j+1;
                let str="n"+ind;
                panelRow.push({
                    // Parametri da passare alle celle
                    number: data[str],
                    revealed: true
                });
            }
            panelMatrix.push(panelRow);
        }

        this.setState({ inputData: data, panelMatrix });
    };


    schedinaRandom = () => {
        const panelMatrix2 = [];
        const { inputData}=this.state;

        // Altri parametri di configurazione della matrice qui...

        //COUNT= NUMERO DI ELEMENTI UGUALI TRAI 2


        const schedinaGiocatore = [inputData.n1, inputData.n2, inputData.n3, inputData.n4, inputData.n5];

        for (let i = 0; i < 1; i++) {
            const panelRow = [];
            const numeri = [];

            while (numeri.length < 5) {
                const n = Math.floor(Math.random() * 10) + 1; // 1..10
                if (!numeri.includes(n)) {
                    numeri.push(n);
                }
            }



            const comuni = schedinaGiocatore.filter(x => numeri.includes(x));
            const count = comuni.length;
            console.log("comuni "+comuni)

            for (let j = 0; j < 5; j++) {

                if(count===2 && comuni.includes(numeri[j]))
                {
                    console.log("AMBO!");
                    panelRow.push({ number: numeri[j], revealed: "ambo" });
                    
                } else if(count===3 && comuni.includes(numeri[j]))
                {
                    console.log("TERNA!");
                    panelRow.push({ number: numeri[j], revealed: "terna" });
                } else if(count===4 && comuni.includes(numeri[j]))
                {
                    console.log("QUATERNA!");
                    panelRow.push({ number: numeri[j], revealed: "quaterna" });

                } else if(count===5 && comuni.includes(numeri[j]))
                {
                    console.log("CINQUINA!");
                    panelRow.push({ number: numeri[j], revealed: "cinquina" });
                } else {
                    console.log("niente");
                    panelRow.push({ number: numeri[j], revealed: false });
                }
            }
            panelMatrix2.push(panelRow);
        }
        this.setState({ panelMatrix2, estratto: true });
    };

    // Sezione2 viene mostrata quando ci sono gli input
    // Appena viene eseguita l'azione li passa alla Sezione3
    handleAction = (row, col) => {
        if (!this.state.end) {
            
            // Ottengo la matrice del pannello
            const { panelMatrix, end, inputData } = this.state;

            if (!end && panelMatrix && inputData) {
                
                // Setto l'elemento in posizione [row,col] come revealed
                const updatedMatrix = panelMatrix.map((panelRow, i) => (
                    panelRow.map((cell, j) => (
                        i === row && j === col ? { ...cell, revealed: true } : cell
                    ))
                ));

                // Condizioni sulla fine partita
                let newRevealedElements = this.state.revealedElements;
                let currentElement = updatedMatrix[row][col];
                let isEnd = false;
                
                if ( currentElement.number === this.state.inputData.target ){
                    isEnd = true;
                } else {
                    newRevealedElements.push(currentElement)
                }
                
                this.setState({
                    panelMatrix: updatedMatrix,
                    revealedElements: newRevealedElements,
                    currentElement: currentElement,
                    end: isEnd,
                });
            }
        }
    };

    handleResettaPartita = () => {
        this.setState({
            inputData: null,
            panelMatrix: null,
            currentElement: null,
            revealedElements: [],
            estratto:false,
            panelMatrix2: null,
            end: false,
        })
    }

    render() {
        const { sectionNames, inputData, panelMatrix, end, revealedElements, currentElement, panelMatrix2, estratto } = this.state;

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

                            onAction={this.handleAction}
                        />
                        <Sezione3
                            name={sectionNames[2]}
                            
                            currentElement={currentElement}
                            revealedElements={revealedElements}

                            onEstrai={ this.schedinaRandom }
                            estratto={estratto}
                            panelMatrix2={panelMatrix2}
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