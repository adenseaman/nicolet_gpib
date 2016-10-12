/*
**************************************************************************************************
************** Program for reading data from Nicolet 2090-III Digital Oscilloscope ***************
**************************************************************************************************
You can only read 8546 bytes at a time with ibrd() before it starts returning garbage.
In the Nicolet, I think each point can have 256 different values, based on experimenting with the controls on the scope.  However, it seems that its value can range from -2048 up to 2034, which is slightly more than 4096 values.
I know for certain that it holds 4096 measurements.
When you talk to the scope over GPIB, it will convert these measurements into ASCII characters, and give you the bytes of the characters.  Each measurement in the scope is converted into 7 ASCII characters:
1 = space or minus sign, to indicate sign
2,3,4,5 = four digit measurement
6,7 = carriage return
Using ibrd() to read only one byte at a time is super-slow.  Even reading 7 bytes at a time is very slow.  Thus, since at most 8546 bytes can be read at a time, divide this by 7 to get 1221.  So read in 1024 scope measurements at a time.  Repeat this four times to get all 4096 points.  This is quite a bit faster, and all points are read in about 3.5 seconds.  This is a total transfer of 224 KB, with a speed of 64 KB/s.
If you get to the end of the data and keep reading, it'll just cycle back to the beginning.  Thus, it's possible if you don't read all of the data points, that when you try reading them again, you won't start at the beginning.  Thus, you must use the ibclr() command before reading to reset the circular memory array back to the beginning.
**************************************************************************************************
Written by Aden Seaman on April 13th, 2006
**************************************************************************************************
*/

#include <gpib/ib.h>
#include <stdio.h>

#define GROUPOFPOINTS 7*1024
#define READS 4
#define SCOPEID 14

int main() {
  int ud,i,j;				// device descriptor, and index counters
  unsigned char memory[GROUPOFPOINTS];	// memory array to hold 1024 measurements
  ud = ibdev(0,SCOPEID,0,11,0,0);	// open the scope device
  ibclr(ud);				// clear the scope to reset the circular array
  for(j=0;j<READS;j++) {		// perform 4 transfers of 7168 bytes ( 1024 measurements )
    ibrd(ud,memory,GROUPOFPOINTS);	// read in the data points
    for(i=0;i<GROUPOFPOINTS;i++) {	// loop for printing measurements
      printf("%c",memory[i]);		// print out the characters composing the 1024 measurements
    }
  }
}
