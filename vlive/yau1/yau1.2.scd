(

Ndef(\a).set(\out,6,\filter,1,\freq,2000,\lag,0,\which,0,\freqlo,02.5,\freqhi,0.18,\level1,0,\level2,0.5,\level3,1,\level4,0,\level,0.1,\fblevel,0.02);
Ndef(\b).set(\out,6,\freqlo,8.8,\freqhi,1009.3,\level1,1,\level2,1,\level3,0,\level4,0.46,\level6,-0.28,\levelpulse,0.1,\level,1,\dis,10,\freq,2000);


Pdef(\y,(
	Pbind(
	\instrument, \hats,
	\out,2,
	//\pan,Prand([-1,1],inf),
	\dur, 1/8,
	\amp,0.0005,//*v[\level1].asMap,
		\fratio,Pseq((1..10),inf),	    \isRest,Pseq([Pseq([1,0.4,0,1,0.3],3),Pseq([0.1,0.4,0,0.1,0.3],1)],inf).coin.not,	    \rel,Pseq([Pgeom(0.1,1.01,32),Pgeom(0.1,-0.001,32).rotate,Pseq([0.075],64)],inf),
	\ctrl,Ndef(\name,{Mix.ar(LFSaw.kr(0.002,[9/5pi,3/5pi,12pi],0.001,0)).range(1,1)}),
)));
Pdef(\x,(
		Pbind(
			\instrument, \tom,
			\out,[0,1],
			\pan,Pwhite([-1,1],inf),//,Prand([-1,1],inf),
			\dur, 1,
			\amp,1,//*v[\level1].asMap,
			\freq, Pseq([ Pseq([100],16), Pseq([120],16)],inf)/30,
		\isRest,Pseq([1,0,0,0,1,1,0,0],inf).coin.not)
));
Pdef(\z,(

		Pbind(
			\instrument,Pseq([\kick],inf),
			\out,4,
			//\pan,Pwhite([-1,1],inf),
			\dur, 2,
		\freq,0,
		\fratio,0.5,
		\lfo,Place([Pseq([12],4),[Pseq([0.12],4),Pseq([-0.12],4)]],inf),
	    \amp,1,//*v[\level1].asMap,
		  //  \fratio,Pseq([0.2],inf),
		\isRest,Pseq([0,1],inf).coin.not
		)
));



Pdef(\w,(
		Pbind(
			\instrument, \tom2,
			\out,[0,1],
			\pan,Pwhite([-1,1],inf),//,Prand([-1,1],inf),
			\dur, 1/4,
			\amp,1,//*v[\level1].asMap,
			\freq, Pseq([ Pseq([100],16), Pseq([120],16)],inf)/30,
		     \isRest,Pseq([1,0,0,0,1,0,0,0,/**/1,1,0,0,0,0,0,0],inf).coin.not)
));

)
Pdef(\y).play;
Pdef(\x).play;
Pdef(\v).play;
Pdef(\y).play;
Pdef(\w).play;


Ndef(\a).clear;
Ndef(\b).clear;
(

SynthDef(\tom2, { |which = 1, which2=2, out=2, amp=1, pan=0, release=0.26, fratio=1.5|
	var env0,env1,
env1m, son;

env0 = \env0.kr(Env.new([0.0126, 0.56, 0.5, 0], [0.126,0.062,0.001], [-4, -2, -4]));
env1 = \env1.kr(Env.new([120, 15.5*2, 15.6*2], [0.03, 0.126,0.1], [-4, -5]));

env0 = EnvGen.ar(env0, doneAction:2);
	env1 = EnvGen.ar(env1);

	env1m = env1.midicps;
	son = LFPulse.ar(env1m,0, 0.01, 1,0.5);
son = son;
son = LPF.ar(son, env1m*fratio, env0);
son = son + SinOsc.ar(env1m, 0.5, env0);
son = son;
son = son.clip2(1);

son = son * amp;
//son = Pan2.ar(son, pan);

Out.ar(out, son);
},
).add;



SynthDef(\snare, {|out|
	var env0, env1,son;
	env0 = \env0.kr(Env.new([0.0126, 0.56, 0.5, 0], [0.006,0.1, 0.05], [-4, -2, -4]));
	env1 = \env1.kr(Env.new([400, 243, 225], [0.03, 0.126,0.01], [-4, -5]));
	env0 = EnvGen.ar(env0,doneAction:2);
	env1 = EnvGen.ar(env1);
	son = PinkNoise.ar(1)+WhiteNoise.ar(0.2);
	son = son + SinOsc.ar(env1);Pdef(\x).play;
Pdef(\y).play;
Pdef(\z).play;

	son = Mix.ar(RHPF.ar(son,[180,1431,522,1530,2142]*2));
	son = Pan2.ar(son);
	son= Compander.ar(son, son,
		thresh: 0.3,
		slopeBelow: 0,
		slopeAbove: 0.3,
		clampTime: 0.001,
		relaxTime: 0.01
	);
	Out.ar(out,son*env0);
	}
).add
)

Ndef(\a).set(\filter,1,\freq,101.3,\lag,0.01,\which,081,\freqlo,20000,\freqhi,16559.8,\level1,1,\level2,1,\level3,0.58,\level4,0.71,\level,1,\fblevel,0.4)
Ndef(\b).set(\out,6,\freqlo,78.8,\freqhi,10309.3,\level1,1,\level2,1,\level3,0,\level4,0.46,\level6,-0.28,\levelpulse,1,\level,1,\dis,10,\freq,20000);

Ndef(\a).set(\level1,0)

Ndef(\a).clear;
Ndef(\b).clear;
Pdef(\w).stop;
Pdef(\x).stop;
Pdef(\v).stop;
Pdef(\y).stop;

Ndef(\a).gui(16);
Ndef(\b).gui(16);