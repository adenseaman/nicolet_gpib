global data;
global Fdata;
global deltat;
global timeexp;
global vscale;
global vscaleexp;
global t;
global gottscale;
global gotvscale;
global gotmeasurement;
global tmax;
global tmaxexp;
gottscale = 0;
gotvscale = 0;
gotmeasurement = 0;

function nicolet()
global deltat;
global vscale;
global timeexp;
global vscaleexp;
global t;
while(true)
  selection = menu(\
  "NICOLET 2090-III MEASUREMENT PROGRAM",\
  "Acquire Measurement",\
  "Enter Time Per Point",\
  "Enter Volts Full Scale",\
  "Mathematical Functions"\
  );
  if ( selection == 1 )
    acquire();
  elseif ( selection == 2 )
    settscale();
  elseif ( selection == 3 )
    setvscale();
  elseif ( selection == 4 )
    mathmenu();
  endif
endwhile
endfunction

function acquire()
  global data;
  global deltat;
  global timeexp;
  global vscale;
  global vscaleexp;
  global t;
  global tmax;
  global gottscale;
  global gotvscale;
  global gotmeasurement;

  if(!gottscale)
    settscale();
  endif
  if(!gotvscale)
    setvscale();
  endif 

  system("./nicolet.read.data > data");
  data = load("data");
  data = data/2048;

  if ( vscale == 100 )
    data = data*102.4;
    ylabel("mV");
  elseif ( vscale == 200 )
    data = data*204.8;
    ylabel("mV");
  elseif ( vscale == 400 )
    data = data*409.6;
    ylabel("mV");
  elseif ( vscale == 1 )
    data = data*1024;
    ylabel("mV");
  elseif ( vscale == 2 )
    data = data*2048;
    ylabel("mV");
  elseif ( vscale == 4 )
    data = data*4096;
    ylabel("mV");
  elseif ( vscale == 10 )
    data = data*10.24;
    ylabel("V");
  elseif ( vscale == 20 )
    data = data*20.48;
    ylabel("V");
  elseif ( vscale == 40 )
    data = data*40.96;
    ylabel("V");
  endif

  if ( timeexp == -9 )
    xlabel("nS");
  elseif ( timeexp == -6 )
    xlabel("uS");
  elseif ( timeexp == -3 )
    xlabel("mS");
  elseif ( timeexp == 0 )
    xlabel("S");
  elseif ( timeexp == 3 )
    xlabel("kS");
  endif

  axis([0,tmax]);
  plot(t,data);
  gotmeasurement = 1;
endfunction

function settscale()
  global deltat;
  global timeexp;
  global gottscale;
  global t;
  global tmax;
  global tmaxexp;
  deltat = input("Enter Time Per Point: ");
  timeexp = menu(\
  "Enter Time Units",\
  "nS",\
  "uS",\
  "mS",\
  "S"\
  );
  if ( timeexp == 1 )
    timeexp = -9;
  elseif ( timeexp == 2 )
    timeexp = -6;
  elseif ( timeexp == 3 )
    timeexp = -3;
  elseif ( timeexp == 4 )
    timeexp = 0;
  endif

  tmax = 4096*deltat;
  tmaxexp = floor(log(tmax)/log(10));
  while(tmaxexp >= 3)
    tmaxexp = tmaxexp - 3;
    timeexp = timeexp + 3;
    tmax = tmax/1000;
  endwhile
  t = linspace(0,1,4096)*tmax;
  gottscale = 1;
endfunction

function setvscale()
  global vscale;
  global vscaleexp;
  global gotvscale;
  vscale = input("Enter Volts Full Scale:  ");
  if ( vscale >= 100 )
    vscaleexp = -3;
  else
    vscaleexp = 0;
  endif
  gotvscale=1;
endfunction

function mathmenu()
  selection = menu(\
  "Choose A Math Function",\
  "FFT log",\
  "FFT linear"\
  );
  if ( selection == 1 )
    plotfft(1);
  elseif ( selection == 2 )
    plotfft(0);
  endif
endfunction

function plotfft(style)
  global data;
  global Fdata;
  global tmax;
  global tmaxexp;
  global gotmeasurement;
  global timeexp;

  if(!gotmeasurement)
    acquire();
  endif

  deltat = tmax/4096;
  fmax = 1/deltat;
  fexp = ceil(log(fmax)/log(10));
  fexp2 = -timeexp;
  while(fexp+3 < 3)
    fexp = fexp + 3;
    fexp2 = fexp2 - 3;
    fmax = fmax*1000;
  endwhile
  f = linspace(0,fmax/2,2048);
  if ( fexp2 == 6 )
    xlabel("MHz");
  elseif ( fexp2 == 3 )
    xlabel("KHz");
  elseif ( fexp2 == 0 )
    xlabel("Hz");
  elseif ( fexp2 == -3 )
    xlabel("mHz");
  elseif ( fexp2 == -6 )
    xlabel("uHz");
  endif
  Fdata = fft(data)(1:2048)/2048;
  axis([1e-6,fmax/2]);
  if ( style == 1 )
    semilogx(f,abs(Fdata));
  else
    plot(f,abs(Fdata));
  endif
endfunction

