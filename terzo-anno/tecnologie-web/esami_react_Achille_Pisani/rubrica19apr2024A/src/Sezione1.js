/*
 * Nome Cognome - Matricola 0000000000
 *
 * Tecnologie Web T - A.A. 2024-2025
 * Template non ufficiale: sostituisci i tuoi dati
 * e verifica che il contenuto sia ancora valido per il tuo anno accademico.
 */

import React, { Component } from "react";

class Sezione1 extends Component {
    constructor(props) {
        super(props);
        this.state = {
            nome: "",
            error: "",
        };
    }

    validateInputs = () => {
        const { nome } = this.state;

        if (!nome.length>0) {
            this.setState({ error: "Errore nei campi" });
            return false;
        }
        this.setState({ error: "" });
        return true;
    };

    handleSubmit = () => {
    const { nome } = this.state;
        if (this.validateInputs()) {
            this.props.onInputSubmit({nome});
        }
    };

    render() {
        const { error } = this.state;
        const { name } = this.props;

        return (
            <div>
                <h2>{name}</h2>
                <input type="text" placeholder="Inserisci nome" onChange={(e) => this.setState({ nome: e.target.value })} />
                <button onClick={this.handleSubmit}>Avvia Ricerca</button>
                {error && <p style={{ color: "red" }}>{error}</p>}
            </div>
        );
    }
}

export default Sezione1;