package de.kai_morich.simple_bluetooth_le_terminal;

/*import android.content.Context;
import android.content.pm.ActivityInfo;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;

import android.widget.TextView;
import android.os.Bundle;
import androidx.fragment.app.FragmentManager;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;

public class MainActivity extends AppCompatActivity implements FragmentManager.OnBackStackChangedListener {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        Toolbar toolbar = findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        getSupportFragmentManager().addOnBackStackChangedListener(this);
        if (savedInstanceState == null)
            getSupportFragmentManager().beginTransaction().add(R.id.fragment, new DevicesFragment(), "devices").commit();
        else
            onBackStackChanged();
    }

    @Override
    public void onBackStackChanged() {
        getSupportActionBar().setDisplayHomeAsUpEnabled(getSupportFragmentManager().getBackStackEntryCount()>0);
    }

    @Override
    public boolean onSupportNavigateUp() {
        onBackPressed();
        return true;
    }
}
*/
import android.graphics.Color;
import android.os.Bundle;

import androidx.appcompat.app.AppCompatActivity;

public class MainActivity extends AppCompatActivity {

    // create variables of the two class
    private Magnetometer magnetometer;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        // instantiate them with this as context
        magnetometer = new Magnetometer(this);

        // create a listener for accelerometer
        magnetometer.setListener(new Magnetometer.Listener() {
            //on translation method of accelerometer
            @Override
            public void onTranslation(float tx, float ty, float ts) {
                // set the color red if the device moves in positive x axis
                if (tx > 1.0f) {
                    getWindow().getDecorView().setBackgroundColor(Color.RED);
                }
                // set the color blue if the device moves in negative x axis
                else if (tx < -1.0f) {
                    getWindow().getDecorView().setBackgroundColor(Color.BLUE);
                }
            }
        });
    }

    // create on resume method
    @Override
    protected void onResume() {
        super.onResume();

        // this will send notification to
        // both the sensors to register
        magnetometer.register();
    }

    // create on pause method
    @Override
    protected void onPause() {
        super.onPause();

        // this will send notification in
        // both the sensors to unregister
        magnetometer.unregister();
    }
}
