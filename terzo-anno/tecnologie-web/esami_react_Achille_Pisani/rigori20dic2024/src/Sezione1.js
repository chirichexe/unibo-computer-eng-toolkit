import React, { Component } from "react";

class Sezione1 extends Component {
    constructor(props) {
        super(props);
        this.state = {
            lunghezza: 2,
            larghezza: 3,
            target: 0,
            error: "",
        };
    }


    handleSubmit = () => {
            const { lunghezza, larghezza, target } = this.state;
            this.props.onInputSubmit({ lunghezza, larghezza, target });
        
    };

    render() {
        const { error } = this.state;
        const { name } = this.props;

        return (
            <div>
                <h2>{name}</h2>
                <button onClick={this.handleSubmit}>PREMI PER GIOCARE</button>
                {error && <p style={{ color: "red" }}>{error}</p>}
            </div>
        );
    }
}

export default Sezione1;