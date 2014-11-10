Ndef(\a).clear;
Ndef(\b).clear;
(

Pdef(\y,(
	Pbind(
	\instrument, \hats,
	\out,2,
	//\pan,Prand([-1,1],inf),
	\dur, 1/8,
	\amp,0.001,//*v[\level1].asMap,
	\fratio,Pseq([1,2,3,4],inf),	    \isRest,Pseq([Pseq([0],2),Prand([1,0.5,Pseq([1,1,0,1,1],2),1,0.5,0.1,1],32),Pseq([1,0.5],4)],inf).coin.not,
	\rel,Pseq([Pgeom(0.001,0.001,1431),Pseries(0.1,-0.001,1431).rotate,Pseq([1],256)],inf),
	\ctrl,Ndef(\name,{Mix.ar(LFSaw.kr(0.002,[9/5pi,3/5pi,12pi],0.001,0)).range(1,1)}),
)));
Pdef(\x,(
		Pbind(
			\instrument, \tom,
			\out,[0,1],
			\pan,Pwhite([-1,1],inf),//,Prand([-1,1],inf),
			\dur, 2,
			\amp,1,//*v[\level1].asMap,
			\freq, Pseq([ Pseq([100],16), Pseq([120],16)],inf)/30,
		\isRest,Pseq([1,1,0,0],inf).coin.not)
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


SynthDef(\kick, { |which = 1, which2=2, lfo =  2,out=2, amp=1, pan=0, release=0.26, fratio=1.5,freq=0,in=0|
	var env0,env1,
env1m, son;

	env0 = \env0.kr(Env.new([0.01, 0.1, 01,0], [0.1, 2,0.112413], [-4, -2, -4,-4,-4]));
env1 = \env1.kr(Env.new([120, 80,70,70,70]/1.2, [0.1,2,0.1,0.1,0.1], [-4, -4,-4]));

env0 = EnvGen.ar(env0, doneAction:2);
	env1 = EnvGen.ar(env1*fratio);
	env1m = env1;
	son = LFSaw.ar(env1m+freq,0, 1,0.4)*SinOsc.ar(0.2,2pi,1).clip(1);
son = BPF.ar(son, env1m*fratio, env1);
son = son + LFSaw.ar(env1m+freq, 0, env0);
son = son;
//son = son.clip2(1);
son = son * amp/200;
son =Pan2.ar(son, SinOsc.kr(lfo).range(1,-1));
/*son= Compander.ar(son,In.ar(0,2),
        thresh: 0.5,
        slopeBelow:1,
        slopeAbove:1,
        clampTime: 	1,
        relaxTime: 0.01,
		mul:1,
		add:0
	);*/
	son = AllpassN.ar(son,0.2,0.01,0.1);
OffsetOut.ar(out, son);
},
).add;





)

Ndef(\a).edit;
(
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
).add;

        Spec.add(\freq, #[100, 20000, \exp, 0.1, 1]);
        Spec.add(\freqlo, #[0.1, 20000, \exp, 0.1, 0.5]);
        Spec.add(\freqhi, #[0.1, 20000, \exp, 0.1, 1]);
        Spec.add(\level1, #[ 0, 1, \lin,0, 1]);
        Spec.add(\level2, #[ 0, 1, \lin,0, 1]);
        Spec.add(\level3, #[ 0, 1, \lin,0, 1]);
        Spec.add(\level4, #[ 0, 1, \lin,0, 1]);
        Spec.add(\levelpulse, #[ 0, 1, \lin,0, 1]);
        Spec.add(\level,  #[ 0, 1, \lin,0, 1]);
Spec.add(\dis, #[0, 10, \lin, 0, 10]);
Ndef(\b,{
	arg freqlo=100,freqhi=4000,level1 = 0.1,level2 = 1,level3 = 0,level4 = 0,level6 = 0,levelpulse=0,level=1,dis=1,freq=100,thresh= 0.5,slopeBelow= 0.2,slopeAbove= 1,clampTime = 1,
		relaxTime = 0.01;
	var sig = ((InFeedback.ar(26,2)*level1)+(InFeedback.ar(0,2)*level2)+ (InFeedback.ar(2,2)*level3)+(InFeedback.ar(4,2)*level4)+(InFeedback.ar(6,2)*level6));
	var pulse = Mix.ar(LFPulse.ar([freqlo ,freqhi],[freqlo+300,freqhi+200],0)*levelpulse);
	sig = sig+(sig * pulse); // bypass sig

	sig = Disintegrator.ar(sig,dis,1,1);
	sig = SineShaper.ar(sig,2);
	sig = LPF.ar(sig,freq);
	sig = Pan2.ar(sig,0);
	sig= Compander.ar(sig, InFeedback.ar(0,2),
		thresh: 0.1,
		slopeBelow: 0.2,
		slopeAbove: 0.1,
		clampTime: 1,
		relaxTime: 0.01
	);
	sig = Limiter.ar(sig,1,0.01);
	 Out.ar(6,sig*level);
	Out.ar(26,sig*level);
}).play;



        Spec.add(\filter, #[0, 1, \lin, 0, 1]);
        Spec.add(\freq, #[0.1, 20000, \exp, 0.1, 0.5]);
        Spec.add(\which, #[0, 1, \lin, 0, 1]);
	    Spec.add(\lag, #[0.000001, 0.01, \lin, 0.000001, 0.01]);
        Spec.add(\freqlo, #[0.1, 20000, \exp, 0.1, 0.5]);
        Spec.add(\freqhi, #[0.1, 20000, \exp, 0.1, 1]);
        Spec.add(\level1, #[ 0, 1, \lin,0, 1]);
        Spec.add(\level2, #[ 0, 1, \lin,0, 1]);
        Spec.add(\level3, #[ 0, 1, \lin,0, 1]);
        Spec.add(\level4, #[ 0, 1, \lin,0, 1]);
        Spec.add(\level, #[0, 1, \lin, 0, 1]);
Ndef(\a,{
		arg out =6, filter = 0, freq= 1000, lag = 0.00000001, which= 0, freqlo= 10,freqhi = 400,level1 = 0.1,level2 = 0.5,level3 = 1,level4 = 0.001,level =0.1,fblevel=0.3;

	var sig =(InFeedback.ar(24,2)*level1)*Mix.ar(SelectX.ar(which,[LFSaw.ar([freqlo,freqhi],0,0.1),LFPulse.ar([freqlo,freqhi],0,0.1)]))
	+ (InFeedback.ar(0,2)*level2)+(InFeedback.ar(2,2)*level3)+(InFeedback.ar(4,2)*level4)*Mix.ar(SelectX.ar(which,[Mix.ar(LFSaw.ar([freqlo,freqhi],0,0.1)),Mix.ar(LFPulse.ar([freqlo,freqhi],0,0.1))]));
	//sig = FreeVerb.ar(sig,1,fblevel);
	sig = CrossoverDistortion.ar(sig,0.5,10,1,0);
	sig = Pan2.ar(sig,0);
	sig = SelectX.ar(filter,[HPF.ar(sig,freq,1),LPF.ar(sig,freq,1)]);
	sig = Limiter.ar(sig,0.9);
	sig = Pan2.ar(sig,0,1);
		sig= Compander.ar(sig, InFeedback.ar(0,2),
		thresh: 0.1,
		slopeBelow: 0.5,
		slopeAbove: 0.5,
		clampTime: 0.01,
		relaxTime: 0.01
	);
	Out.ar(24,Lag.ar(sig*level*(-1),lag));
	Out.ar(out,sig*level);
}).play;
Ndef(\a).set(\out,6,\filter,1,\freq,2000,\lag,0,\which,0,\freqlo,202.5,\freqhi,0.18,\level1,0,\level2,0.5,\level3,1,\level4,0,\level,0.1,\fblevel,0.02);
Ndef(\b).set(\out,6,\freqlo,78.8,\freqhi,10309.3,\level1,1,\level2,1,\level3,0,\level4,0.46,\level6,-0.28,\levelpulse,1,\level,1,\dis,10,\freq,2000);
Ndef(\b).map(\freqhi,Ndef(\lfo,{SinOsc.kr(0.1,0,100,2200)}));
Ndef(\a).map(\freqlo,Ndef(\lfo));
Ndef(\b).unmap(\freqhi);
Ndef(\a).unmap(\freqlo);
)

Ndef(\c).clear;
(
//LOUD!
//x1 = a*x0^2 + b*x0 + c
//x1 = 1 - rx0^2
Ndef(\c,{arg co1 = 1,co2=0,pan=0;
	var sig, r;
	r = MouseX.kr(1.5, 2);
	//sig = InFeedback.ar(6,2)*Phaser.ar(30)*QuadN.ar(SampleRate.ir/r, r.neg, 0, 1, 0.1,0.0001);
	//sig = CuspN.ar(SampleRate.ir/4, MouseX.kr([0.6,-0.6], 2), MouseY.kr([0.6,-0.6], 1.9));
	//sig = InFeedback.ar(6,2)*GbmanN.ar(SampleRate.ir/r*4, 0.02, 2.0002, r, -0.5);
	//sig = InFeedback.ar(6,2)* HenonN.ar(SampleRate.ir/8, MouseX.kr(1, 1.4), MouseY.kr(0, 0.3),0,0,0.001);
	//	sig = LatoocarfianN.ar * -6.dbamp;
	//sig = LatoocarfianN.ar(a: MouseY.kr(1, 4)) * -6.dbamp;
	//sig = LatoocarfianN.ar(SampleRate.ir/4, a: 2.33843, b: 2.14421, c: MouseX.kr(0, 1), d: MouseY.kr(0, 1)) * -6.dbamp;
	//sig = LatoocarfianN.ar(SampleRate.ir/16, a: 2.33843, b: 2.14421, c: MouseX.kr(0, 1), d: MouseY.kr(0, 1)) * -6.dbamp;
	//sig = LatoocarfianN.ar(1000) * -6.dbamp;
	sig = InFeedback.ar(6,2) * LinCongN.ar(
		18000,
		LFNoise2.kr(0.001, 0.05, 1),
		LFNoise2.kr(0.001, 0.01, 0.01),
		LFNoise2.kr(0.001,0.01)
	) * -6.dbamp;
	sig = [DelayL.ar(sig,SinOsc.kr(0.1,0,0.5,SinOsc.kr(0.1,0,1,co1))),DelayL.ar(sig,SinOsc.kr(0.1,0,0.5,SinOsc.kr(-0.1,0,-1,co2*(-1))))]* -39.dbamp ;

	sig = Pan2.ar(sig,pan);
	//~makeXY.value(sig);
}).playN(6,2);
)


Tdef(\c,{loop {
	Ndef(\c).set(\co1,-1,\co2,-1);Ndef(\c).rebuild;
	4.wait;
	Ndef(\c).set(\co1,1,\co2,1);Ndef(\c).rebuild;
	4.wait;}}).play;

Ndef(\c)[1]= \set -> Pbind(\dur,2,\pan,Pseq([-1,1],inf),\co1,Pseq([-1,0,0,0,1,0,0,0],inf))
Ndef(\c).unset(\co1)
s.meter;
Tdef(\c).clear;
Ndef(\c).clear;
///////////////////////











FreqScope.new(400, 200, 0);
