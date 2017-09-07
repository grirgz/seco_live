
{ SinOsc.ar(200) ! 2 * 0.1}.play;

(
SynthDef(\emergency, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	freq = freq.lag(1);
	lfo1 = LFPulse.kr(4, 0, 0.84).range(-1,1) * 0.9;
	lfo1 = LPF.kr(lfo1, 10);
	env1 = EnvGen.kr(\adsr.kr(Env.dadsr(0.2,0.4,0.0,1,0.1,1,4)), gate, doneAction:0);
	sig = LFPulse.ar(freq * ( 1 + ( LFSaw.ar(freq/2) * 1.4 )) * ( 1 + ( SinOsc.ar(freq*2 * [1,1.0001]) * 0.4 )));
	sig1 = sig;
	sig1 = BPF.ar(sig1, ( freq/4  + ( env1 * freq ) * ( lfo1.lag(0.1) + 1 )), 0.8);
	sig1 = ( sig1 * 1000 ).clip2(1)/2;
	sig = sig1 + sig;
	sig = LPF.ar(sig, ( freq*2+100  + ( env1 * freq ) * ( lfo1 + 1 )).clip(80,20000));
	sig = LPF.ar(sig, 10000);
	sig = sig * EnvGen.ar(Env.adsr(0.1,0.1,0.8,0.5),gate,doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\emergency, Pbind(
	\instrument, \emergency,
	\degree, Pseq([0,2+12,4,2],inf),
	\octave, 3,
	\dur, 2,
	\amp, 0.1
)).play;
);


(
Pdef(\emergency, PmonoArtic( \emergency,
	\degree, Pseq([0,2+12,4,2],inf),
	\octave, 3,
	\legato, Pseq([1,1,1,0.8],inf),
	\dur, 2,
	\amp, 0.1
)).play;
);

{ LPF.kr(LFPulse.kr(8,0,0.9).range(-1,1),10) }.plot(1/1)

Pde


/////////////////// hard bass


(
SynthDef(\noisybass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq.lag(0.4);
	env1 = EnvGen.kr(Env([0,0,7000,0],[0.01,0.4,0.8]), \trigx.tr(1));
	sig = Saw.ar(freq * [1/2,1/2] * [ [1,1.00001] ] * ( 1 + ( LFSaw.ar(freq*1) * 0.01 )) * ( 1 + ( LFCub.ar(freq*1) * 0.02 )));
	sig = sig * ( LFSaw.ar(freq * ( 1 + ( SinOsc.ar(2*~t) * 1/8 ))) + 1 );
	sig = sig.mean;
	sig.debug("sig");
	sig1 = sig;
	sig1 = BPF.ar(sig1, freq+[100,300,200],0.1).sum;
	sig1 = ( sig1 * 100 ).clip2(1)/4;
	sig = LPF.ar(sig, \lpfr.kr(4.1) * freq + env1);
	sig = sig + sig1;
	sig = LPF.ar(sig, 10000);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.4),gate,doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\demo, PmonoArtic(\noisybass,
	\degree, Pseq([0,2+12,4,6, 8,4,2,-4],inf),
	\scale, Scale.minor,
	\trigx, 1,
	\legato, Pseq([1,1,1,0.8,0.1,1,1,0.9],inf),
	\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
	//\legato, 0.7,
	\octave, 3,
	\dur, 1/2,
	\dur, PdurStutter(Pseq([1,2,2,4],inf), 1/2),
	\amp, 0.1
)).play;
);


(
SynthDef(\noisybass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq.lag(0.4);
	env1 = EnvGen.kr(Env([0,0,7000,0],[0.01,0.4,0.8]), \trigx.tr(1));
	sig = SinOsc.ar(freq * [1,1] * [[1,1]]) * ( SinOsc.ar(freq/2)+1 ) ;
	sig = sig.mean;
	sig.debug("sig");
	sig1 = sig;
	sig1 = BPF.ar(sig1, freq+[100,300,200],0.1).sum;
	sig1 = ( sig1 * 100 ).clip2(1)/4;
	sig = LPF.ar(sig, \lpfr.kr(4.1) * freq + env1);
	sig = sig + sig1;
	sig = ( sin(sig*7)+1 ) * sig / 2;
	sig = LPF.ar(sig, 10000);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.4),gate,doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\demo, PmonoArtic(\noisybass,
	\degree, Pseq([0,2+12,4,6, 8,4,2,-4],inf),
	\scale, Scale.minor,
	\trigx, 1,
	\legato, Pseq([1,1,1,0.8,0.1,1,1,0.9],inf),
	\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
	//\legato, 0.7,
	\octave, 3,
	\dur, 1/2,
	\dur, PdurStutter(Pseq([1,2,2,4],inf), 1/2),
	\amp, 0.1
)).play;
);

