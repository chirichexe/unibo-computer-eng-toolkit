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
            sectionNames: [ "Ricerca", "Display", "Aggiunta nome" ],
            // Dati in input per l'app
            inputData: null,
            panelMatrix: null,
            // Gestione elemento corrente
            currentElement: null, //TEMPLATE

            rubrica: [
                { nome : "achille" , numero: "3931700486" },
                { nome: "ciro" , numero: "333475464" },
                { nome: "cardillo" , numero: "12423423" }
            ],

            rubricaDaInviare: [],

            end: false,
        };
    }

    // Sezione1 passa gli input, App.js li memorizza nello stato e li passa a Sezione2
    // Dopo aver generato la matrice
    handleInputData = (data) => {

        // Altri parametri di configurazione della matrice qui...

        const { rubrica } = this.state;
        let tmpRubrica = [];
        let c=0;

        for(let i=0; i<rubrica.length; i++){
            if(rubrica.at(i).nome.startsWith(data.nome))
            {
                tmpRubrica.push(rubrica.at(i));
                console.log(tmpRubrica.at(c++));
            }

        }

        this.setState({ inputData: data, rubricaDaInviare: tmpRubrica });
    };

    // Sezione2 viene mostrata quando ci sono gli input
    // Appena viene eseguita l'azione li passa alla Sezione3
    handleAction = (element) => {
        const { rubrica } = this.state;
        this.setState({ rubrica : rubrica.filter(item => item !== element ) })
    };

handleAggiungi = (data) => {
    const { rubrica } = this.state;
    let flag=0;

    for(let i=0; i<rubrica.length; i++){
            if(rubrica.at(i).nome === (data.nome) && rubrica.at(i).numero === (data.numero))
            {
                alert("IL CONTATTO "+rubrica.at(i).nome+" COL NUMERO "+rubrica.at(i).numero+" ESISTE GIA \n se vuoi cambiargli il numero elimina il contatto e ricrealo");
                console.log("ho trovato gia in rubrica: ",rubrica.at(i));
                flag++;
                break;
            }

            if(rubrica.at(i).nome === (data.nome))
            {
                const conferma = window.confirm("gia presente un contatto con questo nome, sostituire?")
                if(!conferma)
                {
                    
                    flag++;
                    break;
                } else {
                    this.handleAction(rubrica.at(i));
                }
            }
        }

        if(flag===0)
        {
            let occ={ nome: data.nome, numero: data.numero }
            this.setState(prevState => ({
                rubrica: [...prevState.rubrica, occ]
            }));
        }


        this.handleResettaPartita();
    }

    handleResettaPartita = () => {




        this.setState({
            inputData: null,
            panelMatrix: null,
            currentElement: null,
            revealedElements: [],
            end: false,
        })
    }

    render() {
        const { sectionNames, inputData, end, revealedElements, currentElement, rubricaDaInviare } = this.state;

        return (
            <div>
                <h1>Esame Achille Pisani</h1>
                <Sezione1
                    name={this.state.sectionNames[0]}

                    onInputSubmit={this.handleInputData}
                />
                {inputData && (
                    <div>
                        <Sezione2
                            name={sectionNames[1]}

                            rubrica={rubricaDaInviare}
                            end={end}

                            onAction={this.handleAction}
                        />
                        <Sezione3
                            name={sectionNames[2]}
                            
                            currentElement={currentElement}
                            revealedElements={revealedElements}
                            end={end}
                            
                            onAggiungi={this.handleAggiungi}
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