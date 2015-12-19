
(
	ParamProto.init;
~t=1;
SynthDef(\glitch, {
arg freq1=40,freq2=200,freq3=100,dec1=1,dec2=0.5,gain=250,index=100,hFreq=1000,lFreq=10000,amp=0.125;

var aEnv = Decay.ar(Impulse.ar(0),dec1);
var pEnv = Decay.ar(Impulse.ar(0),dec2);
var free;

var sound;
var lfemix = \lfemix.kr(1);
var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
var sig;
var kick;
var cfreq;
var coin;
//pEnv = 1;
aEnv = aEnv + Decay.ar(Impulse.ar(0),dec1 * 1.5).log;
aEnv = EnvGen.ar(\env.kr(Env([0,1,0,0,0],[0.001,1,0,0])), timeScale:\timeScale.kr(1), doneAction:2);
lFreq = ( lFreq * ( 1-lfemix ) ) + ( lfemix * aEnv ).clip(0.0001,inf);
//sound = Pan2.ar(Saw.ar(freq1,0.25),Saw.ar(freq2+SinOsc.ar(freq3*pEnv,0,index)))*gain;
//sound = Pan2.ar(aEnv,Saw.ar(freq2+SinOsc.ar(freq3*pEnv,0,index)))*gain;
//freq1 = LFSaw.ar(1/55,2/4 * 2pi).range(ExpRand(50,17000),ExpRand(50,17000));
//freq2 = LFSaw.ar(1/45,1/4 * 2pi).range(ExpRand(50,17000),ExpRand(50,17000));
//freq3 = LFSaw.kr(1/43).range(ExpRand(50,17000),ExpRand(50,7000));
//freq1 = aEnv * freq1;
//freq2 = aEnv * freq2;
coin = { arg x; Select.kr(Rand(0,1), x) };
cfreq = { arg x; ( coin.([0,1])-aEnv )/4 + 1 * x };
cfreq = { arg x; ( coin.([0-aEnv,aEnv]) )/40 + 1 * x };
freq1 = ExpRand(50,15000);
freq2 = ExpRand(50,15000);
freq3 = ExpRand(50,15000);
freq1 = cfreq.(freq1);
freq2 = cfreq.(freq2);
freq3 = cfreq.(freq3);
sig5 = LFPulse.ar(freq3) + Saw.ar(freq2) + SinOsc.ar(freq1);
sig5 = sig5 * aEnv;

kick = SinOsc.ar(XLine.kr(\kickhi.kr(500),\kicklo.kr(60),[0.1,0.1]*\kicktimefac.kr(1/5)));

sig5 = SelectX.ar(\kickmix.kr(1), [sig5, kick]);

sig1 = Pan2.ar(aEnv,sig5)*gain;
sig2 = (sig5)*gain;

sound = SelectX.ar(\mix.kr(0.1), [sig1, sig2]);
sound = HPF.ar(sound,hFreq);
sound = sound*PinkNoise.ar;
sound = LPF.ar(sound,lFreq * [1,1/2,1/3]);
sound = sound.tanh;
sound = sound / 6;
sound = SelectX.ar(\kickmix2.kr(0.11), [sound, kick]);
sig1 = CombL.ar(sound, 1/20, 1/50 * [1,1/1.3,1.7,2] ++ SinOsc.kr([ 1/44, 1/47 ]).range(1,[2.0.rand,1/2.0.rand]),0.1 * SinOsc.kr(1/4,3/2 * pi).range(0,10)) + sound;
sound = SelectX.ar(\combmix.kr(0.5), [sound, sig1]);
sound.debug("sound");
sound = sound*aEnv;
//free = DetectSilence.ar(sound,doneAction:2);
sound = LeakDC.ar(sound);
sound = Pan2.ar(sound, Rand(-1 ! sound.size, 1), 1).flop;

Out.ar(0,sound*amp);
}).store;

Pdef(\glitch,  Pbind(
	\instrument, \glitch,
	\degree, Pseq([0],inf),
	\dur, Pkeyd(\dur,1),
	\amp, Pkeyd(\amp,0.1),
));
Pdef(\glitch).addHalo(\instrument, \glitch);
Pdef(\glitch).addSpec(\env, XEnvSpec( ControlSpec(0,1,\lin)!5 ));
Pdef(\glitch).addSpec(\lfemix, \unipolar);
Pdef(\glitch).addSpec(\kickmix, \unipolar);
Pdef(\glitch).addSpec(\kickmix2, \unipolar);
Pdef(\glitch).addSpec(\combmix, \unipolar);
~modStepTimeline.new(\glitch).drumrack = DrumRack(\glitch);
~modStepTimeline.new(\glitch2).drumrack = DrumRack(\glitch);
~modStepTimeline.new(\glitch3).drumrack = DrumRack(\glitch);
Ndef.defaultQuant = 4;
Pdef.defaultQuant = 4;
);

