
~t = 160/4/60; TempoClock.default.tempo = ~t;

// Rumush
// Facebook: https://www.facebook.com/rumushproduction
// SoundCloud: https://soundcloud.com/rumushproduction
// YouTube: https://www.youtube.com/channel/UCs_Cn1R4iFrYOyc8liFucSQ
// Blog: https://mycelialcordsblog.wordpress.com/
// GitHub: https://github.com/RumushMycelialCords
(
Ndef(\rumush,{
	//I've prepared a couple of arguments to qucikly change the sound, but don't hesitate to add more
	/*
	tempo= lfos and delay time, dist= max distortion, octRange= octave range, octOffset= first degree,
	filtSpeef = speed of LPF modulation by LFTri, delLen= how many 4th notes the delay lasts (0 to 16),
	grainDur= max duration of a grain, grainSpeed= max speed of Impulse multiplied by tempo
	*/
	arg xtempo = 0.5, dist=0.05, octRange=3, octOffset=24, filtSpeed=0.5, delLen=4, grainDur=0.25, grainSpeed=128;
	var lfo1, winenv, env, scale, note, degreeNum, src, loc;
	var tempo = xtempo;
	lfo1 = {arg rt,lw,hg,rd; LFNoise0.ar(rt).range(lw,hg).round(rd)};//Arguments - Rate, Lowest Value, Highest Value, Round
	/*
	Pitch Control
	*/
	scale = Scale.melodicMinor; //Sets the scale
	degreeNum = scale.size-1; //Gets the number of degrees for the scale, I subtract 1 because the lfo works from 0.
	note = DegreeToKey.ar(scale.as(LocalBuf),
		lfo1.(tempo*2,0,degreeNum*octRange,lfo1.(tempo/2,1,7,1)),//lfo1.(rate=2,lowNum=0,highNum=degreeNum*4(4 octaves),round=another lfo)
		scale.stepsPerOctave,1,octOffset).midicps;
	/*
	Source
	*/
	winenv = Env([0,0.5,0.25,1,0],[0.5,0.25,0.5],[8,-8]);
	env = Buffer.sendCollection(s,winenv.discretize,1);
	src = GrainSin.ar(2,
		Impulse.ar(lfo1.(tempo/4,tempo*(grainSpeed/8),tempo*grainSpeed,tempo)),
		lfo1.(tempo*3,grainDur/16,grainDur,grainDur/16),note,lfo1.(tempo*4,-1,1,0.1),
		env, 1024, 0.5);
	/*
	Feedback
	*/
	loc = LocalIn.ar(2)+src;
	loc = DelayL.ar(loc,1/tempo*4,1/tempo*delLen); //delLen 4th Notes at a given tempo (90BPM in this case)
	loc = loc + //Loc + Filtered/FrequencyShifted/Distorted Loc Parameters are modulated with lfo1 function (LFNoise0)
	LPF.ar(
		FreqShift.ar(
			((loc*lfo1.(tempo*2,1,25,1)).softclip*LFSaw.ar(tempo/16,0,dist).abs)
			,lfo1.(tempo/4,-1,1,1)*note*4),
		3000);
	loc = LPF.ar(loc, LFTri.ar(tempo*filtSpeed,100,9500,0.2500).abs); //Simple Low Pass Filter, Freq controlled by Triangle Wave
	2.do{loc = AllpassC.ar(loc,0.5,LFNoise1.ar(0.005!2,0.05,0.125).abs,1)}; //Higher/Lower 'do' value will result in more/less noisy sound
	loc = LeakDC.ar(loc);

	LocalOut.ar(loc*1.25);
	Limiter.ar(loc*2)*0.95 * 0.2;
}).play
)
Ndef(\rumush).edit
Ndef(\rumush).play
Ndef(\rumush).clear
TempoSpec

