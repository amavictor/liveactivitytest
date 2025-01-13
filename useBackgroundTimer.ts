// useBackgroundTimer.ts
import { useState, useEffect, useRef, useCallback} from 'react';
import { AppState, AppStateStatus, NativeModules } from 'react-native';
const {FoodDelivery} = NativeModules;


interface TimerState {
  remainingTime: number;
  deliveryStatus: string;
  progress: number;
  isActive: boolean;
}

export const useBackgroundTimer = () => {
  const [state, setState] = useState<TimerState>({
    remainingTime: 60,
    deliveryStatus: 'Preparing',
    progress: 0,
    isActive: false,
  });

  const startTimeRef = useRef<number>(0);
  const appStateRef = useRef(AppState.currentState);
  const backgroundTimeRef = useRef<number>(0);

  const updateTimer = useCallback(() => {
    const now = Date.now();
    const elapsed = Math.floor((now - startTimeRef.current) / 1000);
    const newRemainingTime = Math.max(60 - elapsed, 0);
    const newProgress = 1 - newRemainingTime / 60;

    let newStatus = 'Preparing';
    if (newProgress >= 0.75) {
      newStatus = 'Delivered';
    } else if (newProgress >= 0.5) {
      newStatus = 'At the Address';
    } else if (newProgress >= 0.25) {
      newStatus = 'On the Way';
    }

    setState({
      remainingTime: newRemainingTime,
      progress: newProgress,
      deliveryStatus: newStatus,
      isActive: newRemainingTime > 0,
    });

    return { newRemainingTime, newProgress, newStatus };
  }, []);

  const handleAppStateChange = useCallback((nextAppState: AppStateStatus) => {
    if (
      appStateRef.current.match(/inactive|background/) &&
      nextAppState === 'active' &&
      state.isActive
    ) {
      // App has come to foreground
      backgroundTimeRef.current = Date.now() - backgroundTimeRef.current;
      startTimeRef.current = startTimeRef.current + backgroundTimeRef.current;
      updateTimer();
    } else if (
      appStateRef.current === 'active' &&
      nextAppState.match(/inactive|background/) &&
      state.isActive
    ) {
      // App has gone to background
      backgroundTimeRef.current = Date.now();
    }

    appStateRef.current = nextAppState;
  }, [state.isActive, updateTimer]);

  useEffect(() => {
    const subscription = AppState.addEventListener('change', handleAppStateChange);

    let intervalId: NodeJS.Timeout | null = null;
    if (state.isActive) {
      intervalId = setInterval(() => {
        const { newRemainingTime, newProgress, newStatus } = updateTimer();
        // Update live activity
        FoodDelivery.updateActivity(newStatus, newProgress, newRemainingTime);

        if (newRemainingTime <= 0) {
          clearInterval(intervalId!);
        }
      }, 1000);
    }

    return () => {
      subscription.remove();
      if (intervalId) {
        clearInterval(intervalId);
      }
    };
  }, [state.isActive, handleAppStateChange, updateTimer]);

  const start = useCallback(() => {
    startTimeRef.current = Date.now();
    setState({
      remainingTime: 60,
      deliveryStatus: 'Preparing',
      progress: 0,
      isActive: true,
    });
    FoodDelivery.startActivity();
  }, []);

  const stop = useCallback(() => {
    setState(prev => ({ ...prev, isActive: false }));
    FoodDelivery.endActivity();
  }, []);

  return {
    ...state,
    start,
    stop,
    formatTime: (seconds: number): string => {
      const minutes = Math.floor(seconds / 60);
      const remainingSeconds = seconds % 60;
      return `${minutes}:${remainingSeconds.toString().padStart(2, '0')}`;
    },
  };
};
