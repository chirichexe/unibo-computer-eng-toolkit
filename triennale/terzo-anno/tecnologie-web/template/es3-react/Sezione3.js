import React, { Component } from "react";

class Sezione3 extends Component {

    render() {
        const { name, end, revealedElements, currentElement } = this.props;

        return (
            <div>
                <h2>{name}</h2>

                <p>{ end && "Partita terminata" }</p>
                <p> { currentElement && currentElement.number } </p>
                <ul>
                    { revealedElements.length > 0 && revealedElements.map((el) => {
                        return <li>{el.number}</li>
                    })}
                </ul>

                { end && <button onClick={this.props.onResettaPartita}>Resetta</button>}
            </div>
        );
    }
}

export default Sezione3;
