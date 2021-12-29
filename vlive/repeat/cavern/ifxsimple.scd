
(
Spec.add(\wet, \unipolar);
Spec.add(\mix, \unipolar);
Spec.add(\gain, \unipolar);

SynthDef(\ifx_greyhole, { arg out=0, gate=1;
	var sig;
	var in = In.ar(out, 2); 
	sig = in;
	sig = Greyhole.ar(sig, \delay.kr(2), \damp.kr(0), \size.kr(1), \diff.kr(0.707), \fb.kr(0.9), \modDepth.kr(0.1), \modFreq.kr(2));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = sig * \gain.kr(1);
	XOut.ar(out, \wet.kr(0), sig* \gain.kr(1));
	//XOut.ar(out, \wet.kr(0), [in,sig]);
}).add;
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
)
