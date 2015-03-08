
(
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var freq2;
	//var sig1, sig2;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var igate = Trig.kr( \itrig.tr(1), \isustain.kr(1) );

	freq = 100*4;
	freq = Duty.kr(1/~t, 0, Dseq([
		12,12,0,5,
	],inf)).midiratio.lag(1.4) * freq;
	freq2 = (-200!8).rand;
	env1 = EnvGen.kr(\env1.kr(Env([1,10,10,1],[0.1,0.3,0.4])), igate);
	env1.poll;
	//env1 = 1;
	freq = freq * ( 1+ (0.01 * env1 * SinOsc.ar(freq / (1+ (0.1* (1..8) ) )).range(0,1) ) );
	lfo1 = SinOsc.ar(100) * 10;
	sig = LFSaw.ar(freq * ( 1 + lfo1));
	sig = CombL.ar(sig, 1/44, 1/DelayL.kr(freq,0.1,0.1 * SinOsc.ar(448).range(2,0.4)) * [1/2,2],1)/8;
	sig = CombL.ar(sig, 1/44, 1/freq * 2 * ((1..8).rand*0.21+1), 1);
	sig = sig / 2;
	sig = sig * EnvGen.kr(\iadsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), igate);
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size, amp).mean;
	sig;
});

Ndef(~name+++\fx).put(1, \set -> ( Pdef(\bla, Pbind()) <> Pbind(
//Ndef(~name+++\fx).put(1, \set -> (  Pbind(
	\itrig, Pseq([
		1,0,1,1,
		1,0,0,1,
	],inf),
	\isustain, 0.21,
	\iadsr, Plazy({ arg ev;
		Pseq([
			Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.53) ],
			],4),
			Pseq([
				[ Env.adsr(0.01,0.1,0.8,1.53) ],
			],4),
		],1);
	}).loop,
	//\env1, [ Env([1,90,1],[0.1,0.4]) ],
	\dur, 1/2,
)) );
)

// END

"debug".debug("kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk");
Param(Ndef(~name+++\fx), \env1, XEnvSpec(\freq!3)).edit
XEnvSpec(\freq!3).times

Ndef(~name+++\fx).unset(\env1)
Ndef(~name+++\fx).clear
Param(Ndef(~name+++\fx), \env1, XEnvSpec(\freq!3)).edit
Pdef(\bla).clear
~p = Param(Pdef(\bla), \env1, XEnvSpec( ControlSpec(1,100,\exp,0,1)!4))
~p.set(Env([1,80,40,1],[0.1,0.3,0.4]))
~p.edit
~p.get.asCompileString
~p.get.asCompileString
