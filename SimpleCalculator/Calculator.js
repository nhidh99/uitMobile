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
            case '=': {
                if (!['+', '-', '*', '/'].includes(calculation.slice(-1))) {
                    this.setState({
                        resultText: eval(calculation).toString()
                    });
                }
                break;
            }

            case '.': {
                if (calculation.includes('.')) return;
            }

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
            case 'DEL': {
                calText.pop();
                break;
            }

            default: {
                if (calText.length === 0) return;

                const lastChar = calText.pop();
                if (!['+', '-', '*', '/'].includes(lastChar)) {
                    calText.push(lastChar);
                }

                calText.push(text);
                break;
            }
        }

        this.setState({
            resultText: calText.join('')
        });
    }

    render() {
        // construct numbers rows
        const nums = [[7, 8, 9], [4, 5, 6], [1, 2, 3], ['.', 0, '=']];
        let num_rows = [];
        for (let i = 0; i < 4; i++) {
            row = []
            for (let j = 0; j < 3; j++) {
                row.push(<TouchableOpacity style={styles.btn} onPress={() => this.numberPressed(nums[i][j])}>
                    <Text style={styles.btnText}>{nums[i][j]}</Text>
                </TouchableOpacity>)
            }
            num_rows.push(<View style={styles.row}>{row}</View>);
        }

        // construct operation rows
        let ops_row = [];
        const ops = ['DEL', '+', '-', '*', '/'];
        for (const op of ops) {
            ops_row.push(<TouchableOpacity style={styles.btn} onPress={() => this.operatorPressed(op)}>
                <Text style={styles.btnText}>{op}</Text>
            </TouchableOpacity>)
        }

        return (
            <View style={styles.container}>

                <View style={styles.calculation}>
                    <Text style={styles.resultText}>{this.state.resultText}</Text>
                </View>

                <View style={styles.buttons}>
                    <View style={styles.numbers}>
                        {num_rows}
                    </View>

                    <View style={styles.operations}>
                        {ops_row}
                    </View>
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