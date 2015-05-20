#include <SoftwareSerial.h>

SoftwareSerial mySerial(4, 5); // RX, TX

void setup(){
  Serial.begin(115200);
  mySerial.begin(9600);
}

void loop(){
  char data[100];
  for(int i=0;i<8;i++){
    sprintf(data,"%d\t%d\t%d",i,i*2,i*3);
    mySerial.print(data); // send a byte with the value 45
    delay(10);
//    Serial.println(data);
  }
}

