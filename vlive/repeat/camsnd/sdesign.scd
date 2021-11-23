
(
SynthDef(\zed, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var num = 40;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	freq = Rand(100.0,4000!num);
	lfo1 = LFNoise1.ar(0.1!num);
	sig = SinOsc.ar(freq * ( SinOsc.ar(freq * lfo1) * lfo1 * 3 + 1 ));
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(
			 \zed,
			\freq, 900,
			\dur, 1,
			\amp, 0.1,
		),	
	])
)).play;
);


//////////////


(
SynthDef(\gongFM, {
	arg ratio1=0.9, ratio2=0.55, ratio3=1.03, index2=2, index3=4, amp=0.7, dur=7, pan=0;
	var sig, op1, op2, op3, env1, env2, env3;
	env3 = EnvGen.kr(Env.new([0, 1, 1, 0], [0.4, 0.3, dur]), doneAction:2);
	env2 = EnvGen.kr(Env.new([0, 1, 1, 0], [0, 0.3, dur]), doneAction:2);
	env1 = EnvGen.kr(Env.new([0, 1, 1, 0], [0.003, 0.3, dur - 0.5]), doneAction:2);
	op3 = SinOsc.ar(([67, 70, 74].midicps * ratio3), mul:[67, 70, 74].midicps * ratio3 * index3) * env3;
	op2 = SinOsc.ar((([67, 70, 74].midicps * ratio2) + op3), mul:[67, 70, 74].midicps * ratio2 * index2) * env2;
	op1 = SinOsc.ar(([67, 70, 74].midicps * ratio1) + op2);
	sig = op1 * env1 * amp;
	sig = Splay.ar(sig);
	sig = Balance2.ar(sig[0], sig[1], pan);
	Out.ar(0, sig);
}).add;
)


// 2. Ejecutar los Synths

Synth(\gongFM);

Synth(\gongFM, [\ratio1, 0.503, \ratio2, 0.50, \ratio3, 1.35, \index2, 1.53, \index3, 4.33]);

Synth(\gongFM, [\ratio1, 0.59, \ratio2, 0.17, \ratio3, 0.75, \index2, 1.54, \index3, 3.29]);

Synth(\gongFM, [\ratio1, 0.49, \ratio2, 0.17, \ratio3, 0.34, \index2, 1.33, \index3, 4.31]);

Synth(\gongFM, [\ratio1, 1.11, \ratio2, 0.2, \ratio3, 0.80, \index2, 1.97, \index3, 5.06]);


//////////////////


	(
	SynthDef(\cymbalsimple, { | out = 0, pan = 0.0, amp=0.1, gate=1 |
		var sig, env;
		//env = EnvGen.ar(Env.perc(0.01, 8, curve: -4), doneAction: 2);
		sig = HPF.ar(Ringz.ar(WhiteNoise.ar(0.1), {exprand(100, 20000)}.dup(100)).mean, 90);
		sig = BPF.ar(sig, LFNoise1.kr(0.1!3).range(200,2000), 0.1) * 30.3 ;
		sig = sig.mean;
		sig = sig * amp;
		sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
		Out.ar(out, Pan2.ar(sig , pan));
	}).add;
	Pdef(\part).reset;
	)

	(
	Pdef(\part, Pdef(\zedpart, 
		Ppar([
			Pmono(
				 \cymbalsimple,
				\freq, 200,
				\dur, 4,
				\amp, 0.1,
			),
		])
	)).play;
	);


////////


(
SynthDef(\zed, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var num = 10;
	sig = Blip.ar(200,Line.kr(1.0,100,20),0.2) ;
	sig = Blip.ar({ exprand(200.0,20000) }!num,10);
	sig = sig.mean;
	sig1 = BPF.ar(sig, LFNoise1.kr(1/2!num).exprange(180,3000), 0.1).mean * 100;
	sig = SelectX.ar(\mix.kr(0.9), [sig, sig1]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
SynthDef(\zed, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var num = 10;
	sig = Blip.ar(200,Line.kr(1.0,100,20),0.2) ;
	sig = Blip.ar({ exprand(200.0,20000) }!num,10);
	sig = sig.mean;
	sig1 = BPF.ar(sig, LFNoise1.kr(1/2!num).exprange(180,3000), 0.1).mean * 100;
	sig = SelectX.ar(\mix.kr(0.9), [sig, sig1]);
	sig = CombL.ar(sig, 0.1, LFNoise1.kr(0.1).exprange(1/50.0,1/1000.0),1);
	sig = sig.softclip;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

	(
	Pdef(\part, Pdef(\zedpart, 
		Ppar([
			Pmono(
				 \zed,
				\freq, 200,
				\dur, 4,
				\amp, 0.1,
			),
		])
	)).play;
	);


//////////////////////



(
// bare minimum exemple by scztt
// monster bass from far away
Ndef(\zed, { arg freq=50, pan=0, amp=0.1;
	var sig;
	var pitchedInput, comb, dist, del;
	del = LFNoise1.kr(1/2)*freq*0.05;
	pitchedInput = Pulse.ar(freq + del);
	comb = CombC.ar(pitchedInput, 1, freq.reciprocal , 0.3);
	dist = SoftClipAmp.ar(comb, 1) * 0.5;
	sig = dist;

	sig = Pan2.ar(sig, pan, amp);
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(3), \damp.kr(0.4));
}).play;
);


(
// worrying
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var pitchedInput, comb, dist, del;
	del = LFNoise1.kr(1/2)*0.3;
	pitchedInput = Impulse.ar(freq * [1/2,3/4,1] + del);
	pitchedInput = LFSaw.ar(freq * 1/(1..8) * 4 + del);
	pitchedInput = pitchedInput.mean;
	comb = CombC.ar(pitchedInput, 1, freq.reciprocal * LFNoise1.ar(0.1).range(0.9,1.1), 1);
	dist = SoftClipAmp.ar(comb, 1) * 0.5;
	sig = dist;

	sig = Pan2.ar(sig, pan, amp);
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(3), \damp.kr(0.4));
}).play;
);


