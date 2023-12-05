package de.kai_morich.simple_bluetooth_le_terminal;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;

public class SensorActivity extends Activity {

    private MagneticFieldReader magneticFieldReader;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        magneticFieldReader = new MagneticFieldReader(this);
    }

    @Override
    protected void onResume() {
        super.onResume();
        magneticFieldReader.startReading();
    }

    @Override
    protected void onPause() {
        super.onPause();
        magneticFieldReader.stopReading();
    }
}
