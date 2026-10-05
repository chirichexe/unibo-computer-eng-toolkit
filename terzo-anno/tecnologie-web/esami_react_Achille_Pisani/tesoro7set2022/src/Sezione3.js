/*
 * Nome Cognome - Matricola 0000000000
 *
 * Tecnologie Web T - A.A. 2024-2025
 * Template non ufficiale (unibo-computer-eng-toolkit): sostituisci i tuoi dati
 * e verifica che il contenuto sia ancora valido per il tuo anno accademico.
 */

import React, { Component } from "react";

class Sezione3 extends Component {

    render() {
        const { name, end, currentElement, errori } = this.props;
        let punti=0;
        if(end && errori<11)
        {
            punti=5;
        } else {punti=2;}
        return (
            <div>
                <h2>{name}</h2>

                <p>{ end && "Partita terminata, punteggio: "+punti }</p>
                <p>{"ERRORI = "+errori}</p>
                <p> { currentElement && currentElement.number } </p>


                { end && <button onClick={this.props.onResettaPartita}>Resetta</button>}
            </div>
        );
    }
}

export default Sezione3;
