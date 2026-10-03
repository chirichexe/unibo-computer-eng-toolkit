import React, { Component } from "react";

class Cella extends Component {



    render() {
        const { element } = this.props;
        const { rowIndex } = this.props;

        // Seleziono il colore della cella

        const coloriRighe = ["green", "blue", "orange", "purple", "red", "cyan", "magenta"];

        let colore = "grey"
        if (element.revealed) {
            colore = coloriRighe[rowIndex];
        }
        
        return (
            <div
                style={{
                    display: "flex",
                    alignItems: "center",
                    justifyContent: "center",
                    width: 80,
                    height: 25,
                    margin: 4,
                    backgroundColor: colore,
                }}
            >
                {<p>{element.number}</p> }
            </div>
        );
    }
}

export default Cella;
