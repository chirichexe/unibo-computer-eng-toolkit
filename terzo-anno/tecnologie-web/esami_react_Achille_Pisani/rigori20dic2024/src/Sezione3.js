/*
 * Nome Cognome - Matricola 0000000000
 *
 * Tecnologie Web T - A.A. 2024-2025
 * Template non ufficiale: sostituisci i tuoi dati
 * e verifica che il contenuto sia ancora valido per il tuo anno accademico.
 */

import React, { Component } from "react";

class Sezione3 extends Component {

    componentDidUpdate(prevProps) {
        // scatta SOLO quando end passa da false → true
        if (!prevProps.end && this.props.end) {

            const { golCPU, golUSR } = this.props;
            let vincitore;

            if (golCPU > golUSR) {
                vincitore = "VINCE CPU";
            } else if (golUSR > golCPU) {
                vincitore = "VINCE GIOCATORE";
            } else {
                let r=Math.round(Math.random() * 1);
                if(r===0)
                    vincitore = "VINCE CPU (ESTRAENDO A SORTE)";
                else
                    vincitore = "VINCE GIOCATORE (ESTRAENDO A SORTE)";
            }

            alert(vincitore);
        }
    }


    render() {
    const { name, end, revealedElements, revealedElements2, currentElement } = this.props;

    let scoreUSR = 0;
    let scoreCPU = 0;

    return (
        <div>
            <h2>{name}</h2>

            <p>{end && "Partita terminata"}</p>
            <p>{currentElement && currentElement.number}</p>

            <table border="1" cellPadding="6">
                <thead>
                    <tr>
                        <th>Tiro Utente</th>
                        <th>Score</th>
                        <th>Tiro CPU</th>
                    </tr>
                </thead>
                <tbody>
                    {revealedElements.map((el, i) => {
                        const userShot = el.number;
                        const cpuShot = revealedElements2[i]?.number ?? "-";

                        // aggiorno score progressivo
                        if (userShot === "O") scoreUSR++;
                        if (cpuShot === "O") scoreCPU++;

                        let strUserShot;
                        (userShot === "O") ? strUserShot="GOL" : (userShot === "X")? strUserShot="PARATO" : strUserShot=userShot;
                        let strCPUShot;
                        (cpuShot === "O") ? strCPUShot="GOL" : (cpuShot === "X") ? strCPUShot="PARATO" : strCPUShot=cpuShot;

                        return (
                            <tr key={i}>
                                <td>{strUserShot}</td>
                                <td>{scoreUSR} - {scoreCPU}</td>
                                <td>{strCPUShot}</td>
                            </tr>
                        );
                    })}
                </tbody>
            </table>

            {end && (
                <button onClick={this.props.onResettaPartita}>
                    Resetta
                </button>
            )}
        </div>
    );
    }

}

export default Sezione3;
