import React, { useState, useEffect, useRef } from 'react';
import { View, Button, Text, StyleSheet, NativeModules } from 'react-native';

const {FoodDelivery} = NativeModules;

function App() {
  const [remainingTime, setRemainingTime] = useState(60);
  const [deliveryStatus, setDeliveryStatus] = useState('Preparing');
  const [isActive, setIsActive] = useState(false);
  const startTimeRef = useRef<number>(0);
  const timerRef = useRef<NodeJS.Timeout | null>(null);

  const formatTime = (seconds: number): string => {
    const minutes = Math.floor(seconds / 60);
    const remainingSeconds = seconds % 60;
    return `${minutes}:${remainingSeconds.toString().padStart(2, '0')}`;
  };



  const updateProgress = () => {
    const now = Date.now();
    const elapsedSeconds = Math.floor((now - startTimeRef.current) / 1000);
    const newRemainingTime = Math.max(60 - elapsedSeconds, 0);
    const newProgress = Math.min(elapsedSeconds / 60, 1);

    setRemainingTime(newRemainingTime);

    let status = 'Preparing';
    if (newProgress >= 0.75) {
      status = 'Delivered';
    } else if (newProgress >= 0.5) {
      status = 'At the Address';
    } else if (newProgress >= 0.25) {
      status = 'On the Way';
    }
    setDeliveryStatus(status);

    FoodDelivery.updateActivity(status, newProgress, newRemainingTime);

    if (newRemainingTime <= 0) {
      stop();
    }
  };


  const start = () => {
    startTimeRef.current = Date.now();
    setIsActive(true);
    setRemainingTime(60);
    setDeliveryStatus('Preparing');

    FoodDelivery.startActivity();
    timerRef.current = setInterval(updateProgress, 1000);
  };

  const stop = () => {
    if (timerRef.current) {
      clearInterval(timerRef.current);
      timerRef.current = null;
    }
    setIsActive(false);
    setRemainingTime(60);
    setDeliveryStatus('Preparing');
    FoodDelivery.endActivity();
  };
  useEffect(() => {
    return () => {
      if (timerRef.current) {
        clearInterval(timerRef.current);
      }
    };
  }, []);

  return (
    <View style={styles.container}>
      <View style={styles.progressContainer}>
        <Text style={styles.timer}>{formatTime(remainingTime)}</Text>
        <Text style={styles.status}>{deliveryStatus}</Text>
      </View>
      <View style={styles.buttonContainer}>
        <Button title="Start Delivery" onPress={start} disabled={isActive} />
        <Button title="Stop Delivery" onPress={stop} disabled={!isActive} />
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    padding: 20,
  },
  progressContainer: {
    width: '100%',
    alignItems: 'center',
    justifyContent: 'center',
    position:'relative',
  },
  timer: {
    fontSize: 48,
    fontWeight: 'bold',
    marginBottom: 20,
  },
  status: {
    fontSize: 24,
    marginBottom: 20,
  },
  buttonContainer: {
    marginTop: 20,
    gap: 10,
  },
});

export default App;
