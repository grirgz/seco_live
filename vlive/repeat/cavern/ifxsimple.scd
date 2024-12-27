
(
Spec.add(\wet, \unipolar);
Spec.add(\mix, \unipolar);
Spec.add(\gain, \unipolar);

SynthDef(\ifx_greyhole, { arg out=0, gate=1;
	var sig;
	var in = In.ar(out, 2); 
	sig = in;
	sig = sig * \ingain.kr(1);
	sig = Greyhole.ar(sig, \delay.kr(2), \damp.kr(0), \size.kr(1), \diff.kr(0.707), \fb.kr(0.9), \modDepth.kr(0.1), \modFreq.kr(2));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = sig * \gain.kr(1);
	XOut.ar(out, \wet.kr(0), sig* \gain.kr(1));
	//XOut.ar(out, \wet.kr(0), [in,sig]);
}, metadata:(specs:(
	ingain: \unipolar.asSpec,
))).add;
TagSpecDef(\SynthDef_InsertFx).addUnique(\ifx_greyhole);

SynthDef(\ifx_freeverb2, { arg out=0, gate=1;
	var sig;
	var in = In.ar(out, 2); 
	sig = in;
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(1), \damp.kr(0.4));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = sig * \gain.kr(1);
	XOut.ar(out, \wet.kr(0), sig* \gain.kr(1));
	//XOut.ar(out, \wet.kr(0), [in,sig]);
}).add;
TagSpecDef(\SynthDef_InsertFx).addUnique(\ifx_freeverb2);

SynthDef(\ifx_limiter, { arg out=0, gate=1;
	var sig;
	var in = In.ar(out, 2); 
	sig = in;
	sig = Limiter.ar(sig, \level.kr(1), \limdur.kr(0.01));
	sig = SelectX.ar(\mix.kr(1), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.01)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	XOut.ar(out, \wet.kr(0), sig);
}).add;
TagSpecDef(\SynthDef_InsertFx).addUnique(\ifx_limiter);

SynthDef(\ifx_send, { arg out=0, gate=1;
	var sig;
	var in = In.ar(out, 2); 
	sig = in;
	Out.ar(\sendbus.kr(BusDef(\null, \audio, 2)), in * \send.kr(0));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.01)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	XOut.ar(out, \wet.kr(0), sig);
}, metadata:(specs:(
	//sendbus: ParamBusSpec(),
	sendbus: TagSpecDef(\BusDef),
	send: \unipolar,
))).add;
TagSpecDef(\SynthDef_InsertFx).addUnique(\ifx_send);

SynthDef(\ifx_simplecomp, { arg out=0, gate=1;
	var sig;
	var in = In.ar(out, 2); 
	//var sidein = InFeedback.ar(\sideinbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = sig * \pregain.kr(1);
	sig = Compander.ar(sig, sig, \cpt.kr(0.4), \cpbelow.kr(1.001), \cpabove.kr(0.9), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	sig = SelectX.ar(\mix.kr(1), [in, sig]);
	sig = sig * \gain.kr(1);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	XOut.ar(out, \wet.kr(0), sig);
}).add;
TagSpecDef(\SynthDef_InsertFx).addUnique(\ifx_simplecomp);


SynthDef(\ifx_fb, { arg out=0, gate=1;
	var sig;
	var in = In.ar(out, 2); 
	//var sidein = InFeedback.ar(\sideinbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = sig * \gain.kr(1);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	Out.ar(\fbbus.kr, sig * \fb.kr(0.9));
	XOut.ar(out, \wet.kr(0), sig);
}, metadata:(specs:(
	fbbus: ParamBusSpec(),
))).add;
TagSpecDef(\SynthDef_InsertFx).addUnique(\ifx_fb);

SynthDef(\ifx_stutter, { arg out = 0, time= 0.1, mix=0, rate=1;
	var stutter = { arg sig, reset, time, rate = 1.0, maxdelay = 10;
		var phase, fragment, del;
		phase = Sweep.ar(reset);
		fragment = { |ph| (ph - Delay1.ar(ph)) < 0 + Impulse.ar(0) }.value(phase / time % 1);
		del = Latch.ar(phase, fragment) + ((time - Sweep.ar(fragment)) * (rate - 1));
		DelayC.ar(sig, maxdelay, del);
	};
	var sig;
	var in = In.ar(out, 2); 
	var reset;
	reset = Changed.kr(mix);
	sig = in;
	sig = sig * SinOsc.ar(200);
	sig = stutter.(sig, reset, time, rate, \maxdelay.ir(10));
	sig = SelectX.ar(mix, [in, sig]);
	sig = sig * \gain.kr(1);
	XOut.ar(out, \wet.kr(0), sig);
}).add;
TagSpecDef(\SynthDef_InsertFx).addUnique(\ifx_stutter);

SynthDef(\ifx_out, { arg out = 0, inbus;
	var sig;
	var in = In.ar(inbus, 2); 
	sig = in;
	sig = sig * \gain.kr(1);
	XOut.ar(out, \wet.kr(1), sig);
}).add;
TagSpecDef(\SynthDef_InsertFx).addUnique(\ifx_out);
)
