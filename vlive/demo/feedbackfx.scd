(
	TempoClock.default.tempo = 1;



Ndef(\fb).put(0, Pbind(
	\instrument, \zkick,
	\dur, 1,
	\amp, 0.1
)).play;

Ndef(\fb).put(1, \filter -> {  arg in, fb=0.1;
	var fbnode;
	var sig;

	fbnode = FbNode(2);
	sig = in + ( fb * fbnode );
	sig = DelayC.ar(sig, 0.01) + sig;
	fbnode.write(sig);
	sig = Limiter.ar(sig);
	sig;



});
)
Ndef(\fb).edit
Ndef(\fb).clear


(

SynthDef(\zkick, { |out=0, amp=0.1, pan=0, fratio=1.5, freqpan=0.01, spread=0.08, timeScale=1|
	var env0, env1, env1m, son;

	env0 = \env0.kr(Env.new([0, 1, 0.5, 0], [0.005, 0.16, 00.2], [-4, -2, -4]));
	env1 = \env1.kr(Env.new([110, 32, 29], [0.005, 0.29], [-4, -5]));
	
	env0 =  EnvGen.ar(env0, doneAction:2, timeScale:timeScale);
	env1 = EnvGen.ar(env1, timeScale:timeScale);
	env1m = env1.midicps;
	
	son = LFPulse.ar(env1m * freqpan, 0, 0.5, 1, -0.5);
	son = son + WhiteNoise.ar(1);
	son = LPF.ar(son, env1m*fratio);
	son = son + SinOsc.ar(env1m, 0.5);
	son = LPF.ar(son, \lpf.kr(2000));
	
	son = son * amp;
	son = son * env0 * 8;
	son = Pan2.ar(son, pan, amp);
	
	OffsetOut.ar(out, son);
}, metadata:(specs:(
	timeScale: ControlSpec(0.001,4,\lin, 0, 1),
))).add;

///// some input
Ndef(\fb).put(0, Pbind(
	\instrument, \zkick,
	\dur, Pseq([2,1,1],inf),
	\amp, 0.2
));

///// feedback fx
Ndef(\fb).put(1, \filter -> { arg in;

	var fbNode = FbNode(2); // 2 channels

	var sig = fbNode.delay; // read the feedback bus and delay the result. 

	// The delay time defaults to the max delay time, 0.0 s in this case.
	// Add the input to the feedback sig, then delay and distort it.

	sig = sig * \fb.kr(0.19) + in;
	5.do {
		sig = DelayC.ar(sig, 0.1,[0.1, 0.1 ].rand * \delay.kr(1)) + sig / 2;
	};
	sig = (sig * \distamp.kr(2)).tanh * \dpamp.kr(2);

	sig = Limiter.ar(sig);
	sig = LeakDC.ar(sig);

	fbNode.write(sig); // write the sig to the feedback buffer

	sig = Limiter.ar(sig) * \mamp.kr(0.3);
	sig;

});

Ndef(\fb).play;

///// some preset

Ndef(\fb).put(10, \pset ->
	Pbind(  
		'wet1', 1.0338460882146,
		'fb', 0.000260094365312,
		'delay', 0.002030823992397451,
		'distamp', 4471.929989888001,
		'dpamp', 0.99968123740614,
		'mamp', 0.13951978918987,
	).keep(1)
)
)

(
Ndef(\fb).put(10, \pset ->
	Pbind(  
        'wet1', 1.0338460882146,
        'fb', 0.0029638548712324,
        'delay', 0.0032442260791716,
        'distamp', 475.100221128656,
        'dpamp', 153.971313906943,
        'mamp', 0.13951978918987,
	).keep(1)
)
)
Ndef(\fb).asParamGroup.getPbindCompileString