(
Ndef(\zed, { arg freq=150, pan=0, amp=0.1;
	var sig;
	var pitchedInput, comb, dist, del;
	sig = 10.collect({ arg idx;
		var ifreq = freq * ( ( idx+1 ) );
		del = LFNoise1.kr(1/2)*freq*0.05;
		pitchedInput = Pulse.ar(ifreq/4 + del);
		comb = CombC.ar(pitchedInput, 1, ifreq.reciprocal , 3.3);
		dist = SoftClipAmp.ar(comb, 1) * 0.5;
	});
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);

	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(3), \damp.kr(0.4));
}).play;
);

(
Ndef(\zed, { arg freq=350, pan=0, amp=0.1;
	var sig;
	var pitchedInput, comb, dist, del;
	sig = 10.collect({ arg idx;
		var ifreq = freq * ( ( idx+1 ) );
		del = LFNoise1.kr(1/2)*freq*0.05;
		pitchedInput = SinOsc.ar(ifreq/4 + del);
		comb = CombC.ar(pitchedInput, 1, ifreq.reciprocal , 3.3);
		dist = SoftClipAmp.ar(comb, 1) * 0.5;
	});
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);

	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(3), \damp.kr(0.4));
}).play;
);

(
Ndef(\zed, { arg freq=350, pan=0, amp=0.1;
	var sig;
	var pitchedInput, comb, dist, del;
	sig = 10.collect({ arg idx;
		var ifreq = freq * ( ( idx+1 ) );
		del = LFNoise1.ar(ExpRand(1/10,3.0))*45;
		pitchedInput = SinOsc.ar(ifreq + [0,1]/4 + del);
		pitchedInput = pitchedInput.fold2( LFNoise1.kr(1/2).range(0.0,1.0) );
		comb = CombC.ar(pitchedInput, 1, ifreq.reciprocal , 3.3);
		dist = SoftClipAmp.ar(comb, 1) * 0.5;
	});
	sig = sig.flatten;
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);

	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(1), \damp.kr(0.4));
}).play;
);


(
Ndef(\zed, { arg freq=50, pan=0, amp=0.1;
	var sig;
	var pitchedInput, comb, dist, del;
	sig = 10.collect({ arg idx;
		var ifreq = freq * ( ( idx+1 ) );
		del = LFNoise1.kr(1/2)*5;
		pitchedInput = Pulse.ar(ifreq + del);
		comb = CombC.ar(pitchedInput, 1, ifreq.reciprocal , 3.3);
		dist = SoftClipAmp.ar(comb, 1) * 0.5;
	});
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);

	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(3), \damp.kr(0.4));
}).play;
);

(
Ndef(\zed, { arg freq=110, pan=0, amp=0.1;
	var sig;
	var pitchedInput, comb, dist, del;
	sig = 10.collect({ arg idx;
		var ifreq = freq * ( ( idx+1 ) );
		del = LFNoise1.kr(1/2)*15;
		pitchedInput = Pulse.ar(ifreq + del);
		comb = CombC.ar(pitchedInput, 1, ifreq.reciprocal * LFNoise1.kr(1/2).range(1.0,1.1) , 3.3);
		dist = SoftClipAmp.ar(comb, 1) * 0.5;
	});
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);

	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(3), \damp.kr(0.4));
}).play;
);

(
Ndef(\zed, { arg freq=110, pan=0, amp=0.1;
	var sig;
	var pitchedInput, comb, dist, del;
	sig = 10.collect({ arg idx;
		var ifreq = freq * ( ( idx+1 ) );
		del = LFNoise1.kr(1/9)*15;
		pitchedInput = Pulse.ar(freq + del);
		comb = CombC.ar(pitchedInput, 1, ifreq.reciprocal * LFNoise1.kr(1/2).range(1.0,1.01) , 3.3);
		dist = SoftClipAmp.ar(comb, 1) * 0.5;
	});
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);

	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(3), \damp.kr(0.4));
}).play;
);

(
Ndef(\zed, { arg freq=70, pan=0, amp=0.1;
	var sig;
	var pitchedInput, comb, dist, del;
	sig = 10.collect({ arg idx;
		var ifreq = freq * ( ( idx+1 ) );
		del = LFNoise1.kr(1/9)*15;
		pitchedInput = Pulse.ar(freq + del);
		comb = CombL.ar(pitchedInput, 1, ifreq.reciprocal * LFNoise1.kr(1/2).range(1.0,2.01) , 3.3);
		dist = SoftClipAmp.ar(comb, 1) * 0.5;
		dist = RLPF.ar(dist, ifreq * LFNoise1.kr(1/2).range(0.4,3.0), \rq.kr(0.5));
	});
	sig = HPF.ar(sig, 190);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);

	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(3), \damp.kr(0.4));
}).play;
);

