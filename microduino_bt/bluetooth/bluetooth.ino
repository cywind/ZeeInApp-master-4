#include <SoftwareSerial.h>

SoftwareSerial BLE_Shield(4, 5); // RX, TX

void setup(){
  Serial.begin(115200);
  BLE_Shield.begin(9600);
}

void loop(){
  if (BLE_Shield.available()) {
    Serial.println(BLE_Shield.read());  // Read and output
  }    
}
