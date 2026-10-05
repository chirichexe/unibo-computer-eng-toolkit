/*
 * Nome Cognome - Matricola 0000000000
 *
 * Tecnologie Web T - A.A. 2024-2025
 * Template non ufficiale: sostituisci i tuoi dati
 * e verifica che il contenuto sia ancora valido per il tuo anno accademico.
 */

import React, { Component } from "react";

class Sezione3 extends Component {
constructor(props) {
        super(props);
        this.state = {
            nome: "",
            numero: "",
            error: "",
        };
    }

    validateInputs = () => {
        const { nome } = this.state;

        if (!nome.length>0) {
            this.setState({ error: "Errore nei campi" });
            return false;
        }
        this.setState({ error: "" });
        return true;
    };

    handleAggiungi = () => {
        
        const { nome } = this.state;
        const {numero} = this.state;
        if (this.validateInputs()) {
            this.props.onAggiungi({nome, numero});
        }
        
    };


    render() {
       
      const { name,end } = this.props;
        return (
            <div>
                <h2>{name}</h2>
                <input type="text" placeholder="Inserisci nome" onChange={(e) => this.setState({ nome: e.target.value })} />
                <input type="text" placeholder="Inserisci numero" onChange={(e) => this.setState({ numero: e.target.value })} />
                <button onClick={this.handleAggiungi}>Aggiungi contatto</button>


                <p>{ end && "Fine!" }</p>
               
            </div>
        );


        /* const { name, end, revealedElements, currentElement } = this.props;

        return (
            <div>
                <h2>{name}</h2>

                <p>{ end && "Partita terminata" }</p>
                <p> { currentElement && currentElement.number } </p>
                <ul>
                    { revealedElements.length > 0 && revealedElements.map((el) => {
                        return <li>{el.number}</li>
                    })}
                </ul>

                { end && <button onClick={this.props.onResettaPartita}>Resetta</button>}
            </div>
        );
    }*/
}}

export default Sezione3;