(
Ndef(\rumush,{
	//I've prepared a couple of arguments to qucikly change the sound, but don't hesitate to add more
	/*
	tempo= lfos and delay time, dist= max distortion, octRange= octave range, octOffset= first degree,
	filtSpeef = speed of LPF modulation by LFTri, delLen= how many 4th notes the delay lasts (0 to 16),
	grainDur= max duration of a grain, grainSpeed= max speed of Impulse multiplied by tempo
	*/
	arg xtempo = 0.5, dist=0.05, octRange=3, octOffset=24, filtSpeed=0.5, delLen=4, grainDur=0.25, grainSpeed=128;
	var lfo1, winenv, env, scale, note, degreeNum, src, loc;
	var tempo = xtempo;
	lfo1 = {arg rt,lw,hg,rd; LFNoise0.ar(rt).range(lw,hg).round(rd)};//Arguments - Rate, Lowest Value, Highest Value, Round
	/*
	Pitch Control
	*/
	scale = Scale.melodicMinor; //Sets the scale
	degreeNum = scale.size-1; //Gets the number of degrees for the scale, I subtract 1 because the lfo works from 0.
	note = DegreeToKey.ar(scale.as(LocalBuf),
		lfo1.(tempo*2,0,degreeNum*octRange,lfo1.(tempo/2,1,7,1)),//lfo1.(rate=2,lowNum=0,highNum=degreeNum*4(4 octaves),round=another lfo)
		scale.stepsPerOctave,1,octOffset).midicps;
	/*
	Source
	*/
	winenv = Env([0,0.5,0.25,1,0],[0.5,0.25,0.5],[8,-8]);
	env = Buffer.sendCollection(s,winenv.discretize,1);
	src = GrainSin.ar(2,
		Impulse.ar(lfo1.(tempo/4,tempo*(grainSpeed/8),tempo*grainSpeed,tempo)),
		lfo1.(tempo*3,grainDur/16,grainDur,grainDur/16),note,lfo1.(tempo*4,-1,1,0.1),
		env, 1024, 0.5);
	/*
	Feedback
	*/
	loc = src;
	Limiter.ar(loc*2)*0.95 * 0.2;
}).play
)


(
SynthDef(\passback, { arg out=0, gate=1, xtempo = 0.5, dist=0.05, octRange=3, octOffset=24, filtSpeed=0.5, delLen=4, grainDur=0.25, grainSpeed=128;
	var sig;
	var lfo1, winenv, env, scale, note, degreeNum, src, loc;
	var tempo = xtempo;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	lfo1 = {arg rt,lw,hg,rd; LFNoise0.ar(rt).range(lw,hg).round(rd)};//Arguments - Rate, Lowest Value, Highest Value, Round
	scale = Scale.melodicMinor; //Sets the scale
	degreeNum = scale.size-1; //Gets the number of degrees for the scale, I subtract 1 because the lfo works from 0.
	note = DegreeToKey.ar(scale.as(LocalBuf),
		lfo1.(tempo*2,0,degreeNum*octRange,lfo1.(tempo/2,1,7,1)),//lfo1.(rate=2,lowNum=0,highNum=degreeNum*4(4 octaves),round=another lfo)
		scale.stepsPerOctave,1,octOffset).midicps;
	sig = in;
	loc = LocalIn.ar(2)+sig;
	loc = DelayL.ar(loc,1/tempo*4,1/tempo*delLen); //delLen 4th Notes at a given tempo (90BPM in this case)
	loc = loc + //Loc + Filtered/FrequencyShifted/Distorted Loc Parameters are modulated with lfo1 function (LFNoise0)
	LPF.ar(
		FreqShift.ar(
			((loc*lfo1.(tempo*2,1,25,1)).softclip*LFSaw.ar(tempo/16,0,dist).abs)
			,lfo1.(tempo/4,-1,1,1)*note*4),
		3000);
	loc = LPF.ar(loc, LFTri.ar(tempo*filtSpeed,100,9500,0.2500).abs); //Simple Low Pass Filter, Freq controlled by Triangle Wave
	2.do{loc = AllpassC.ar(loc,0.5,LFNoise1.ar(0.005!2,0.05,0.125).abs,1)}; //Higher/Lower 'do' value will result in more/less noisy sound
	loc = LeakDC.ar(loc);

	LocalOut.ar(loc*\fb.kr(1.25));
	sig = Limiter.ar(loc*2)*0.95 * 0.2;
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\passpers, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = LocalIn.ar(2)+sig;
	//sig = DelayL.ar(sig, 0.5,\delay.kr(0.1))+sig;
	4.do{sig = AllpassC.ar(sig,0.5,LFNoise1.ar(0.005!2 * \allpassf.kr(200),0.05,0.125)  * \allpassf.kr(200) + 1 * \apdelay.kr(1),1) + sig};

	sig = FreqShift.ar(sig, LFNoise1.kr(1/22 * \freqshift_noisefreq.kr(1)) * \freqshift_fac.kr(0.6) + 1 * \freqshift.kr(100));

	sig = LeakDC.ar(sig);
	LocalOut.ar(sig*\fb.kr(1.25));

	sig = Limiter.ar(sig*2)*0.95 * 0.2;
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\passpers, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = LocalIn.ar(2)+sig;
	//sig = DelayL.ar(sig, 0.5,\delay.kr(0.1))+sig;
	4.do{sig = AllpassC.ar(sig,0.5,LFNoise1.ar(0.005!2 * \allpassfac.kr(200),0.05,0.125).abs,1) + sig};

	sig = FreqShift.ar(sig, LFNoise1.kr(1/22).range(-100.0,100.0));

	sig = LeakDC.ar(sig);
	LocalOut.ar(sig*\fb.kr(1.25));

	sig = Limiter.ar(sig*2)*0.95 * 0.2;
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
);

TagSpecDef(\SynthDef_fx).addUnique(\passpers)

Ndef(\passback).source = \passback
Ndef(\passback).edit
Ndef(\passback).set(\inbus, BusDef(\sendbus1, \audio))

Ndef(\passpers).source = \passpers
Ndef(\passpers).edit
Ndef(\passpers).set(\inbus, BusDef(\sendbus1, \audio))
Ndef(\passpers).play

Ndef(\passpers2).source = \passpers
Ndef(\passpers2).edit
Ndef(\passpers2).set(\inbus, BusDef(\sendbus2, \audio))
Ndef(\passpers2).play
Ndef(\fx2).clear
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				0,1,3,5,
			],inf),
			\isRest, Pseq([
			   	0.40,0.40,0.40,0.40,
				1,0.40,0.40,0.40,
			],inf).coin.not,
			\dur, 1/4,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[7].value,
			\isRest, Pseq([
				Prand([
					Pseq([
						1,0,
					],1),
					Pseq([
						1,0,0,
					],1),
				],1),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				0,-1,
			],inf),
			\octave, 3,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		
	])
)).play;
);

