//https://dl.espressif.com/dl/package_esp32_index.json

#include "BluetoothSerial.h"
#include "esp_adc_cal.h"
#include <Adafruit_MPU6050.h>
#include <Adafruit_Sensor.h>
#include <Wire.h>

Adafruit_MPU6050 mpu;

#if !defined(CONFIG_BT_ENABLED) || !defined(CONFIG_BLUEDROID_ENABLED)
#error Bluetooth is not enabled! Please run `make menuconfig` to and enable it
#endif

BluetoothSerial SerialBT;


  unsigned long tiempo=0, tiempo_ant,muestreo;

//Contador de Muestras
  unsigned long muestra=0;


void setup() {
  SerialBT.begin("ESP32_MARTIN");
  Serial.begin(115200);
  while (!Serial)
    delay(10); // will pause Zero, Leonardo, etc until serial console opens

  Serial.println("Adafruit MPU6050 test!");

  // Try to initialize!
  if (!mpu.begin()) {
    Serial.println("Failed to find MPU6050 chip");
    while (1) {
      delay(10);
    }
  }
  Serial.println("MPU6050 Found!");

  mpu.setAccelerometerRange(MPU6050_RANGE_8_G);
  Serial.print("Accelerometer range set to: ");
  switch (mpu.getAccelerometerRange()) {
  case MPU6050_RANGE_2_G:
    Serial.println("+-2G");
    break;
  case MPU6050_RANGE_4_G:
    Serial.println("+-4G");
    break;
  case MPU6050_RANGE_8_G:
    Serial.println("+-8G");
    break;
  case MPU6050_RANGE_16_G:
    Serial.println("+-16G");
    break;
  }
  mpu.setGyroRange(MPU6050_RANGE_500_DEG);
  Serial.print("Gyro range set to: ");
  switch (mpu.getGyroRange()) {
  case MPU6050_RANGE_250_DEG:
    Serial.println("+- 250 deg/s");
    break;
  case MPU6050_RANGE_500_DEG:
    Serial.println("+- 500 deg/s");
    break;
  case MPU6050_RANGE_1000_DEG:
    Serial.println("+- 1000 deg/s");
    break;
  case MPU6050_RANGE_2000_DEG:
    Serial.println("+- 2000 deg/s");
    break;
  }

  mpu.setFilterBandwidth(MPU6050_BAND_5_HZ);
  Serial.print("Filter bandwidth set to: ");
  switch (mpu.getFilterBandwidth()) {
  case MPU6050_BAND_260_HZ:
    Serial.println("260 Hz");
    break;
  case MPU6050_BAND_184_HZ:
    Serial.println("184 Hz");
    break;
  case MPU6050_BAND_94_HZ:
    Serial.println("94 Hz");
    break;
  case MPU6050_BAND_44_HZ:
    Serial.println("44 Hz");
    break;
  case MPU6050_BAND_21_HZ:
    Serial.println("21 Hz");
    break;
  case MPU6050_BAND_10_HZ:
    Serial.println("10 Hz");
    break;
  case MPU6050_BAND_5_HZ:
    Serial.println("5 Hz");
    break;
  }

  Serial.println("");



  
  delay(100);
}
void loop() {

  /* Get new sensor events with the readings */
  sensors_event_t a, g, temp;
  mpu.getEvent(&a, &g, &temp);

  /* Print out the values */
// Serial.print("Acceleration X: ");
//Serial.print(a.acceleration.x);
// Serial.print(", Y: ");
//Serial.print(a.acceleration.y);
//Serial.print(", Z: ");
//Serial.print(a.acceleration.z);
//Serial.println(" m/s^2");

//  Serial.print("Rotation X: ");
//  Serial.print(g.gyro.x);
//  Serial.print(", Y: ");
//  Serial.print(g.gyro.y);
//  Serial.print(", Z: ");
//  Serial.print(g.gyro.z);
//  Serial.println(" rad/s");

  float sumatoria,ACx,ACy,ACz,RTx,RTy,RTz;
  ACx=a.acceleration.x;
  ACy=a.acceleration.y;
  ACz=a.acceleration.z;
  RTx=g.gyro.x;
  RTy=g.gyro.y;
  RTz=g.gyro.z;
  sumatoria=a.acceleration.x+a.acceleration.y+a.acceleration.z;
  
// print the temperature in the Serial Monitor:
//Serial.println(sumatoria);   // print the temperature in Celsius
//SerialBT.println (sumatoria);

//Medicion de Tiempo de Muestreo
  tiempo= millis();
  muestreo=tiempo-tiempo_ant;
  tiempo_ant=tiempo;

  Serial.println(ACx);
  SerialBT.print (ACx);
  SerialBT.print (" ");
  SerialBT.print (ACy);
  SerialBT.print (" ");
  SerialBT.print (ACz);
  SerialBT.print (" ");
  SerialBT.print (RTx);
  SerialBT.print (" ");
  SerialBT.print (RTy);
  SerialBT.print (" ");
  SerialBT.print (RTz);
  SerialBT.print (" ");
  SerialBT.print (muestra);
  SerialBT.print (" ");
  SerialBT.println (muestreo);

  muestra=muestra+1;
  delay(1);


}
