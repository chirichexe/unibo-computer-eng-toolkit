/*
 * Nome Cognome - Matricola 0000000000
 *
 * Tecnologie Web T - A.A. 2024-2025
 * Template non ufficiale (unibo-computer-eng-toolkit): sostituisci i tuoi dati
 * e verifica che il contenuto sia ancora valido per il tuo anno accademico.
 */

import React, { Component } from "react";
import Cella from "./Cella";

class Sezione3 extends Component {


        renderPanel = () => {
        const { panelMatrix2, end } = this.props;
    
        return panelMatrix2.map((row, rowIndex) => (
            <div key={rowIndex} style={{ display: "flex" }}>
                {row.map((element, colIndex) => (
                    <Cella 
                        key={colIndex} 
                        element={element} 
                        end={end} 
                    />
                ))}
            </div>
        ));
    };




    render() {
        const { name, end, revealedElements, currentElement, estratto } = this.props;

        return (
            <div>
                <h2>{name}</h2>

                {<button onClick={this.props.onEstrai}>ESTRAI NUMERI</button> }

                {estratto && this.renderPanel()}

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
