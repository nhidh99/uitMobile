import React, {Component} from 'react';
import { 
  View, 
  Text, 
  StyleSheet, 
  TextInput, 
  Button,
} from 'react-native';

class BMICompute extends Component {
  constructor(props) {
    super(props);
    this.state = {weight: '0', height: '0', bmi: 0};
    this.compute = this.compute.bind(this);
  }

  compute() {
    const weight = parseFloat(this.state.weight);
    const height = parseFloat(this.state.height);
    this.setState({bmi: weight/Math.pow(height/100, 2)});
  }

  render() {
    return(
      <View style={styles.container}>
      <View style={styles.group}>
        <Text>Weight (KG)</Text>
          <TextInput
            style={styles.input}
            keyboardType='numeric' 
            onChangeText={(text) => this.state.weight=text}
          />
        </View>

        <View style={styles.group}>
          <Text>Height (CM)</Text>
          <TextInput 
            style={styles.input}
            keyboardType='numeric'
            onChangeText={(text) => this.state.height=text}
          />
        </View>

        <View style={styles.group}>
          <Text style={styles.title}>BMI: {this.state.bmi.toFixed(2)} </Text>
        </View>
      
        <View style={styles.button}>
          <Button title="COMPUTE"
            onPress={this.compute}
          />
        </View>
      </View>
    )
  }
}

export default function App() {
  return (<BMICompute/>);
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    flexDirection: 'column',
    padding: 20
  },
  
  group: {
    margin: 10
  },

  title: {
    textAlign: 'center',
    marginTop: 10
  },

  button: {
    marginTop: 10,
    marginLeft: 'auto',
    marginRight: 'auto',
    width: 150
  },

  input: {
    minHeight: 40,
    padding: 10,
    marginTop: 5,
    marginBottom: 5,
    flex: 1,
    height: 40,
    borderWidth: 1,
    borderRadius: 5
  }
})