(
ParamProto.init;
ParamGroupDef(\glitch, Pdef(\glitch).asParamGroup);
WindowDef(\glitch, {
	var player = Pdef(\glitch), pg = ParamGroupDef(\glitch);
	var lay;
	lay = ParamGroupLayout.two_panes(pg, \property);
	VLayout (
		HLayout (
			PlayerWrapper(player).asView,
			EventClass.presetSelectorView.(pg),
		),
		ScrollView.new.canvas_(View.new.layout_(lay));
	);
}).front
)
~modStepTimeline.new(\glitch).edit
~modStepTimeline.new(\glitch2).edit
~modStepTimeline.new(\glitch3).edit
~clipTimeline.new(\glitch).edit

Ndef(\kilik).play
Ndef(\kilik).stop
Ndef(\kilik).edit

(
Ndef(\kilik).put(0, { arg freq=700, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = SinOsc.ar(freq);
	sig1 = (sig*800).tanh;
	sig = SelectX.ar( LFPulse.kr(1/2 * LFPulse.kr(1/4)), [sig, sig1]);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
)

(
Ndef(\kilik).put(0, { arg freq=700, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var wob = \wob.kr(8);
	sig = SinOsc.ar(freq * SinOsc.ar(wob.lag(1)).range(1,2));
	sig1 = (sig*800).tanh;
	sig = SelectX.ar( LFPulse.kr(1/2 * LFPulse.kr(1/4)), [sig, sig1]);
	sig = RLPF.ar(sig, \lpf.kr(500) * SinOsc.kr(wob).range(2,1), \rq.kr(0.5));
	sig = Pan2.ar(sig, pan, amp);
});

Ndef(\kilik).put(1, \set -> Pbind(
	\freq, Pseq([50,80,60,50,Pwhite(100,900,1)],inf),
	\dur, Pseq([1,1,1,1,4],inf),

	
));

Ndef(\kilik).put(2, \set -> Pbind(
	\wob, Pseq([2,8,16,32,360],inf),
	\dur, Pseq([1,1,1,1,4],inf),

	
));
)
(
Ndef(\plonk).put(0, { arg freq, amp=0.1, pan=0, fspread=0.1;
	var sig;
	var line;
	var tim;
	line = Line.kr(-1,1,20);
	sig = Impulse.ar(1 * [2,1/4]);
	sig = Decay.ar(sig, 0.4, WhiteNoise.ar);
	//sig = LFSaw.ar(200 * [1,1.01]);
	tim = Select.kr( SinOsc.kr(1/2).range(0,1)*5, [
		1/16,
		1/8,
		1/32,
		1/4,
		1/64,
		1/2,
	]);
	sig = sig * Duty.kr(1/8/~t, 0, Dseq([
		1,0,0,0,
		0,0,0,0,
		1,0,1,0,
	],inf));
	sig = CombL.ar(sig, 1/4,tim,1) + sig;
	sig = DelayL.ar(sig, 1/2);
	//sig = Pan2.ar(sig, pan, amp).flop;
	sig = Pan2.ar(sig, pan, amp).flop;
	//sig = sig * 2;
});
)
(
Ndef(\plik).put(0, { arg freq, amp=0.1, pan=0, fspread=0.1;
	var sig;
	var line;
	var tim;
	line = Line.kr(-1,1,20);
	sig = Impulse.ar(1 * [4,1/4]);
	sig = Decay.ar(sig, 0.4, WhiteNoise.ar);
	sig = RLPF.ar(sig, SinOsc.kr(1/16).range(100,7001), \rq.kr(0.5));
	//sig = LFSaw.ar(200 * [1,1.01]);
	tim = Select.kr( SinOsc.kr(1/2).range(0,1)*5, [
		1/16,
		1/8,
		1/32,
		1/4,
		1/64,
		1/2,
	]);
	sig = CombL.ar(sig, 1/4,tim,1) + sig;
	sig = FreqShift.ar(sig, SinOsc.kr(1/4).range(0,1000)) + sig;
	sig = sig * Duty.kr(
		Dstutter(8,
			Dseq([
				1/16,1/8,
				1/16,1/8,
				1/32,1/16,
				1/16,1/8,
				1/8,1/12,
				1/16,1/8,
			],inf)/~t
		),
		0, Dseq([
		1,0,1,0,
	],inf));
	sig = DelayL.ar(sig, 1/2);
	//sig = Pan2.ar(sig, pan, amp).flop;
	sig = Pan2.ar(sig, pan, amp).flop;
	//sig = sig * 2;
});
)


(
Ndef(\rip).put(0, { arg freq, amp=0.1, pan=0, fspread=0.1;
	var sig;
	var line;
	line = Line.kr(-1,1,20);
	sig = LFSaw.ar(line.range(50,1000)) ;
	sig = RLPF.ar(sig, \lpf.kr(500), \rq.kr(0.5));
	sig = Pan2.ar(sig, pan, amp);
})
)
(
Ndef(\rip).put(0, { arg freq, amp=0.1, pan=0, fspread=0.1;
	var sig;
	var line;
	line = Line.kr(-1,1,20);
	sig = LFSaw.ar(line.range(50,1000) * [1,1.01] * ( 1 + ( SinOsc.kr(400 * ( 1 + ( SinOsc.kr(1/4) * 4 ))) * 1 ))) ;
	sig = RLPF.ar(sig, \lpf.kr(500) * line.range(1,20), \rq.kr(0.5));
	sig = Pan2.ar(sig, pan, amp);
	//sig = Impulse.ar(1);
	//sig = Decay.ar(sig, 0.4, mul:PinkNoise.ar * SinOsc.ar(1500) );
	sig = HPF.ar(sig, 20);
	sig = CombL.ar(sig, 1/4,1/4,1) + sig;
	//sig = Pan2.ar(sig, pan, amp).flop;
	sig = Pan2.ar(sig, pan, amp).flop;
	sig = sig * 2;
})
)
Ndef(\rip).clear
Ndef(\rip).play;
Ndef(\rip).free(0.1);
Ndef(\rip).free;
Ndef(\rip).fadeTime = 0.1
Ndef(\rip).fadeTime = 0
Ndef(\rip).scope
Ndef(\rip).send;
Ndef(\rip).stop(1,true)
Ndef(\rip).deepWakeUp
Ndef(\rip).wakeUp

~clipTimeline.all.save

Ndef(\rip).isPlaying

(
SynthDef(\rip, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, doneAction=2, fspread=0.001;
	var sig;
	var line;
	line = EnvGen.kr(Env([-0.8,-1,1],[0.01,4.8]), gate);
	line = Line.kr(-1,1,8);
	freq = line.range(70,7000);
	sig = LFSaw.ar(freq * ((0..7)/7 - 0.5 * fspread * line.range(0.1,5000) + 1) * ( 1 + ( SinOsc.ar(freq) * line.range(0.1,8) ))); 
	sig = WhiteNoise.ar + sig;
	sig = RLPF.ar(sig, \lpf.kr(1500) * line.linexp(-1,1,1,20), \rq.kr(0.2) * line.range(1,3));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:doneAction);
	//sig = Impulse.ar(1);
	//sig = Decay.ar(sig, 0.4, mul:PinkNoise.ar);
	//sig = Pan2.ar(sig, pan, amp).flop;
	sig = Pan2.ar(sig, pan, amp);
	//sig = sig / 2;
	Out.ar(out, sig);
}).add;
);