(
// trumpet
Ndef(\zed, { arg freq=110, pan=0, amp=0.1;
	var sig;
	var pitchedInput, comb, dist, del;
	sig = 10.collect({ arg idx;
		var ifreq = freq * ( ( idx+1 ) );
		del = LFNoise1.kr(1/9)*15;
		pitchedInput = SinOsc.ar(freq + del + ( SinOsc.ar(freq) * ifreq * LFNoise1.kr(1/2).range(0.0,1.0) ));
		comb = CombL.ar(pitchedInput, 1, ifreq.reciprocal * LFNoise1.kr(1/2).range(1.0,2.01) , 0.3);
		dist = SoftClipAmp.ar(comb, 1) * 0.5;
		dist = RHPF.ar(dist, ifreq * LFNoise1.kr(1/2).range(0.4,3.0), \rq.kr(0.1));
	});
	sig = HPF.ar(sig, 190) * 3;
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);

	//sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(1), \damp.kr(0.4));
}).play;
);

(
// bass
Ndef(\zed, { arg freq=50, pan=0, amp=0.1;
	var sig;
	var pitchedInput, comb, dist, del;
	sig = 10.collect({ arg idx;
		var ifreq = freq * ( ( idx+1 ) );
		del = LFNoise1.kr(1/9)*1;
		pitchedInput = SinOsc.ar(ifreq + del + ( SinOsc.ar(ifreq) * ifreq * LFNoise1.kr(0.1).range(0.0,4.0) ));
		comb = CombL.ar(pitchedInput, 1, ifreq.reciprocal * LFNoise1.kr(1/2).range(1.0,1.01) , 0.3);
		dist = RLPF.ar(dist, ifreq * LFNoise1.kr(0.01).range(0.4,4.0), \rq.kr(0.5));
		dist = SoftClipAmp.ar(comb, 1) * 0.5;
	});
	sig = HPF.ar(sig, 40) * 2;
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);

	//sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(1), \damp.kr(0.4));
}).play;
);

(
Ndef(\zed, { arg freq=50, pan=0, amp=0.1;
	var sig;
	var pitchedInput, comb, dist, del;
	sig = 10.collect({ arg idx;
		var ifreq = freq * ( ( idx+1 ) );
		del = LFNoise1.kr(1/9)*1;
		pitchedInput = SinOsc.ar(ifreq + del + ( SinOsc.ar(freq) * ifreq * LFNoise1.kr(0.1).range(2.0,14.0) ));
		comb = CombL.ar(pitchedInput, 1, ifreq.reciprocal * LFNoise1.kr(1/2).range(1.0,1.01) , 0.3);
		dist = RLPF.ar(dist, ifreq * LFNoise1.kr(1.1).range(0.4,4.0), \rq.kr(0.5));
		dist = SoftClipAmp.ar(comb, 1* LFNoise1.kr(1/2).range(0.0,1.0)) * 0.5;
	});
	sig = HPF.ar(sig, 40) * 2;
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);

	//sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(1), \damp.kr(0.4));
}).play;
);

(
Ndef(\zed, { arg freq=50, pan=0, amp=0.1;
	var sig;
	var pitchedInput, comb, dist, del;
	del = LFNoise1.kr(1/2)*freq*0.05;
	pitchedInput = Pulse.ar(freq * [1,1.01,2,3/2] - del);
	comb = CombC.ar(pitchedInput, 1, ( freq  + del ).reciprocal , 0.3);
	del = LFNoise1.kr(1/2)*freq*0.05;
	comb = CombC.ar(pitchedInput, 1, ( freq  + del ).reciprocal , 0.3);
	del = LFNoise1.kr(1/2)*freq*0.01;
	comb = CombC.ar(pitchedInput, 1, ( freq  + del ).reciprocal , 3);
	dist = SoftClipAmp.ar(comb, 1);
	sig = dist.mean;

	sig = Pan2.ar(sig, pan, amp);
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(3), \damp.kr(0.4));
}).play;
);

