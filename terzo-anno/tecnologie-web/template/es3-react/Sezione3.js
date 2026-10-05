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
        const { name, end, revealedElements, currentElement } = this.props;

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
    }
}

export default Sezione3;
