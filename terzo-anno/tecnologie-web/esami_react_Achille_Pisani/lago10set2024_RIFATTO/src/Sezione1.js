import React, { Component } from "react";

class Sezione1 extends Component {
    constructor(props) {
        super(props);
        this.state = {
            lunghezza: 0,
            larghezza: 0,
            numLanci: 0,
            error: "",
        };
    }

    validateInputs = () => {
        const { lunghezza, larghezza, numLanci } = this.state;
        
        if (larghezza <= 5 || lunghezza <= 5 || numLanci > 4 ) {
            this.setState({ error: "Errore nei campi" });
            return false;
        }
        this.setState({ error: "" });
        return true;
    };

    handleSubmit = () => {
        if (this.validateInputs()) {
            const { lunghezza, larghezza, numLanci } = this.state;
            this.props.onInputSubmit({ lunghezza, larghezza, numLanci });
        }
    };

    render() {
        const { error } = this.state;
        const { name } = this.props;

        return (
            <div>
                <h2>{name}</h2>
                <input type="number" placeholder="lunghezza" onChange={(e) => this.setState({ lunghezza: Number(e.target.value) })} />
                <input type="number" placeholder="larghezza" onChange={(e) => this.setState({ larghezza: Number(e.target.value) })} /> <br></br>
                <input type="number" placeholder="numero di lanci" onChange={(e) => this.setState({ numLanci: Number(e.target.value) })} />
                <button onClick={this.handleSubmit}>Invia</button>
                {error && <p style={{ color: "red" }}>{error}</p>}
            </div>
        );
    }
}

export default Sezione1;