(
Ndef(\zed, { arg freq=400, pan=0, amp=0.1;
	var sig;
	var pitchedInput, comb, dist, del;
	del = LFNoise1.kr(1/2)*40.3;
	pitchedInput = LFSaw.ar(freq  + del);
	pitchedInput = Impulse.ar(freq);
	pitchedInput = RLPF.ar(pitchedInput, \lpfr.kr(1.1) * freq * LFNoise1.kr(1/2).range(1.0,4.0), \rq.kr(0.5));
	//pitchedInput = pitchedInput.mean;
	comb = CombC.ar(pitchedInput, 1, ( freq  + del ).reciprocal , 1);
	dist = SoftClipAmp.ar(comb, 1) * 0.5;
	sig = dist!2;
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(3), \damp.kr(0.4));

	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var pitchedInput, comb, dist, del;
	del = LFNoise1.kr(1/2)*0.3;
	pitchedInput = Impulse.ar(freq * [1/2,3/4,1] + del);
	pitchedInput = LFSaw.ar(freq * 1/(1..8) * 1 + del);
	pitchedInput = pitchedInput.mean;
	comb = CombC.ar(pitchedInput, 1, freq.reciprocal * LFNoise1.ar(0.1).range(0.9,1.1), 1);
	dist = SoftClipAmp.ar(comb, 1) * 0.5;
	sig = dist;

	sig = Pan2.ar(sig, pan, amp);
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(3), \damp.kr(0.4));
}).play;
);

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var pitchedInput, comb, dist, del;
	del = LFNoise1.kr(1/2!8)*18.3;
	pitchedInput = LFSaw.ar(freq * 1/(1..8) * 1 + del);
	pitchedInput = pitchedInput.mean;
	comb = CombC.ar(pitchedInput, 1, freq.reciprocal * LFNoise1.ar(0.1).range(0.9,1.1), 4);
	dist = SoftClipAmp.ar(comb, 1) * 0.5;
	sig = dist;

	sig = Pan2.ar(sig, pan, amp);
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(3), \damp.kr(0.4));
}).play;
);

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var pitchedInput, comb, dist, del;
	del = LFNoise1.kr(1/2)*0.3;
	pitchedInput = Impulse.ar(freq * [1/2,3/4,1] + del);
	pitchedInput = LFSaw.ar(freq * 1/(1..8) * 4 + del);
	pitchedInput = pitchedInput.mean;
	comb = CombC.ar(pitchedInput, 1, freq.reciprocal * LFNoise1.ar(0.1!8).range(0.9,1.1), 1);
	dist = SoftClipAmp.ar(comb, 1) * 0.5;
	sig = dist;

	sig = Pan2.ar(sig, pan, amp);
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(3), \damp.kr(0.4));
}).play;
);

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var pitchedInput, comb, dist, del;
	del = LFNoise1.kr(1/2)*4.3;
	pitchedInput = Impulse.ar(freq * [1/2,3/4,1] + del);
	pitchedInput = Pulse.ar(freq * 1/(1..8) * 2 + del);
	pitchedInput = pitchedInput.mean;
	comb = CombC.ar(pitchedInput, 1, freq.reciprocal * LFNoise1.ar(0.1!8).range(0.9,1.1), 1);
	dist = SoftClipAmp.ar(comb, 1);
	sig = dist!2;
	sig = BPF.ar(sig, LFNoise1.kr(1/2!23).range(6, 1/3) * freq, 0.1);
	sig = sig.mean * 3*2*3;

	sig = Pan2.ar(sig, pan, amp);
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(3), \damp.kr(0.4));
}).play;
);


/////////////////////:


(
SynthDef(\combbass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var pitchedInput, comb, dist, del;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([4,1/2,8],[0.1,1.8]), 1);
	sig = 10.collect({ arg idx;
		var ifreq = freq * ( ( idx+1 ) );
		del = LFNoise1.kr(1/9)*1;
		pitchedInput = SinOsc.ar(ifreq + del + ( SinOsc.ar(freq) * ifreq * LFNoise1.kr(0.1).range(2.0,14.0) ));
		comb = CombL.ar(pitchedInput, 1, ifreq.reciprocal * LFNoise1.kr(1/2).range(1.0,1.01) , 0.3);
		dist = RLPF.ar(dist, ifreq * LFNoise1.kr(1.1).range(0.4,1.0), \irq.kr(0.5));
		dist = SoftClipAmp.ar(comb, 1) * 0.5;
	});
	sig = HPF.ar(sig, 40) * 3;
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq * env1, \rq.kr(0.1));
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \combbass,
			\note, Pseq([
				0,3,
			],inf),
			\octave, 3,
			\dur, 1/4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		
	])
)).play;
);

(
Ndef(\zed, { arg freq=50, pan=0, amp=0.1;
	var sig;
	var pitchedInput, comb, dist, del;
	sig = 10.collect({ arg idx;
		var ifreq = freq * ( ( idx+1 ) );
		del = LFNoise1.kr(1/9)*1;
		pitchedInput = SinOsc.ar(ifreq + del + ( SinOsc.ar(freq) * ifreq * LFNoise1.kr(0.1).range(2.0,14.0) ));
		comb = CombL.ar(pitchedInput, 1, ifreq.reciprocal * LFNoise1.kr(1/2).range(1.0,1.01) , 0.3);
		dist = RLPF.ar(dist, ifreq * LFNoise1.kr(1.1).range(0.4,4.0), \rq.kr(0.5));
		dist = SoftClipAmp.ar(comb, 1* LFNoise1.kr(1/2).range(0.0,1.0)) * 0.5;
	});
	sig = HPF.ar(sig, 40) * 3;
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);

	//sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(1), \damp.kr(0.4));
}).play;
);


/////////////


