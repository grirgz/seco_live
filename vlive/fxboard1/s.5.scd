
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq,freq2;
	var in;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var bufnum = LocalBuf(s.sampleRate * 4,2);
	var bufgate, stuttrig, choosetrig, recordtrig;
	var attack=0.01, decay=0.01, stutter;
	var env;

	bufnum.clear;
	in = InFeedback.ar(\inbus.kr(BusDef(\in1, \audio)), 2); 
	sig = in;
	in.debug("in");
	sig = sig * 1;
	//Amplitude.ar(sig).poll;
	//sig = SinOsc.ar(200);
	
	bufgate = Duty.kr(1/8/~t, 0, Dseq([
		1,1,0,0,
		1,0,1,0,
		1,1,0,0,
		1,0,0,0,
		1,1,0,0,
		1,1,1,0,
		1,1,0,0,
		0,0,0,0,

		1,0,1,1,
		0,0,1,0,
		1,1,1,0,
		0,0,0,1,
		1,1,0,0,
		0,0,0,0,
		0,0,0,0,
		0,0,0,0,
		//0,1,1,1,
		//0,1,1,1,
		//0,1,0,1,
		//0,1,0,1,
		//1,1,1,0,
		//1,0,1,0,
		//0,0,0,0,
		//0,0,1,1,
	],inf));
	bufgate = Duty.kr(1/8/~t, 0, Dseq([
		0,0,0,0, 0,0,0,0,
		1,1,1,1, 1,1,1,1,
		//0,1,1,1,
		//0,1,1,1,
		//0,1,0,1,
		//0,1,0,1,
		//1,1,1,0,
		//1,0,1,0,
		//0,0,0,0,
		//0,0,1,1,
	],inf));
	choosetrig = bufgate > 0;
	stutter = DC.kr(1/8);
	stutter = Duty.kr(1/~t, 0, Dseq(1/[
		1068/3
		4,8,16,32,
	],inf));
	stuttrig = TDuty.ar(stutter/~t, choosetrig + Changed.kr(stutter), 1);
	//stuttrig = Impulse.ar( SinOsc.kr(8).range(84,1) );
	recordtrig = Trig1.kr(choosetrig, 0.01);
	env = EnvGen.ar(Env([0,1,1,0],[attack, stutter-attack-decay, decay]), stuttrig);
	
	RecordBuf.ar(sig, bufnum, 0, 1, 0, run:1,loop:0,trigger: recordtrig,doneAction:0);
	sig1 = PlayBuf.ar(2, bufnum, rate:\rate.kr(1), trigger:stuttrig,startPos:0, loop:0) * env;
	sig1 = sig1 * 1.2;
	sig = SelectX.ar( bufgate.lag(0.01), [sig, sig1]);
	

	sig = sig * \xamp.kr(1);
	sig.debug("sig");
	sig = SelectX.ar(\mix.kr(0),[in, sig]);
	amp = amp * \gain.kr(1);
	//sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size, amp).mean;
	sig;
});
Ndef(~name+++\fx).addSpec(\allpmix, \unipolar);
Ndef(~name+++\fx).addSpec(\allpdecay, ControlSpec(0,8,\lin));

// END

Ndef(~name+++\fx).set(\lpf, 100)

BusDef(\in1).getSynchronous
BusDef(\in1).set(0)

Ndef(~name+++\fx).get(\inbus)
~name

EventType


(
Pbind(
	\instrument, \default,
	\freq, 200,
	\dur, 1,
	\amp, 0.1
);
)

Event

(
SynthDef(\rix, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, igate=1;
	var sig;
	sig = SinOsc.ar(freq * ( 1 + ( SinOsc.kr(1/8) * 1 )));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),igate,doneAction:0);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\xplop, Pmono( \rix,
	\degree, Pseq([0],inf),
	\dur, 1,
	//\type, \monoNote,
	\igate, 1,
	\legato, 0.1,
	\finish, { 
		debug("what");
		{
			if(~id.notNil) {

				~schedBundleArray.(
					~lag,
					~sustain.value + ~timingOffset,
					~server,
					[15 /* \n_set */, ~id, \igate, 0].flop,
					~latency
				);
			};
		}.inEnvir.defer;
		
	},
	\amp, 0.1
)).play;
);



ParamProto.init
~noteTimeline.new(\bla, Param(Ndef(\got), \midinote)).edit
~noteTimeline.new(\bla).param
~noteTimeline.new(\bla).edit
~noteTimeline.composeParamPattern = true
~noteTimeline.new(\bla).composeParamPattern = false
~noteTimeline.new(\bla).xasPattern

(
Ndef(\got).put(0, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\got).put(1, \set -> ~noteTimeline.new(\bla).xasPattern);
);
