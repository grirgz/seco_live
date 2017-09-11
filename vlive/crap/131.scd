//================ 1. SERVER CONFIG ==================//
s.quit;
(
ServerBoot.removeAll;
ServerTree.removeAll;
ServerQuit.removeAll;

//================ 2. GLOBAL VARIABLES ================//
~masterOut = 0;
~bpm = 110;
~scale=48 ;//C
~path = "/tmp/";


//================ 3. SCORE FUNCTIONS ================//
~makeBuffers = {
	b = Dictionary.new;
	PathName(~path).entries.do {
		arg subfolder;
		b.add (
			subfolder.folderName.asSymbol ->
			Array.fill(
				subfolder.entries.size,
				{
					arg i;
					Buffer.read(s, subfolder.entries[i].fullPath);
				}
			);
		);
	};
};

~makeBusses = {
	~bus = Dictionary.new;
	~bus.add(\fx -> Bus.audio(s, 2));
};

~cleanup = {
	s.newBusAllocators;
	ServerBoot.removeAll;
	ServerTree.removeAll;
	ServerQuit.removeAll;
};

~makeNodes = {
	s.bind( {
	~mainGrp = Group.new;
	~fxGrp = Group.after(~mainGrp);
	~fxSynth = Synth.new(\fx,
			[
				\amp, 1,
				\predelay, 0.1,
				\revtime, 1.8,
				\lpf, 4500,
				\mix, 0.35,
				\in, ~bus[\fx],
				\out, ~masterOut,
			],
			~fxGrp
		);
	});
};

~makeEvents = {
	MIDIClient.init;
	MIDIIn.connectAll;
	e = Dictionary.new;
	e.add(\event1 -> {

		~fmMelody = Pbind(
			\instrument, \fmSynth,
			\dur, 1,
			\stretch, 60/~bpm*2,
			\freq, Pseq([[3, 7, 12 ], [7, 14], 0, [7,15], 0, [2, 7], 10, 2] + ~scale, inf).midicps,
			\dur, Pseq([1, 1], inf),
			\attack, Pseq([0.1, 0.2, 0.1, 0.8], inf),
			\decay, Pseq([1.5, 0.5, 1.5, 0.5], inf),
			\sustain, Pseq([0.8, 0.9, 0.8, 0.9], inf),
			\release, Pseq([0.8, 1.5, 1.0, 1.2], inf),
			\cutoff, Pseq([6000, 500], inf).asStream,
			\amp, Pseq([0.38, 0.43], inf),
			\group, ~mainGrp,
			\out, ~bus[\fx],
		).play;
	});

	e.add(\event2 -> {

		~crotaleMelody = Pbind(
			\instrument, \crotale,
			\dur, Pseq(#[0.5, 0.25, 0.25, 0.5, 0.5], inf),
			\stretch, 60/~bpm*2,
			\midi, Pseq(#[12, 8, 0, 7]+~scale, inf),
			\amp, Pseq(#[0.2, 0.4], inf),
			\pan, Pseq(#[-0.4, 0, 0.2, -0.5, 0.3, -0.25], inf),
		).play;
	});

	e.add(\event3 -> {

		~drone = Pbind(
			\instrument, \bpfsaw,
			\dur, 1,
			\freq, ~scale+12.midicps,
			\detune, Pwhite(0.03,0.2),
			\rqmin, 0.08,
			\rqmax, 0.12,
			\cfmin, 50,
			\cfmax, 400,
			\atk, 2,
			\sus, 0.1,
			\rel, 4,
			\amp, 2,
			\group, ~mainGrp,
			\out, ~bus[\fx],
		).play;
	});

e.add(\event4 -> {

		Routine({/*
			~hats = Pbind(
				\instrument, \bpfbuf,
				\dur, 0.25,
				\atk, Pexprand(0.01,0.2),
				\rel, 1,
				\buf, b[\kicks][2],
				\rate, 4,
				\amp, Pexprand(0.8,1.0),
				\bpfmix, 0,
				\group, ~mainGrp,
				\out, ~bus[\fx],
			).play;
			*/
	~kicks =	Pbind (
				\instrument, \snapkick,
				\dur, 1/4,
				\stretch, 60/~bpm*1,
				\gate, Pseq([1,1,1,1   ,1,0,1,0,   0,1,0,1,1,0,1,0], inf),
				\amp, Pseq([1,0,0,0.8,1,0,1,0,   0,1,0,0.7,1,0,1,0], inf),
			).play;
    ~snares =	Pbind (
				\instrument, \snapsnare,
				\dur, 1/4,
				\stretch, 60/~bpm*2,
				\gate, Pseq([0,0,1,0,0,1,0,0], inf),
				\amp, Pseq([0,0,0.4,0,0,1.9,0,0], inf);
			).play;


/*
			Pbind(
				\instrument, \hat,
				\dur, 1/4,
				\stretch, 60/~bpm*4,
				\buf3, Pseq([d[\dhat][8],  d[\dhat][3]], inf, 1),
				\gate, Pseq([1,0,0,1   ,1,0,1,0,   0,1,0,1,1,0,1,0], inf),
				\amp, Pseq([1,0,0,0.8,1,0,1,0,   0,1,0,0.7,1,0,1,0], inf),
			).play;

*/

/*			~bubbles = Pbind(
				\instrument, \bpfsaw,
				\dur, Pwhite(0.1,0.5),
				\freq, Pexprand(1,25),
				\detune, Pwhite(0.03, 0.2, inf),
				\rqmin, 0.1,
				\rqmax, 0.5,
				\cfmin, 50,
				\cfmax, 2000,
				\atk, 2,
				\sus, 0,
				\rel, Pexprand(3,8),
				\pan, Pwhite(-0.9,0.9),
				\amp, Pexprand(0.05,0.1),
				\group, ~mainGrp,
				\out, ~bus[\fx],
			).play;*/

			4.wait;

			~shakerSustain.stop;
			~drone.stop;
		}).play(AppClock);
	});
};


//================ 4. REGISTER FUNCTIONS ==============//

ServerBoot.add(~makeBuffers);
ServerBoot.add(~makeBusses);
ServerQuit.add(~cleanup);

//================ 5. BOOT SERVER ===================//

s.waitForBoot({
	s.sync;

	SynthDef(\padsynth, {
		arg note = 60, freq=100, rate=2, cutoff=1000, amp=0.1, gate=1, attack = 0.5, decay = 0.3, sustain = 0.5, release = 0.8, mw = 10, out=0;
		var lfo1, lfo2, env, env2, modenv, sig, temp, sum;
		lfo1 = SinOsc.kr(1);
		lfo2 = SinOsc.kr(lfo1, 0, 100, 200);
		env = Env([0, 1, 0.3, 0.8, 0], [2, 3, 1, 4], -2);
		//env = Env([0.1, 0.2, 0.9, 1.0, 0.9, 1.0], [0.05, 0.1, 0.01, 1.0, 1.5], -8);
	    modenv = EnvGen.kr((env),gate);
		sum = 0;
		5.do{
			temp = VarSaw.ar(
				freq* {Rand(0.99, 1.01)} !2,
				0*{Rand(0, 1)} !2,
				{ExpRand(0.005, 0.05)}!2
			);
			sum = sum + temp;
		};
		sum = sum + temp;
	    env2 = EnvGen.kr(Env.adsr(1.0, 0.5, 0.2, 1), gate, doneAction:2);
	    sig = LPF.ar(sum, 20 + lfo2 + mw + 1200) ;
	    env = EnvGen.kr(Env.adsr(attack, decay, sustain, release), gate,doneAction:2); //was gate
	    Out.ar(out, sig * env * amp *0.22);
	}).add;

	SynthDef(\fmSynth, {
		arg note = 60, freq=100, rate=2, cutoff=1000, amp=0.1, gate=1,
		attack = 0.5, decay = 0.3, sustain = 0.5, release = 0.8, mw = 10, out=0;
		var carrfreq, modfreq, carrier, modulator, env, sig;
		carrfreq = freq;
		modfreq = freq*2;
		carrier = SinOsc.ar(carrfreq, 0, 1);
		modulator = SinOsc.ar(modfreq + freq, 0, 0.25, 0.25);
		sig = LPF.ar(carrier*modulator,10000, 0.5)!2;
		env = EnvGen.kr(Env.adsr(attack, decay, sustain, release), gate,doneAction:2); //was gate
		Out.ar(out, sig * env * amp *0.8);// sig*env*amp*0.2;
	}).add;

	SynthDef(\bpfsaw, {
		arg atk=2, sus=0, rel=3, c1=1, c2=(-1), freq=500, detune=0.2, pan=0,
		cfhzmin=0.1, cfhzmax=0.3, cfmin=500, cfmax=2000, rqmin=0.1, rqmax=0.2,
		lsf=200, ldb=0, amp=1, out=0;
		var sig, env;
		env = EnvGen.kr(Env([0,1,1,0], [atk,sus,rel], [c1,0,c2]), doneAction:2);
		sig = Saw.ar(freq * {LFNoise1.kr(0.5, detune).midiratio}!2);
		sig = BPF.ar(
			sig,
			{LFNoise1.kr(
				LFNoise1.kr(4).exprange(cfhzmin, cfhzmax)
			).exprange(cfmin, cfmax) }!2,
			{LFNoise1.kr(0.1).exprange(rqmin, rqmax)}!2
		);
		sig = BLowShelf.ar(sig, lsf, 0.5, ldb);
		sig = Balance2.ar(sig[0], sig[1], pan);
		sig = sig * env * amp;
		Out.ar(out, sig);
	}).add;

	SynthDef(\bass, {
		arg freq = 440, gate = 1, amp = 0.5, slideTime = 0.17, ffreq = 1100, width = 0.15,
		detune = 1.005, preamp = 4, out=0;
		var    sig,
		env = Env.adsr(0.01, 0.3, 0.4, 0.1);
		freq = Lag.kr(freq, slideTime);
		sig = Mix(VarSaw.ar([freq, freq * detune], 0, width, preamp)).distort * amp
		* EnvGen.kr(env, gate, doneAction: 2);
		sig = LPF.ar(sig, ffreq);
		Out.ar(out, sig!2 * 0.4)
	}).add;

	SynthDef(\bpfbuf, {
		arg atk=0, sus=0, rel=3, c1=1, c2=(-1),
		buf=0, rate=1, spos=0, freq=440, rq=1, bpfmix=0,
		pan=0, amp=1, out=0;
		var sig, env;
		env = EnvGen.kr(Env([0,1,1,0],[atk, sus, rel], [c1, 0, c2]),doneAction: 2);
		sig = PlayBuf.ar(2, buf, rate*BufRateScale.ir(buf), startPos: spos);
		sig = XFade2.ar(sig, BPF.ar(sig, freq, rq, 1/rq.sqrt), bpfmix*2-1);
		sig = sig * env;
		sig = Pan2.ar(sig, pan, amp);
		Out.ar(out, sig);
	}).add;

	//run this first
	SynthDef(\crotale, {
		arg midi = ~scale, tone = 3, art = 1.5, amp = 0.8, pan = 0, out=0;
		var env, sig, mod, freq;
		freq = midi.midicps*2;
		env = Env.perc(0, art);
		mod = 1 + (1/IRand(2.0, 2.4));
		sig = PMOsc.ar(freq, mod*freq,
			pmindex: EnvGen.kr(env, timeScale: art, levelScale: tone),
			mul: EnvGen.kr(env, timeScale: art, levelScale: 0.3));
		sig = Pan2.ar(sig, pan);
		sig = sig * EnvGen.kr(env, timeScale: 1.3*art,
			levelScale: Rand(0.1, 0.5), doneAction:2);
		Out.ar(out, sig);
	}).add;

	//============DRUMS================
	SynthDef(\kick, {
		arg amp=1, t_gate=0, buf1=0, freq=200, rate=1, out=0;
		var env, sig;
		env = EnvGen.kr(Env.perc(0.01, 2), t_gate, doneAction:2);
		sig = PlayBuf.ar(2, buf1, BufRateScale.ir(buf1) * rate, doneAction: 2);
		Out.ar(out, sig * amp * 0.7 * env);
	}).add;
	SynthDef(\snare, {
		arg amp=0.2, t_gate=0, buf2=0, rate=1, out=0;
		var env, sig;
		env = EnvGen.kr(Env.perc(0.01, 1), t_gate, doneAction:2);
		sig = PlayBuf.ar(2, buf2, BufRateScale.ir(buf2) * rate, startPos: 0, doneAction: 2);
		Out.ar(out, sig * amp * env);
	}).add;
	SynthDef(\hat, {
		arg amp=0.2, t_gate=0, buf3=0, rate=1, out=0;
		var env, sig;
		env = EnvGen.kr(Env.perc(0.01, 1), t_gate, doneAction:2);
		sig = PlayBuf.ar(2, buf3, BufRateScale.ir(buf3) * rate, startPos: 0); //, doneAction: 2);
		Out.ar(out, sig * amp * env * 0.8);
	}).add;

	SynthDef(\fx, {
		arg in, predelay=0.1, revtime=1.8,
		lpf=4500, mix=0.15, amp=1, out=0;
		var dry, wet, temp, sig;
		dry = In.ar(in,2);
		temp = In.ar(in,2);
		wet = 0;
		temp = DelayN.ar(temp, 0,2, predelay);
		16.do{
			temp = AllpassN.ar(temp, 0.05, {Rand(0.001,0.05)}!2, revtime);
			temp = LPF.ar(temp, lpf);
			wet = wet + temp;
		};
		sig = XFade2.ar(dry, wet, mix*2-1, amp);
		Out.ar(out, sig);
	}).add;


	//s.sync;

	ServerTree.add(~makeNodes);
	ServerTree.add(~makeEvents);
	//s.freeAll;

	//s.sync;

	"Done Setting Up".postln;

});
)

e[\event1].value
e[\event2].value
e
~makeBuffers.()
~makeBusses.()
~makeNodes.()
~makeEvents.()

//There needs to be some event/sequence here to trigger events on and off, based on a clock, rather than using this "free" midi method.

	MIDIdef.noteOn(\noteOn, {
		arg vel, nn;
		case
		{nn==60} {e[\event1].value;"event1".postln;}
		{nn==61} {e[\event2].value;"event2".postln;}
		{nn==62} {e[\event3].value;"event3".postln;}
		{nn==63} {e[\event4].value;"event4".postln;}
		{true} {"wrong!".postln; nil};
	});



 (
~bpm = 80;
~clock = TempoClock(60/~bpm);
~seq =
{

e[\event1].value;

2.0.wait;

e[\event2].value;

}.fork(~clock);
)






(
	~dict = Dictionary.new;
	~dict.add(\event1 -> Pbind(
			\instrument, \fmSynth,
			\dur, 1,
			\stretch, 60/~bpm*2,
			\freq, Pseq([[3, 7, 12 ], [7, 14], 0, [7,15], 0, [2, 7], 10, 2] + ~scale, inf).midicps,
			\dur, Pseq([1, 1], inf),
			\attack, Pseq([0.1, 0.2, 0.1, 0.8], inf),
			\decay, Pseq([1.5, 0.5, 1.5, 0.5], inf),
			\sustain, Pseq([0.8, 0.9, 0.8, 0.9], inf),
			\release, Pseq([0.8, 1.5, 1.0, 1.2], inf),
			\cutoff, Pseq([6000, 500], inf).asStream,
			\amp, Pseq([0.38, 0.43], inf),
			\group, ~mainGrp,
			\out, ~bus[\fx],
	));
)
)


(
~dict = (
	ev1: Pbind(\note, Pseq([1,2])),
	ev2: Pbind(\note, Pseq([10,5])),
);

Pseq([ ~dict.ev1, ~dict.ev2 ]).play
)


// balls...
s.boot;
(
var noBalls = 1000;
var balls = [];
var friction = 0.9;
var width = Window.screenBounds.width, height = Window.screenBounds.height;
var bang = {|pan,velocity,i,size|
i=i.linlin(0,noBalls,8,16);
velocity=velocity.linlin(0,200,0,0.05);
size = size.linlin(0,10,0.1,0.66);
s.sendBundle(0.2,["/s_new", "imp", s.nextNodeID, 0, 0, \pan, pan, \velocity, velocity, \i, i, \size, size])
};

SynthDef(\imp, {|pan,velocity,i,size|
//var dur=0.25;
OffsetOut.ar(0,
Pan2.ar(
SinOsc.ar(66 * i * Line.ar(1,0,size/3).fold(0.5,1)) * velocity *
EnvGen.kr(Env.perc(0,size), doneAction: 2)
,pan)
);
}).add;

noBalls.do{
balls = balls.add(
(xspeed:(30.0.rand-15), yspeed:(6.0.rand-3), x:width * (1.0.rand), y:height * (1.0.rand),
color:Color(1.0.rand,1.0.rand,1,0.33+(0.67.rand)))
)
};
w = Window("ball", Rect(100, 200, width, height));
u = UserView(w, Rect(0, 0, width, height));
u.background = Color.black;
u.animate = true;
u.drawFunc = {
var ft = u.frame/250;

Pen.smoothing_(false);

balls.do{|ball,i|
var size = 10-(i%10+2);

// walls left & right
if(ball[\x]<0 or:{ball[\x]>width }, {
var velocity = ((ball[\xspeed]**2) + (ball[\yspeed]**2))**0.5;
bang.value(ball[\x]/width*2-1,velocity,i,size); // make bounce sound

ball[\xspeed] = 0 - (ball[\xspeed]*friction);
ball[\x] = ball[\x].fold(0,width);

});

// walls up & down
if( (ball[\y]<0)or:{ball[\y]>height}, {
var velocity = ((ball[\xspeed]**2) + (ball[\yspeed]**2))**0.5;
bang.value(ball[\x]/width*2-1,velocity,i,size); // make bounce sound

ball[\yspeed] = 0 - (ball[\yspeed]*friction);
ball[\y] = ball[\y].fold(0,height);

});

// apply acceleration
ball[\yspeed] = ball[\yspeed] + (cos(ft)/2) + (2.0.rand-1);
ball[\xspeed] = ball[\xspeed] + (sin(ft)/2) + (2.0.rand-1);

// apply speed
ball[\x] = ball[\x] + (ball[\xspeed]/40);
ball[\y] = ball[\y] + (ball[\yspeed]/40);

Pen.fillColor = ball[\color];
Pen.fillOval(Rect.aboutPoint(Point(ball[\x], ball[\y]), size, size));

};

};
w.front;
w.fullScreen;
)
