#include <Wire.h>
#include <Adafruit_BMP085.h>
#include "DHT.h"
#include "max6675.h"

#define seaLevelPressure_hPa 1013.25
Adafruit_BMP085 bmp;

//DHT11 (Humidity
#define DHTPIN 2
#define DHTTYPE DHT11
DHT dht(DHTPIN, DHTTYPE);

//MAX6675 (Thermocouple Temp)
int thermoDO = 4;
int thermoCS = 5;
int thermoCLK = 6;
MAX6675 thermocouple(thermoCLK, thermoCS, thermoDO);

//Potentiometer (Analog Input)
int potPin = A0;

void setup() {
  Serial.begin(9600);
  delay(500); 

  // Start BMP085
  if (!bmp.begin()) {
    Serial.println("Could not find a valid BMP085 sensor, check wiring!");
    while (1);
  }

  // Start DHT11
  dht.begin();

 // Serial.println("Sensor system initialized.");
}

void loop() {
  //BMP085 Measurements 
  float bmpTemp = bmp.readTemperature();
  float bmpPressure = bmp.readPressure();
  float bmpAltitude = bmp.readAltitude();
  float bmpSealevel = bmp.readSealevelPressure();
  float bmpRealAltitude = bmp.readAltitude(seaLevelPressure_hPa * 100);

  //DHT11 Measurement
  float humidity = dht.readHumidity();

  //MAX6675 Measurement
  float thermoTemp = thermocouple.readCelsius();

  //Potentiometer Reading
  int potValue = analogRead(potPin);  // Range: 0–1023

  //Check for NaN values
  if (isnan(humidity)) {
    Serial.print("Failed to read from DHT11 sensor!");
    humidity = -1;
  }

  //Serial.println("=== Sensor Readings ===");
 // Serial.print("BMP085 Temp (°C): ");
 // Serial.println(bmpTemp);

 // Serial.print("BMP085 Pressure (Pa): ");
  Serial.print(bmpPressure);
  Serial.print(",");

  //Serial.print("BMP085 Altitude (m): ");
  Serial.print(bmpAltitude);
  Serial.print(",");
  //Serial.print("BMP085 Sealevel Pressure (Pa): ");
  Serial.print(bmpSealevel);
  Serial.print(",");
  //Serial.print("BMP085 Real Altitude (m): ");
  Serial.print(bmpRealAltitude);
  Serial.print(",");
 // Serial.print("DHT11 Humidity (%): ");
  Serial.print(humidity);
  Serial.print(",");
 // Serial.print("MAX6675 Thermocouple Temp (°C): ");
  Serial.print(thermoTemp);
  Serial.print(",");
 // Serial.print("Potentiometer Value (0–1023): ");
  Serial.print(potValue);
  // Serial.print(",");

  Serial.println();
  delay(500);  
}