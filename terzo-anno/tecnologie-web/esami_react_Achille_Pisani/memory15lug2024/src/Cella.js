/*
 * Nome Cognome - Matricola 0000000000
 *
 * Tecnologie Web T - A.A. 2024-2025
 * Template non ufficiale: sostituisci i tuoi dati
 * e verifica che il contenuto sia ancora valido per il tuo anno accademico.
 */

import React, { Component } from "react";

class Cella extends Component {

    handleClick = () => {
        const { element, end } = this.props;
        
        if ( !element.revealed && !end ) {
            this.props.onElementClick();
        }
    };

    render() {
        const { element } = this.props;

        // Seleziono il colore della cella
        let colore = "grey"
        if (element.revealed) {
            colore = "green"
        }
        
        return (
            <div
                onClick={this.handleClick}
                style={{
                    display: "flex",
                    alignItems: "center",
                    justifyContent: "center",
                    width: 25,
                    height: 25,
                    margin: 4,
                    backgroundColor: colore,
                }}
            >
                { element.revealed && <p>{element.number}</p> }
            </div>
        );
    }
}

export default Cella;
