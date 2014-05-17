~name = \7;

Veco(~name).lib.buf = Buffer.sendCollection(s, a, 1);
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

~buf =Buffer.sendCollection(s, a, 1);

SynthDef(~name, { arg out=0, amp=0.1, gate=1, freq1=100, freq2=300, doneAction=2;
	var b = ~buf;
	var sig;
	sig = WaveTerrain.ar(b.bufnum,SinOsc.ar(freq1).range(0,1) + LFNoise2.ar(2),SinOsc.ar(freq2,pi*0.5).range(0,1),100,50);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:doneAction);

	//sig = SinOsc.ar(100);
	sig = sig ! 2;
	sig = sig*amp;
	Out.ar(out, sig);
}).add;

SynthDef(~name, { arg out=0, amp=0.1, gate=1, freq1=100, freq2=300, doneAction=2;
	var b = ~buf;
	var sig;
	sig = WaveTerrain.ar(b.bufnum,SinOsc.ar(freq1).range(0,1) + LFNoise2.ar(2),SinOsc.ar(freq2,pi*0.5).range(0,1),100,50);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:doneAction);

	//sig = SinOsc.ar(100);
	sig = sig ! 2;
	sig = sig*amp;
	Out.ar(out, sig);
}).add;

if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, ~name,
	\degree, Pseq([0],inf),
	\isRest, Veco(~name).isrest,
	\freq1, 10,
	\freq2, 3,
	\dur, 1/4,
	\amp, 0.1 * Pkey(\amp),
) <> Veco(~name).mixer
);

//b.sendCollection(a, 1);
)
