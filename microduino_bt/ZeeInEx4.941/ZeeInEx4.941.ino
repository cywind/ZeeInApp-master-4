#include "audio.h"
#include <I2Cdev.h>
#include <MPU6050.h>
#include <Wire.h>//添加必须的库文件
#include "mpu.h"
#include <SoftwareSerial.h>

SoftwareSerial BLE_Shield(4, 5); // RX, TX

int Vol = 10;  //初始音量0~30
int Balance = 1;
unsigned long nextT;
int status = 0;
int lastStatus = 0;
int steady = 0;

void setup() {
    // initialize serial:
    Wire.begin();
    Serial.begin(115200);
    BLE_Shield.begin(9600);
    accelgyro.initialize();
    audio_init(DEVICE_Flash,MODE_One_END,Vol);//初始化mp3模块
}

/*
ACTION:

*/

void loop() {
    
    getMPU();
    okZeeIn(movement,posture);
    //    Serial.print(movement);
    //    Serial.print("   ");
    //    Serial.print(posture);
    //    Serial.print("   ");
    //    Serial.println(status);
    //Serial.println("action: " +action);
//    if (BLE_Shield.available()){
        bleSend(movement,posture,status);
//    }else{
//        Serial.println("blue unavai");
//    }
    delay(500);
}

void okZeeIn(int mvmt, int posture){
    status = zeeMove(mvmt);
    int statusChange = checkStatusChange(lastStatus,status);
    // Serial.println(statusChange);
    switch(status){
    case 0:
        //LightChange(x,y,z);
        if(statusChange)
        // audio_choose(8);
        Ssoundplay(posture);
        break;
    case 1:
        DsoundVolchange(mvmt);
        if(statusChange)
        //audio_choose(10);
        Dsoundplay();
        break;
    case 2:
        IMbalanced();
    }
    lastStatus = status;
    
}

int zeeMove(int mvmt) {
    if(mvmt>50)
    {
        return 2;//imbalanced
    }
    if(mvmt>3){
        steady = 0;
        return 1;//slowly move
    }
    else{
        return checkSteady(mvmt);
    }//still
}

int checkSteady(int mvmt){
    if(steady<30){
        steady+=1;
        return -1;}
    if (steady==30)
    return 0;
}


int checkIMBalance(int mvmt){
    if(mvmt>50)
    Balance = 0;
    else
    Balance = 1;
}

int checkStatusChange(int laststate, int state){
    return laststate ^ state;
    // nextT = millis();
}
//int checkMovementSpeed(int mvmt){
//  return (1000/mvmt+800);
//}

//void changeVol(){
//  if(!Balance && Vol>0){
//    Vol = Vol-1;
//    audio_vol(Vol);
//  }
//  else if(Balance && Vol<25){
//    Vol = Vol+1;
//    audio_vol(Vol);
//  }
//}
//
//void melodyPlay(int mvmt){
//   if(t==6)
//   {t=1;
//   audio_choose(1);
//   }
//   else if(t<6){
//   t += 1;
//   int delayTime = checkMovementSpeed(mvmt);
//   audio_down();  }
//}

void Ssoundplay(int posture){
    audio_vol(15);
    audio_choose(posture);
}

void Dsoundplay(){
    audio_choose(4);
}

void DsoundVolchange(int mvmt){
    Vol = map(mvmt,0,50,10,30);
    
    // if(Vol<10)
    //  Vol = 10;
    audio_vol(Vol);
    // delay(5);
}

void IMbalanced(){
    Serial.print("Imbalance");
    //audio_pause;
}

void bleSend(int mvmt, int pose, int state){
    char data[10];
    sprintf(data,"%d\t%d\t%d",mvmt,pose,state);
    BLE_Shield.print(data); // send a byte with the value 45
    // delay(30);
    Serial.println(data);
}