/////////////


(
SynthDef(\amdel, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	freq = freq.lag(0.1);
	sig = SinOsc.ar(freq); 
	sig = Select.ar(sig+1*2, [ Saw.ar(freq), Pulse.ar(freq), SinOsc.ar(freq+1) ]);
	sig = Select.ar(sig+1*2, [ Saw.ar(freq), Pulse.ar(freq), SinOsc.ar(freq+1) ]);
	sig = Select.ar(sig+1*2, [ Saw.ar(freq), Pulse.ar(freq), SinOsc.ar(freq+1) ]);
	sig = Select.ar(sig+1*2, [ Saw.ar(freq), Pulse.ar(freq), SinOsc.ar(freq+1) ]);
	//sig = Select.ar(sig+1*3, [ Saw.ar(freq), Pulse.ar(freq), K2A.ar(XLine.kr(0.1,1,10)), SinOsc.ar(freq+1) ]);
	//sig = Select.ar(sig+1*3, [ Saw.ar(freq), Pulse.ar(freq), K2A.ar(XLine.kr(0.1,1,1)), SinOsc.ar(freq+1) ]);
	sig = LeakDC.ar(sig);
	//sig = sig.ring3(sig);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = BLowShelf.ar(sig, 180, 1.4, 10);
	//sig = sig * 0.4;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\demo, PmonoArtic(\amdel,
	\degree, Pseq([0,2+12,4,6, 8,4,2,-4],inf),
	\scale, Scale.minor,
	\trigx, 1,
	\legato, Pseq([1,1,1,0.8,0.1,1,1,0.9],inf),
	\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
	//\legato, 0.7,
	\octave, 3,
	\dur, 1/2,
	\dur, PdurStutter(Pseq([1,2,2,4],inf), 1/2),
	\amp, 0.1
)).play;
);


(
SynthDef(\amdel, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq.lag(0.1);

	env1 = EnvGen.kr(Env([0,0,1,0],[0.01,0.1,1.8]), \trigx.tr(1));
	sig = SinOsc.ar(freq); 
	sig1 = Select.ar(sig+1*2, [ Saw.ar(freq), Pulse.ar(freq), SinOsc.ar(freq+1) ]);
	sig = SelectX.ar(env1, [sig, sig1]);
	sig1 = Select.ar(sig+1*3, [ sig, Saw.ar(freq), Pulse.ar(freq), SinOsc.ar(freq+1) ]);
	sig = SelectX.ar(env1, [sig, sig1]);
	sig1 = Select.ar(sig+1*3, [ sig, Saw.ar(freq), Pulse.ar(freq), SinOsc.ar(freq+1) ]);
	sig = SelectX.ar(env1, [sig, sig1]);
	sig = LeakDC.ar(sig);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\amdel, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	freq = freq.lag(0.4);

	sig = SinOsc.ar(freq); 
	5.do { arg x;
		var drysig = sig;
		var wetsig;
		wetsig = Select.ar(sig+1*2*[1,1], [ Saw.ar(freq/2), Pulse.ar(freq*2), SinOsc.ar(freq) ].rotate(x));
		//sig = SelectX.ar( LFNoise2.ar(x+1*1000/2*[1,1]).range(0,1), [drysig, wetsig]);
		sig = SelectX.ar( LFNoise1.ar([1,1]/2).range(0,1), [drysig, wetsig]);
	};
	sig = LeakDC.ar(sig);

	sig1 = sig;
	env1 = EnvGen.kr(Env([0,0,15000,500,10000],[0.01,0.1,0.1,5]), \trigx.tr(1));
	sig1 = BPF.ar(sig1, freq+[100,300,200],0.1).sum;
	sig1 = ( sig1 * 100 ).clip2(1)/4;
	env2 = Duty.kr(1/~t, 0, Dseq([
		1,1,1,1,
		4,4,4,4,
		2,4,4,16,
	],inf));
	sig = LPF.ar(sig, \lpfr.kr(4.1) * freq + env1 * LFSaw.ar(env2*~t).lag(0.07).range(1.2,0.1));


	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
);


(
Pdef(\demo, PmonoArtic(\amdel,
	\degree, Pseq([0,-2,4,6, -6,4,2,-4],inf),
	\scale, Scale.minor,
	\trigx, 1,
	\legato, Pseq([1,1,1,0.8,0.1,1,1,0.9],inf),
	\legato, 0.9,
	\legato, Pseq([1,1,1,0.9],inf),
	\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
	\octave, 3,
	\dur, PdurStutter(Pseq([1,2,2,4],inf), 1/2),
	\dur, 2,
	\amp, 0.1
)).play;
);
