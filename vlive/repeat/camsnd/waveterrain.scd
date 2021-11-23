
WaveTerrain

//create buffer. I want the equation z = 2*(((x/100)**2) + ((abs(sin(10*y))/50)**(1/3)))-1
//over a 100 by 50 area

//2d to 1d conversion follows index= y*rowlength+ x
(
var width= 100; //= num cols
var height=50; //=num rows, though indexing bottom to top; i.e., standard Cartesian co-ordinates

a=Array.fill(width*height,{arg i; 
var xnow, ynow, x, y; 

xnow= i%width;
ynow= (i-xnow).div(width);

x=xnow/width;
y=ynow/height;

2*(((x)**2) + ((abs(sin(10*y)))**(1/3)))-1

});


b=Buffer.sendCollection(s, a, 1);
)


//test scanning; you can't move fast enough... scan controls should also be audio rate!
{WaveTerrain.ar(b.bufnum,MouseX.kr(0.0,1.0), MouseY.kr(0.0,1.0),100,50) * 0.1}.play


//LFNoise adds some drift to explore the landscape more
{WaveTerrain.ar(b.bufnum,SinOsc.ar(MouseX.kr(1,200,'exponential')).abs + LFNoise2.ar(2),SinOsc.ar(MouseY.kr(1,300,'exponential'),pi*0.5).abs,100,50) * 0.1 ! 2 }.play

{WaveTerrain.ar(b.bufnum,LFNoise1.ar(MouseX.kr(1,200,'exponential')).abs,LFNoise1.ar(MouseY.kr(1,300,'exponential'),pi*0.5).abs,100,50) * 0.1 ! 2 }.play




//change surface equation
(
var width= 100; //= num cols
var height=50; //=num rows, though indexing bottom to top; i.e., standard Cartesian co-ordinates

a=Array.fill(width*height,{arg i; 
var xnow, ynow, x, y; 

xnow= i%width;
ynow= (i-xnow).div(width);

x=xnow/width;
y=ynow/height;

(((cos(5*x+1.7))**3) - ((abs(sin(23*y)))**(1/3)))

});

b.sendCollection(a);
)





//change surface equation
(
var width= 100; //= num cols
var height=50; //=num rows, though indexing bottom to top; i.e., standard Cartesian co-ordinates

a=Array.fill(width*height,{arg i; 
var xnow, ynow, x, y; 

xnow= i%width;
ynow= (i-xnow).div(width);

x=xnow/width;
y=ynow/height;

(((1.3*(cos(rrand(1,2)*x+1.7))**2) - ((abs(sin(rrand(1.2,4.9)*y)))**(1/2)))).max(-1.0).min(1.0)

});

b.sendCollection(a);
)


(
SynthDef(\waveterrain, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, freq2=201;
	var sig;
	sig = WaveTerrain.ar(\terrain.kr(b.bufnum),SinOsc.ar(freq,mul:0.01, add:LFNoise1.kr(0.01)).abs,SinOsc.ar(freq2,mul:0.01, add:LFNoise1.kr(0.01)).abs,\xsize.kr(100),\ysize.kr(50));
	//sig = SinOsc.ar(freq);
	//freq2.poll;
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = HPF.ar(sig, 40);
	sig = Pan2.ar(sig, pan, amp);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(2.1,0.1,0.8,2.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \waveterrain,
			\note, Pseq([
				[0,4,7,0+12],
				[0,3,7,0+12],
			],inf) + Pstep(Pseq([0,4,3,6],inf),2),
			\lpfr, 2.1,
			\freq2, Pfunc({ arg ev;
				ev.use {  ~freq.value(ev).postln + 1 };
			}),
			//\octave, 5,
			\adsr, Pseq([
				[ Env.adsr(1.1,1.1,0.8,2.1) ],
			],inf),
			//\terrain, b.bufnum,
			\dur, 4,
			\amp, 0.3,
		),
		
	])
)).play;
);


(
SynthDef(\waveterrain, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, freq2=201;
	var sig;
	sig = WaveTerrain.ar(\terrain.kr(b.bufnum),SinOsc.ar(freq,mul:0.01, add:\xshift.kr(0).poll).abs,SinOsc.ar(freq2,mul:0.01, add:\yshift.kr(0)).abs,\xsize.kr(100),\ysize.kr(50));
	//sig = SinOsc.ar(freq);
	//freq2.poll;
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = HPF.ar(sig, 40);
	sig = Pan2.ar(sig, pan, amp);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(2.1,0.1,0.8,2.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \waveterrain,
			\note, Pseq([
				[0,4,7,0+12],
				[0,3,7,0+12],
			],inf) + Pstep(Pseq([0,4,3,6],inf),2),
			\xshift, ~pmodenv.(Pseq([0,1],1), 8).loop,
			\yshift, Pstep(Pseq((0..64)/64,inf),8),
			\lpfr, 2.1,
			\freq2, Pfunc({ arg ev;
				ev.use {  ~freq.value(ev).postln + 1 };
			}),
			//\octave, 5,
			\adsr, Pseq([
				[ Env.adsr(1.1,1.1,0.8,2.1) ],
			],inf),
			//\terrain, b.bufnum,
			\dur, 4,
			\amp, 0.3,
		),
		
	])
)).play;
);