(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = LFSaw.ar(freq * ( SinOsc.kr(4) * 1 + 1 ));
	sig = RLPF.ar(sig, LFNoise1.kr(1/2).range(100.0,4001.0), \rq.kr(0.1));
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

60.midicps/3
(
Ndef(\zed, { arg freq=87.2, pan=0, amp=0.1;
	var sig;
	freq = Duty.kr(1/~t, 0, Dseq([
		0,0,0,0, -1,-1,-1,-5,
	],inf)).midiratio.lag2ud(0.2,2) * freq;
	sig = LFSaw.ar(freq * [1,1.01] );
	sig = RLPF.ar(sig, LFNoise1.kr(1/2).exprange(200.0,4001.0) * ( SinOsc.kr(4*~t * [1,1.01]) * 0.3 + 1 ), \rq.kr(0.1)) * 0.3;
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

36.midicps
(
Ndef(\zed, { arg freq=(65.4), pan=0, amp=0.1;
	var sig;
	freq = Duty.kr(1/~t, 0, Dseq([
		0,0,0,0, -1,-1,-1,-5,
	],inf)).midiratio.lag2ud(0.2,2) * freq;
	sig = LFSaw.ar(freq * [1,1.01] * ( Saw.ar(freq+[0.01,0.02]) * 0.81 + 1 ) );
	sig = RLPF.ar(sig, LFNoise1.kr(1/2).exprange(200.0,4001.0) * ( SinOsc.ar(freq - 0.01 * [1,1.01]) * LFNoise1.kr(0.1).range(0,0.71) + 1 ), \rq.kr(0.1)) * 0.3;
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
SynthDef(\bassvibrato, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	freq.poll;
	freq = Duty.kr(1/~t, 0, Dseq([
		0,0,0,0, -1,-1,-1,-5,
	],inf)).midiratio.lag2ud(0.2,2) * freq;
	sig = LFSaw.ar(freq * [1,1.01] );
	sig = RLPF.ar(sig, LFNoise1.kr(1/2).exprange(200.0,4001.0) * ( SinOsc.kr(4*~t * [1,1.01]) * 0.3 + 1 ), \rq.kr(0.1));
	sig = Pan2.ar(sig, pan, amp);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
);


(
SynthDef(\jmcpiano, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env;
	var delayTime, detune, pitch;
	var strike = \strike.tr(1);
	//strike = K2A.ar(strike);
	strike = Trig.ar(strike, 1/Server.default.sampleRate)*0.1;
	//strike = Impulse.ar(0.1+0.4.rand, 2pi.rand, 0.1); // random period for each key
	env = Decay2.ar(strike, 0.008, 0.04);
	detune = [-0.05, 0, 0.04].midiratio;
	delayTime = 1 / ( freq * detune ).poll;
	sig = LFNoise2.ar(3000!detune.size, env);
	sig = CombL.ar(sig, delayTime, delayTime, \decay.kr(6));
	sig.debug("sig");
	sig = sig.mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * 4*2*4*2;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);



(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(
			 \bassvibrato,
			 \note, Pseq([
			 	0,
			 ],inf),
			 \octave, 3,
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \jmcpiano,
			\note, Pseq([
				8,9,12,\r,
			],inf),
			\dur, Pseq([
				1/8,1/2,1,1/2+(3/8)+1+(1/2),
			],inf),
			\amp, 0.1,
			//\isRest, true,
		),
		Pbind(
			\instrument, \jmcpiano,
			\note, Pseq([
				8,9,12,\r,
			],inf),
			\dur, Pseq([
				1/8,1/2,1,1/2+(3/8)+1+(1/2),
			],inf),
			\amp, 0.1,
			//\isRest, true,
		),
		Pbind(
			\instrument, \jmcpiano,
			\note, Pseq([
				12,11,
			],inf).stutter(8*3),
			\octave, 4,
			\dur, Pseq([
				1/2/3
			],inf),
			\isRest, Pseq([
				1,0,0.1,
				0.6,0,0.1,
			],inf).coin.not,
			\amp, 0.1,
			//\isRest, true,
		),
	])
)).play;
);


///////////

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var del;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var ofreq;
	freq = Duty.kr(1/~t, 0, Dseq([
		1,3,Dwhite(0,12,2),
	],inf)).midiratio * freq;
	ofreq = freq;
	del = LFNoise1.kr(1/2).range(0.0,1.0)*2;
	lfo1 = LFNoise1.kr(1/2).exprange(0.0001,0.004);
	sig = LFSaw.ar(freq * ((0..7)/7 - 0.5 * \fspread.kr(1) * lfo1 + 1) + del).mean;
	sig = CombL.ar(sig, 0.1, (ofreq*[1,2]).reciprocal, 3.1)*0.02;
	sig = Pan2.ar(sig, pan, amp);
}).play;
);


(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var factors = (0..12).midiratio;
	factors = [0,3,7,9,12].midiratio;
	sig = SinOsc.ar(freq * factors, mul: Pulse.kr(factors.scramble).range(0.0,1.0)).mean;
	sig = Pan2.ar(sig, pan, amp);
}).play;
);



