# nicolet_gpib
Linux program to read data from a Nicolet 2090-III digital oscilloscope over a GPIB interface

I have a very old Nicolet 2090-III digital oscilloscope with a GPIB interface on the back.
It didn't come with any manuals, so here's my effort to read data from the GPIB interface.  I actually got it to
work, years ago, but your mileage may vary.
I used an old ISA GPIB interface in a Linux machine and connected it to the scope and was able to read data from it.

The file **nicolet.read.data.c** contains all the details of the communication protocol, which is very simple.
It doesn't convey any information for the switch settings, so you need to make note of those yourself.

The GNU/Octave program **scope.program.m** is a simple front-end that calls the data reading program and lets you
generate plots and calculate FFTs, and scale the data according to the switch settings.

Getting the scope to communicate was rather finicky.  The file **how.to.make.the.nicolet.work.txt** contains the steps I
used to get the scope to communicate properly.

Good luck!
