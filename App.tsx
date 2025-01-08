/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 */

import React from 'react';
import {Button, StyleSheet, NativeModules, View} from 'react-native';
const {FoodDelivery} = NativeModules;

function App() {
  const onStartActivity = () => {
    FoodDelivery.startActivity();
  };

  const onEndActivity = () => {
    FoodDelivery.endActivity();
  };

  const updateActivity = () => {
    FoodDelivery.updateActivity('Updated Live activity');
  };

  return (
    <View style={styles.container}>
      <Button title="Start Activity" onPress={onStartActivity} />
      <Button title="Update Activity"  onPress={updateActivity}/>
      <Button title="Stop Activity" onPress={onEndActivity} />
    </View>
  );
}

export default App;

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
});
