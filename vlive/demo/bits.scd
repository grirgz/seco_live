(
Ndef(\bitshift, {
    var t = PulseCount.ar(Impulse.ar(8e3));
    var sig = HPF.ar(
        (  
            ((t * 15) & (t >> 5)) |
            ((t * 5) & (t >> [3, 4])) |
            ((t * 2) & (t >> 9)) |
            ((t * 8) & (t >> 11))
            - 3 % 256
        ) / 127-1 * 3
        , 20
    ).distort * 0.2; 
	sig/4;
    //sig = Greyhole.ar(sig, sig, 0.5, sig).flop.mean/4;
}).play;
)
(
	Ndef(\bitshift, { arg freq=8000, mod=200, amp=0.7, lpf=120, fb=0.5, x=15, y=5; 
		var son, count; count = PulseCount.ar(Impulse.ar(freq, (fb*Ndef(\bitshift).ar.abs.reverse)));
		a = (count * x); b = (count >> y);
		c = a & b;
		mod=mod.round(1); 
		son=Limiter.ar((c % [mod, mod*3])) * amp; 
		5.do{ 
			son=AllpassN.ar(son, 0.3, rrand(0.001,0.03).postln, rrand(0.1,0.2))
		};
		son=HPF.ar(son, 40);
		son=RLPF.ar(son, lpf, 0.1, 0.6).tanh + son.tanh;
		son=son/4;
		son;
	}).play; 
) 
Ndef(\bitshift).set(\freq, 8000, \x, 15, \y, 4, \mod, 200);

(
Ndef(\bitshift, { arg ffreq = 200, freqfac=15, freq=8000, amp=0.1, pan=0, spread=0.8, shift=1, toffset=0, sigmix=0.5;
	//var t = PulseCount.ar(Impulse.ar(2**13), Impulse.kr(1/(512)));
	var t = PulseCount.ar(Impulse.ar(2**13 * ~t), Impulse.kr(1/(128) * ~t));
	var sig;
	var sig1, sig2;
	var compcontrol;
	var compsig;
	var delay;
	//t = SelectX.ar( MouseX.kr(0,1), [t, LPF.ar(t,MouseY.kr(0.001,10))] );
	//t = SelectX.ar( 1, [t, Lag.ar(t,MouseY.kr(0.001,10))] );
	//t = Lag.ar(t, 1/1000);
	//t = LPF.ar(t, 1);
	t = t + toffset;
	//t = t + (2**28);
	sig1 = HPF.ar(
		(
			//t & (t>>19 | (t>>2)) | (t>>8) | (t *8)

				//(sin(log(t)*2) * 18) )
				//( ( (t * [1,2,3,4,5] ) | ( t >> [4,5,6,7,8,9,10] ) ) fold2: ( 70 * [1,1.012,1.25]) )
				//| ( ( (t * [5,2,3,4,1] ) & ( t >> 12 ) ) fold2: ( [4,4.012,4.15]) )
				//& ( ( (t * [5,2,3,4,1] ) | ( t >> 12 ) ))
				//t * ( [11,15,5,21] * SinOsc.kr(1/1).range(0.1,2) )
				( t * [16,8] ) & ( t *5 >> 8 )
				| ( ( t * [16,8]/2 ) & ( t *2 >> 7 ) )
				| ( ( t * [16,8]/4 ) & ( t *2 >> 6 ) )
				| ( ( t * [16,8]/8 ) & ( t *2 >> 5 ) )
				| ( ( t * [8,16]*2 ) & ( t  >> 2 ) )
				& ( ( t * [16,8]*4 ) | ( t *2 >> 10 ) )
				| ( ( t * [16,8]*8 ) & ( t *2 >> 14 ) )
				//| ( t *2 >> [2,3,4] )
				//& ( ( t *8 >> [12,3,4] ) | ( t *8 >> [12,3,4] ))
				//| (LFSaw.ar(4.8).abs * 10000000)
				//& (LFSaw.ar(0.8).abs * 10000000 >> 10)

				//& ((t >> 8) << 4)
				//& ((t * 4) & (t >> (19)))
		) % 256
		, 20
	) * 0.08;
	sig2 = HPF.ar(
		(
			//t & (t>>19 | (t>>2)) | (t>>8) | (t *8)

			t *8
				& (t >> 2)
				| (t >> 4)
				| (t >> 8)
				| (t >> 1)
				//& ((t >> 8) << 4)
				//& ((t * 4) & (t >> (19)))
		) % 256
		, 20
	) * 0.08;
	sig = SelectX.ar(sigmix, [sig1, sig2]);
	compcontrol = 
		InFeedback.ar(BusDef(\amixer)) * 2 
		+ InFeedback.ar(BusDef(\zmixer))
		+ InFeedback.ar(BusDef(\emixer));
	//compcontrol = SinOsc.ar(100) * Pulse.kr(1/4) * 2;

	//Amplitude.kr(sig).poll;
	//compcontrol.poll(label:"compcontrol");
	compsig = Compander.ar(sig, compcontrol,
		//thresh: MouseX.kr(0.1, 1),
		thresh: 0.2,
		slopeBelow: 1.00,
		slopeAbove: 0.0001,
		clampTime: 0.0011,
		relaxTime: 0.5
	);
	sig = compsig;
	delay = 1/8 / ~t;
	compsig = DelayN.ar(Amplitude.ar(compsig),delay, delay);
	//compsig = sqrt(compsig).linexp;
	compsig = compsig.linexp(0,8,0.01,1);
	//compsig = compsig.explin(0.01,5,0.01,1);
	compsig.poll;
	//sig = RLPF.ar(sig, log(ffreq).round(1/2).exp,0.5);
	sig = sig * 0.15;
	sig = RLPF.ar(sig, compsig * 17400 + 100,0.1);
	sig = Splay.ar(sig, spread, amp, pan);

}).play;
)

