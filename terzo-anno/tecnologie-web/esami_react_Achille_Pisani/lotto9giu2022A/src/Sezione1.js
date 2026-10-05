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
            n1:0,
            n2:0,
            n3:0,
            n4:0,
            n5:0,
            error: "",
        };
    }

    validateInputs = () => {
        const { n1, n2, n3, n4, n5 } = this.state;
        
        if ((n1>10 || n1<1) || (n2>10 || n2<1) || (n3>10 || n3<1) || (n4>10 || n4<1) || (n5>10 || n5<1)) {
            this.setState({ error: "Errore nei campi" });
            return false;
        }
        this.setState({ error: "" });
        return true;
    };

    handleSubmit = () => {
        if (this.validateInputs()) {
            const { n1, n2, n3, n4, n5 } = this.state;
            this.props.onInputSubmit({ n1, n2, n3, n4, n5  });
        }
    };

    render() {
        const { error } = this.state;
        const { name } = this.props;

        return (
            <div>
                <h2>{name}</h2>
                <input type="number" placeholder="numero da 1 a 10 (1)" onChange={(e) => this.setState({ n1: Number(e.target.value) })} /><br></br>
                <input type="number" placeholder="numero da 1 a 10 (2)" onChange={(e) => this.setState({ n2: Number(e.target.value) })} /><br></br>
                <input type="number" placeholder="numero da 1 a 10 (3)" onChange={(e) => this.setState({ n3: Number(e.target.value) })} /><br></br>
                <input type="number" placeholder="numero da 1 a 10 (4)" onChange={(e) => this.setState({ n4: Number(e.target.value) })} /><br></br>
                <input type="number" placeholder="numero da 1 a 10 (5)" onChange={(e) => this.setState({ n5: Number(e.target.value) })} /><br></br>
                <button onClick={this.handleSubmit}>Invia</button>
                {error && <p style={{ color: "red" }}>{error}</p>}
            </div>
        );
    }
}

export default Sezione1;