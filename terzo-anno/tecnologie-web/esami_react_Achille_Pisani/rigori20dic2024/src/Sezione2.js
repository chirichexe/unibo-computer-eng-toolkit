import React, { Component } from "react";
import Cella from "./Cella";

class Sezione2 extends Component {
    renderPanel = () => {
        const { panelMatrix, onAction, end } = this.props;
    
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

    renderPanel2 = () => {
        const { panelMatrix2 ,end } = this.props;
    
        return panelMatrix2.map((row, rowIndex) => (
            <div key={rowIndex} style={{ display: "flex" }}>
                {row.map((element, colIndex) => (
                    <Cella 
                        key={colIndex} 
                        element={element} 
                        onElementClick={()=>""}
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

                porta 1 {this.renderPanel()}
                porta 2 {this.renderPanel2()}
            </div>
        );
    }
}

export default Sezione2;
