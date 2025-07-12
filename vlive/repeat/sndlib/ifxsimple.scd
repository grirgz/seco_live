
(
Spec.add(\wet, \unipolar);
Spec.add(\mix, \unipolar);
Spec.add(\gain, \unipolar);

SynthDef(\ifx_greyhole, { arg out=0, gate=1;
	var sig;
	var in = In.ar(out, 2); 
	var env;
	sig = in;
	sig = sig * \ingain.kr(1);
	sig = Greyhole.ar(sig, \delay.kr(2), \damp.kr(0), \size.kr(1), \diff.kr(0.707), \fb.kr(0.9), \modDepth.kr(0.1), \modFreq.kr(2));
	env = EnvGen.ar(\adsr.kr( Env.adsr(0.1, 0, 1, 0.1) ), gate, doneAction:2);
	sig = sig + (in * \dry.kr(1));
	sig = sig * env;
	//sig = sig * \gain.kr(1);
	XOut.ar(out, \wet.kr(0) * env, sig* \gain.kr(1));
	//XOut.ar(out, \wet.kr(0), [in,sig]);
}, metadata:(specs:(
	ingain: \unipolar.asSpec,
))).add;
TagSpecDef(\SynthDef_InsertFx).addUnique(\ifx_greyhole);

SynthDef(\ifx_greyhole_tail, { arg out=0, gate=1;
	var sig;
	var in = In.ar(out, 2); 
	var env, envtail;
	sig = in;
	sig = sig * \ingain.kr(1);
	env = EnvGen.ar(\adsr.kr( Env.adsr(0.1, 0, 1, 0.1) ), gate, doneAction:0);
	sig = sig * env;
	sig = Greyhole.ar(sig, \delay.kr(2), \damp.kr(0), \size.kr(1), \diff.kr(0.707), \fb.kr(0.9), \modDepth.kr(0.1), \modFreq.kr(2));
	DetectSilence.ar(sig, 0.005, doneAction:2);
	envtail = EnvGen.ar(Env([0,1],[\attack.kr(0.1)]), gate, doneAction:0);
	sig = sig + (in * \dry.kr(1));
	//sig = sig * \gain.kr(1);
	XOut.ar(out, \wet.kr(0) * envtail, sig* \gain.kr(1));
	//XOut.ar(out, \wet.kr(0), [in,sig]);
}, metadata:(specs:(
	ingain: \unipolar.asSpec,
))).add;
TagSpecDef(\SynthDef_InsertFx).addUnique(\ifx_greyhole_tail);

SynthDef(\ifx_freeverb2, { arg out=0, gate=1;
	var sig;
	var in = In.ar(out, 2); 
	var env;
	sig = in;
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(1), \damp.kr(0.4));
	env = EnvGen.ar(\adsr.kr( Env.adsr(0.1, 0, 1, 0.1) ), gate, doneAction:2);
	sig = sig + (in * \dry.kr(1));
	sig = sig * env;
	//sig = sig * \gain.kr(1);
	XOut.ar(out, \wet.kr(0) * env, sig* \gain.kr(1));
}).add;
TagSpecDef(\SynthDef_InsertFx).addUnique(\ifx_freeverb2);

SynthDef(\ifx_freeverb2_tail, { arg out=0, gate=1;
	var sig;
	var in = In.ar(out, 2); 
	var env;
	sig = in;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:0);
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(1), \damp.kr(0.4));
	env = EnvGen.ar(Env([0,1],[\attack.kr(0.1)]), gate, doneAction:0);
	DetectSilence.ar(sig, 0.005, doneAction:2);
	sig = sig + (in * \dry.kr(1));
	//sig = sig * \gain.kr(1);
	XOut.ar(out, \wet.kr(0) * env, sig* \gain.kr(1));
}).add;
TagSpecDef(\SynthDef_InsertFx).addUnique(\ifx_freeverb2_tail);

SynthDef(\ifx_limiter, { arg out=0, gate=1;
	var sig;
	var in = In.ar(out, 2); 
	var env;
	sig = in;
	sig = Limiter.ar(sig, \level.kr(1), \limdur.kr(0.01));
	sig = SelectX.ar(\mix.kr(1), [in, sig]);
	env = EnvGen.ar(\adsr.kr( Env.adsr(0.1, 0, 1, 0.1) ), gate, doneAction:2);
	sig = sig * env;
	sig = sig * \gain.kr(1);
	XOut.ar(out, \wet.kr(0) * env, sig);
}).add;
TagSpecDef(\SynthDef_InsertFx).addUnique(\ifx_limiter);

