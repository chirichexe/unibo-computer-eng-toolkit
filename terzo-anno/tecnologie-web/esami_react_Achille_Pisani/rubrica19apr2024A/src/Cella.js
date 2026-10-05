/*
 * Nome Cognome - Matricola 0000000000
 *
 * Tecnologie Web T - A.A. 2024-2025
 * Template non ufficiale (unibo-computer-eng-toolkit): sostituisci i tuoi dati
 * e verifica che il contenuto sia ancora valido per il tuo anno accademico.
 */

import React, { Component } from "react";

class Cella extends Component {


    handleClick = () => {
        
        const { element } = this.props;
        this.props.onElementClick(element);
        
    };

    render() {
        const { element } = this.props;

        // Seleziono il colore della cella
       
        return (
            <div
                style={{
                    display: "flex",
                    alignItems: "center",
                    justifyContent: "center",
                    margin: 4,
                }}
            >
                Nome: {element.nome} <br /> 
                Numero: {element.numero} 
                <button onClick={this.handleClick}>Elimina</button>
            </div>
        );
    }
}

export default Cella;
