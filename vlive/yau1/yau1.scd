
(

Pdef(\z,(

		Pbind(
			\instrument,Pseq([\kick],inf),
			\out,2,
			\pan,Pwhite([-1,1],inf),
			\dur, 2,
		    \lfo,Place([Pseq([12],2),[Pseq([0.12],2),Pseq([-0.12],2)]],inf),
		    \amp,1,//*v[\level1].asMap,
		    \freq,Pseq([Pseq([0],16),Pseq([216],16)],inf),
		//\freq,Pseq([Pseq([0],2),Pseq([2],2),Pseq([4],2),Pseq([6],2)],inf),
		    \fratio,Pseq([Pseq([1.3],4),Pseq([1.5],4)],inf),
			\isRest,Pseq([1],inf).coin.not
		)
));
)

(
Pdef(\y,(
	Pbind(
	\instrument, \hats,
	\out,2,
	\pan,Pseq([-1,1],inf),
	\dur, 1/8,
	\amp,0.0005,//*v[\level1].asMap,
	\fratio,Pseq((1..100)/100,inf),	\isRest,Pseq([Pseq([0],2),Prand([1,0.5,Pseq([1,1,0,1,1],2),1,0.5,0.1,1],32),Pseq([1,0.5],4)],inf).coin.not,
	\rel,Pseq([Pgeom(0.001,0.001,1431),Pseries(0.1,-0.001,1431).rotate,Pseq([1],256)],inf),
		\ctrl,Ndef(\name,{Mix.ar(LFSaw.kr(0.02,[9/5pi,3/5pi,12pi],0.001,0)).range(10,100)}),
)));
Pdef(\x,(
		Pbind(
			\instrument, \tom,
			\out,[0,1],
			\pan,Pwhite([-1,1],inf),//,Prand([-1,1],inf),
			\dur, 4,
			\amp,1,//*v[\level1].asMap,
			\freq, Pseq([ Pseq([100],16), Pseq([120],16)],inf)/30,
		\isRest,Pseq([1.0],inf).coin.not)
));
Pdef(\z,(

		Pbind(
			\instrument,Pseq([\kick],inf),
		    \out,4,
			//\pan,Pseq([-1,1],inf),
			\dur, 2,
		    \freq,0,
		    \lfo,Place([Pseq([12],2),[Pseq([0.12],2),Pseq([-0.12],2)]],inf),
			\amp,1,//*v[\level1].asMap,
		  //  \fratio,Pseq([0.2],inf),
			\isRest,Pseq([1],inf).coin.not
		)
));


SynthDef(\tom, { |which = 1, which2=2, out=2, amp=1, pan=0, release=0.26, fratio=1.5|
	var env0,env1,
env1m, son;

env0 = \env0.kr(Env.new([0.0126, 0.56, 0.5, 0], [0.126,1.62, 1], [-4, -2, -4]));
env1 = \env1.kr(Env.new([120, 15.5*2, 15.6*2], [0.03, 0.126], [-4, -5]));

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
SynthDef(\kick, { |which = 1, which2=2, lfo =  2,out=2, amp=1, pan=0, release=0.26, fratio=1.5,freq=0,in=0|
	var env0,env1,
env1m, son;

	env0 = \env0.kr(Env.new([0.01, 0.1, 0,0], [0.1, 2,0.1], [-4, -2, -4]));
env1 = \env1.kr(Env.new([120, 80,70]/1.2, [0.1,2,0.1], [-4, -5]));

env0 = EnvGen.ar(env0, doneAction:2);
	env1 = EnvGen.ar(env1*fratio);
	env1m = env1;
	son = LFSaw.ar(env1m+freq,2, 1,0.4)*SinOsc.ar(0.2,0,1);
son = LPF.ar(son, env1m*fratio, env1);
son = son + LFSaw.ar(env1m+freq, 2, env0).clip(0,1);
son = son;
//son = son.clip2(1);
son = son * amp/200;
son =Pan2.ar(son, SinOsc.kr(lfo).range(1,-1));
son= Compander.ar(son,In.ar(0,2),
        thresh: 0.5,
        slopeBelow:1,
        slopeAbove:1,
        clampTime: 	1,
        relaxTime: 1,
		mul:1,
		add:0
	);	son = CombC.ar(son,0.01,0.1);
OffsetOut.ar(out, son);
},
).add;


SynthDef(\hats, { |which = 1, which2=2, out=4, amp=1, pan=0, rel=0.26, fratio=0.2|
	var env0,env1,
	env1m, son;
	env0 = (Env.perc(0.1,rel));
	env1 = \env1.kr(Env.new([40,40, 40, 40]*16, [0.05,0.05, 0.01,0.01], [-4, -5]));

	env0 = EnvGen.ar(env0, doneAction:2);
	env1 = EnvGen.ar(env1);

	env1m = env1.midicps;
	son = SinOsc.ar(env1+SinOsc.ar([2160*7,2160*8]),0, 0.01, 0.1, -0.5);
	son = son + WhiteNoise.ar(1)*Ndef.kr(\name).range(0,1);
	son = LPF.ar(son, env1m*fratio, env0);
	son = son + Mix.ar(LFTri.ar([env1*\ctrl.kr,env1+741*\ctrl.kr]+\ctrl.kr, 0.5, [env0,env0*0.2]));
	son = son;
	son = son.clip2(0.1);

	son = son * amp;
	son = Pan2.ar(son, pan);
	son= Compander.ar(son, son,
        thresh: 0.16,
        slopeBelow: 0.5,
        slopeAbove: 0.47,
        clampTime: 1,
        relaxTime: 1
    );
	son = GVerb.ar(son,1,0.06);
	son = Splay.ar(son,SinOsc.kr(0.9).range(0,1),1,SinOsc.kr(0.9).range(0,1));
	OffsetOut.ar(out, son);
	},
).add;
Ndef(\a).set(\out,6,\filter,1,\freq,1000,\lag,0,\which,0,\freqlo,202.4,\freqhi,0.2,\level1,0,\level2,0.5,\level3,1,\level4,0,\level,0.1,\fblevel,0.02);
Ndef(\b).set(\out,6,\freqlo,78.8,\freqhi,1039.3,\level1,1,\level2,1,\level3,0,\level4,0.46,\level6,-1.28,\levelpulse,1,\level,1,\dis,10,\freq,20000);



SynthDef(\snare, {|out|
	var env0, env1,son;
	env0 = \env0.kr(Env.new([0.0126, 0.56, 0.5, 0], [0.006,0.1, 0.05], [-4, -2, -4]));
	env1 = \env1.kr(Env.new([400, 243, 225], [0.03, 0.126,0.01], [-4, -5]));
	env0 = EnvGen.ar(env0,doneAction:2);
	env1 = EnvGen.ar(env1);
	son = PinkNoise.ar(1)+WhiteNoise.ar(0.2);
	son = son + SinOsc.ar(env1);

	son = Mix.ar(RHPF.ar(son,[180,1431,522,1530,2142]));
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



s.meter;

///////////////////////






Ndef(\b).gui(16);
Ndef(\a).gui;

FreqScope.new(400, 200, 0);