(
Pdef(\part2, Pdef(\zedpart2, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/feynman.flac'),
			\dur, 1,
			\gain, 1,
			\out, BusDef(\sendbus1, \audio),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
		)
		
	])
)).play;
);


(
Pdef(\part2, Pdef(\zedpart2, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\isRest, Pseq([
				Pfin(16,Prand([
					Pseq([
						1,0,0,0,
					],1),
					Pseq([
						1,0,
					],1),
					Pseq([
						1,0,
					],1),
					Pseq([
						1,0,0,
					],1),
				],inf)),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		
	])
)).play;
);
Pdef(\part2).clear;

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\sendbus1, \audio),
		),
		
	])
)).play;
);

(
Pdef(\part3, Pdef(\zedpart3, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1,
			\st, 92.10/4/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 0.1, 1,
			],1),1).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1,
			\out, BusDef(\sendbus2, \audio),
		)
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[732].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				0,0,0,0, 0,0,0,1,
				1,0,0,1, 0,0,1,0,
				0,0,0,0, 0,0,0,1,
				1,0,0,0, 1,0,1,0,
				1,0,0,0, 0,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\fx2, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2113].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\fx1, \audio),
		),
		
	])
)).play;
);

(
Pdef(\part3, Pdef(\zedpart3, 
	Ppar([

		Pbind(
			\instrument, \nappy,
			\note, Pseq([
				0,
				-1,
			],inf),
			\octave,5,
			//\lpfr, ~pmodenv.(Pseq([1,2,1,4]+18,1), 8).loop,
			\lpf, ~pmodenv.(Pseq([300,1200]+18,1), 8).loop,
			\lfo1range, ~pmodenv.(Pseq([0,0.0001],1), 8).loop,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,2.1) ],
			],inf),
			\chord, Pseq([
				[ [0,3,7,9].midiratio ],
				[ [0,3,7,10].midiratio ],
			],inf),
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\sendbus2, \audio),
		),
		
	])
)).play;
);

