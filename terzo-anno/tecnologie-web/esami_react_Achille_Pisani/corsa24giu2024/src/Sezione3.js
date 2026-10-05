/*
 * Nome Cognome - Matricola 0000000000
 *
 * Tecnologie Web T - A.A. 2024-2025
 * Template non ufficiale: sostituisci i tuoi dati
 * e verifica che il contenuto sia ancora valido per il tuo anno accademico.
 */

import React, { Component } from "react";



class Sezione3 extends Component {

    /*printVincitori = () => {
        const {vincitori}=this.props;
        
        let str ="";

        for(let i=0;i<vincitori.length;i++)
        {
            str+=vincitori[i]+"classificato: "+i+"\n";
        }
        return str;
    };*/

    printVincitori = () => {
        const { vincitori } = this.props;

        // Creiamo un array di coppie [vincitore, indice]
        const coppie = vincitori.map((pos, i) => ({ pos, i }));

        // Ordiniamo per posizione crescente
        coppie.sort((a, b) => a.pos - b.pos);

        // Generiamo l'elenco puntato
        return (
            <ul>
                {coppie.map((coppia, idx) => (
                    <li key={idx}>
                        Classificato {coppia.pos}: giocatore {coppia.i}
                    </li>
                ))}
            </ul>
        );
    };


    render() {
        const { name, end } = this.props;

        return (
            <div>
                <h2>{name}</h2>

                <p>{ end && "Partita terminata" }</p>
                
                {end && this.printVincitori()}

                { end && <button onClick={this.props.onResettaPartita}>Resetta</button>}
            </div>
        );
    }
}

export default Sezione3;
