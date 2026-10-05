/*
 * Nome Cognome - Matricola 0000000000
 *
 * Tecnologie Web T - A.A. 2024-2025
 * Template non ufficiale: sostituisci i tuoi dati
 * e verifica che il contenuto sia ancora valido per il tuo anno accademico.
 */

import React, { Component } from "react";

class Cella extends Component {



    render() {
        const { element } = this.props;
        const { rowIndex } = this.props;

        // Seleziono il colore della cella

        const coloriRighe = ["green", "blue", "orange", "purple", "red", "cyan", "magenta"];

        let colore = "grey"
        if (element.revealed) {
            colore = coloriRighe[rowIndex];
        }
        
        return (
            <div
                style={{
                    display: "flex",
                    alignItems: "center",
                    justifyContent: "center",
                    width: 80,
                    height: 25,
                    margin: 4,
                    backgroundColor: colore,
                }}
            >
                {<p>{element.number}</p> }
            </div>
        );
    }
}

export default Cella;
