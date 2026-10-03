import React, { Component } from "react";

class Sezione1 extends Component {
    constructor(props) {
        super(props);
        this.state = {
            dimensione: 0,
            passi: 0,
            error: "",
        };
    }

    validateInputs = () => {
        const { passi } = this.state;
        
        if (passi <= 3 ) {
            this.setState({ error: "Errore nei campi" });
            return false;
        }
        this.setState({ error: "" });
        return true;
    };

    handleSubmit = () => {
        if (this.validateInputs()) {
            const { dimensione, passi } = this.state;
            this.props.onInputSubmit({ dimensione, passi });
        }
    };

    render() {
        const { error } = this.state;
        const { name } = this.props;

        return (
            <div>
                <h2>{name}</h2>
                <input type="number" placeholder="dimensione" onChange={(e) => this.setState({ dimensione: Number(e.target.value) })} />
                <input type="number" placeholder="numero passi" onChange={(e) => this.setState({ passi: Number(e.target.value) })} />
                <button onClick={this.handleSubmit}>Invia</button>
                {error && <p style={{ color: "red" }}>{error}</p>}
            </div>
        );
    }
}

export default Sezione1;