SynthDef(\ifx_send, { arg out=0, gate=1;
	var sig;
	var in = In.ar(out, 2); 
	var env;
	sig = in;
	Out.ar(\sendbus.kr(BusDef(\null, \audio, 2)), in * \send.kr(0));
	env = EnvGen.ar(\adsr.kr( Env.adsr(0.1, 0, 1, 0.1) ), gate, doneAction:2);
	sig = sig * env;
	sig = sig * \gain.kr(1);
	XOut.ar(out, \wet.kr(0) * env, sig);
}, metadata:(specs:(
	//sendbus: ParamBusSpec(),
	sendbus: TagSpecDef(\BusDef),
	send: \unipolar,
))).add;
TagSpecDef(\SynthDef_InsertFx).addUnique(\ifx_send);

SynthDef(\ifx_simplecomp, { arg out=0, gate=1;
	var sig;
	var in = In.ar(out, 2); 
	var env;
	//var sidein = InFeedback.ar(\sideinbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = sig * \pregain.kr(1);
	sig = Compander.ar(sig, sig, \cpt.kr(0.4), \cpbelow.kr(1.001), \cpabove.kr(0.9), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	sig = SelectX.ar(\mix.kr(1), [in, sig]);
	sig = sig * \gain.kr(1);
	env = EnvGen.ar(\adsr.kr( Env.adsr(0.1, 0, 1, 0.1) ), gate, doneAction:2);
	sig = sig * env;
	XOut.ar(out, \wet.kr(0) * env, sig);
}).add;
TagSpecDef(\SynthDef_InsertFx).addUnique(\ifx_simplecomp);


SynthDef(\ifx_fb, { arg out=0, gate=1;
	var sig;
	var in = In.ar(out, 2); 
	var env;
	//var sidein = InFeedback.ar(\sideinbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = sig * \gain.kr(1);
	env = EnvGen.ar(\adsr.kr( Env.adsr(0.1, 0, 1, 0.1) ), gate, doneAction:2);
	sig = sig * env;
	Out.ar(\fbbus.kr, sig * \fb.kr(0.9));
	XOut.ar(out, \wet.kr(0) * env, sig);
}, metadata:(specs:(
	fbbus: ParamBusSpec(),
))).add;
TagSpecDef(\SynthDef_InsertFx).addUnique(\ifx_fb);

SynthDef(\ifx_stutter, { arg out = 0, gate=1, time= 0.1, mix=1, rate=1;
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
	var env;
	reset = Changed.kr(mix);
	sig = in;
	sig = stutter.(sig, reset, time, rate, \maxdelay.ir(10));
	sig = SelectX.ar(mix, [in, sig]);
	env = EnvGen.ar(\adsr.kr( Env.adsr(0.1, 0, 1, 0.1) ), gate, doneAction:2);
	sig = sig * env;
	sig = sig * \gain.kr(1);
	XOut.ar(out, \wet.kr(0) * env, sig);
}).add;
TagSpecDef(\SynthDef_InsertFx).addUnique(\ifx_stutter);

SynthDef(\ifx_out, { arg out = 0, inbus, gate=1;
	var sig;
	var in = In.ar(inbus, 2); 
	sig = in;
	sig = sig * EnvGen.ar(\adsr.kr( Env.adsr(0.01,0.1,0.8,0.1) ),gate,doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
TagSpecDef(\SynthDef_InsertFx).addUnique(\ifx_out);

SynthDef(\ifx_chorus, { arg out=0, gate=1;
	var sig;
	var in = In.ar(out, 2); 
	var env;
	sig = LocalIn.ar(2) * \fb.kr(0.4);
	sig = sig + in;
	sig = DelayC.ar(sig, \maxdelay.ir(0.2), \delay.kr(0.0101) * ((0..7)/7 - 0.5 * \diff.kr(0.4001) + 1) * ( SinOsc.ar(\modfreq.kr(8.1)) * \modamp.kr(0.48) + 1 )).mean;
	//sig = LPF.ar(sig, \dif.kr(7500));
	LocalOut.ar(sig);

	sig = LPF.ar(sig, \lpf.kr(15000));
	sig = HPF.ar(sig, \hpf.kr(50));
	sig = sig * \wetgain.kr(1);
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * \gain.kr(1);
	env = EnvGen.ar(\adsr.kr( Env.adsr(0.1, 0, 1, 0.1) ), gate, doneAction:2);
	sig = sig * env;
	XOut.ar(out, \wet.kr(0) * env, sig);
}).add;
TagSpecDef(\SynthDef_InsertFx).addUnique(\ifx_chorus);

SynthDef(\ifx_rlpf, { arg out=0, gate=1;
	var sig;
	var in = In.ar(out, 2); 
	var env;
	sig = in;
	sig = RLPF.ar(sig, \lpf.kr(2301), \rq.kr(0.5));
	env = EnvGen.ar(\adsr.kr( Env.adsr(0.1, 0, 1, 0.1) ), gate, doneAction:2);
	sig = sig * env;
	sig = SelectX.ar(\mix.kr(1), [in, sig]);
	sig = sig * \gain.kr(1);
	XOut.ar(out, \wet.kr(0) * env, sig);
}).add;
TagSpecDef(\SynthDef_InsertFx).addUnique(\ifx_rlpf);

SynthDef(\ifx_rhpf, { arg out=0, gate=1;
	var sig;
	var in = In.ar(out, 2); 
	var env;
	sig = in;
	sig = RHPF.ar(sig, \hpf.kr(2301), \rq.kr(0.5));
	env = EnvGen.ar(\adsr.kr( Env.adsr(0.1, 0, 1, 0.1) ), gate, doneAction:2);
	sig = sig * env;
	sig = SelectX.ar(\mix.kr(1), [in, sig]);
	sig = sig * \gain.kr(1);
	XOut.ar(out, \wet.kr(0) * env, sig);
}).add;
TagSpecDef(\SynthDef_InsertFx).addUnique(\ifx_rhpf);

SynthDef(\ifx_echo, { arg out=0, gate=1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env;
	var in = In.ar(out, 2); 
	sig = in;
	sig = CombC.ar(sig, 1, \delay.kr(1),\decay.kr(1));
	sig1 = sig;
	sig1 = LPF.ar(sig1, \lpf.kr(19000));
	sig1 = HPF.ar(sig1, \hpf.kr(50));
	sig = SelectX.ar(\filtermix.kr(0.5), [sig, sig1]);
	sig = sig + (in * \dry.kr(1));
	sig = sig * \gain.kr(1);
	env = EnvGen.ar(\adsr.kr( Env.adsr(0.01,0.1,0.8,0.1) ),gate,doneAction:2);
	sig = sig * env;
	XOut.ar(out, \wet.kr(0) * env, sig);
}).add;
TagSpecDef(\SynthDef_InsertFx).addUnique(\ifx_echo);

SynthDef(\ifx_echo_tail, { arg out=0, gate=1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env, envtail;
	var in = In.ar(out, 2); 
	sig = in;
	sig = sig * \ingain.kr(1);
	env = EnvGen.ar(\adsr.kr( Env.adsr(0.01,0.1,0.8,0.1) ),gate,doneAction:0);
	sig = sig * env;
	sig = CombC.ar(sig, 1, \delay.kr(1),\decay.kr(1));
	sig1 = sig;
	sig1 = LPF.ar(sig1, \lpf.kr(19000));
	sig1 = HPF.ar(sig1, \hpf.kr(50));
	sig = SelectX.ar(\filtermix.kr(0.5), [sig, sig1]);
	DetectSilence.ar(sig, 0.005, doneAction:2);
	envtail = EnvGen.ar(Env([0,1],[\attack.kr(0.1)]), gate, doneAction:0);
	sig = sig + (in * \dry.kr(1));
	sig = sig * envtail;
	sig = sig * \gain.kr(1);
	XOut.ar(out, \wet.kr(0) * envtail, sig);
}, metadata:(specs:(
	ingain: \unipolar,
))).add;
TagSpecDef(\SynthDef_InsertFx).addUnique(\ifx_echo_tail);

SynthDef(\ifx_infeedback, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var env;
	sig = in;
	env = EnvGen.ar(\adsr.kr( Env.adsr(0.1, 0, 1, 0.1) ), gate, doneAction:2);
	sig = sig * env;
	sig = sig * \gain.kr(1);
	//XOut.ar(out, \wet.kr(1) * env, sig);
	Out.ar(out, sig);
}).add;
TagSpecDef(\SynthDef_InsertFx).addUnique(\ifx_infeedback);
)
