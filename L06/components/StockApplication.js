import React, { Component } from 'react';
import { StyleSheet, Text, View } from 'react-native';
import StockButton from './StockButton';
import StockAPI from '../api/StockAPI';

export default class StockApplication extends Component {
    constructor(props) {
        super(props);
        this.changeIndex = this.changeIndex.bind(this);
        this.state = {
            stockName: 'Google',
            stockCode: 'GOOG',
            stockIndex: '0.00',
            stockChangeRaw: '+0.00',
            stockChangePercent: '0.00%'
        }
        this.changeIndex('Google', 'GOOG');
    }

    changeIndex(stockName, stockCode) {
        StockAPI(stockCode)
        .then(data => this.setState({...data, stockName, stockCode }));
    }

    render() {
        return (
            <View style={styles.container}>
                <View style={styles.header}>
                    <Text style={styles.stockName}>{this.state.stockName}</Text>
                    <Text style={styles.stockIndex}>{this.state.stockIndex}</Text>
                    <Text style={styles.stockChange}>
                        {this.state.stockChangeRaw} ({this.state.stockChangePercent})
                    </Text>
                </View>

                <View style={styles.footer}>
                    <StockButton name='Google' code="GOOG" onPress={this.changeIndex} />
                    <StockButton name='Microsoft' code="MSFT" onPress={this.changeIndex} />
                    <StockButton name='Facebook' code="FB" onPress={this.changeIndex} />
                </View>
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        flex: 1
    },

    header: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: 'yellow',
    },

    footer: {
        flex: 1,
        backgroundColor: 'pink',
        justifyContent: 'center',
        alignItems: 'center',
        flexWrap: 'wrap',
        flexDirection: 'row',
        paddingTop: 10
    },

    stockName: {
        fontSize: 30
    },

    stockIndex: {
        fontSize: 80
    },

    stockChange: {
        fontSize: 40
    }
});