/////////////

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = 7.collect({ arg idx;
		sig = Impulse.ar(1+idx);
		sig = Decay2.ar(sig, 0.01, 0.1 * LFNoise1.kr(1/2).exprange(0.0001,3.0))*WhiteNoise.ar(1);
		sig = Ringz.ar(sig, freq * idx.midiratio * LFNoise1.kr(1/2).range(1.0,1.01));
	});
	//sig = CombL.ar(sig, 0.1, 1/freq * LFNoise1.kr(1/2).range(0.1,1.0),4) / 2;
	//sig = CombL.ar(sig, 0.1, Rand(0.1,0.3!7),4) / 2;
	sig = sig.mean;
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = 7.collect({ arg idx;
		sig = Impulse.ar(0.1+( idx/4 ));
		sig = Decay2.ar(sig, 0.01, 0.1 * LFNoise1.kr(1/2).exprange(0.0001,3.0))*WhiteNoise.ar(1);
		sig = Ringz.ar(sig, freq * idx * LFNoise1.kr(1/2).range(1.0,1.01));
	});
	//sig = CombL.ar(sig, 0.1, 1/freq * LFNoise1.kr(1/2).range(0.1,1.0),4) / 2;
	//sig = CombL.ar(sig, 0.1, Rand(0.1,0.3!7),4) / 2;
	sig = sig.mean;
	sig = FreeVerb.ar(sig, mix:0.5, room:1, damp:0.5);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = [0,3,7,9,12,15,19].midiratio.collect({ arg fac, idx;
		sig = Impulse.ar(0.1+( idx/4 ));
		sig = Decay2.ar(sig, 0.01, 0.1 * LFNoise1.kr(1/2).exprange(0.0001,3.0))*WhiteNoise.ar(1);
		sig = Ringz.ar(sig, freq * fac * LFNoise1.kr(1/2).range(1.0,1.01));
	});
	//sig = CombL.ar(sig, 0.1, 1/freq * LFNoise1.kr(1/2).range(0.1,1.0),4) / 2;
	//sig = CombL.ar(sig, 0.1, Rand(0.1,0.3!7),4) / 2;
	sig = sig.mean;
	sig = FreeVerb.ar(sig, mix:0.5, room:1, damp:0.5);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\zed, { arg freq=400, pan=0, amp=0.1;
	var sig;
	var num=7;
	sig = [0,4,7,11,12,16,19].midiratio.collect({ arg fac, idx;
		sig = Impulse.ar(fac/2);
		sig = Decay2.ar(sig, 0.01, 0.1 * LFNoise1.kr(1/2).exprange(0.0001,3.0))*WhiteNoise.ar(1)*LFSaw.ar(freq);
		sig = Ringz.ar(sig, freq * fac * LFNoise1.kr(1/2).range(1.0,1.01)) * ( SinOsc.ar(freq * fac) * LFNoise1.kr(0.1).range(0.0,1.0) + 1 );
	});
	//sig = CombL.ar(sig, 0.1, 1/freq * LFNoise1.kr(1/2).range(0.1,1.0),4) / 2;
	sig = CombL.ar(sig, 0.3, Rand(0.1,0.3!num) * LFNoise1.kr(0.1!num).range(0.0,1.0),0.4) ;
	sig = sig.mean * 2;
	sig = FreeVerb.ar(sig, mix:0.5, room:1, damp:0.5);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\zed, { arg freq=400, pan=0, amp=0.1;
	var sig;
	var num=7;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,1,4,1,10],[9,2.1,3.8,3]), 1);
	sig = [0,4,7,11,12,16,19].midiratio.collect({ arg fac, idx;
		sig = Impulse.ar(fac/2 * env1);
		sig = Decay2.ar(sig, 0.01, 0.1 * LFNoise1.kr(1/2).exprange(0.0001,3.0))*WhiteNoise.ar(1)*LFSaw.ar(freq);
		sig = Ringz.ar(sig, freq / env1 * fac * LFNoise1.kr(1/2).range(1.0,1.01)) * ( SinOsc.ar(freq * fac) * LFNoise1.kr(0.1).range(0.0,1.0) + 1 );
	});
	//sig = CombL.ar(sig, 0.1, 1/freq * LFNoise1.kr(1/2).range(0.1,1.0),4) / 2;
	sig = CombL.ar(sig, 0.3, Rand(0.1,0.3!num) * LFNoise1.kr(0.1!num).range(0.0,1.0),0.4) ;
	sig = sig.mean * 2;
	sig = FreeVerb.ar(sig, mix:0.5, room:1, damp:0.5);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\zed, { arg freq=400, pan=0, amp=0.1;
	var sig;
	var num=7;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,1,4,1,10],[9,2.1,3.8,3]), 1);
	sig = [0,4,7,11,12,16,19].midiratio.collect({ arg fac, idx;
		sig = Impulse.ar(fac/2 * env1);
		sig = Decay2.ar(sig, 0.01, 0.1 * LFNoise1.kr(1/2).exprange(0.0001,3.0))*WhiteNoise.ar(1)*LFSaw.ar(freq);
		sig = Ringz.ar(sig, freq * fac * LFNoise1.kr(1/2).range(1.0,1.01)) * ( SinOsc.ar(freq * fac / env1) * LFNoise1.kr(0.1).range(0.0,1.0) + 1 );
	});
	//sig = CombL.ar(sig, 0.1, 1/freq * LFNoise1.kr(1/2).range(0.1,1.0),4) / 2;
	sig = CombL.ar(sig, 0.3, Rand(0.1,0.3!num) * LFNoise1.kr(0.1!num).range(0.0,1.0),0.4) ;
	sig = sig.mean * 2;
	sig = FreeVerb.ar(sig, mix:0.5, room:1, damp:0.5);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\zed, { arg freq=400, pan=0, amp=0.1;
	var sig;
	var num=7;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,1,4,1,10],[9,2.1,3.8,3]), 1);
	sig = [0,4,7,11,12,16,19].midiratio.collect({ arg fac, idx;
		sig = Impulse.ar(fac/2 * env1);
		sig = Decay2.ar(sig, 0.01, 0.1 * LFNoise1.kr(1/2).exprange(0.0001,3.0))*WhiteNoise.ar(1)*LFSaw.ar(freq);
		sig = Ringz.ar(sig, freq * fac * LFNoise1.kr(1/2).range(1.0,1.01)) * ( SinOsc.ar(freq * fac) * LFNoise1.kr(0.1).range(0.0,1.0) + 1 );
	});
	//sig = CombL.ar(sig, 0.1, 1/freq * LFNoise1.kr(1/2).range(0.1,1.0),4) / 2;
	sig = CombL.ar(sig, 0.3, Rand(0.1,0.3!num) * LFNoise1.kr(0.1 * env1!num).range(0.01,1.0),0.4) ;
	sig = sig.mean * 2;
	sig = FreeVerb.ar(sig, mix:0.5, room:1, damp:0.5);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\zed, { arg freq=400, pan=0, amp=0.1;
	var sig;
	var num=7;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,1,4,1,10],[9,2.1,3.8,3]), 1);
	sig = [0,4,7,11,12,16,19].midiratio.collect({ arg fac, idx;
		sig = Impulse.ar(fac/2 / env1.sqrt);
		sig = Decay2.ar(sig, 0.01, 0.1 * LFNoise1.kr(1/2).exprange(0.0001,3.0))*WhiteNoise.ar(1)*LFSaw.ar(freq);
		sig = Ringz.ar(sig, freq * fac * LFNoise1.kr(1/2).range(1.0,1.01), env1/4) * ( SinOsc.ar(freq * fac) * LFNoise1.kr(0.1).range(0.0,1.0) + 1 );
		sig = FreqShift.ar(sig, -1 * env1**2 * fac);
	});
	//sig = CombL.ar(sig, 0.1, 1/freq * LFNoise1.kr(1/2).range(0.1,1.0),4) / 2;
	//sig = CombL.ar(sig, 0.3, Rand(0.1,0.3!num) * LFNoise1.kr(0.1 * env1!num).range(0.01,1.0),0.4) ;
	sig = sig.mean * 2;
	sig = FreeVerb.ar(sig, mix:0.5, room:1, damp:0.5);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\zed, { arg freq=400, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var num=7;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,1,4,1,10],[9,2.1,3.8,3]), 1);
	env2 = EnvGen.kr(Env([1,1,4,1,10],[9,2.1,3.8,3]), 1);
	env3 = EnvGen.kr(Env([0,0,1,0,1],[9,2.1,3.8,3]), 1);
	sig = [0,4,7,11,12,16,19].midiratio.collect({ arg fac, idx;
		sig = Impulse.ar(fac/2 );
		sig = Decay2.ar(sig, 0.01, 0.1 * LFNoise1.kr(1/2).exprange(0.0001,3.0))*WhiteNoise.ar(1)*LFSaw.ar(freq);
		sig = Ringz.ar(sig, freq * fac * LFNoise1.kr(1/2).range(1.0,1.01), env1/4) * ( SinOsc.ar(freq * fac / env1) * LFNoise1.kr(0.1).range(0.0,1.0) + 1 );
		sig1 = SinOsc.ar(freq*fac * ( SinOsc.ar(env2*10) * env3 + 1 )) * LFSaw.ar(1/4*fac*env2).range(0,0.4) * Amplitude.kr(sig).lag2ud(0.1,2);
		sig = FreqShift.ar(sig, -1 * env3 * fac * freq) + sig1;
	});
	//sig = CombL.ar(sig, 0.1, 1/freq * LFNoise1.kr(1/2).range(0.1,1.0),4) / 2;
	//sig = CombL.ar(sig, 0.3, Rand(0.1,0.3!num) * LFNoise1.kr(0.1 * env1!num).range(0.01,1.0),0.4) ;
	//sig = Limiter.ar(sig);
	sig = sig.mean * 4;
	sig = FreeVerb.ar(sig, mix:0.5, room:1, damp:0.5);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\zed, { arg freq=400, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var num=7;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var root = 10.rand - 5;
	var harm = [0,4,7,11,12,16,19];
	env1 = EnvGen.kr(Env([1,1,4,1,10].scramble,[9,2.1,3.8,3].scramble*2).circle, 1);
	env2 = EnvGen.kr(Env([1,1,4,1,10],[1,3.1,7.8,5]).circle, 1);
	env3 = EnvGen.kr(Env([0,0,1,0,1],[9,4.1,3.8,3]).circle, 1);
	sig = ( harm+root ).midiratio.collect({ arg fac, idx;
		sig = Impulse.ar(fac.postln*2);
		sig = Decay2.ar(sig, 0.01, 0.1 * LFNoise1.kr(1/2).exprange(0.01,8.0))*PinkNoise.ar(1);
		sig = Ringz.ar(sig, freq * fac * LFNoise1.kr(1/2).range(1.0,1.01), 1/env1/4) * ( SinOsc.ar(freq * fac / env1) * LFNoise1.kr(0.1).range(0.0,0.1) + 1 );
		sig = Ringz.ar(sig, freq / 2 * fac * LFNoise1.kr(1/8).range(1.0,1.01), 1/env2/4) * ( SinOsc.ar(freq * fac / env2) * LFNoise1.kr(0.1).range(0.0,0.1) + 1 ) + sig/14;
		//sig1 = SinOsc.ar(freq*fac * ( SinOsc.ar(env2*10) * env3 + 1 )) * LFSaw.ar(1/4*fac*env2).range(0,0.4) * Amplitude.kr(sig).lag2ud(0.1,2);
	});
	sig = BPF.ar(sig, LFNoise1.kr([ 1/2!2 ]).range(70,12000.0), 0.4 * LFNoise1.kr([ 1/2!2 ]).range(0.5,2.0)).flop.sum;
	sig.debug("sig");
	sig = sig.mean * 4;
	sig = CombL.ar(sig, 0.1, 1/( freq * Duty.kr(1/~t, 0, Dseq([
		Drand(( harm+root ).midiratio)
	],inf)) ),0.1)/ 2 + sig ;
	//sig = CombL.ar(sig, 0.3, Rand(0.1,0.3!num) * LFNoise1.kr(0.1 * env1!num).range(0.01,1.0),0.4) ;
	//sig = Limiter.ar(sig);
	sig = FreeVerb.ar(sig, mix:0.5, room:1, damp:0.5);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\zed, { arg freq=400, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var num=7;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var root = 10.rand - 5;
	var harm = [
		[0,3,7,10, 12,15,19],
		[0,4,7,11, 12,16,19],
		[0,4,7,9, 12,16,19],
		[0,3,7,9, 12,15,19],
	].choose;
	env1 = EnvGen.kr(Env([1,1,4,1,10].scramble,[9,2.1,3.8,3].scramble*2).circle, 1);
	env2 = EnvGen.kr(Env([1,1,4,1,10],[1,3.1,7.8,5]).circle, 1);
	env3 = EnvGen.kr(Env([0,0,1,0,1],[9,4.1,3.8,3]).circle, 1);
	sig = ( harm+root ).midiratio.collect({ arg fac, idx;
		sig = Impulse.ar(fac.postln*2);
		sig = Decay2.ar(sig, 0.01, 0.1 * LFNoise1.kr(1/2).exprange(0.01,8.0))*PinkNoise.ar(1);
		sig = Ringz.ar(sig, freq * fac * LFNoise1.kr(1/2).range(1.0,1.01), 1/env1/4) * ( SinOsc.ar(freq * fac / env1) * LFNoise1.kr(0.1).range(0.0,0.1) + 1 );
		sig = Ringz.ar(sig, freq / 2 * fac * LFNoise1.kr(1/8).range(1.0,1.01), 1/env2/4) * ( SinOsc.ar(freq * fac / env2) * LFNoise1.kr(0.1).range(0.0,0.1) + 1 ) + sig/14;
		//sig1 = SinOsc.ar(freq*fac * ( SinOsc.ar(env2*10) * env3 + 1 )) * LFSaw.ar(1/4*fac*env2).range(0,0.4) * Amplitude.kr(sig).lag2ud(0.1,2);
	});
	sig = BPF.ar(sig, LFNoise1.kr([ 1/2!2 ]).range(70,12000.0), 0.4 * LFNoise1.kr([ 1/2!2 ]).range(0.8,2.0)).flop.sum;
	sig.debug("sig");
	sig = sig.mean * 4;
	sig = CombL.ar(sig, 0.1, 1/( freq * Duty.kr(1/~t * [1,1.1], 0, Dseq([
		Drand(( harm+root ).midiratio)
	],inf)).lag2ud(0.01,0.2 * LFNoise1.kr(1/2).range(0.5,2.0)) ),0.4)/ 2 + sig ;
	//sig = CombL.ar(sig, 0.3, Rand(0.1,0.3!num) * LFNoise1.kr(0.1 * env1!num).range(0.01,1.0),0.4) ;
	sig = Limiter.ar(sig, 0.5, 0.001);
	//sig = FreeVerb.ar(sig, mix:0.5, room:1, damp:0.5);
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(1), \damp.kr(0.4));
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
}).play;
);

