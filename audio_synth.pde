import processing.serial.*;

import ddf.minim.*;
import ddf.minim.ugens.*;
 
Minim       minim;
AudioOutput out;
Oscil       wave;
 
Serial myPort;
int val;

int screenX;
int screenY;
int signalMin = 36;
int signalMax = 80;
int t = 0;
float normVal = 0.0;
float waveVal = 312.0;
float[] lastVals;
int numVals = 1;
int lastValIndex = 0;
 
void setup()
{
  size(512, 200, P3D);
 
  minim = new Minim(this);
 
  // use the getLineOut method of the Minim object to get an AudioOutput object
  out = minim.getLineOut();
 
  // create a sine wave Oscil, set to 440 Hz, at 0.5 amplitude
  wave = new Oscil( waveVal, 0.5f, Waves.SINE );
  // patch the Oscil to the output
  wave.patch( out );
  
  printArray(Serial.list());
  String portName = "/dev/cu.usbserial-A700eI67";
  myPort = new Serial(this, portName, 9600);
  screenX = 2000;
  screenY = 800;
  lastVals = new float[numVals];
}
 
void draw()
{
  //background(0);
  //stroke(255);
  //strokeWeight(1);
   t++;
  
  clear();
  if(myPort.available() > 0){
    val = myPort.read();
    normVal = map(val, signalMax, signalMin, 0,1);
    waveVal = map(val,signalMax,signalMin, 600,150);
    println("norm: "+normVal);
    println("raw: "+val);
    println("wave:"+waveVal);
    wave.setFrequency( waveVal );
    lastVals[lastValIndex] = normVal;
    lastValIndex = (lastValIndex+1) % numVals;
  }
  
  rect(0,screenY, screenX,-screenY*valAvg());
}

float valAvg(){
  float avg = 0;
  for(int i=0; i<numVals; i++){
    float val = lastVals[i];
    avg += val;
  }
  return avg/numVals;
}
