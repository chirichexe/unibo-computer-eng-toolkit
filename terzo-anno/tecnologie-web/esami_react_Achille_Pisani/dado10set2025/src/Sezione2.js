import React, { Component } from "react";
import Cella from "./Cella";

class Sezione2 extends Component {
    renderPanel = () => {
        const { panelMatrix, end } = this.props;
    
        return panelMatrix.map((row, rowIndex) => (
            <div key={rowIndex} style={{ display: "flex" }}>
                {row.map((element, colIndex) => (
                    <Cella 
                        key={colIndex} 
                        element={element} 
                        onElementClick={() => ""}
                        end={end} 
                    />
                ))}
            </div>
        ));
    };

    handleEstrai = () => {
        this.props.onEstrai();
    }

    render() {
		
		const { name, ultimoEstratto } = this.props;
		
        return (
            <div>
                <h2>{name}</h2>
                <button onClick={this.handleEstrai}>ESTRAI NUMERO</button>
                {ultimoEstratto && <h3>{"Ultimo numero estratto: "+ultimoEstratto}</h3>}
                {this.renderPanel()}
            </div>
        );
    }
}

export default Sezione2;