(
SynthDef(\nappy, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var cfreq = freq * \chord.kr(1!4);
	var num = 4 * 2 * 5;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var amps;
	//freq.poll(label:"freq");
	lfo1 = SinOsc.kr(0.1) * 0.001 * \lfo1range.kr(1);
	lfo3 = LFNoise1.kr(0.1!num).range(0.3,3); 
	lfo5 = LFNoise1.kr(0.1!num).range(0.3,0.7); 
	lfo2 = EnvGen.kr(Env([1,1.2,1],[0.1,1.8]), 1, timeScale: lfo3, levelScale: lfo5);
	lfo4 = EnvGen.kr(Env([1,2,1],[0.7,0.8]), 1, timeScale: lfo3);
	cfreq = cfreq *.x [1 - lfo1,1 + lfo1] * [ [1/2,1,2,7,9] ];
	amps = [0.6,1,0.6,0.1,0.1];
	cfreq.debug("cfreq");
	sig = SelectX.ar( LFNoise1.kr(1/2!num).range(0.0,1.0) ,[
		SinOsc.ar(cfreq) * amps,
		LFSaw.ar(cfreq) * amps,
	].collect(_.flatten)) * 5;
	sig.debug("sig");
	//sig = sig * ( SinOsc.ar(freq/2 * ( SinOsc.ar(freq/4 + Rand(0.0,1!sig.size)) * 0.71 + 1 )) * 0.7 + 1 );
	sig = sig * sig.fold( ( SinOsc.kr(0.11) * 0.1 + 1 ).neg, ( SinOsc.kr(0.3) * 1 + 1 ) );
	//sig = RLPF.ar(sig, ( \lpfr.kr(1.1) * freq * lfo2 ).poll, \rq.kr(0.5) * lfo4);
	sig = RLPF.ar(sig, ( \lpf.kr(10001.1) * lfo2 ).clip(10,20000), \rq.kr(0.5) * lfo4);
	sig = HPF.ar(sig,\hpf.kr(30));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	pan = pan + LFNoise1.kr(0.1!sig.size);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);

NoteTimeline(\notes).edit
NoteTimeline(\notes).stop
NoteTimeline(\notes3, Pdef(\notes1)).edit
NoteTimeline(\notes2, Pdef(\notes)).edit

(
Pdef(\notes, 
	Pbind(
		\instrument, \bilin,
		\oscmix, Pseq([0,1/2,1,Pwhite(0,1.0,1)],inf),
		\amp, 0.1,
	)
).play;
);

(
Pdef(\notes1, 
	Pbind(
		\instrument, \chordb,
		\amp, 0.1,
	)
).play;
);


SynthDef(\bilin, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq * [1,2,1/2] * (\bilintab.kr({ 1.0.bilinrand }!100) * \fspread.kr(0.01) + 1);
	sig = sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = SinOsc.ar(freq);
	sig = SelectX.ar(\oscmix.kr(0.5)*2, [sig1, sig2, sig3]);
	//sig = LFSaw.ar(freq * [1,2,1/2] * ({ 1.0.bilinrand }!100 * 0.01 + 1)).clump(2).mean;
	sig = sig.clump(2).mean;
	sig.debug("sig");
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
	Out.ar(out, sig);
}, metadata:(specs:(
	oscmix: \unipolar,
	fspread: ControlSpec(0.001,0.2,\exp),
))).add;

SynthDef(\chordb, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = {arg x; 
		var isig;
		var ffac = 8;
		isig = LFSaw.ar( freq/2 * x + ExpRand(freq/64,2*freq/64));
		isig = isig + LFPulse.ar( freq/ffac * x + ExpRand(freq/64/ffac,2*freq/64/ffac));

		isig = RLPF.ar(isig, freq/2 * x + ExpRand(freq/64,2*freq/64)* LFNoise1.kr(1/4).range(1.1,1) * \lpffac.kr(2) , \rq.kr(0.5));
	}!5;
	sig = sig.scramble;
	sig = TScramble.ar(sig, Impulse.kr(4),1);
	//sig = FreqShift.ar(sig, 4 * SinOsc.kr(1/45).range(0,1)) + sig;
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(1.01,0.1,1,1.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan) / 5;
	Out.ar(out, sig);
}).add;
