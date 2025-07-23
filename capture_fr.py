import serial
import csv
import time

# === CONFIGURATION ===
port = 'COM3'       # Change this to your Arduino's port (e.g., '/dev/ttyUSB0' for Linux/Mac)
baud_rate = 9600    # Match this with Arduino code
csv_filename = 'arduino_data.csv'

# === SETUP SERIAL CONNECTION ===
ser = serial.Serial(port, baud_rate, timeout=1)
time.sleep(2)  # Wait for Arduino to reset

# === OPEN CSV FILE FOR WRITING ===
with open("arduino_data.csv", 'w', newline='') as csvfile:
    writer = csv.writer(csvfile)
   
    # Optional: write header row
    writer.writerow(['Time', 'Pressure','Altitude','Sealevel','Real Altitude','Humidity','Temp-k','Potentiometer'])  # Adjust column names as needed

    print("Recording data... Press Ctrl+C to stop.")

    try:
        while True:
            line = ser.readline().decode('utf-8').strip()
            if line:
                data = line.split(',')  # assuming comma-separated data
                timestamp = time.strftime('%Y-%m-%d %H:%M:%S')
                writer.writerow([timestamp] + data)
                print([timestamp] + data)
    except KeyboardInterrupt:
        print("Data recording stopped.")
    finally:
        ser.close()