///////////////


(
Ndef(\zed, { arg freq=70, pan=0, amp=0.1;
	var sig;
	var harm = [0,3,7].midiratio *.x [1,2,3,4,5,6];
	sig = harm.collect({ arg fac;
		sig = LFSaw.ar(freq * fac * [1,1 + LFNoise1.kr(1/8).exprange(0.00001,0.1)] * ( SinOsc.ar(freq*harm.choose) * LFNoise1.kr(1/2).range(0.0,1.0) + 1 )).fold2( LFNoise1.kr(1/2!2).range(0.0,1.0) );
		RLPF.ar(sig, \lpfr.kr(1.1) * LFNoise1.kr(1/4).range(0.5,2.0) * freq * fac, \rq.kr(0.5) * LFNoise1.kr(1/8).range(0.1,1.7));
	}).mean * 4;
	sig.debug("sig");
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
}).play;
);

Ndef(\zed).play(BusDef(\sendbus1).index, 2)

/////////////////

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var num=40;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,1,4],[4.1,3.8]), 1);
	env2 = EnvGen.kr(Env([0.051,1,20],[4.1,3.8]), 1);
	env3 = EnvGen.kr(Env([1,1,0.001],[5.1,3.8],\exp), 1);
	env4 = EnvGen.kr(Env([1,1,1.4],[3.1,3.8]), 1);
	sig = HPF.ar(Ringz.ar(WhiteNoise.ar(0.1), {exprand(100, 20000)}.dup(num) * env4).mean, 90);
	sig = BPF.ar(sig, LFNoise1.kr(0.1!3).range(200,2000) * env1, 0.1) * 10.3 * env3;
	sig = HPF.ar(sig, env1*1000);
	sig = sig.mean;
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
}).play;
);
