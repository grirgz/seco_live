
(
SynthDef(\scagrain, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, fspread=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var xfreq = freq * ((0..7)/7 - 0.5 * fspread + 1);
	xfreq = xfreq * XLine.kr(1,2,2);
	sig1 = SinOsc.ar(xfreq);
	sig2 = LFSaw.ar(xfreq);
	sig2 = RLPF.ar(sig2, \lpfr.kr(2.2) * freq, \rq.kr(0.5));
	sig = SelectX.ar(\oscwave.kr(0), [sig1, sig2]);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean * 4;
	Out.ar(out, sig);
}).add;

SynthDef(\scagrain2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, fac1=0.1, fac2=1, fac3=1, fac4=1, fac5=1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = SinOsc.ar(freq * ( 1 + ( SinOsc.kr(freq/2 * ( 1 + ( SinOsc.kr((1..8) * fac1) * fac3 ))) * fac2 )));
	sig = LPF.ar(sig, freq * \lpfr.kr(2) * SinOsc.ar(fac4, mul:fac5, add:1) ) + ( sig/2 );
	sig = sig * EnvGen.ar(Env.adsr(0.2,0.1,0.8,0.2),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean * 4;
	Out.ar(out, sig);
}).add;

Pdef(\scape, 
	Ppar([
		8.collect({ arg x;
			Pbind(
				\oscwave, Pseg(Pseq([0,1],inf),8+x),
				\fspread, Pseg(Pseq([0.00001,0.01],inf),8+x+3),
				\lpfr, Pseg(Pseq([0,4],inf),8+x+2),
				\instrument, \scagrain,
				\freq, 60 * ( x*16+1 ),
				\sustain, Pseg(Pseq([0.05,0.5],inf),8+x+1),
				\dur, 1/8 * ( 1+x ),
				\pan, Pseg(Pseq((0..7).linlin(0,7,-1,1),inf,x),8+x+6.123) * Pseg(Pseq([0,1],inf),16+x) ,
				\amp, 0.1/4 * Pseg(Pseq([1,1/2,1],inf),8+x+2.321),
			);
		})
	].flat)
);


Pdef(\scape2, 
	Ppar([
		8.collect({ arg x;
			Pbind(
				\instrument, \scagrain2,
				\freq, 60 * (x*8+1),
				\fac1, Pseg(Pseq([0.00001,0.1,2],inf),8+x+3),
				\fac2, Pseg(Pseq([0.40001,0.1,2],inf),8+x+2),
				\fac3, Pseg(Pseq([0.00001,0.1,2],inf),8+x+1),
				\fac4, Pseg(Pseq([0.00001,0.1,2],inf),8+x+4),
				\fac5, Pseg(Pseq([0.00001,0.1,1/2],inf),8+x+5),
				//\fac1, 0, \fac2, 0, \fac3, 0,
				\dur, 1/8 + ( x/ Pseg(Pseq([1,8],inf),8) ),
				\pan, Pseg(Pseq((0..7).linlin(0,7,-1,1),inf,x),8+x+6) * 0.8 ,
				\lag, x,
				\amp, 0.1/4 * Pseg(Pseq([1,1/2,1],inf),8+x+3.321),
			);
		})
	].flat)
);

	Pdef(\city, Ptpar([
		0, Pdef(\scape),
		16, Pdef(\scape2),
	])).play
)
