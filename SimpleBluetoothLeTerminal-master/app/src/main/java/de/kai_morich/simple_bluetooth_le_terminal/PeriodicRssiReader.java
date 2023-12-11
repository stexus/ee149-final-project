package de.kai_morich.simple_bluetooth_le_terminal;
import android.bluetooth.BluetoothGatt;
import android.os.Handler;
import android.os.Looper;

public class PeriodicRssiReader {
    private BluetoothGatt bluetoothGatt;
    private Handler handler;
    private Runnable readRssiRunnable;
    private boolean isReadingRssi;

    private int curr_rssi;

    public PeriodicRssiReader(BluetoothGatt gatt) {
        this.bluetoothGatt = gatt;
        this.handler = new Handler(Looper.getMainLooper());
        this.curr_rssi = -10;
        this.readRssiRunnable = new Runnable() {
            @SuppressWarnings("MissingPermission")
            @Override
            public void run() {
                if (bluetoothGatt != null && isReadingRssi) {
                    bluetoothGatt.readRemoteRssi();
                    // Schedule next read after a delay (adjust as needed)
                    handler.postDelayed(this, 100); // Read RSSI every 1 second
                }
            }
        };
    }

    public void startReadingRssi() {
        isReadingRssi = true;
        handler.post(readRssiRunnable);
    }

    public void stopReadingRssi() {
        isReadingRssi = false;
        handler.removeCallbacks(readRssiRunnable);
    }

    public void setBluetoothGatt(BluetoothGatt gatt) {
        this.bluetoothGatt = gatt;
    }

    private void handleUpdatedRssi(int rssiValue) {
        // Process the updated RSSI value here
        System.out.println("Updated RSSI: " + rssiValue);
    }
    public int getRssi() {return curr_rssi;}
}