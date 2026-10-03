import React, { Component } from "react";

class Sezione3 extends Component {

    calcoloPerc = () => {
        const {lanciFatti,uscite}=this.props;
        if (lanciFatti)
        {
            return (
            <div>
            <p>{"Numero 1 uscito il "+(uscite[0]/lanciFatti)*100+"% delle volte"}</p><br></br>
            <p>{"Numero 2 uscito il "+(uscite[1]/lanciFatti)*100+"% delle volte"}</p><br></br>
            <p>{"Numero 3 uscito il "+(uscite[2]/lanciFatti)*100+"% delle volte"}</p><br></br>
            <p>{"Numero 4 uscito il "+(uscite[3]/lanciFatti)*100+"% delle volte"}</p><br></br>
            <p>{"Numero 5 uscito il "+(uscite[4]/lanciFatti)*100+"% delle volte"}</p><br></br>
            <p>{"Numero 6 uscito il "+(uscite[5]/lanciFatti)*100+"% delle volte"}</p><br></br>
            </div>
            )
        }
    }

    render() {
        const { name, end } = this.props;

        return (
            <div>
                <h2>{name}</h2>

                <p>{ end && "Lanci terminati." }</p>
                <p> {this.calcoloPerc() } </p>

                { end && <button onClick={this.props.onResettaPartita}>Resetta</button>}
            </div>
        );
    }
}

export default Sezione3;
