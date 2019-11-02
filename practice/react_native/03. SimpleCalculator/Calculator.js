import React from 'react';
import { StyleSheet, Text, View, TouchableOpacity } from 'react-native';

export default class Calculator extends React.Component {

    constructor() {
        super();
        this.state = {
            resultText: ""
        }
    }

    numberPressed(text) {
        const calculation = this.state.resultText;
        switch (text) {
            // calculate the function
            case '=': {
                if (!['+', '-', '*', '/'].includes(calculation.slice(-1))) {
                    this.setState({
                        resultText: eval(calculation).toString()
                    });
                }
                break;
            }

            // add floating point (only one floating point)
            case '.': {
                if (calculation.includes('.')) return;
            }

            // default press
            default: {
                this.setState({
                    resultText: calculation + text
                });
                break;
            }
        }
    }

    operatorPressed(text) {
        let calText = this.state.resultText.split('');
        switch (text) {
            // delete a char
            case 'DEL': {
                calText.pop();
                break;
            }

            // add a char
            default: {
                if (calText.length === 0) return;

                const lastChar = calText.pop();
                const isOperatorChar = ['+', '-', '*', '/'].includes(lastChar);
                if (!isOperatorChar) {
                    calText.push(lastChar);
                }
                calText.push(text);
                break;
            }
        }

        // reload calculation
        this.setState({
            resultText: calText.join('')
        });
    }

    buildNumberRows() {
        const nums = [[7, 8, 9], [4, 5, 6], [1, 2, 3], ['.', 0, '=']];
        const output = [];
        for (let i = 0; i < 4; i++) {
            row = []
            for (let j = 0; j < 3; j++) {
                row.push(<TouchableOpacity style={styles.btn} onPress={() => this.numberPressed(nums[i][j])}>
                    <Text style={styles.btnText}>{nums[i][j]}</Text>
                </TouchableOpacity>)
            }
            output.push(<View style={styles.row}>{row}</View>);
        }
        return output;
    }

    buildOperatorRow() {
        const ops = ['DEL', '+', '-', '*', '/'];
        const output = [];
        for (const op of ops) {
            output.push(<TouchableOpacity style={styles.btn} onPress={() => this.operatorPressed(op)}>
                <Text style={styles.btnText}>{op}</Text>
            </TouchableOpacity>)
        }
        return output;
    }

    render() {
        const num_rows = this.buildNumberRows();
        const ops_row = this.buildOperatorRow();
        return (
            <View style={styles.container}>
                <View style={styles.calculation}>
                    <Text style={styles.resultText}>{this.state.resultText}</Text>
                </View>

                <View style={styles.buttons}>
                    <View style={styles.numbers}>{num_rows}</View>
                    <View style={styles.operations}>{ops_row}</View>
                </View>
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
    },

    calculation: {
        flex: 1,
        backgroundColor: 'white',
        justifyContent: 'center',
        paddingRight: 10
    },

    buttons: {
        flex: 4,
        flexDirection: 'row',
    },

    numbers: {
        flex: 3,
        backgroundColor: 'darkgray',
    },

    operations: {
        flex: 1,
        backgroundColor: 'lightgray'
    },

    row: {
        flex: 1,
        flexDirection: 'row',
        justifyContent: 'space-around',
        alignItems: 'center'
    },

    btn: {
        flex: 1,
        alignItems: 'center',
        alignSelf: 'stretch',
        justifyContent: 'center',
    },

    btnText: {
        fontSize: 30
    },

    resultText: {
        fontSize: 45,
        textAlign: 'right',
    }
});