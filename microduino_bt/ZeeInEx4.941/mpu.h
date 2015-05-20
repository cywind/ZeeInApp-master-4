#include <I2Cdev.h>
#include <MPU6050.h>
#include <Wire.h>//添加必须的库文件

//====一下三个定义了陀螺仪的偏差===========
#define Gx_offset -3.06 
#define Gy_offset 1.01
#define Gz_offset -0.88
#define ARRAY_SIZE 10 // Xg, Yg, Zg, Ag,xa,ya,za数组的大小

//DEBUG-----------
//#define Serial_DEBUG_rawDATA
//#define Serial_DEBUG_processingDATA1
//#define Serial_DEBUG_processingDATA2
//#define Serial_DEBUG_processingDATA3

//====================
MPU6050 accelgyro;

int16_t ax,ay,az;
int16_t gx,gy,gz;//存储原始数据
//存放x, y, z三个方向的加速度，连续10个。
double Gxs[ARRAY_SIZE];
double Gys[ARRAY_SIZE];
double Gzs[ARRAY_SIZE];
// 用来循环上面4个数组的index
int arrayIndex = 0;
double Axs[ARRAY_SIZE];
double Ays[ARRAY_SIZE];
double Azs[ARRAY_SIZE];


long Gx = 0;
long Gy = 0;
long Gz = 0;
float Ax,Ay,Az;//单位 g(9.8m/s^2)
double Egx,Egy,Egz;
double Eax,Eay,Eaz;
double SDax,SDay,SDaz,SDaxyz;
int  Angel_accX,Angel_accY,Angel_accZ;//存储加速度计算出的角度

int movement;
int posture;
// 获取下一个index，如果越界了，就循环从零开始
int nextIndex(int index) {
    if (index >= ARRAY_SIZE) {
        return 0;
    } else {
        return index + 1;
    }
}
// 把当前获取的数据存到数组中
void saveData() {
    arrayIndex = nextIndex(arrayIndex); // 获取下一个index，如果越界了，就循环从零开始

    Gxs[arrayIndex] = Gx;
    Gys[arrayIndex] = Gy;
    Gzs[arrayIndex] = Gz;
    
    Axs[arrayIndex] = Angel_accX;
    Ays[arrayIndex] = Angel_accY;
    Azs[arrayIndex] = Angel_accZ;
}

void processData(){
  //==========以下三行是对角速度做量化==========
   Gx=gx/131.00;
   Gy=gy/131.00;
   Gz=gz/131.00;
  //======一下三行是对加速度进行量化，得出加速度值=========
   Ax=ax/1638.00;
   Ay=ay/1638.00;
   Az=az/1638.00;
  //==========以下三行是用加速度计算三个轴和水平面坐标系之间的夹角==========
   Angel_accX=atan(Ax/sqrt(Az*Az+Ay*Ay))*180/3.14;
   Angel_accY=atan(Ay/sqrt(Ax*Ax+Az*Az))*180/3.14;
   Angel_accZ=atan(Az/sqrt(Ax*Ax+Ay*Ay))*180/3.14;
}
  
double getAvgfor(double array[]){
  int sum = 0;
  for (int i = 0; i < ARRAY_SIZE; i++) {
        sum += array[i];
    }
  return (sum / ARRAY_SIZE);
}

// SD stands for Standard-Deviation 标准差
double getSDfor(double array[]) {
    int sum = 0;
    for (int i = 0; i < ARRAY_SIZE; i++) {
        sum += array[i];
    }
    double sumSD = 0.0;
    double avg = sum / ARRAY_SIZE;
    for (int i = 0; i < ARRAY_SIZE; i++) {
        sumSD += (array[i] - avg) * (array[i] - avg);
    }

    return sqrt(sumSD / ARRAY_SIZE);
}  

int pingFangHe(int a, int b, int c) {
  return a*a + b*b + c*c;
}

int bidaxiao(int a, int b, int c){
  if((a*a>b*b) && (a*a>c*c)) return 1;
    if((b*b>a*a) && (b*b>c*c)) return 2;
        if((c*c>a*a) && (c*c>b*b)) return 3;
}

void getMPU()
{ 
   accelgyro.getMotion6(&ax,&ay,&az,&gx,&gy,&gz);//获取三个轴的加速度和角速度
   processData();
   saveData();
   
   Egx = getAvgfor(Gxs);
   Egy = getAvgfor(Gys);
   Egz = getAvgfor(Gzs);
  
   Eax = getAvgfor(Axs);
   Eay = getAvgfor(Ays);
   Eaz = getAvgfor(Azs);
   
   SDax = getSDfor(Axs);
   SDay = getSDfor(Ays);
   SDaz = getSDfor(Azs);
   SDaxyz = SDax + SDay + SDaz;
  movement = map(pingFangHe(Egx, Egy, Egz),0,50000,0,2000);
  posture = bidaxiao(Eax,Eay,Eaz);
  //==============================
#ifdef Serial_DEBUG_rawDATA
  delay(5);//这个用来控制采样速度
  Serial.print("    Xa:");
  Serial.print(Ax);
  Serial.print("    Ya:");
  Serial.print(Ay);
  Serial.print("    Za:");
  Serial.print(Az);
  Serial.print("    Xg:");
  Serial.print(Gx);
  Serial.print("    Yg:");
  Serial.print(Gy);
  Serial.print("    Zg:");
  Serial.println(Gz);  
#endif 
  //==============================
#ifdef Serial_DEBUG_processingDATA1

//  Serial.print("    Egx:");
//  Serial.print(Egx);
//  Serial.print("    Egy:");
//  Serial.print(Egy);
//  Serial.print("    Egz:");
//  Serial.print(Egz);
  Serial.print("    movement:");
  Serial.print(movement);
  Serial.print("    SDaxyz:");
  Serial.println(SDaxyz);

#endif 
#ifdef Serial_DEBUG_processingDATA2
  Serial.print("    Eax:");
  Serial.print(Eax);
  Serial.print("    Eay:");
  Serial.print(Eay);
  Serial.print("    Eaz:");
  Serial.print(Eaz);

  Serial.print("    SDax:");
  Serial.print(SDax);
  Serial.print("    SDay:");
  Serial.print(SDay);
  Serial.print("    SDaz:");
  Serial.print(SDaz);  
  Serial.print("    SDaxyz");
  Serial.println(SDaxyz);
 
#endif 

#ifdef Serial_DEBUG_processingDATA3
  Serial.print("movement: ");
  Serial.print(movement);
  Serial.print(" Eax:");
  Serial.print(Eax);
  Serial.print(" Eay:");
  Serial.print(Eay);
  Serial.print(" Eaz:");
  Serial.println(Eaz); 
  Serial.print(" Egx:");
  Serial.print(Egx);
  Serial.print(" Egy:");
  Serial.print(Egy);
  Serial.print(" Egz:");
  Serial.println(Egz); 
#endif 
}


