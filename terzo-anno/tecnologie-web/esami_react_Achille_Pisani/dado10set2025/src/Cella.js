import React, { Component } from "react";

class Cella extends Component {

    handleClick = () => {
        const { element, end } = this.props;
        
        if ( !element.revealed && !end ) {
            this.props.onElementClick();
        }
    };

    render() {
        const { element } = this.props;

        // Seleziono il colore della cella
        let colore = "grey"
        if (element.revealed===1) {
            colore = "yellow"
        }
        if (element.revealed===2) {
            colore = "red"
        }
        if (element.revealed===3) {
            colore = "green"
        }
        if (element.revealed===4) {
            colore = "blue"
        }
        if (element.revealed===5) {
            colore = "purple"
        }
        if (element.revealed===6) {
            colore = "cyan"
        }
        
        return (
            <div
                onClick={this.handleClick}
                style={{
                    display: "flex",
                    alignItems: "center",
                    justifyContent: "center",
                    width: 25,
                    height: 25,
                    margin: 4,
                    backgroundColor: colore,
                }}
            >
                { <p>{element.number}</p> }
            </div>
        );
    }
}

export default Cella;
