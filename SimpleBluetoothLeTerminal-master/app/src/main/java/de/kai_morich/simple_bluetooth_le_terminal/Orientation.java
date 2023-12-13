package de.kai_morich.simple_bluetooth_le_terminal;

import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;

public class Orientation implements SensorEventListener {

    private SensorManager sensorManager;
    private Sensor accelerometerSensor;
    private Sensor magnetometerSensor;

    private float[] accelerometerValues = new float[3];
    private float[] magnetometerValues = new float[3];
    private float[] rotationMatrix = new float[9];
    private float[] orientationValues = new float[3]; // yaw, pitch, roll

    private static final float ALPHA = 0.1f; // Complementary filter constant

    public Orientation(Context context) {
        sensorManager = (SensorManager) context.getSystemService(Context.SENSOR_SERVICE);
        accelerometerSensor = sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);
        magnetometerSensor = sensorManager.getDefaultSensor(Sensor.TYPE_MAGNETIC_FIELD);
    }

    public void startListening() {
        sensorManager.registerListener(this, accelerometerSensor, SensorManager.SENSOR_DELAY_NORMAL);
        sensorManager.registerListener(this, magnetometerSensor, SensorManager.SENSOR_DELAY_NORMAL);
    }

    public void stopListening() {
        sensorManager.unregisterListener(this);
    }

    @Override
    public void onSensorChanged(SensorEvent event) {
        if (event.sensor.getType() == Sensor.TYPE_ACCELEROMETER) {
            System.arraycopy(event.values, 0, accelerometerValues, 0, 3);
        } else if (event.sensor.getType() == Sensor.TYPE_MAGNETIC_FIELD) {
            System.arraycopy(event.values, 0, magnetometerValues, 0, 3);
        }

        SensorManager.getRotationMatrix(rotationMatrix, null, accelerometerValues, magnetometerValues);
        SensorManager.getOrientation(rotationMatrix, orientationValues);

        // Apply complementary filter for smoother results
        float[] fusedOrientation = new float[3];
        fusedOrientation[0] = ALPHA * orientationValues[0] + (1 - ALPHA) * fusedOrientation[0];
        fusedOrientation[1] = ALPHA * orientationValues[1] + (1 - ALPHA) * fusedOrientation[1];
        fusedOrientation[2] = ALPHA * orientationValues[2] + (1 - ALPHA) * fusedOrientation[2];

        // Update the orientation values
        orientationValues = fusedOrientation.clone();
    }

    @Override
    public void onAccuracyChanged(Sensor sensor, int accuracy) {
        // Handle accuracy changes if needed
    }

    // Getter method to retrieve orientation values
    public float[] getOrientationValues() {
        return orientationValues;
    }
    // removes the pitch since we don't need it
    public String yawToString() {
        return Double.toString(Math.toDegrees(orientationValues[0]));
    }
    public double yaw() {
        return Math.toDegrees(orientationValues[0]);
    }
    public double roll() {
        return Math.toDegrees(orientationValues[2]);
    }
}
