/*
 * Nome Cognome - Matricola 0000000000
 *
 * Tecnologie Web T - A.A. 2024-2025
 * Template non ufficiale (unibo-computer-eng-toolkit): sostituisci i tuoi dati
 * e verifica che il contenuto sia ancora valido per il tuo anno accademico.
 */

import React, { Component } from "react";
import Cella from "./Cella";

class Sezione2 extends Component {
    renderPanel = () => {
        const { panelMatrix, end } = this.props;
    
        return panelMatrix.map((row, rowIndex) => (
            <div key={rowIndex} style={{ display: "flex" }}>
                {row.map((element, colIndex) => (
                    <Cella 
                        key={colIndex} 
                        element={element} 
                        onElementClick={() => ""}
                        end={end} 
                    />
                ))}
            </div>
        ));
    };

    handleEstrai = () => {
        this.props.onEstrai();
    }

    render() {
		
		const { name, ultimoEstratto } = this.props;
		
        return (
            <div>
                <h2>{name}</h2>
                <button onClick={this.handleEstrai}>ESTRAI NUMERO</button>
                {ultimoEstratto && <h3>{"Ultimo numero estratto: "+ultimoEstratto}</h3>}
                {this.renderPanel()}
            </div>
        );
    }
}

export default Sezione2;
