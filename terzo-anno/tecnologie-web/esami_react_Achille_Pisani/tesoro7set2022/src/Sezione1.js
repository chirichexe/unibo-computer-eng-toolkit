/*
 * Nome Cognome - Matricola 0000000000
 *
 * Tecnologie Web T - A.A. 2024-2025
 * Template non ufficiale (unibo-computer-eng-toolkit): sostituisci i tuoi dati
 * e verifica che il contenuto sia ancora valido per il tuo anno accademico.
 */

import React, { Component } from "react";

class Sezione1 extends Component {
    constructor(props) {
        super(props);
        this.state = {
            lunghezza: 0,
            larghezza: 0,
            error: "",
        };
    }

    validateInputs = () => {
        const { lunghezza, larghezza } = this.state;
        
        if (larghezza < 5 || lunghezza < 5 ) {
            this.setState({ error: "Errore nei campi" });
            return false;
        }
        this.setState({ error: "" });
        return true;
    };

    handleSubmit = () => {
        if (this.validateInputs()) {
            const { lunghezza, larghezza } = this.state;
            this.props.onInputSubmit({ lunghezza, larghezza });
        }
    };

    render() {
        const { error } = this.state;
        const { name } = this.props;

        return (
            <div>
                <h2>{name}</h2>
                <input type="number" onChange={(e) => this.setState({ lunghezza: Number(e.target.value) })} />
                <input type="number" onChange={(e) => this.setState({ larghezza: Number(e.target.value) })} />
                <button onClick={this.handleSubmit}>Invia</button>
                {error && <p style={{ color: "red" }}>{error}</p>}
            </div>
        );
    }
}

export default Sezione1;