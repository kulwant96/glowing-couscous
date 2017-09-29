#include "mbed.h"
// including for serial communication between our device and board
#include "Serial.h"
#include "HCSR04.h"
#define data_chr '>'

//function used for taking gps location from mobile phone sensor 
//via bluetooth of phone to bluetooth(HC 05) connencted to wizwiki board 
void ggp();

//function used for determining the depth of the pothole for dummy purposes we have taken (10 cm) as threshold value
void ultra();

 int flag=0;
 
//bluetooth device pin no for transmiiter and reciever
//D1 is tx pin of board connected to rx pin of hc05
//D0 is recievepin of board connected to tx pin of hc05
Serial bt(D1, D0);

//pc is used for serial communication or for printing of msgs to console
Serial pc(USBTX, USBRX);

Timer timer;

int main()
{
while(1)//for repeating forever 
      {
      ultra();//ultrasonic sensor reading
     // pc.printf("\r\nflag is %d\n",flag);  
     //if flag is one that means the distance is more than the threshold value set and chances of pothole present are more
   
  ggp();//fetching gps location if flag is one
    }
}

void ggp()
{
     unsigned char rx;
  int sensorType = 0;
  float value0=0;
  float value1=0;
  float value2=0;
  unsigned long logCount = 0L;
    //setting baud rate by calling the object 
    bt.baud(9600);
  //  while(1) {
 
        if(bt.readable()) {
            // if some data is there then print it on console
            rx = bt.getc();
           if(rx!=data_chr)
           {}
           else if((rx==data_chr)&&(flag==1))
           {
            sensorType=bt.getc();
            logCount=bt.getc();
            value0=bt.getc();
            value1=bt.getc();
            value2=bt.getc();
           // pc.printf("\n\nreceived : %c",rx);
            //pc.printf("\n\nreceived : %d",sensorType);
           pc.printf("\nPothole detected");
           pc.printf("\nGPS locations are");
            pc.printf("\n\nlatitude : %f",value0);
            pc.printf("\n\nlongitude : %f",value1);
          //  pc.printf("\n\nreceived : %f",value2);
            wait(0.9);
            
            }
            }
            else
            {}
        
        
    //}
}

void ultra()
  {
          float distance;
          //int flag=0;
         HCSR04 sensor(D2,D7);
      sensor.setRanges(5, 300);// setting the minimum range as 5cm and maximum as 300cm
    // pc.printf("Min. range = %g cm\n\rMax. range = %g cm\n\r",sensor.getMinRange(), sensor.getMaxRange());
    //  while(true) {
          timer.reset();
          timer.start();
          sensor.startMeasurement();
          while(!sensor.isNewDataReady()) {
              // wait for new data
              // waiting time depends on the distance
          }
          distance= sensor.getDistance_mm()*0.1;//getting the distance in mm 
          //converting it to cm
         // pc.printf("\nDistance: %5.1f cm\r", distance);
         //if you want to see distance
          timer.stop();//5.1
          wait_ms(750 - timer.read_ms()); // time the loop
          if ((distance > 10)&&(distance!=300))
          {
              flag=1;
              }
              else
              {
                  flag=0;
                  }
          //  pc.printf("\r\nflag is %d\n",flag);
  //}
}