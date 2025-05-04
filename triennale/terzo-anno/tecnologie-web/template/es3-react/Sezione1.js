import React, { Component } from "react";

class Sezione1 extends Component {
    constructor(props) {
        super(props);
        this.state = {
            lunghezza: 0,
            larghezza: 0,
            target: 0,
            error: "",
        };
    }

    validateInputs = () => {
        const { lunghezza, larghezza, target } = this.state;
        
        if (larghezza <= 5 || lunghezza <= 5 || target > 4 ) {
            this.setState({ error: "Errore nei campi" });
            return false;
        }
        this.setState({ error: "" });
        return true;
    };

    handleSubmit = () => {
        if (this.validateInputs()) {
            const { lunghezza, larghezza, target } = this.state;
            this.props.onInputSubmit({ lunghezza, larghezza, target });
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
                <input type="number" onChange={(e) => this.setState({ target: Number(e.target.value) })} />
                <button onClick={this.handleSubmit}>Invia</button>
                {error && <p style={{ color: "red" }}>{error}</p>}
            </div>
        );
    }
}

export default Sezione1;