//////////////////////////////
// an unique counter shared by multiple synths


(
SynthDef(\bitcounter, { arg out=0, gate=1;
	var sig = PulseCount.ar(Impulse.ar(8e3));
	EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
)

(
SynthDef(\bitshifter1, { arg out=0, gate=1;
	var cc = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var sig = HPF.ar(
		(  
			((cc * 15) & (cc >> 5)) |
			((cc * 5) & (cc >> 3)) |
			((cc * 2) & (cc >> 9)) |
			((cc * 1) & (cc >> 11))
			- 3 % 256
		) / 127-1 * 3
		, 20
	).distort * 0.2; 
	sig = sig/4;
	sig = sig!2;
	//sig = Greyhole.ar(sig, sig, 0.5, sig).flop.mean/4;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;

SynthDef(\bitshifter2, { arg out=0, gate=1;
	var cc = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var sig = HPF.ar(
		(  
			((cc * 2) & (cc >> 2)) |
			((cc * 1) & (cc >> 11))
			- 3 % 1000
		) / 1127-1 * 3
		, 50
	).distort * 0.2; 
	sig = sig/4;
	sig = sig!2;
	//sig = Greyhole.ar(sig, sig, 0.5, sig).flop.mean/4;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;

SynthDef(\bitshifter3, { arg out=0, gate=1;
	var cc = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var sig = HPF.ar(
		(  
			((cc * 7) & (cc >> 9))
			| ((sqrt(cc) * 7) & (cc >> 9))
			- 3 % 256
		) / 127-1 * 3
		, 20
	).distort * 0.2; 
	sig = sig/3;
	sig = sig!2;
	//sig = Greyhole.ar(sig, sig, 0.5, sig).flop.mean/4;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;

SynthDef(\bitshifter4, { arg out=0, gate=1;
	var cc = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var sig = HPF.ar(
		(  
			((cc * 15) & (cc >> 5)) |
			((cc * 25) & (cc >> 13)) 
			- 3 % 256
		) / 127-1 * 3
		, 2190
	).distort * 0.2; 
	sig = sig/3;
	sig = sig!2;
	//sig = Greyhole.ar(sig, sig, 0.5, sig).flop.mean/4;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
)

(
Pdef(\bit, 
	Ppar([
		Pmono(\bitcounter,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\bitcounter,\audio),
		),
		Pbind(
			\instrument, \bitshifter1,
			\inbus, BusDef(\bitcounter,\audio),
			\legato, Pseq([
					0,0,0,0, 4,0,0,0,
					8,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\freq, 200,
			\dur, 1/8,
			\out, BusDef(\fx1, ),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \bitshifter2,
			\inbus, BusDef(\bitcounter,\audio),
			\legato, Pseq([
					 4,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\freq, 200,
			\dur, 1/8,
			\amp, 0.1,
		),

		
	])
).play;
);

(
Pdef(\bit, 
	Ppar([
		Pmono(\bitcounter,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\bitcounter,\audio),
		),
		Pbind(
			\instrument, \bitshifter4,
			\inbus, BusDef(\bitcounter,\audio),
			\legato, Pseq([
					0,0,0,0, 4,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\freq, 200,
			\dur, 1/8,
			\out, BusDef(\mixer6),
			\amp, 0.1,
		),

		
	])
).play;
);