s.latency = 0.2

(
Pdef(\rip, Pmono(\rip,
	\dur, 4,
))
)


(
	(
		type: \player,
		receiver: Ref(PlayerWrapper(Ndef(\rip))),
		sustain: 4,
	).play
)

~p  = PlayerWrapper(Ndef(\rip))
~p.play
~p.stop
~p.quant = 4

~clipTimeline.new(\glitch).edit



(
	{
		var freq, trig, sin;
		trig = TDuty.kr(1/0.55*Dseq([Dseq([1],3),Dseq([0.5],2)],inf)*Dseq([4],inf),0);
		freq = Demand.kr(trig,0,Dseq([523.25,622.25,587.33,554.37],inf));
		sin = SinOsc.ar([freq,freq+(2*(freq/12)),freq+(4*(freq/12)),freq+(5*(freq/12)),freq+(7*(freq/12))])*0.2;
		sin = Pan2.ar(sin, pan:[0,-1,1,0.3]).flop;
		sin
	}.play;
);

(
	{
		var freq, trig, sin;
		trig = TDuty.kr(1/0.55*Dseq([Dseq([1],3),Dseq([0.5],2)],inf)*Dseq([4],inf),0);
		freq = Demand.kr(trig,0,Dseq([523.25,622.25,587.33,554.37],inf));
		sin = SinOsc.ar([freq,freq+(2*(freq/12)),freq+(4*(freq/12)),freq+(5*(freq/12)),freq+(7*(freq/12))])*0.2;
		sin = Pan2.ar(sin, LFNoise1.kr((1..4)).range(-1,1),0.1).flop;
		sin
	}.play;
);

(
	{
		var freq, trig, sin;
		trig = TDuty.kr(1/0.55*Dseq([Dseq([1],3),Dseq([0.5],2)],inf)*Dseq([4],inf),0);
		freq = Demand.kr(trig,0,Dseq([523.25,622.25,587.33,554.37],inf));
		sin = SinOsc.ar([freq,freq+(2*(freq/12)),freq+(4*(freq/12)),freq+(5*(freq/12)),freq+(7*(freq/12))])*0.2;
		sin = Splay.ar(sin, spread:0.8, amp:1, pan:0);
		sin
	}.play;
);
