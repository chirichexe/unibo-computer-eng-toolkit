import React, { Component } from "react";
import Cella from "./Cella";

class Sezione2 extends Component {
    renderPanel = () => {
        const { panelMatrix, onAction, end } = this.props;
        
        if (!panelMatrix) return null;

        return panelMatrix.map((row, rowIndex) => (
            <div key={rowIndex} style={{ display: "flex" }}>
                {row.map((element, colIndex) => (
                    <Cella 
                        key={colIndex} 
                        element={element} 
                        onElementClick={() => onAction(rowIndex, colIndex)}
                        end={end} 
                    />
                ))}
            </div>
        ));
    };

    render() {
		
		const { name } = this.props;
		
        return (
            <div>
                <h2>{name}</h2>
                {this.renderPanel()}
            </div>
        );
    }
}

export default Sezione2;
