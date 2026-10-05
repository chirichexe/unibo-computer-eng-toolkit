/*
 * Nome Cognome - Matricola 0000000000
 *
 * Tecnologie Web T - A.A. 2024-2025
 * Template non ufficiale: sostituisci i tuoi dati
 * e verifica che il contenuto sia ancora valido per il tuo anno accademico.
 */

import React, { Component } from "react";
import Cella from "./Cella";

class Sezione2 extends Component {


    renderPanel = () => {
        const { rubrica } = this.props;
    
        return rubrica.map((element, rowIndex) => (
            <div key={rowIndex} style={{ display: "flex" }}>
                <Cella  key={rowIndex}  element={element} onElementClick={(el) => (this.props.onAction(el)) }/>

            </div>
        ));
    };

    render() {
        return (
            <div>
                <h2>{this.props.name}</h2>
                {this.renderPanel()}
            </div>
        );
    }
}

export default Sezione2;
