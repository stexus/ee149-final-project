package de.kai_morich.simple_bluetooth_le_terminal;

import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;

public class Magnetometer {

    // create an interface with one method
    public interface Listener {
        // create method with all 3
        // axis translation as argument
        void onTranslation(float tx, float ty);
    }

    // create an instance
    private Listener listener;

    // method to set the instance
    public void setListener(Listener l) {
        listener = l;
    }

    private SensorManager sensorManager;
    private Sensor sensor;
    private SensorEventListener sensorEventListener;

    // create constructor with
    // context as argument
    Magnetometer(Context context) {
        // create instance of sensor manager
        sensorManager = (SensorManager) context.getSystemService(Context.SENSOR_SERVICE);

        // create instance of sensor
        sensor = sensorManager.getDefaultSensor(Sensor.TYPE_MAGNETIC_FIELD);

        // create the sensor listener
        sensorEventListener = new SensorEventListener() {
            // this method is called when the
            // device's position changes
            @Override
            public void onSensorChanged(SensorEvent sensorEvent) {
                // check if listener is
                // different from null
                if (listener != null) {
                    // pass the three floats in listener on translation of axis
                    listener.onTranslation(sensorEvent.values[0], sensorEvent.values[1]);
                }
            }

            @Override
            public void onAccuracyChanged(Sensor sensor, int i) {

            }
        };
    }

    // create register method
    // for sensor notifications
    public void register() {
        // call sensor manger's register listener
        // and pass the required arguments
        sensorManager.registerListener(sensorEventListener, sensor, SensorManager.SENSOR_DELAY_NORMAL);
    }

    // create method to unregister
    // from sensor notifications
    public void unregister() {
        // call sensor manger's unregister listener
        // and pass the required arguments
        sensorManager.unregisterListener(sensorEventListener);
    }
}
