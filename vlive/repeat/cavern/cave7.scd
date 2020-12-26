(
~t = 124/4/60; TempoClock.default.tempo = ~t;
~master = {
	ProtoDef(\FxManager).play;
};
~master.();

BusDef(\bus0,\audio);
BusDef(\bus1,\audio);
BusDef(\bus2,\audio);
BusDef(\bus3,\audio);
)

(
SynthDef(\bolonvib, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var num = 50;
	var ofreq = freq;
	freq = freq * [1,2,1/2] * (\bilintab.kr({ 1.0.bilinrand }!num) * \fspread.kr(0.01) + 1);
	sig = sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = SinOsc.ar(freq);
	sig = SelectX.ar(( \oscmix.kr(0.5)*\oscmixtab.kr(1!num) ).wrap(0,1)*2, [sig1, sig2, sig3]);
	//sig = LFSaw.ar(freq * [1,2,1/2] * ({ 1.0.bilinrand }!100 * 0.01 + 1)).clump(2).mean;
	sig = sig.clump(2).mean;
	sig.debug("sig");
	sig1 = RHPF.ar(sig, \lpfr.kr(1.1) * ofreq * ( SinOsc.kr(\lplfofreq.kr(16*~t)) * \lplfofac.kr(0.11) + 1 ), \rq.kr(0.5));
	sig = SelectX.ar(\lpmix.kr(1), [sig, sig1]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp * \modamp.kr(1);
	Out.ar(out, sig);
}, metadata:(specs:(
	oscmix: \unipolar,
	fspread: ControlSpec(0.001,0.2,\exp),
))).add;
SynthDef(\organ_donorenv,{|out= 0 freq = 440 amp = 0.2 gate=1 lforate = 10 lfowidth= 0.0 cutoff= 100 rq=0.5 pan=0.0|

	//Simulation of transistor organ from Steal This Sound
	var vibrato, pulse, filter, env;
	var envcutoff;
	var filtermixenv;
	var vibratofilter;
	envcutoff = EnvGen.kr(\envcutoff.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:0);
	filtermixenv = EnvGen.kr(\filtermixenv.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:0);

	vibrato = SinOsc.ar(lforate,Rand(0,2.0));
	vibratofilter = SinOsc.ar(\lforatefilter.kr(16*~t),Rand(0,2.0));

	//up octave, detune by 4 cents
	//11.96.midiratio = 1.9953843530485
	//up octave and a half, detune up by 10 cents
	//19.10.midiratio = 3.0139733629359

	//Pulse version
	//pulse = Mix(Pulse.ar(([1,1.9953843530485,3.0139733629359]*freq)*(1.0+(lfowidth*vibrato)),Rand(0.4,0.6)!3,[1.0,0.7,0.3]))*0.5;

	//better alternative
	pulse = Mix(VarSaw.ar((
		[
			//1,1.9953843530485,3.0139733629359
			1,6.99.midiratio, 19.10.midiratio,
		]
		* freq)*(1.0+(lfowidth*vibrato)),Rand(0.0,1.0)!3,Rand(0.3,0.5)!3,[1.0,0.7,0.3]))*0.5;

	filter = MoogFF.ar(pulse,(vibratofilter *  \lfowidthfilter.kr(0.1) + 1) * \cutoffamt.kr(1.1) * freq * ( envcutoff * \envcutoffamt.kr(0.21) + 1 ) ,1/rq)*2;
	filter = SelectX.ar(\filtermix.kr(0.6) * ( filtermixenv * \filtermixenvamt.kr(0.7) + 1 ), [pulse, filter]);
	filter = filter * 1.7;

	//env = EnvGen.ar(Env.adsr(0.01,0.5,1.0,0.5),gate,doneAction:2);
	env = EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.5,0.8,0.5)), gate, doneAction:2);

	Out.ar(out,Pan2.ar(filter*env*amp,pan));

//By Nick Collins, from Mitchell Sigman (2011) Steal this Sound
//http://www.sussex.ac.uk/Users/nc81/index.html
}, metadata:(specs:(
	filtermixenv: ParamEnvSpec.new,
	envcutoff: ParamEnvSpec.new,
))).add;
SynthDef(\grainephasor, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, pitch_stretch=1, pos=0, gdur=0.1, mbufnum=0, rate=1;
	var sig;
	var clk = Impulse.ar(\gfreq.kr(1));
	var phasor = Phasor.ar(\phasortrig.tr(1), rate / s.sampleRate,pos,\endpos.kr(1) % BufDur.kr(mbufnum), resetPos:\resetPos.kr(0));
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch,  phasor % BufDur.kr(mbufnum), gdur, pan, 1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

SynthDef(\chordmito, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	freq = freq * [1,2,3/2];
	sig = LFCub.ar(freq * ((0..7)/7 - 0.5 * \fspread.kr(0.01) + 1)) * [1,1/2,1/3];
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan + LFNoise1.kr(1), amp).mean;
	sig.debug("sig");
	Out.ar(out, sig);
}).add;

SynthDef(\chordmito2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq * [1,2,3/2];
	sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = SinOsc.ar(freq);
	sig = SelectX.ar(\oscmix.kr(0.5)*2, [sig1, sig2, sig3]);
	sig = LFCub.ar(freq * ((0..7)/7 - 0.5 * \fspread.kr(0.01) + 1)) * [1,1/2,1/3];
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan + LFNoise1.kr(1), amp).mean;
	sig.debug("sig");
	Out.ar(out, sig);
}).add;

SynthDef(\chordmito2hpf, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq * [1,2,3/2];
	sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = SinOsc.ar(freq);
	sig = SelectX.ar(\oscmix.kr(0.5)* LFNoise1.kr(1/2!sig1.size).range(0.5,1.5)*2, [sig1, sig2, sig3]);
	sig = LFCub.ar(freq * ((0..7)/7 - 0.5 * \fspread.kr(0.01) + 1)) * [1,1/2,1/3];
	sig = RHPF.ar(sig, \hpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan + LFNoise1.kr(1), amp).mean;
	sig.debug("sig");
	Out.ar(out, sig);
}).add;

SynthDef(\peaky, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq * [1,2,3/2,19.10.midiratio];
	sig = LFPulse.ar(freq * ((0..7)/7 - 0.5 * \fspread.kr(0.01) * [ [1,1.01] ] + 1)) * [1,1/2,1/3,1/4];
	sig2 = LFSaw.ar(freq * ((0..7)/7 - 0.5 * \fspread.kr(0.01) * [ [1,1.01] ] + 1)) * [1,1/2,1/3,1/4];
	sig.debug("sig1");
	sig = SelectX.ar( LFNoise1.kr(1!sig.size).range(0.0,1.0), [sig,sig2]);
	sig.debug("sig2");
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig1 = BPF.ar(sig, LFNoise1.kr(1/2!4).range(0.2,4.0) * freq, \bprq.kr(0.9));
	sig = sig ++ sig1;
	sig = sig * ( LFNoise1.kr(1!sig.size).range(0,1) * 1  );
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig.mean.debug("sig");
	sig = sig * amp * \modamp.kr(1);
	//sig = Pan2.ar(sig, pan + LFNoise1.kr(1), amp).mean;
	Out.ar(out, sig);
}).add;

SynthDef(\hasher, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.01)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
SynthDef(\bilinvibrond, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var num = 50;
	//freq = freq * [1,2,1/2,4] * (\bilintab.kr({ 1.0.bilinrand }!num) * \fspread.kr(0.01) + 1);
	//sig = sig1 = LFSaw.ar(freq);
	//sig2 = LFPulse.ar(freq);
	//sig3 = SinOsc.ar(freq);
	//sig = SelectX.ar(( \oscmix.kr(0.5)*\oscmixtab.kr(1!num) ).wrap(0,1)*2, [sig1, sig2, sig3]);
	sig = LFPulse.ar(freq * [1,1.001,1.001,1/2,2,2.001,3,3.001].mirror1) * ( 1/[1,1.001,1.001,2,2,2.001,3,3.001].cubed.cubed ).mirror1;
	//sig = LFSaw.ar(freq * [1,2,1/2] * ({ 1.0.bilinrand }!100 * 0.01 + 1)).clump(2).mean;
	//sig = sig.clump(2).mean;
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	sig.debug("sig");
	sig1 = RLPF.ar(sig, \lpfr.kr(1.1) * freq * ( SinOsc.kr(\lplfofreq.kr(16*~t)) * \lplfofac.kr(0.11) + 1 ), \rq.kr(0.5));
	sig2 = BPF.ar(sig, freq * -5.midicps);
	sig = SelectX.ar(\lpmix.kr(1), [sig2, sig1]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp * \modamp.kr(1);
	Out.ar(out, sig);
}, metadata:(specs:(
	oscmix: \unipolar,
	fspread: ControlSpec(0.001,0.2,\exp),
))).add;
);

// FX manager config

(
ProtoDef('rdn').inbus = BusDef('sendbus1');
ProtoDef('rdn').outBus = 0;
ProtoDef('rdn').make('deldefault', 'rdn', "5-U7S3-FT52", BusDef('sendbus1'));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.61764705882353,
	'gain', 0.53445378151261,
	'fb', 0.0001,
	'delay', 0.0001,
	'delay2', 0.0001,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 0.45233707447721,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 1.0259630501905,
	'fbdistmix', 0.0,
	'postlpf', 15855.854778901,
	'posthpf', 17,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
	'distamp3', 3.9466141732283,
	'brfrqfac', 0.37940593233798,
	'brffac', 0.60195390291997,
	'shift3', -2.4789915966387,
	'shiftmix', 0.0,
	'stereo', 0.0,
	'delay3', 0.0001,
	'distamp2', 3.9466141732283,
).keep(1));


Ndef('fx1').source = 'fx_freeverb2';
PlayerWrapper(Ndef('fx1')).outBus = 0;
Ndef('fx1').set('inbus', BusDef('sendbus1'));
Ndef('fx1').set('verbmix', 1.0);
Ndef('fx1').set('room', 0.5);
Ndef('fx1').set('damp', 0.1);
Ndef('fx1').set('mix', 0.15656565656566);
Ndef('fx1').set('gain', 1.0);

Ndef('fx2').source = 'fx_freeverb2';
PlayerWrapper(Ndef('fx2')).outBus = 0;
Ndef('fx2').set('inbus', BusDef('sendbus2'));
Ndef('fx2').set('verbmix', 0.50505050505051);
Ndef('fx2').set('room', 1.4165561271907);
Ndef('fx2').set('damp', 2.0505532865581);
Ndef('fx2').set('mix', 0.71212121212121);
Ndef('fx2').set('gain', 1.0);

Ndef('fx3').source = nil;
PlayerWrapper(Ndef('fx3')).outBus = 0;


Ndef('fx4').source = nil;
PlayerWrapper(Ndef('fx4')).outBus = 0;


);


/////////////////////////


(
	~master.();
// drums coin 0.7 + acid bass + widechord + hi
Pdef(\part, Pdef(\intro, 
	Ppar([
		Psched(0,Pmono(
			\bilinvibrond,
			//\note, Pseq([
				//2,0,
			//],inf),
			\degree, Pstep(Pwhite(0,7),Prand([Pseq([1/8],8),1,2,4],inf)),
			\degree, Prand([0,2,4],inf),

			\note, Prand([
				Pseq([ 11,10,7,6,5,4,2,1 ],1),
				Pseq([ 11,10,7,6,5,4,2,1 ]-12,1),
			],inf),
			\ctranspose, 5,
			\octave, 6,
			//\dur, PdurStutter(Pseq([1,4],inf), 4),

			\oscmixtab, Plazy({
				Pseq([
					[ { 0.1.bilinrand+1 }!100 ],
				],1);
			}).loop,
			\fspread, ~pmodenv.(Pseq([0.005,0.01],inf), Pwhite(1.0,8,inf)),
			\lplfofac, ~pmodenv.(Pseq([0.5,0.05,0.8,0.1]/4,inf), Pwhite(1,7.0)),
			\oscmix, Pseq([0,1/2,1,Pwhite(0,1.0,1)],inf),

			\modamp, ~pmodenv.(Pseq([0.4,1,0.02,1,0.1,1.4],inf), Pwhite(1/2,4), 1, -4),
			\oscmix, ~pmodenv.(Pseq([0.01,0.3,Pwhite(0,0.4,1)],inf), Pwhite(0.5,7)),
			\lpfr, ~pmodenv.(Pseq([2,4],inf), Pwhite(1.0/8,8)),
			\rq, 0.4,
			\lpmix, ~pmodenv.(Pseq([1,2,1,4]/4,inf), Pwhite(1.0/8,8)),
			\lpmix,1,
			\adsr, Pseq([
				[ Env.adsr(1.4,0.1,0.8,2.1) ],
			],inf),
			\dur, Pwrand([1/8,1/4,1],[1,2,3].cubed.normalizeSum,inf),
			\amp, 0.1/2,
			\pan, Pseq([1,-1],inf),
			\out, BusDef(\sendbus2, \audio),
			\amp, 0.12,
		)),
		Psched(4,Pbind(
			\instrument, \bolonvib,
			//\note, Pseq([
				//( { rrand(0,12) }!5 ).postln,
				//( { rrand(0,12) }!5 ).postln,
				//( { rrand(0,12) }!5 ).postln,
			//].collect({ arg x;
				//x
			//}),inf).stutter(1),
			\note, Pseq([
				[ 1,  5, 11, 2  ],
				[ 6,  4, 7, 5  ],
				[ 10,  4, 1, 5  ],
			],inf),
			\ctranspose, 5,
			\oscmixtab, Plazy({
				Pseq([
					[ { 0.1.bilinrand+1 }!100 ],
				],1);
			}).loop,
			\octave, 4,
			\rq, 0.4,
			\fspread, ~pmodenv.(Pseq([1,0.005, Pseq([0.005,0.007],inf)],inf), Pseq([1],inf)),
			\adsr, Pseq([
				[ Env.adsr(0.49,0.1,0.8,0.1) ],
			],inf),
			\lplfofac, ~pmodenv.(Pseq([0.5,0.05,0.8,0.1]/4,inf), Pwhite(1,7.0)),
			\lpfr, ~pmodenv.(Pseq([2,1.2,1.4]/2,inf), Pseq([1],inf)),
			\legato, 1.0,
			\lpmix, 1,
			\oscmix, Pseq([0,1/2,1,Pwhite(0,1.0,1)],inf),
			\oscmix, ~pmodenv.(Pseq([0.5,0.7],inf), Pseq([1],inf)),
			\dur, Pseq([1/2,1,1/2],inf),
			\amp, 0.1/2,
			\out, BusDef(\sendbus2, \audio),
			\out, 0,
		)),
		
	])
)).play;
);

(
// nokick, drums coin 0.7 + acid bass + widechord + hi
Pdef(\part, Pdef(\intro2, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[673].value,
			\legato,2,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.11,
			\out, BusDef(\movefil, \audio),
		),
		Psched(0,Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[673].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1168].value,
			\legato,1,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				],2),
				Pseq([
					1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1,
				]*0.7,4),
				Pseq([
					1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1,
				]*0.3,2),
			],inf).coin.not,
			\pan, 1,
			\dur, 1/16,
			\gain, 0.11,
			\out, BusDef(\movefil, \audio),
		)),
		Psched(0,Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[19].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\bufnum, ~buflib.clap[49].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
				Pseq([
					1,1,2,1, 2,1,1,1,
					2,1,1,1, 1,1,2,1,
				]*0.7,4),
				Pseq([
					1,1,2,1, 2,1,1,1,
					2,1,1,1, 1,1,2,1,
				]*0.4,2),
			],inf).coin.not,
			\dur, 1/16,
			\lag, 1/32,
			\gain, 0.11,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.4,0.1) ],
			],inf),
			\sustain, 0.02 * Prand([1,1.33,1,0.7],inf),
			\gain, 0.07 * Pseq([1,0.3,0.7],inf),
			\out, BusDef(\movefil, \audio),
		)),
		Pmono(\fx_rlpfrhpf,
			\inbus, BusDef(\movefil, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			//\lpf, ~pmodenv.(Pexprand(1000.0,17000,inf), Pwhite(2.0,8)),
			\lpf, 19000,
			//\hpf, ~pmodenv.(Pexprand(1.0,10000,inf), Pwhite(2.0,8)),
			\hpf, ~pmodenv.(Pseq([17000,Pseq([20],inf)],inf), 4),
			\dur, 1,
		),
		//PschedMute(Pseq([0,7,1,0],inf)) <>
		Pbind(
			\instrument, \basicbass,
			\note, Pstep(Pseq([
				2,6,6,10,
				5,4,4,10,
				7,2,2,10,
				11,7,7,10,
			],inf),1/2),
			\ctranspose, 5,
			\legato, Pseq([
				Prand([
					//Pseq([
						//2,0,0,
					//],1),
					//Pseq([
						//3,0,0,
					//],1),
					Pseq([
						1/2,1/2,
					],1),
					Pseq([
						1/2,1/2,
					],1),
					Pseq([
						1/2,1/2,
					],1),
					Pseq([
						1,0,
					],1),
					Pseq([
						2,0,
					],1),
				],1),
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.01) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\lpf, ~pmodenv.(Pseq([3,110,200,400,1000,8000,120,120],1), Pseq([1.1],inf)).loop,
			\rq, ~pmodenv.(Pseq([0.8,0.5,0.3,0.1],1), Pseq([2],inf)).loop,
			\octave, 2,
			\dur, 1/8,
			\dur, PdurStutter(Pseq([8,8,8,8, 8,8,8,4],inf), 1/2),
			\amp, ~pmodenv.(Pseq([0,0.5,0.7,1]*0.1,1), 4).loop,
		),
		Pbind(
			\instrument, \organ_donorenv,
			//\note, Pseq([
				//( { rrand(0,12) }!5 ).postln,
				//( { rrand(0,12) }!5 ).postln,
				//( { rrand(0,12) }!5 ).postln,
			//].collect({ arg x;
				//x
			//}),inf).stutter(1),
			\note, Pseq([
				[ 1,  5, 11, 2  ],
				[ 6,  4, 7, 5  ],
				[ 10,  4, 1, 5  ],
			],inf).collect({ arg x; x.choose }),
			\ctranspose, 5,
			\oscmixtab, Plazy({
				Pseq([
					[ { 0.1.bilinrand+1 }!100 ],
				],1);
			}).loop,
			\octave, 6,
			\rq, 0.5,
			\fspread, ~pmodenv.(Pseq([0.05,0.001,0.005,0.001,0.02],inf), Pwhite(0.7,4)),
			\adsr, Pseq([
				[ Env.adsr(0.09,0.1,0.2,0.1) ],
			],inf),
			\legato, 0.5,
			\lplfofac, ~pmodenv.(Pseq([0.5,0.05,0.8,0.1]/4,inf), Pwhite(1,7.0)),
			\lpfr, ~pmodenv.(Pseq([0.1,2,1.2,4],inf), Pwhite(1.0,7)),
			\legato, 1.0,
			\oscmix, Pseq([0,1/2,1,Pwhite(0,1.0,1)],inf),
			\oscmix, ~pmodenv.(Pseq([0.8,1/2,0.6,Pwhite(0,1.0,1)],inf), Pwhite(0.5,7)),
			\dur, Pseq([1/2,1,1/2],inf),
			\amp, 0.1/6,
			\dur, PdurStutter(Pseq([1,4,2,8],inf), 1/2),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\out, 0,
			\out, BusDef(\sendbus2, \audio),
			\isRest, true,
		),
		Pbind(
			\instrument, \bolonvib,
			//\note, Pseq([
				//( { rrand(0,12) }!5 ).postln,
				//( { rrand(0,12) }!5 ).postln,
				//( { rrand(0,12) }!5 ).postln,
			//].collect({ arg x;
				//x
			//}),inf).stutter(1),
			\note, Pseq([
				[ 1,  5, 11, 2  ],
				[ 6,  4, 7, 5  ],
				[ 10,  4, 1, 5  ],
			],inf),
			\ctranspose, 5,
			\oscmixtab, Plazy({
				Pseq([
					[ { 0.1.bilinrand+1 }!100 ],
				],1);
			}).loop,
			\octave, 5,
			\rq, 0.2,
			\fspread, ~pmodenv.(Pseq([0.05,0.001,0.005,0.001,0.02],inf), Pwhite(0.7,4)),
			\adsr, Pseq([
				[ Env.adsr(0.09,0.1,0.8,0.1) ],
			],inf),
			\lplfofac, ~pmodenv.(Pseq([0.5,0.05,0.8,0.1]/4,inf), Pwhite(1,7.0)),
			\lpfr, ~pmodenv.(Pseq([0.1,2,1.2,4],inf), Pwhite(1.0,7)),
			\legato, 1.0,
			\oscmix, Pseq([0,1/2,1,Pwhite(0,1.0,1)],inf),
			\oscmix, ~pmodenv.(Pseq([0.0,1/2,0.6,Pwhite(0,1.0,1)],inf), Pwhite(0.5,7)),
			\dur, Pseq([1/2,1,1/2],inf),
			\amp, 0.1/2,
			\out, 0,
			\out, BusDef(\sendbus2, \audio),
		),
		Psched(8,Pmono(
			\bilinvibrond,
			//\note, Pseq([
				//2,0,
			//],inf),
			\degree, Pstep(Pwhite(0,7),Prand([Pseq([1/8],8),1,2,4],inf)),
			\degree, Prand([0,2,4],inf),

			\note, Prand([
				Pseq([ 11,10,7,6,5,4,2,1 ],1),
				Pseq([ 11,10,7,6,5,4,2,1 ]-12,1),
			],inf),
			\ctranspose, 5,
			\octave, 6,
			//\dur, PdurStutter(Pseq([1,4],inf), 4),

			\oscmixtab, Plazy({
				Pseq([
					[ { 0.1.bilinrand+1 }!100 ],
				],1);
			}).loop,
			\fspread, ~pmodenv.(Pseq([0.005,0.01],inf), Pwhite(1.0,8,inf)),
			\lplfofac, ~pmodenv.(Pseq([0.5,0.05,0.8,0.1]/4,inf), Pwhite(1,7.0)),
			\oscmix, Pseq([0,1/2,1,Pwhite(0,1.0,1)],inf),

			\modamp, ~pmodenv.(Pseq([0.4,1,0.02,1,0.1,1.4],inf), Pwhite(1/2,4), 1, -4),
			\oscmix, ~pmodenv.(Pseq([0.01,0.3,Pwhite(0,0.4,1)],inf), Pwhite(0.5,7)),
			\lpfr, ~pmodenv.(Pseq([2,4],inf), Pwhite(1.0/8,8)),
			\rq, 0.4,
			\lpmix, ~pmodenv.(Pseq([1,2,1,4]/4,inf), Pwhite(1.0/8,8)),
			\lpmix,1,
			\adsr, Pseq([
				[ Env.adsr(1.4,0.1,0.8,2.1) ],
			],inf),
			\dur, Pwrand([1/8,1/4,1],[1,2,3].cubed.normalizeSum,inf),
			\amp, 0.1/2,
			\pan, Pseq([1,-1],inf),
			\out, BusDef(\sendbus2, \audio),
			\amp, 0.12,
		)),
		
	])
)).play;
);

(
// drums coin 0.7 + acid bass + widechord + hi
Pdef(\part, Pdef(\mpart1, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1474].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[673].value,
			\legato,2,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,1, 1,0,0,0, 1,0,0,0,
				1,0,0,1, 1,0,0,0, 1,0,0,0, 1,0,0,1,
			]*0.7,inf).coin.not,
			\dur, 1/16,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[673].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1268].value,
			\legato,1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.2) ],
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 1,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,1,0,0, 1,0,0,1, 0,0,1,0,
				0,0,1,0, 1,1,0,1, 1,0,1,1, 0,1,1,0,
			]*0.7,inf).coin.not,
			\pan, 1,
			\dur, 1/16,
			\gain, 0.1 * Pseq([1,0.3,0.7],inf),
		),
		Psched(4,Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[673].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1168].value,
			\legato,2,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 1,1,1,1,
					1,0,1,0, 1,0,1,0, 0,0,0,0, 1,1,1,1,
					1,0,0,1, 0,0,1,0, 0,0,0,0, 1,1,1,1,
					1,0,1,0, 1,0,1,0, 0,0,0,0, 1,1,1,1,
					
					0,0,0,0, 0,0,0,0, 0,0,0,0, 1,1,1,1,
					1,0,0,1, 0,0,1,0, 0,0,0,0, 1,1,1,1,
					1,1,0,1, 1,0,1,1, 0,0,0,0, 1,1,1,1,
					1,0,1,0, 1,0,1,0, 0,0,0,0, 1,1,1,1,
				],5),
				Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				],8),
			]*0.7,inf).coin.not,
			\pan, 1,
			\dur, 1/16,
			\gain, 0.11,
		)),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[2076].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.31,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.clap[3].value,
			\bufnum, ~buflib.snare[2076].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 1,1,0,1,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,1,0,0, 1,0,0,0, 0,0,0,1, 1,0,1,1,
			]*0.7,inf).coin.not,
			\dur, 1/16,
			//\lag,0.051,
			\sustain, 0.03 * Prand([1,1.33,1,0.7],inf),
			\gain, 0.21 * Pseq([1,0.3,0.7],inf),
		),
		Psched(8,Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[19].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\bufnum, ~buflib.clap[49].value,
			\isRest, Pseq([
				0,0,1,0, 0,1,0,1,
				0,0,1,0, 1,0,0,1,
				1,1,1,1, 0,0,0,0,
				1,1,0,1, 0,0,1,0,
				0,0,0,0, 1,1,1,1,
				0,1,0,1, 1,0,0,0,
				0,1,0,0, 1,1,0,1,
				Pseq([
					0,0,0,0, 0,0,0,0,
				],15),
			]*0.7,inf).coin.not,
			\dur, 1/16,
			\lag, 1/32,
			\gain, 0.11,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.4,0.1) ],
			],inf),
			\sustain, 0.02 * Prand([1,1.33,1,0.7],inf),
			\gain, 0.07 * Pseq([1,0.3,0.7],inf),
		)),
		Pbind(
			\instrument, \basicbass,
			\note, Pstep(Pseq([
				2,6,6,10,
				5,4,4,10,
				11,7,7,10,
			],inf),1/2),
			\ctranspose, 5,
			\legato, Pseq([
				Prand([
					Pseq([
						1,0.3,0.51,
					],1),
					Pseq([
						1,0.7,
					],1),
					Pseq([
						1,0.7,0.21,
					],1),
				],1),
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.01) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\lpf, ~pmodenv.(Pseq([300,700,100,1000],inf), Pwhite(0.1,8)),
			\rq, ~pmodenv.(Pseq([0.5,0.1,0.8],inf), Pwhite(0.1,8)),
			\octave, 2,
			\dur, 1/8,
			\dur, PdurStutter(Pseq([8,8,8,8, 8,8,8,4],inf), 1/2),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \bolonvib,
			//\note, Pseq([
				//( { rrand(0,12) }!5 ).postln,
				//( { rrand(0,12) }!5 ).postln,
				//( { rrand(0,12) }!5 ).postln,
			//].collect({ arg x;
				//x
			//}),inf).stutter(1),
			\note, Pseq([
				[ 1,  5, 11, 2  ],
				[ 6,  4, 7, 5  ],
				[ 10,  4, 1, 5  ],
			],inf),
			\ctranspose, 5,
			\oscmixtab, Plazy({
				Pseq([
					[ { 0.1.bilinrand+1 }!100 ],
				],1);
			}).loop,
			\octave, 4,
			\rq, 0.2,
			\fspread, ~pmodenv.(Pseq([0.05,0.001,0.005,0.001,0.02],inf), Pwhite(0.7,4)),
			\adsr, Pseq([
				[ Env.adsr(0.09,0.1,0.8,0.1) ],
			],inf),
			\lplfofac, ~pmodenv.(Pseq([0.5,0.05,0.8,0.1]/4,inf), Pwhite(1,7.0)),
			\lpfr, ~pmodenv.(Pseq([0.1,2,1.2,4],inf), Pwhite(1.0,7)),
			\legato, 1.0,
			\oscmix, Pseq([0,1/2,1,Pwhite(0,1.0,1)],inf),
			\oscmix, ~pmodenv.(Pseq([0.0,1/2,0.6,Pwhite(0,1.0,1)],inf), Pwhite(0.5,7)),
			\dur, Pseq([1/2,1,1/2],inf),
			\amp, 0.1/2,
			\out, 0,
			\out, BusDef(\sendbus2, \audio),
		),
		Psched(8,Pmono(
			\bilinvibrond,
			//\note, Pseq([
				//2,0,
			//],inf),
			\degree, Pstep(Pwhite(0,7),Prand([Pseq([1/8],8),1,2,4],inf)),
			\degree, Prand([0,2,4],inf),

			\note, Prand([
				Pseq([ 11,10,7,6,5,4,2,1 ],1),
				Pseq([ 11,10,7,6,5,4,2,1 ]-12,1),
			],inf),
			\ctranspose, 5,
			\octave, 6,
			//\dur, PdurStutter(Pseq([1,4],inf), 4),

			\oscmixtab, Plazy({
				Pseq([
					[ { 0.1.bilinrand+1 }!100 ],
				],1);
			}).loop,
			\fspread, ~pmodenv.(Pseq([0.005,0.01],inf), Pwhite(1.0,8,inf)),
			\lplfofac, ~pmodenv.(Pseq([0.5,0.05,0.8,0.1]/4,inf), Pwhite(1,7.0)),
			\oscmix, Pseq([0,1/2,1,Pwhite(0,1.0,1)],inf),

			\modamp, ~pmodenv.(Pseq([0.4,1,0.02,1,0.1,1.4],inf), Pwhite(1/2,4), 1, -4),
			\oscmix, ~pmodenv.(Pseq([0.01,0.3,Pwhite(0,0.4,1)],inf), Pwhite(0.5,7)),
			\lpfr, ~pmodenv.(Pseq([2,4],inf), Pwhite(1.0/8,8)),
			\rq, 0.4,
			\lpmix, ~pmodenv.(Pseq([1,2,1,4]/4,inf), Pwhite(1.0/8,8)),
			\lpmix,1,
			\adsr, Pseq([
				[ Env.adsr(1.4,0.1,0.8,2.1) ],
			],inf),
			\dur, Pwrand([1/8,1/4,1],[1,2,3].cubed.normalizeSum,inf),
			\amp, 0.1/2,
			\pan, Pseq([1,-1],inf),
			\out, BusDef(\sendbus2, \audio),
			\amp, 0.12,
		)),
		Psched(4,Pbind(
			\instrument, \organ_donorenv,
			//\note, Pseq([
				//( { rrand(0,12) }!5 ).postln,
				//( { rrand(0,12) }!5 ).postln,
				//( { rrand(0,12) }!5 ).postln,
			//].collect({ arg x;
				//x
			//}),inf).stutter(1),
			\note, Pseq([
				[ 1,  5, 11, 2  ],
				[ 6,  4, 7, 5  ],
				[ 10,  4, 1, 5  ],
			],inf).collect({ arg x; x.choose }),
			\ctranspose, 5,
			\oscmixtab, Plazy({
				Pseq([
					[ { 0.1.bilinrand+1 }!100 ],
				],1);
			}).loop,
			\octave, 6,
			\rq, 0.5,
			\fspread, ~pmodenv.(Pseq([0.05,0.001,0.005,0.001,0.02],inf), Pwhite(0.7,4)),
			\adsr, Pseq([
				[ Env.adsr(0.09,0.1,0.2,0.1) ],
			],inf),
			\legato, 0.5,
			\lplfofac, ~pmodenv.(Pseq([0.5,0.05,0.8,0.1]/4,inf), Pwhite(1,7.0)),
			\lpfr, ~pmodenv.(Pseq([0.1,2,1.2,4],inf), Pwhite(1.0,7)),
			\legato, 1.0,
			\oscmix, Pseq([0,1/2,1,Pwhite(0,1.0,1)],inf),
			\oscmix, ~pmodenv.(Pseq([0.8,1/2,0.6,Pwhite(0,1.0,1)],inf), Pwhite(0.5,7)),
			\dur, Pseq([1/2,1,1/2],inf),
			\amp, 0.1/6,
			\dur, PdurStutter(Pseq([1,4,2,8],inf), 1/2),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\out, 0,
			\out, BusDef(\sendbus2, \audio),
		)),
		
	])
)).play;
);
(
	~master.();
// voices
Pdef(\part, Pdef(\mpart2, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1474].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,1,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
					0,0,1,0, 0,0,0,0,
				],3),
					1,0,0,0, 0,0,0,0,
					1,0,1,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.3,
		),
		//Pbind(
			//\timekeeper, Ptime(),
			//\type, Pfunc({ arg ev;
				//if(ev[\timekeeper] % 8 >= 7) {
					//\rest
				//} {
					//\note
				//}
			//}) 
		//) <>
		Ppar([
			PschedMute(Pseq([0,7,1,0],inf))<>
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[1064].value,
				\bufnum, ~buflib.hat[673].value,
				\legato,2,
				\isRest, Pseq([
					1,0,0,0, 1,0,0,1, 1,0,0,0, 1,0,0,0,
					1,0,0,1, 1,0,0,0, 1,0,0,0, 1,0,0,1,
				]*0.7,inf).coin.not,
				\dur, 1/16,
				\gain, 0.11,
			),
			PschedMute(Pseq([0,7,1,0],inf))<>
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[673].value,
				\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[1268].value,
				\legato,1/8,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.4,0.2) ],
				],inf),
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 1,1,1,1, 1,1,1,1,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					1,1,1,1, 1,1,1,1, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,1,0,0, 1,0,0,1, 0,0,1,0,
					0,0,1,0, 1,1,0,1, 1,0,1,1, 0,1,1,0,
				]*0.7,inf).coin.not,
				\pan, 1,
				\dur, 1/16,
				\gain, 0.1 * Pseq([1,0.3,0.7],inf),
			),
			PschedMute(Pseq([0,14,2,0],inf))<>
			Psched(4,Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[673].value,
				\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[1168].value,
				\legato,2,
				\isRest, Pseq([
					Pseq([
						0,0,0,0, 0,0,0,0, 0,0,0,0, 1,1,1,1,
						1,0,1,0, 1,0,1,0, 0,0,0,0, 1,1,1,1,
						1,0,0,1, 0,0,1,0, 0,0,0,0, 1,1,1,1,
						1,0,1,0, 1,0,1,0, 0,0,0,0, 1,1,1,1,
			
						0,0,0,0, 0,0,0,0, 0,0,0,0, 1,1,1,1,
						1,0,0,1, 0,0,1,0, 0,0,0,0, 1,1,1,1,
						1,1,0,1, 1,0,1,1, 0,0,0,0, 1,1,1,1,
						1,0,1,0, 1,0,1,0, 0,0,0,0, 1,1,1,1,
					],5),
					Pseq([
						0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					],8),
				]*0.7,inf).coin.not,
				\pan, 1,
				\dur, 1/16,
				\gain, 0.11,
			)),
			PschedMute(Pseq([0,14,2,0],inf))<>
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[2076].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.31,
			),
			PschedMute(Pseq([0,14,2,0],inf))<>
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.clap[3].value,
				\bufnum, ~buflib.snare[2076].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 1,1,0,1,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,1,0,0, 1,0,0,0, 0,0,0,1, 1,0,1,1,
				]*0.7,inf).coin.not,
				\dur, 1/16,
				//\lag,0.051,
				\sustain, 0.03 * Prand([1,1.33,1,0.7],inf),
				\gain, 0.21 * Pseq([1,0.3,0.7],inf),
			),
			PschedMute(Pseq([0,14,2,0],inf))<>
			Psched(8,Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.clap[19].value,
				//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
				\bufnum, ~buflib.clap[49].value,
				\isRest, Pseq([
					0,0,1,0, 0,1,0,1,
					0,0,1,0, 1,0,0,1,
					1,1,1,1, 0,0,0,0,
					1,1,0,1, 0,0,1,0,
					0,0,0,0, 1,1,1,1,
					0,1,0,1, 1,0,0,0,
					0,1,0,0, 1,1,0,1,
					Pseq([
						0,0,0,0, 0,0,0,0,
					],15),
				]*0.7,inf).coin.not,
				\dur, 1/16,
				\lag, 1/32,
				\gain, 0.11,
				\adsr, Pseq([
					[ Env.adsr(0.001,0.1,0.4,0.1) ],
				],inf),
				\sustain, 0.02 * Prand([1,1.33,1,0.7],inf),
				\gain, 0.07 * Pseq([1,0.3,0.7],inf),
			)),
			PschedMute(Pseq([0,7+0.5,0.5,0, 0,6,2,0,],inf))<>
			Pbind(
				\instrument, \basicbass,
				\note, Pstep(Pseq([
					2,6,6,10,
					5,4,4,10,
					11,7,7,10,
				],inf),1/2),
				\ctranspose, 5,
				\legato, Pseq([
					Prand([
						Pseq([
							1,0.3,0.51,
						],1),
						Pseq([
							1,0.7,
						],1),
						Pseq([
							1,0.7,0.21,
						],1),
					],1),
				],inf),
				\adsr, Pseq([
					[ Env.adsr(0.001,0.1,0.8,0.01) ],
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\lpf, ~pmodenv.(Pseq([300,700,100,1000],inf), Pwhite(0.1,8)),
				\rq, ~pmodenv.(Pseq([0.5,0.1,0.8],inf), Pwhite(0.1,8)),
				\octave, 2,
				\dur, 1/8,
				\dur, PdurStutter(Pseq([8,8,8,8, 8,8,8,4],inf), 1/2),
				\amp, 0.1,
			),
		]),
		Pbind(
			\instrument, \bolonvib,
			//\note, Pseq([
				//( { rrand(0,12) }!5 ).postln,
				//( { rrand(0,12) }!5 ).postln,
				//( { rrand(0,12) }!5 ).postln,
			//].collect({ arg x;
				//x
			//}),inf).stutter(1),
			\note, Pseq([
				[ 1,  5, 11, 2  ],
				[ 6,  4, 7, 5  ],
				[ 10,  4, 1, 5  ],
			],inf),
			\ctranspose, 5,
			\oscmixtab, Plazy({
				Pseq([
					[ { 0.1.bilinrand+1 }!100 ],
				],1);
			}).loop,
			\octave, 4,
			\rq, 0.2,
			\fspread, ~pmodenv.(Pseq([0.05,0.001,0.005,0.001,0.02],inf), Pwhite(0.7,4)),
			\adsr, Pseq([
				[ Env.adsr(0.09,0.1,0.8,0.1) ],
			],inf),
			\lplfofac, ~pmodenv.(Pseq([0.5,0.05,0.8,0.1]/4,inf), Pwhite(1,7.0)),
			\lpfr, ~pmodenv.(Pseq([0.1,2,1.2,4],inf), Pwhite(1.0,7)),
			\legato, 1.0,
			\oscmix, Pseq([0,1/2,1,Pwhite(0,1.0,1)],inf),
			\oscmix, ~pmodenv.(Pseq([0.0,1/2,0.6,Pwhite(0,1.0,1)],inf), Pwhite(0.5,7)),
			\dur, Pseq([1/2,1,1/2],inf),
			\amp, 0.1/2,
			\out, 0,
			\out, BusDef(\sendbus2, \audio),
		),
		Psched(8,Pmono(
			\bilinvibrond,
			//\note, Pseq([
				//2,0,
			//],inf),
			\degree, Pstep(Pwhite(0,7),Prand([Pseq([1/8],8),1,2,4],inf)),
			\degree, Prand([0,2,4],inf),

			\note, Prand([
				Pseq([ 11,10,7,6,5,4,2,1 ],1),
				Pseq([ 11,10,7,6,5,4,2,1 ]-12,1),
			],inf),
			\ctranspose, 5,
			\octave, 6,
			//\dur, PdurStutter(Pseq([1,4],inf), 4),

			\oscmixtab, Plazy({
				Pseq([
					[ { 0.1.bilinrand+1 }!100 ],
				],1);
			}).loop,
			\fspread, ~pmodenv.(Pseq([0.005,0.01],inf), Pwhite(1.0,8,inf)),
			\lplfofac, ~pmodenv.(Pseq([0.5,0.05,0.8,0.1]/4,inf), Pwhite(1,7.0)),
			\oscmix, Pseq([0,1/2,1,Pwhite(0,1.0,1)],inf),

			\modamp, ~pmodenv.(Pseq([0.4,1,0.02,1,0.1,1.4],inf), Pwhite(1/2,4), 1, -4),
			\oscmix, ~pmodenv.(Pseq([0.01,0.3,Pwhite(0,0.4,1)],inf), Pwhite(0.5,7)),
			\lpfr, ~pmodenv.(Pseq([2,4],inf), Pwhite(1.0/8,8)),
			\rq, 0.4,
			\lpmix, ~pmodenv.(Pseq([1,2,1,4]/4,inf), Pwhite(1.0/8,8)),
			\lpmix,1,
			\adsr, Pseq([
				[ Env.adsr(1.4,0.1,0.8,2.1) ],
			],inf),
			\dur, Pwrand([1/8,1/4,1],[1,2,3].cubed.normalizeSum,inf),
			\amp, 0.1/2,
			\pan, Pseq([1,-1],inf),
			\out, BusDef(\sendbus2, \audio),
			\amp, 0.12,
		)),
		Psched(4,Pbind(
			\instrument, \organ_donorenv,
			//\note, Pseq([
				//( { rrand(0,12) }!5 ).postln,
				//( { rrand(0,12) }!5 ).postln,
				//( { rrand(0,12) }!5 ).postln,
			//].collect({ arg x;
				//x
			//}),inf).stutter(1),
			\note, Pseq([
				[ 1,  5, 11, 2  ],
				[ 6,  4, 7, 5  ],
				[ 10,  4, 1, 5  ],
			],inf).collect({ arg x; x.choose }),
			\ctranspose, 5,
			\oscmixtab, Plazy({
				Pseq([
					[ { 0.1.bilinrand+1 }!100 ],
				],1);
			}).loop,
			\octave, 6,
			\rq, 0.5,
			\fspread, ~pmodenv.(Pseq([0.05,0.001,0.005,0.001,0.02],inf), Pwhite(0.7,4)),
			\adsr, Pseq([
				[ Env.adsr(0.09,0.1,0.2,0.1) ],
			],inf),
			\legato, 0.5,
			\lplfofac, ~pmodenv.(Pseq([0.5,0.05,0.8,0.1]/4,inf), Pwhite(1,7.0)),
			\lpfr, ~pmodenv.(Pseq([0.1,2,1.2,4],inf), Pwhite(1.0,7)),
			\legato, 1.0,
			\oscmix, Pseq([0,1/2,1,Pwhite(0,1.0,1)],inf),
			\oscmix, ~pmodenv.(Pseq([0.8,1/2,0.6,Pwhite(0,1.0,1)],inf), Pwhite(0.5,7)),
			\dur, Pseq([1/2,1,1/2],inf),
			\amp, 0.1/6,
			\dur, PdurStutter(Pseq([1,4,2,8],inf), 1/2),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\out, 0,
			\out, BusDef(\sendbus2, \audio),
		)),

		// icing
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('cliprec/rec_rec_t0_201215_153343.wav'),
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1,
			\gain, 1,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('cliprec/rec_rec_t0_201215_173158.wav'),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1,
			\legato, 4,
			\gain, 1,
		),
		Pbind(
			\instrument, \playersec_hlpf,
			\bufnum, BufDef('cliprec/rec_rec_t0_201215_162500.wav'),
			\legato,1,
			\adsr, Pseq([
				[ Env.adsr(0.2,1.1,1,0.1,1,-1) ],
			],inf),
			\dur, 1,
			\legato, 4,
			\speed, -1.1,
			\lag, 0.5,
			\loop,1,
			\hpf, ~pmodenv.(Pseq([100,500,1000,4000],1), 2).loop,
			\hpf, 600,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\gain, 1/5,
		),
		Pbind(
			\instrument, \grainephasor,
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\gdur,0.08,
			\gfreq,170,
			\rate, Pseg(Pseq([1,1,1.02],inf),1),
			\pos, Pseg(Pseq([0,4],inf),8)%Pseg(Pseq([0,5],inf),1/2)+1,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],8),

				Pseq([
					0,0,0,0, 0,0,0,0,
				],6),
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,1,

			],inf).coin.not,
			\endpos,4,
			\legato, Pseq([
				1,0.1,0.1,
				1,0.8,0.5,
				1,0.8,
				1,0.8,
				1,0.8,
				1,0.8,
				1,0.8,
			],inf),
			\legato, 1,
			\dur, 1/8,
			\gain, 2,
		),
		
	])
)).play;
);


(
// nokick, drums coin 0.7 + acid bass + widechord + hi
Pdef(\part, Pdef(\break1, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[673].value,
			\legato,2,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.11,
			\out, BusDef(\movefil, \audio),
		),
		Psched(0,Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[673].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1168].value,
			\legato,1,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				],2),
				Pseq([
					1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1,
				]*0.7,4),
				Pseq([
					1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1,
				]*0.3,2),
			],inf).coin.not,
			\pan, 1,
			\dur, 1/16,
			\gain, 0.11,
			\out, BusDef(\movefil, \audio),
		)),
		Psched(0,Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[19].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\bufnum, ~buflib.clap[49].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
				Pseq([
					1,1,2,1, 2,1,1,1,
					2,1,1,1, 1,1,2,1,
				]*0.7,4),
				Pseq([
					1,1,2,1, 2,1,1,1,
					2,1,1,1, 1,1,2,1,
				]*0.4,2),
			],inf).coin.not,
			\dur, 1/16,
			\lag, 1/32,
			\gain, 0.11,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.4,0.1) ],
			],inf),
			\sustain, 0.02 * Prand([1,1.33,1,0.7],inf),
			\gain, 0.07 * Pseq([1,0.3,0.7],inf),
			\out, BusDef(\movefil, \audio),
		)),
		Pmono(\fx_rlpfrhpf,
			\inbus, BusDef(\movefil, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			//\lpf, ~pmodenv.(Pexprand(1000.0,17000,inf), Pwhite(2.0,8)),
			\lpf, 19000,
			//\hpf, ~pmodenv.(Pexprand(1.0,10000,inf), Pwhite(2.0,8)),
			\hpf, ~pmodenv.(Pseq([17000,Pseq([20],inf)],inf), 4),
			\dur, 1,
		),
		Pbind(
			\instrument, \bolonvib,
			//\note, Pseq([
				//( { rrand(0,12) }!5 ).postln,
				//( { rrand(0,12) }!5 ).postln,
				//( { rrand(0,12) }!5 ).postln,
			//].collect({ arg x;
				//x
			//}),inf).stutter(1),
			\note, Pseq([
				[ 1,  5, 11, 2  ],
				[ 6,  4, 7, 5  ],
				[ 10,  4, 1, 5  ],
			],inf),
			\ctranspose, 5,
			\oscmixtab, Plazy({
				Pseq([
					[ { 0.1.bilinrand+1 }!100 ],
				],1);
			}).loop,
			\octave, 5,
			\rq, 0.2,
			\fspread, ~pmodenv.(Pseq([0.05,0.001,0.005,0.001,0.02],inf), Pwhite(0.7,4)),
			\adsr, Pseq([
				[ Env.adsr(0.09,0.1,0.8,0.1) ],
			],inf),
			\lplfofac, ~pmodenv.(Pseq([0.5,0.05,0.8,0.1]/4,inf), Pwhite(1,7.0)),
			\lpfr, ~pmodenv.(Pseq([0.1,2,1.2,4],inf), Pwhite(1.0,7)),
			\legato, Pseg(Pseq([0.1,Pn(1,inf)],inf),8),
			\oscmix, Pseq([0,1/2,1,Pwhite(0,1.0,1)],inf),
			\oscmix, ~pmodenv.(Pseq([0.0,1/2,0.6,Pwhite(0,1.0,1)],inf), Pwhite(0.5,7)),
			\dur, Pseq([1/2,1,1/2],inf),
			\amp, 0.1/2,
			\out, 0,
			\out, BusDef(\sendbus2, \audio),
		),
		Psched(8,Pmono(
			\bilinvibrond,
			//\note, Pseq([
				//2,0,
			//],inf),
			\degree, Pstep(Pwhite(0,7),Prand([Pseq([1/8],8),1,2,4],inf)),
			\degree, Prand([0,2,4],inf),

			\note, Prand([
				Pseq([ 11,10,7,6,5,4,2,1 ],1),
				Pseq([ 11,10,7,6,5,4,2,1 ]-12,1),
			],inf),
			\ctranspose, 5,
			\octave, 6,
			//\dur, PdurStutter(Pseq([1,4],inf), 4),

			\oscmixtab, Plazy({
				Pseq([
					[ { 0.1.bilinrand+1 }!100 ],
				],1);
			}).loop,
			\fspread, ~pmodenv.(Pseq([0.005,0.01],inf), Pwhite(1.0,8,inf)),
			\lplfofac, ~pmodenv.(Pseq([0.5,0.05,0.8,0.1]/4,inf), Pwhite(1,7.0)),
			\oscmix, Pseq([0,1/2,1,Pwhite(0,1.0,1)],inf),

			\modamp, ~pmodenv.(Pseq([0.4,1,0.02,1,0.1,1.4],inf), Pwhite(1/2,4), 1, -4),
			\oscmix, ~pmodenv.(Pseq([0.01,0.3,Pwhite(0,0.4,1)],inf), Pwhite(0.5,7)),
			\lpfr, ~pmodenv.(Pseq([2,4],inf), Pwhite(1.0/8,8)),
			\rq, 0.4,
			\lpmix, ~pmodenv.(Pseq([1,2,1,4]/4,inf), Pwhite(1.0/8,8)),
			\lpmix,1,
			\adsr, Pseq([
				[ Env.adsr(1.4,0.1,0.8,2.1) ],
			],inf),
			\dur, Pwrand([1/8,1/4,1],[1,2,3].cubed.normalizeSum,inf),
			\amp, 0.1/2,
			\pan, Pseq([1,-1],inf),
			\out, BusDef(\sendbus2, \audio),
			\amp, 0.12,
		)),
		
	])
)).play;
);

(
// nokick, drums coin 0.7 + acid bass + widechord + hi
Pdef(\part, Pdef(\break2, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[673].value,
			\legato,2,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.11,
			\out, BusDef(\movefil, \audio),
		),
		Psched(0,Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[673].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1168].value,
			\legato,1,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				],2),
				Pseq([
					1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1,
				]*0.7,4),
				Pseq([
					1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1,
				]*0.3,2),
			],inf).coin.not,
			\pan, 1,
			\dur, 1/16,
			\gain, 0.11,
			\out, BusDef(\movefil, \audio),
		)),
		Psched(0,Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[19].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\bufnum, ~buflib.clap[49].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
				Pseq([
					1,1,2,1, 2,1,1,1,
					2,1,1,1, 1,1,2,1,
				]*0.7,4),
				Pseq([
					1,1,2,1, 2,1,1,1,
					2,1,1,1, 1,1,2,1,
				]*0.4,2),
			],inf).coin.not,
			\dur, 1/16,
			\lag, 1/32,
			\gain, 0.11,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.4,0.1) ],
			],inf),
			\sustain, 0.02 * Prand([1,1.33,1,0.7],inf),
			\gain, 0.07 * Pseq([1,0.3,0.7],inf),
			\out, BusDef(\movefil, \audio),
		)),
		Pmono(\fx_rlpfrhpf,
			\inbus, BusDef(\movefil, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			//\lpf, ~pmodenv.(Pexprand(1000.0,17000,inf), Pwhite(2.0,8)),
			\lpf, 19000,
			//\hpf, ~pmodenv.(Pexprand(1.0,10000,inf), Pwhite(2.0,8)),
			\hpf, ~pmodenv.(Pseq([17000,Pseq([20],inf)],inf), 4),
			\dur, 1,
		),
		Pbind(
			\instrument, \bolonvib,
			//\note, Pseq([
				//( { rrand(0,12) }!5 ).postln,
				//( { rrand(0,12) }!5 ).postln,
				//( { rrand(0,12) }!5 ).postln,
			//].collect({ arg x;
				//x
			//}),inf).stutter(1),
			\note, Pseq([
				[ 1,  5, 11, 2  ],
				[ 6,  4, 7, 5  ],
				[ 10,  4, 1, 5  ],
			],inf),
			\ctranspose, 5,
			\oscmixtab, Plazy({
				Pseq([
					[ { 0.1.bilinrand+1 }!100 ],
				],1);
			}).loop,
			\octave, 5,
			\rq, 0.2,
			\fspread, ~pmodenv.(Pseq([0.05,0.001,0.005,0.001,0.02],inf), Pwhite(0.7,4)),
			\adsr, Pseq([
				[ Env.adsr(0.09,0.1,0.8,0.1) ],
			],inf),
			\lplfofac, ~pmodenv.(Pseq([0.5,0.05,0.8,0.1]/4,inf), Pwhite(1,7.0)),
			\lpfr, ~pmodenv.(Pseq([0.1,2,1.2,4],inf), Pwhite(1.0,7)),
			\legato, Pseg(Pseq([0.1,Pn(1,inf)],inf),8),
			\oscmix, Pseq([0,1/2,1,Pwhite(0,1.0,1)],inf),
			\oscmix, ~pmodenv.(Pseq([0.0,1/2,0.6,Pwhite(0,1.0,1)],inf), Pwhite(0.5,7)),
			\dur, Pseq([1/2,1,1/2]/4,inf),
			\amp, 0.1/2,
			\out, 0,
			\out, BusDef(\sendbus2, \audio),
		),
		Psched(8,Pmono(
			\bilinvibrond,
			//\note, Pseq([
				//2,0,
			//],inf),
			\degree, Pstep(Pwhite(0,7),Prand([Pseq([1/8],8),1,2,4],inf)),
			\degree, Prand([0,2,4],inf),

			\note, Prand([
				Pseq([ 11,10,7,6,5,4,2,1 ],1),
				Pseq([ 11,10,7,6,5,4,2,1 ]-12,1),
			],inf),
			\ctranspose, 5,
			\octave, 6,
			//\dur, PdurStutter(Pseq([1,4],inf), 4),

			\oscmixtab, Plazy({
				Pseq([
					[ { 0.1.bilinrand+1 }!100 ],
				],1);
			}).loop,
			\fspread, ~pmodenv.(Pseq([0.005,0.01],inf), Pwhite(1.0,8,inf)),
			\lplfofac, ~pmodenv.(Pseq([0.5,0.05,0.8,0.1]/4,inf), Pwhite(1,7.0)),
			\oscmix, Pseq([0,1/2,1,Pwhite(0,1.0,1)],inf),

			\modamp, ~pmodenv.(Pseq([0.4,1,0.02,1,0.1,1.4],inf), Pwhite(1/2,4), 1, -4),
			\oscmix, ~pmodenv.(Pseq([0.01,0.3,Pwhite(0,0.4,1)],inf), Pwhite(0.5,7)),
			\lpfr, ~pmodenv.(Pseq([2,4],inf), Pwhite(1.0/8,8)),
			\rq, 0.4,
			\lpmix, ~pmodenv.(Pseq([1,2,1,4]/4,inf), Pwhite(1.0/8,8)),
			\lpmix,1,
			\adsr, Pseq([
				[ Env.adsr(1.4,0.1,0.8,2.1) ],
			],inf),
			\dur, Pwrand([1/8,1/4,1],[1,2,3].cubed.normalizeSum,inf),
			\amp, 0.1/2,
			\pan, Pseq([1,-1],inf),
			\out, BusDef(\sendbus2, \audio),
			\amp, 0.12,
		)),
		
	])
)).play;
);

(
// bouillie chord + rumble bass
Pdef(\part, Pdef(\bouillie, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1474].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				1,0,0,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[2076].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.31,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[2076].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0.31,0,0, 0,1,0,1,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,1, 0,0,0,1,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
				0,0,0,0, 0,0,1,0,
			]*0.7,inf).coin.not,
			\dur, 1/16,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1926].value,
			\isRest, Pseq([
				Pseq([
					1,1,1,1, 1,0,1,0,
					1,0,1,0, 1,1,0,1, 
					1,0,1,0, 1,1,1,1,
					1,0,1,0, 1,0,0,0, 
					
					1,1,1,1, 1,0,1,0,
					1,0,1,0, 1,0,1,0, 
					1,0,1,0, 1,1,1,1,
					1,0,1,0, 1,0,1,0, 
					
					1,1,1,1, 1,0,1,0,
					1,0,0,0, 0,0,1,1, 
					0,0,1,1, 1,0,0,1,
					1,0,1,0, 1,0,1,0, 
				],1),
				Prand([
					1,1,1,1, 1,0,1,0,
					1,0,1,0, 1,1,0,1, 
					1,0,1,0, 1,1,1,1,
					1,0,1,0, 1,0,0,0, 
					
					1,1,1,1, 1,0,1,0,
					1,0,1,0, 1,0,1,0, 
					1,0,1,0, 1,1,1,1,
					1,0,1,0, 1,0,1,0, 
					
					1,1,1,1, 1,0,1,0,
					1,0,0,0, 0,0,1,1, 
					0,0,1,1, 1,0,0,1,
					1,0,1,0, 1,0,1,0, 
				].clump(8*4).collect({ arg x; Pseq(x) })*0.8,1),
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.11 * Pseq([
				1,Pwhite(0.5,0.91,1),
				Pwhite(0.7,0.91,1), Pwhite(0.2,0.71,1)
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1927].value,
			\isRest, Pseq([

				1,1,1,1, 1,0,1,0,
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,1,1,1,
				1,0,1,0, 1,0,1,0, 
			]*0.3,inf).coin.not,
			\lag, 1/16/~t,
			\speed, 1/2+Pwhite(0,0.01),
			\legato, Pseq([
				0.11,Pwhite(0.1,0.4,3),
				Pwhite(0.1,0.4,1), 0.41,Pwhite(0.1,0.4,2),
				Pwhite(0.1,0.4,2), 0.41,Pwhite(0.1,0.4,2),
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \grainephasor,
			\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
			\note, Pseq([
				0,3,1,2,
			],inf).stutter(4),
			\gdur, 0.051,
			\gfreq, Pkey(\freq)/4/16*Pseg(Prand([64,32,32,1],inf),Pseq([ 1,1/2 ],inf)),
			\endpos, ~pmodenv.(Pseq([0.1],inf), 8),
			\gdur, ~pmodenv.(Pseq([0.01,0.1],inf), 4),
			\pos, 0,
			\phasortrig, Plazy({ arg ev;
				Ndef(\lfo1, { 
					Impulse.kr(
						Line.kr(1,( ev.use{~freq.value}/4 ).postln,1/2/~t)*~t
						//EnvGen.kr(Env([1,1,ev.use{~freq.value},10],[0,8.1,0.8]), Impulse.kr(1/4*~t)).poll
					) 
				}).asPattern.keep(8)
			}).loop,
			//\gfreq, 40,
			\legato, Pseq([

				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,2,0,
				8,0,0,0, 0,0,0,0,
				0,0,2,0, 0,0,0,0,
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 4,0,0,0,
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 4,0,0,0,
				Pseq([
					1,1,1,1, 1,0,0,0,
					1,1,1,0, 0,1,1,1,
					1,1,1,1, 1,0,0,0,
					1,1,0,0, 0,0,1,1,
				]/2,1),
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1/4,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \chordmito2hpf,
			\note, Pseq([
				[4,7,5,1],
				( { rrand(0,12) }!5 ).postln,
				[4,7,5,1],
				( { rrand(0,12) }!5 ).postln,
			],inf),
			\note, Pseq([
				[ 0,3,7,11, ],
				[ 0,3,7,11, ]+4
			],inf),
			\note, Pseq([
				[ 1,  5, 11, 2  ],
				[ 6,  4, 7, 5  ],
				[ 10,  4, 1, 5  ],
			],inf),
			\ctranspose, 5,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.5) ],
			],inf),
			\hpfr, Ndef(\rbassanalyzer, {
				var sig;
				var in = InFeedback.ar(BusDef(\sendbus1,\audio),2);
				sig = in;
				sig = DelayN.ar(sig,0.4,0.4)+sig;
				sig = DelayN.ar(sig,0.4,0.4)+sig;
				sig = sig/3;
				Amplitude.kr(sig).linlin(0,0.01,0.8,1.8);
			}),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,4.1) ],
			],inf),
			\dur, Pseq([1/2,1,1/2],inf),
			\legato, 0.3,
			\amp, 0.1,
			\fspread, ~pmodenv.(Pseq([0.001,0.02,0.007],inf), Pwhite(0.1,4)),
			\out, BusDef(\hasher2, \audio),
			\out, 0,
		),
		
	])
)).play;
);

(
// rumble drums coin + peaky
Pdef(\part, Pdef(\rumbledrums, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[1238].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1,
			\st, 92.10/4/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, 
			Pseq([
				Pseq([
					Pseg(Pseq([
						0, 1/8,
					]+( 1/8 ),1),3/2),
					Pseg(Pseq([
						1/2, 4,
					],1.1),1/2),

					Pseg(Pseq([
						1/4, 8,
					]+( 0/2 ),1),1/4),
					Pseg(Pseq([
						1/2, 2/8,
					]+( 0/2 ),1),3/4),
					Pseg(Pseq([
						1/2, 4,
					],1.1),1),


					Pseg(Pseq([
						0, 1/8,
					]+( 0/2 ),1),3/2),
					Pseg(Pseq([
						1/2, 4,
					],1.1),1/2),

					Pseg(Pseq([
						1/4, 2/8,
					]+( 0/2 ),1),1/4),
					Pseg(Pseq([
						1/2, 2/8,
					]+( 0/2 ),1),3/4),
					Pseg(Pseq([
						1/2, 4,
					],1.1),1),
				],inf),
			],inf) / Pkey(\st),
			\dur, 1/32,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				2,1,1,1, 1,1,1,1,
				2,1,1,1, 1.3,1,1,1,
				1,1,1,1, 2,1,1,1,
			]*0.7,inf).coin.not,
			\gain, 1,
			\out, BusDef(\comp, \audio),
		),
		Pmono(\simplecomp,
			\inbus, BusDef(\comp, \audio),
			\cpt, 0.1,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1.2,
			\dur, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[680].value,
			\legato,1/2,
			\isRest, Pseq([
				0,0,1,0,
				1,0,1,0,
				1,0,1,0,
				0,0,0,0,
			]*0.3,inf).coin.not,
			\dur, 1/16,
			\gain, 0.07,
			\out, BusDef(\echo, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[673].value,
			\legato,2,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,1, 1,0,0,0, 1,0,0,0,
				1,0,0,1, 1,0,0,0, 1,0,0,0, 1,0,0,1,
				1,0,0,0, 1,0,0,1, 1,0,0,0, 1,0,0,0,
				1,0,0,1, 1,0,0,0, 1,0,0,0, 1,0,0,1,

				1,0,0,0, 1,0,0,1, 1,0,0,0, 1,0,0,0,
				1,0,0,1, 0,0,1,0, 0,1,0,0, 1,0,0,1,
				1,0,0,0, 1,0,0,1, 1,0,0,0, 1,0,0,0,
				1,0,0,1, 1,0,0,0, 1,0,0,0, 1,0,0,1,
			]*0.7,inf).coin.not,
			\dur, 1/16,
			\gain, 0.11,
			\out, BusDef(\echo, \audio),
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\echo, \audio),
			\addAction, \addToTail,
			\decay, Pseg(Pseq([0,2],inf),8),
			\delay, ~pmodenv.(Pwhite(1/20,0.2), Pwhite(0.1,8)),
			\mix, 0.5,
			\lag, 0.0009,
			\dur, 1/4,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[2076].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.31,
		),
		Pbind(
			\instrument, \peaky,
			\note, Pseq([
				11,10,
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,

				Pseq([
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
				],8),
				Pseq([
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
				]*0.7,16),
			],inf).coin.not,
			\dur, 1/16,
			\fspread, ~pmodenv.(Pseq([0.05,0.12],inf), Pwhite(0.7,4)),
			\lpfr, ~pmodenv.(Pseq([1,2,1,4]/2,inf), Pwhite(0.7,4)),
			\out, BusDef(\echopeaky, \audio),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \peaky,
			\note, Pseq([
				7,1,
			],inf)+12,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],8),
				Pseq([
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
				]*0.7,16),
			],inf).stutter(8).coin.not,
			\dur, 1/16,
			\lag, 1/32,
			\fspread, ~pmodenv.(Pseq([0.05,0.12],inf), Pwhite(0.7,4)),
			\lpfr, ~pmodenv.(Pseq([1,2,1,4]/2,inf), Pwhite(0.7,4)),
			\out, BusDef(\echopeaky, \audio),
			\amp, 0.1,
		),
		Pmono(\fx_echopass,
			\inbus, BusDef(\echopeaky, \audio),
			\addAction, \addToTail,
			\decay, Pseg(Pseq([0,1,2,0.51],inf),7),
			\delay, ~pmodenv.(Pwhite(1/5,0.7), Pwhite(0.1,8)),
			\mix, 0.5,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \chordmito2,
			//\note, Pseq([
				//( { rrand(0,12) }!5 ).postln,
				//( { rrand(0,12) }!5 ).postln,
				//( { rrand(0,12) }!5 ).postln,
			//].collect({ arg x;
				//x
			//}),inf).stutter(1),
			\note, Pseq([
				[ 1,  5, 11, 2  ],
				[ 6,  4, 7, 5  ],
				[ 10,  4, 1, 5  ],
			],inf),
			\ctranspose, 5,
			\oscmixtab, Plazy({
				Pseq([
					[ { 0.1.bilinrand+1 }!100 ],
				],1);
			}).loop,
			\octave, 4,
			\rq, 0.5,
			\fspread, ~pmodenv.(Pseq([0.05,0.001,0.005,0.001,0.02],inf), Pwhite(0.7,4)),
			\adsr, Pseq([
				[ Env.adsr(0.09,0.1,0.8,0.1) ],
			],inf),
			\lplfofac, ~pmodenv.(Pseq([0.5,0.05,0.8,0.1]/4,inf), Pwhite(1,7.0)),
			\lpfr, ~pmodenv.(Pseq([0.1,2,1.2,4],inf), Pwhite(1.0,7)),
			\legato, 1.0,
			\oscmix, Pseq([0,1/2,1,Pwhite(0,1.0,1)],inf),
			\oscmix, ~pmodenv.(Pseq([0.8,1/2,0.6,Pwhite(0,1.0,1)],inf), Pwhite(0.5,7)),
			\dur, Pseq([1/2,1,1/2],inf),
			\amp, 0.1/2,
			\out, 0,
			\out, BusDef(\sendbus2, \audio),
		),
	])
)).play;
);

(
// rumble drums coin + acidbass + widechords
Pdef(\part, Pdef(\rumbledrums2, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1,
			\st, 92.10/4/60,
			\speed, 1 * ~t / Pkey(\st) * Pseq([
				Pseq([
					1	
				],32*14),
				Pseq([
					Pseq(( 1 - ( (1..32)/32 * 0.2 ) )),
				],2),
			],inf),
			\pos, 
			Pseq([
				Pseq([
					Pseg(Pseq([
						0, 1/8,
					]+( 1/8 ),1),3/2),
					Pseg(Pseq([
						1/2, 4,
					],1.1),1/2),

					Pseg(Pseq([
						1/4, 8,
					]+( 0/2 ),1),1/4),
					Pseg(Pseq([
						1/2, 2/8,
					]+( 0/2 ),1),3/4),
					Pseg(Pseq([
						1/2, 4,
					],1.1),1),


					Pseg(Pseq([
						0, 1/8,
					]+( 0/2 ),1),3/2),
					Pseg(Pseq([
						1/2, 4,
					],1.1),1/2),

					Pseg(Pseq([
						1/4, 2/8,
					]+( 0/2 ),1),1/4),
					Pseg(Pseq([
						1/2, 2/8,
					]+( 0/2 ),1),3/4),
					Pseg(Pseq([
						0, 4,
					],1.1),1),
				],1),
				Pseq([
					Pseg(Pseq([
						0, 1/8,
					]+( 1/8 ),1),3/2),
					Pseg(Pseq([
						1/2, 4,
					],1.1),1/2),

					Pseg(Pseq([
						1/4, 8,
					]+( 0/2 ),1),1/4),
					Pseg(Pseq([
						1/2, 2/8,
					]+( 0/2 ),1),3/4),
					Pseg(Pseq([
						1/2, 4,
					],1.1),1),


					Pseg(Pseq([
						0, 1/8,
					]+( 0/2 ),1),3/2),
					Pseg(Pseq([
						1/2, 4,
					],1.1),1/2),

					Pseg(Pseq([
						1/4, 2/8,
					]+( 0/2 ),1),1/4),
					Pseg(Pseq([
						1/2, 2/8,
					]+( 0/2 ),1),3/4),
					Pseg(Pseq([
						1/2, 8,
					],1.1),1),
				],1),
			],inf) / Pkey(\st),
			\dur, 1/32,
			\isRest, Pseq([
				Pseq([
					1,1,1,1, 1,1,1,1,
					2,1,1,1, 1,1,1,1,
					2,1,1,1, 1.3,1,1,1,
					1,1,1,1, 2,1,1,1,
				],7),
				Pseq([
					1,1,1,1, 1,1,1,1,
					2,1,1,1, 1,1,1,1,
					0,0,0,0, 0,0,0,0,
					1,1,1,1, 2,1,1,1,
				],1),
				Pseq([
					1,1,1,1, 1,1,1,1,
					2,1,1,1, 1,1,1,1,
					2,1,1,1, 1.3,1,1,1,
					1,1,1,1, 2,1,1,1,
				],7),
				Pseq([
					1,1,1,1, 1,1,1,1,
					2,1,1,1, 1,1,1,1,
					2,1,1,1, 1,1,1,1,
					2,0,0,0, 2,2,2,2,
				]*0.7,1),
			]*0.7,inf).coin.not,
			\gain, 1,
			\out, BusDef(\comp, \audio),
		),
		PschedMute(Pseq([0,7,1,0],inf)) <>
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[1238].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pmono(\simplecomp,
			\inbus, BusDef(\comp, \audio),
			\cpt, 0.1,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1.2,
			\dur, 1,
		),
		PschedMute(Pseq([0,7,1,0],inf)) <>
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[680].value,
			\legato,1/2,
			\isRest, Pseq([
				0,0,1,0,
				1,0,1,0,
				1,0,1,0,
				0,0,0,0,
			]*0.3,inf).coin.not,
			\dur, 1/16,
			\gain, 0.07,
			\out, BusDef(\echo, \audio),
		),
		PschedMute(Pseq([0,7,1,0],inf)) <>
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[673].value,
			\legato,2,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,1, 1,0,0,0, 1,0,0,0,
				1,0,0,1, 1,0,0,0, 1,0,0,0, 1,0,0,1,
				1,0,0,0, 1,0,0,1, 1,0,0,0, 1,0,0,0,
				1,0,0,1, 1,0,0,0, 1,0,0,0, 1,0,0,1,

				1,0,0,0, 1,0,0,1, 1,0,0,0, 1,0,0,0,
				1,0,0,1, 0,0,1,0, 0,1,0,0, 1,0,0,1,
				1,0,0,0, 1,0,0,1, 1,0,0,0, 1,0,0,0,
				1,0,0,1, 1,0,0,0, 1,0,0,0, 1,0,0,1,
			]*0.7,inf).coin.not,
			\dur, 1/16,
			\gain, 0.11,
			\out, BusDef(\echo, \audio),
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\echo, \audio),
			\addAction, \addToTail,
			\decay, Pseg(Pseq([0,2],inf),8),
			\delay, ~pmodenv.(Pwhite(1/20,0.2), Pwhite(0.1,8)),
			\mix, 0.5,
			\lag, 0.0009,
			\dur, 1/4,
		),
		PschedMute(Pseq([0,7,1,0],inf)) <>
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[2076].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.31,
		),
		Pbind(
			\instrument, \peaky,
			\note, Pseq([
				11,10,
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,

				Pseq([
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
				],8),
				Pseq([
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
				]*0.7,16),
			],inf).coin.not,
			\dur, 1/16,
			\fspread, ~pmodenv.(Pseq([0.05,0.12],inf), Pwhite(0.7,4)),
			\lpfr, ~pmodenv.(Pseq([1,2,1,4]/2,inf), Pwhite(0.7,4)),
			\out, BusDef(\echopeaky, \audio),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \peaky,
			\note, Pseq([
				7,1,
			],inf)+12,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],8),
				Pseq([
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
				]*0.7,16),
			],inf).stutter(8).coin.not,
			\dur, 1/16,
			\lag, 1/32,
			\fspread, ~pmodenv.(Pseq([0.05,0.12],inf), Pwhite(0.7,4)),
			\lpfr, ~pmodenv.(Pseq([1,2,1,4]/2,inf), Pwhite(0.7,4)),
			\out, BusDef(\echopeaky, \audio),
			\amp, 0.1,
		),
		Pmono(\fx_echopass,
			\inbus, BusDef(\echopeaky, \audio),
			\addAction, \addToTail,
			\decay, Pseg(Pseq([0,1,2,0.51],inf),7),
			\delay, ~pmodenv.(Pwhite(1/5,0.7), Pwhite(0.1,8)),
			\mix, 0.5,
			\lag, 0.0009,
			\dur, 1,
		),
		PschedMute(Pseq([0,7,1,0],inf)) <>
		Pbind(
			\instrument, \basicbass,
			\note, Pstep(Pseq([
				2,6,6,10,
				5,4,4,10,
				11,7,7,10,
			],inf),1/2),
			\ctranspose, 5,
			\legato, Pseq([
				Prand([
					Pseq([
						1,0.3,0.51,
					],1),
					Pseq([
						1,0.7,
					],1),
					Pseq([
						1,0.7,0.21,
					],1),
				],1),
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.01) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\lpf, ~pmodenv.(Pseq([300,700,100,1000],inf), Pwhite(0.1,8)),
			\rq, ~pmodenv.(Pseq([0.5,0.1,0.8],inf), Pwhite(0.1,8)),
			\octave, 2,
			\dur, 1/8,
			\dur, PdurStutter(Pseq([8,8,8,8, 8,8,8,4],inf), 1/2),
			\amp, 0.1,
		),
		Psched(8,Pbind(
			\instrument, \organ_donorenv,
			//\note, Pseq([
				//( { rrand(0,12) }!5 ).postln,
				//( { rrand(0,12) }!5 ).postln,
				//( { rrand(0,12) }!5 ).postln,
			//].collect({ arg x;
				//x
			//}),inf).stutter(1),
			\note, Pseq([
				[ 1,  5, 11, 2  ],
				[ 6,  4, 7, 5  ],
				[ 10,  4, 1, 5  ],
			],inf).collect({ arg x; x.choose }),
			\ctranspose, 5,
			\oscmixtab, Plazy({
				Pseq([
					[ { 0.1.bilinrand+1 }!100 ],
				],1);
			}).loop,
			\octave, 6,
			\rq, 0.5,
			\fspread, ~pmodenv.(Pseq([0.05,0.001,0.005,0.001,0.02],inf), Pwhite(0.7,4)),
			\adsr, Pseq([
				[ Env.adsr(0.09,0.1,0.2,0.1) ],
			],inf),
			\legato, 0.5,
			\lplfofac, ~pmodenv.(Pseq([0.5,0.05,0.8,0.1]/4,inf), Pwhite(1,7.0)),
			\lpfr, ~pmodenv.(Pseq([0.1,2,1.2,4],inf), Pwhite(1.0,7)),
			\legato, 1.0,
			\oscmix, Pseq([0,1/2,1,Pwhite(0,1.0,1)],inf),
			\oscmix, ~pmodenv.(Pseq([0.8,1/2,0.6,Pwhite(0,1.0,1)],inf), Pwhite(0.5,7)),
			\dur, Pseq([1/2,1,1/2],inf),
			\amp, 0.1/6,
			\dur, PdurStutter(Pseq([1,4,2,8],inf), 1/2),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\out, 0,
			\out, BusDef(\sendbus2, \audio),
		)),
		PschedMute(Pseq([0,14,2,0],inf)) <>
		Pbind(
			\instrument, \bolonvib,
			//\note, Pseq([
				//( { rrand(0,12) }!5 ).postln,
				//( { rrand(0,12) }!5 ).postln,
				//( { rrand(0,12) }!5 ).postln,
			//].collect({ arg x;
				//x
			//}),inf).stutter(1),
			\note, Pseq([
				[ 1,  5, 11, 2  ],
				[ 6,  4, 7, 5  ],
				[ 10,  4, 1, 5  ],
			],inf),
			\ctranspose, 5,
			\oscmixtab, Plazy({
				Pseq([
					[ { 0.1.bilinrand+1 }!100 ],
				],1);
			}).loop,
			\octave, 4,
			\rq, 0.2,
			\fspread, ~pmodenv.(Pseq([0.05,0.001,0.005,0.001,0.02],inf), Pwhite(0.7,4)),
			\adsr, Pseq([
				[ Env.adsr(0.09,0.1,0.8,0.1) ],
			],inf),
			\lplfofac, ~pmodenv.(Pseq([0.5,0.05,0.8,0.1]/4,inf), Pwhite(1,7.0)),
			\lpfr, ~pmodenv.(Pseq([0.1,2,1.2,4],inf), Pwhite(1.0,7)),
			\legato, 1.0,
			\oscmix, Pseq([0,1/2,1,Pwhite(0,1.0,1)],inf),
			\oscmix, ~pmodenv.(Pseq([0.0,1/2,0.6,Pwhite(0,1.0,1)],inf), Pwhite(0.5,7)),
			\dur, Pseq([1/2,1,1/2],inf),
			\amp, 0.1/2,
			\out, 0,
			\out, BusDef(\sendbus2, \audio),
		),
		// icing


		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('clapkai'),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1,
			\pos, 0.08,
			\legato, 4,
			\gain, 1/3.5,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('clappuit'),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1,
			\pos, 0.08,
			\legato, 4,
			\gain, 1/1,
		),
	])
)).play;
);

////// MAIN

(
	~master.();
Pdef(\part, Pdef(\main, 
	Pseq([
		Pfindur(6,Pdef(\intro)),
		Pfindur(6,Pdef(\intro2)),
		Pfindur(2,Pdef(\break1)),
		Pfindur(30,Pdef(\mpart2)),
		Pfindur(8,Pdef(\break1)),
		Pfindur(8,Pdef(\bouillie)),
		Pfindur(6,Pdef(\rumbledrums)),
		Pfindur(2,Pdef(\break1)),
		Pfindur(32,Pdef(\rumbledrums2)),
		Pfindur(6,Pdef(\break2)),
		Pfindur(14,Pdef(\mpart2)),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('clapbass'),
			\adsr, Pseq([
				[ Env.adsr(0.01,1.1,0.4,2.1) ],
			],inf),
			\dur, Pn(4,1),
			\gain, 1,
		)
	])
)).play;
);


////////////////////////////////////////////////////
///////// drafts

(
// drums coin 0.7 + acid bass + widechord + hi
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1474].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[673].value,
			\legato,2,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,1, 1,0,0,0, 1,0,0,0,
				1,0,0,1, 1,0,0,0, 1,0,0,0, 1,0,0,1,
			]*0.7,inf).coin.not,
			\dur, 1/16,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[673].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1268].value,
			\legato,1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.2) ],
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 1,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,1,0,0, 1,0,0,1, 0,0,1,0,
				0,0,1,0, 1,1,0,1, 1,0,1,1, 0,1,1,0,
			]*0.7,inf).coin.not,
			\pan, 1,
			\dur, 1/16,
			\gain, 0.1 * Pseq([1,0.3,0.7],inf),
		),
		Psched(4,Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[673].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1168].value,
			\legato,2,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 1,1,1,1,
					1,0,1,0, 1,0,1,0, 0,0,0,0, 1,1,1,1,
					1,0,0,1, 0,0,1,0, 0,0,0,0, 1,1,1,1,
					1,0,1,0, 1,0,1,0, 0,0,0,0, 1,1,1,1,
					
					0,0,0,0, 0,0,0,0, 0,0,0,0, 1,1,1,1,
					1,0,0,1, 0,0,1,0, 0,0,0,0, 1,1,1,1,
					1,1,0,1, 1,0,1,1, 0,0,0,0, 1,1,1,1,
					1,0,1,0, 1,0,1,0, 0,0,0,0, 1,1,1,1,
				],5),
				Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				],8),
			]*0.7,inf).coin.not,
			\pan, 1,
			\dur, 1/16,
			\gain, 0.11,
		)),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[2076].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.31,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.clap[3].value,
			\bufnum, ~buflib.snare[2076].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 1,1,0,1,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,1,0,0, 1,0,0,0, 0,0,0,1, 1,0,1,1,
			]*0.7,inf).coin.not,
			\dur, 1/16,
			//\lag,0.051,
			\sustain, 0.03 * Prand([1,1.33,1,0.7],inf),
			\gain, 0.21 * Pseq([1,0.3,0.7],inf),
		),
		Psched(8,Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[19].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\bufnum, ~buflib.clap[49].value,
			\isRest, Pseq([
				0,0,1,0, 0,1,0,1,
				0,0,1,0, 1,0,0,1,
				1,1,1,1, 0,0,0,0,
				1,1,0,1, 0,0,1,0,
				0,0,0,0, 1,1,1,1,
				0,1,0,1, 1,0,0,0,
				0,1,0,0, 1,1,0,1,
				Pseq([
					0,0,0,0, 0,0,0,0,
				],15),
			]*0.7,inf).coin.not,
			\dur, 1/16,
			\lag, 1/32,
			\gain, 0.11,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.4,0.1) ],
			],inf),
			\sustain, 0.02 * Prand([1,1.33,1,0.7],inf),
			\gain, 0.07 * Pseq([1,0.3,0.7],inf),
		)),
		Pbind(
			\instrument, \basicbass,
			\note, Pstep(Pseq([
				2,6,6,10,
				5,4,4,10,
				11,7,7,10,
			],inf),1/2),
			\ctranspose, 5,
			\legato, Pseq([
				Prand([
					Pseq([
						1,0.3,0.51,
					],1),
					Pseq([
						1,0.7,
					],1),
					Pseq([
						1,0.7,0.21,
					],1),
				],1),
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.01) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\lpf, ~pmodenv.(Pseq([300,700,100,1000],inf), Pwhite(0.1,8)),
			\rq, ~pmodenv.(Pseq([0.5,0.1,0.8],inf), Pwhite(0.1,8)),
			\octave, 2,
			\dur, 1/8,
			\dur, PdurStutter(Pseq([8,8,8,8, 8,8,8,4],inf), 1/2),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \organ_donorenv,
			//\note, Pseq([
				//( { rrand(0,12) }!5 ).postln,
				//( { rrand(0,12) }!5 ).postln,
				//( { rrand(0,12) }!5 ).postln,
			//].collect({ arg x;
				//x
			//}),inf).stutter(1),
			\note, Pseq([
				[ 1,  5, 11, 2  ],
				[ 6,  4, 7, 5  ],
				[ 10,  4, 1, 5  ],
			],inf).collect({ arg x; x.choose }),
			\ctranspose, 5,
			\oscmixtab, Plazy({
				Pseq([
					[ { 0.1.bilinrand+1 }!100 ],
				],1);
			}).loop,
			\octave, 6,
			\rq, 0.5,
			\fspread, ~pmodenv.(Pseq([0.05,0.001,0.005,0.001,0.02],inf), Pwhite(0.7,4)),
			\adsr, Pseq([
				[ Env.adsr(0.09,0.1,0.2,0.1) ],
			],inf),
			\legato, 0.5,
			\lplfofac, ~pmodenv.(Pseq([0.5,0.05,0.8,0.1]/4,inf), Pwhite(1,7.0)),
			\lpfr, ~pmodenv.(Pseq([0.1,2,1.2,4],inf), Pwhite(1.0,7)),
			\legato, 1.0,
			\oscmix, Pseq([0,1/2,1,Pwhite(0,1.0,1)],inf),
			\oscmix, ~pmodenv.(Pseq([0.8,1/2,0.6,Pwhite(0,1.0,1)],inf), Pwhite(0.5,7)),
			\dur, Pseq([1/2,1,1/2],inf),
			\amp, 0.1/6,
			\dur, PdurStutter(Pseq([1,4,2,8],inf), 1/2),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\out, 0,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \bolonvib,
			//\note, Pseq([
				//( { rrand(0,12) }!5 ).postln,
				//( { rrand(0,12) }!5 ).postln,
				//( { rrand(0,12) }!5 ).postln,
			//].collect({ arg x;
				//x
			//}),inf).stutter(1),
			\note, Pseq([
				[ 1,  5, 11, 2  ],
				[ 6,  4, 7, 5  ],
				[ 10,  4, 1, 5  ],
			],inf),
			\ctranspose, 5,
			\oscmixtab, Plazy({
				Pseq([
					[ { 0.1.bilinrand+1 }!100 ],
				],1);
			}).loop,
			\octave, 4,
			\rq, 0.2,
			\fspread, ~pmodenv.(Pseq([0.05,0.001,0.005,0.001,0.02],inf), Pwhite(0.7,4)),
			\adsr, Pseq([
				[ Env.adsr(0.09,0.1,0.8,0.1) ],
			],inf),
			\lplfofac, ~pmodenv.(Pseq([0.5,0.05,0.8,0.1]/4,inf), Pwhite(1,7.0)),
			\lpfr, ~pmodenv.(Pseq([0.1,2,1.2,4],inf), Pwhite(1.0,7)),
			\legato, 1.0,
			\oscmix, Pseq([0,1/2,1,Pwhite(0,1.0,1)],inf),
			\oscmix, ~pmodenv.(Pseq([0.0,1/2,0.6,Pwhite(0,1.0,1)],inf), Pwhite(0.5,7)),
			\dur, Pseq([1/2,1,1/2],inf),
			\amp, 0.1/2,
			\out, 0,
			\out, BusDef(\sendbus2, \audio),
		),
		Psched(8,Pmono(
			\bilinvibrond,
			//\note, Pseq([
				//2,0,
			//],inf),
			\degree, Pstep(Pwhite(0,7),Prand([Pseq([1/8],8),1,2,4],inf)),
			\degree, Prand([0,2,4],inf),

			\note, Prand([
				Pseq([ 11,10,7,6,5,4,2,1 ],1),
				Pseq([ 11,10,7,6,5,4,2,1 ]-12,1),
			],inf),
			\ctranspose, 5,
			\octave, 6,
			//\dur, PdurStutter(Pseq([1,4],inf), 4),

			\oscmixtab, Plazy({
				Pseq([
					[ { 0.1.bilinrand+1 }!100 ],
				],1);
			}).loop,
			\fspread, ~pmodenv.(Pseq([0.005,0.01],inf), Pwhite(1.0,8,inf)),
			\lplfofac, ~pmodenv.(Pseq([0.5,0.05,0.8,0.1]/4,inf), Pwhite(1,7.0)),
			\oscmix, Pseq([0,1/2,1,Pwhite(0,1.0,1)],inf),

			\modamp, ~pmodenv.(Pseq([0.4,1,0.02,1,0.1,1.4],inf), Pwhite(1/2,4), 1, -4),
			\oscmix, ~pmodenv.(Pseq([0.01,0.3,Pwhite(0,0.4,1)],inf), Pwhite(0.5,7)),
			\lpfr, ~pmodenv.(Pseq([2,4],inf), Pwhite(1.0/8,8)),
			\rq, 0.4,
			\lpmix, ~pmodenv.(Pseq([1,2,1,4]/4,inf), Pwhite(1.0/8,8)),
			\lpmix,1,
			\adsr, Pseq([
				[ Env.adsr(1.4,0.1,0.8,2.1) ],
			],inf),
			\dur, Pwrand([1/8,1/4,1],[1,2,3].cubed.normalizeSum,inf),
			\amp, 0.1/2,
			\pan, Pseq([1,-1],inf),
			\out, BusDef(\sendbus2, \audio),
			\amp, 0.12,
		)),
		
	])
)).play;
);

(
// drums coin 0.7 + acid bass + widechord
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1474].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[673].value,
			\legato,2,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,1, 1,0,0,0, 1,0,0,0,
				1,0,0,1, 1,0,0,0, 1,0,0,0, 1,0,0,1,
			]*0.7,inf).coin.not,
			\dur, 1/16,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[673].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1268].value,
			\legato,1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.2) ],
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 1,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,1,0,0, 1,0,0,1, 0,0,1,0,
				0,0,1,0, 1,1,0,1, 1,0,1,1, 0,1,1,0,
			]*0.7,inf).coin.not,
			\pan, 1,
			\dur, 1/16,
			\gain, 0.1 * Pseq([1,0.3,0.7],inf),
		),
		Psched(4,Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[673].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1168].value,
			\legato,2,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 1,1,1,1,
					1,0,1,0, 1,0,1,0, 0,0,0,0, 1,1,1,1,
					1,0,0,1, 0,0,1,0, 0,0,0,0, 1,1,1,1,
					1,0,1,0, 1,0,1,0, 0,0,0,0, 1,1,1,1,
					
					0,0,0,0, 0,0,0,0, 0,0,0,0, 1,1,1,1,
					1,0,0,1, 0,0,1,0, 0,0,0,0, 1,1,1,1,
					1,1,0,1, 1,0,1,1, 0,0,0,0, 1,1,1,1,
					1,0,1,0, 1,0,1,0, 0,0,0,0, 1,1,1,1,
				],5),
				Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				],8),
			]*0.7,inf).coin.not,
			\pan, 1,
			\dur, 1/16,
			\gain, 0.11,
		)),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[2076].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.31,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.clap[3].value,
			\bufnum, ~buflib.snare[2076].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 1,1,0,1,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,1,0,0, 1,0,0,0, 0,0,0,1, 1,0,1,1,
			]*0.7,inf).coin.not,
			\dur, 1/16,
			//\lag,0.051,
			\sustain, 0.03 * Prand([1,1.33,1,0.7],inf),
			\gain, 0.21 * Pseq([1,0.3,0.7],inf),
		),
		Psched(8,Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[19].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\bufnum, ~buflib.clap[49].value,
			\isRest, Pseq([
				0,0,1,0, 0,1,0,1,
				0,0,1,0, 1,0,0,1,
				1,1,1,1, 0,0,0,0,
				1,1,0,1, 0,0,1,0,
				0,0,0,0, 1,1,1,1,
				0,1,0,1, 1,0,0,0,
				0,1,0,0, 1,1,0,1,
				Pseq([
					0,0,0,0, 0,0,0,0,
				],15),
			]*0.7,inf).coin.not,
			\dur, 1/16,
			\lag, 1/32,
			\gain, 0.11,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.4,0.1) ],
			],inf),
			\sustain, 0.02 * Prand([1,1.33,1,0.7],inf),
			\gain, 0.07 * Pseq([1,0.3,0.7],inf),
		)),
		Pbind(
			\instrument, \basicbass,
			\note, Pstep(Pseq([
				2,6,6,10,
				5,4,4,10,
				11,7,7,10,
			],inf),1/2),
			\ctranspose, 5,
			\legato, Pseq([
				Prand([
					Pseq([
						1,0.3,0.51,
					],1),
					Pseq([
						1,0.7,
					],1),
					Pseq([
						1,0.7,0.21,
					],1),
				],1),
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.01) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\lpf, ~pmodenv.(Pseq([300,700,100,1000],inf), Pwhite(0.1,8)),
			\rq, ~pmodenv.(Pseq([0.5,0.1,0.8],inf), Pwhite(0.1,8)),
			\octave, 2,
			\dur, 1/8,
			\dur, PdurStutter(Pseq([8,8,8,8, 8,8,8,4],inf), 1/2),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \organ_donorenv,
			//\note, Pseq([
				//( { rrand(0,12) }!5 ).postln,
				//( { rrand(0,12) }!5 ).postln,
				//( { rrand(0,12) }!5 ).postln,
			//].collect({ arg x;
				//x
			//}),inf).stutter(1),
			\note, Pseq([
				[ 1,  5, 11, 2  ],
				[ 6,  4, 7, 5  ],
				[ 10,  4, 1, 5  ],
			],inf).collect({ arg x; x.choose }),
			\ctranspose, 5,
			\oscmixtab, Plazy({
				Pseq([
					[ { 0.1.bilinrand+1 }!100 ],
				],1);
			}).loop,
			\octave, 6,
			\rq, 0.5,
			\fspread, ~pmodenv.(Pseq([0.05,0.001,0.005,0.001,0.02],inf), Pwhite(0.7,4)),
			\adsr, Pseq([
				[ Env.adsr(0.09,0.1,0.2,0.1) ],
			],inf),
			\legato, 0.5,
			\lplfofac, ~pmodenv.(Pseq([0.5,0.05,0.8,0.1]/4,inf), Pwhite(1,7.0)),
			\lpfr, ~pmodenv.(Pseq([0.1,2,1.2,4],inf), Pwhite(1.0,7)),
			\legato, 1.0,
			\oscmix, Pseq([0,1/2,1,Pwhite(0,1.0,1)],inf),
			\oscmix, ~pmodenv.(Pseq([0.8,1/2,0.6,Pwhite(0,1.0,1)],inf), Pwhite(0.5,7)),
			\dur, Pseq([1/2,1,1/2],inf),
			\amp, 0.1/6,
			\dur, PdurStutter(Pseq([1,4,2,8],inf), 1/2),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\out, 0,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \bolonvib,
			//\note, Pseq([
				//( { rrand(0,12) }!5 ).postln,
				//( { rrand(0,12) }!5 ).postln,
				//( { rrand(0,12) }!5 ).postln,
			//].collect({ arg x;
				//x
			//}),inf).stutter(1),
			\note, Pseq([
				[ 1,  5, 11, 2  ],
				[ 6,  4, 7, 5  ],
				[ 10,  4, 1, 5  ],
			],inf),
			\ctranspose, 5,
			\oscmixtab, Plazy({
				Pseq([
					[ { 0.1.bilinrand+1 }!100 ],
				],1);
			}).loop,
			\octave, 4,
			\rq, 0.2,
			\fspread, ~pmodenv.(Pseq([0.05,0.001,0.005,0.001,0.02],inf), Pwhite(0.7,4)),
			\adsr, Pseq([
				[ Env.adsr(0.09,0.1,0.8,0.1) ],
			],inf),
			\lplfofac, ~pmodenv.(Pseq([0.5,0.05,0.8,0.1]/4,inf), Pwhite(1,7.0)),
			\lpfr, ~pmodenv.(Pseq([0.1,2,1.2,4],inf), Pwhite(1.0,7)),
			\legato, 1.0,
			\oscmix, Pseq([0,1/2,1,Pwhite(0,1.0,1)],inf),
			\oscmix, ~pmodenv.(Pseq([0.0,1/2,0.6,Pwhite(0,1.0,1)],inf), Pwhite(0.5,7)),
			\dur, Pseq([1/2,1,1/2],inf),
			\amp, 0.1/2,
			\out, 0,
			\out, BusDef(\sendbus2, \audio),
		),
		
	])
)).play;
);

(
// drums coin 0.7 + rumble bass + widechords
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1474].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[673].value,
			\legato,2,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,1, 1,0,0,0, 1,0,0,0,
				1,0,0,1, 1,0,0,0, 1,0,0,0, 1,0,0,1,
			]*0.7,inf).coin.not,
			\dur, 1/16,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[673].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1268].value,
			\legato,1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.2) ],
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 1,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,1,0,0, 1,0,0,1, 0,0,1,0,
				0,0,1,0, 1,1,0,1, 1,0,1,1, 0,1,1,0,
			]*0.7,inf).coin.not,
			\pan, 1,
			\dur, 1/16,
			\gain, 0.1 * Pseq([1,0.3,0.7],inf),
		),
		Psched(4,Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[673].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1168].value,
			\legato,2,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 1,1,1,1,
					1,0,1,0, 1,0,1,0, 0,0,0,0, 1,1,1,1,
					1,0,0,1, 0,0,1,0, 0,0,0,0, 1,1,1,1,
					1,0,1,0, 1,0,1,0, 0,0,0,0, 1,1,1,1,
					
					0,0,0,0, 0,0,0,0, 0,0,0,0, 1,1,1,1,
					1,0,0,1, 0,0,1,0, 0,0,0,0, 1,1,1,1,
					1,1,0,1, 1,0,1,1, 0,0,0,0, 1,1,1,1,
					1,0,1,0, 1,0,1,0, 0,0,0,0, 1,1,1,1,
				],5),
				Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				],8),
			]*0.7,inf).coin.not,
			\pan, 1,
			\dur, 1/16,
			\gain, 0.11,
		)),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[2076].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.31,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.clap[3].value,
			\bufnum, ~buflib.snare[2076].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 1,1,0,1,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,1,0,0, 1,0,0,0, 0,0,0,1, 1,0,1,1,
			]*0.7,inf).coin.not,
			\dur, 1/16,
			//\lag,0.051,
			\sustain, 0.03 * Prand([1,1.33,1,0.7],inf),
			\gain, 0.21 * Pseq([1,0.3,0.7],inf),
		),
		Psched(8,Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[19].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\bufnum, ~buflib.clap[49].value,
			\isRest, Pseq([
				0,0,1,0, 0,1,0,1,
				0,0,1,0, 1,0,0,1,
				1,1,1,1, 0,0,0,0,
				1,1,0,1, 0,0,1,0,
				0,0,0,0, 1,1,1,1,
				0,1,0,1, 1,0,0,0,
				0,1,0,0, 1,1,0,1,
				Pseq([
					0,0,0,0, 0,0,0,0,
				],15),
			]*0.7,inf).coin.not,
			\dur, 1/16,
			\lag, 1/32,
			\gain, 0.11,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.4,0.1) ],
			],inf),
			\sustain, 0.02 * Prand([1,1.33,1,0.7],inf),
			\gain, 0.07 * Pseq([1,0.3,0.7],inf),
		)),
		Psched(8+8,Pbind(
			\instrument, \grainephasor,
			\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
			\note, Pseq([
				0,3,1,2,
			],inf).stutter(4),
			\gdur, 0.051,
			\gfreq, Pkey(\freq),
			\endpos, ~pmodenv.(Pseq([0.1],inf), 8),
			\gdur, ~pmodenv.(Pseq([0.01,0.1],inf), 4),
			\pos, 0,
			\phasortrig, Plazy({ arg ev;
				Ndef(\lfo1, { 
					Impulse.kr(
						Line.kr(1,( ev.use{~freq.value}/4 ).postln,1/2/~t)*~t
						//EnvGen.kr(Env([1,1,ev.use{~freq.value},10],[0,8.1,0.8]), Impulse.kr(1/4*~t)).poll
					) 
				}).asPattern.keep(8)
			}).loop,
			\gfreq, 100,
			\legato, Pseq([
				Pseq([
					2,0,0,1, 0,0,0,1,
					1,0,1,0, 0,0,0,0,
					4,0,0,0, 0,0,0,1,
					0,0,2.5,0, 0,1,0,0,
				],4),
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
				Pseq([
					2,0,0,1, 0,0,0,1,
					1,0,1,0, 0,0,0,0,
					4,0,0,0, 0,0,0,1,
					0,0,2.5,0, 0,1,0,0,
				],3),
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1/2,
			\out, BusDef(\sendbus1, \audio),
		)),
		Pbind(
			\instrument, \bolonvib,
			//\note, Pseq([
				//( { rrand(0,12) }!5 ).postln,
				//( { rrand(0,12) }!5 ).postln,
				//( { rrand(0,12) }!5 ).postln,
			//].collect({ arg x;
				//x
			//}),inf).stutter(1),
			\note, Pseq([
				[ 1,  5, 11, 2  ],
				[ 6,  4, 7, 5  ],
				[ 10,  4, 1, 5  ],
			],inf),
			\ctranspose, 5,
			\oscmixtab, Plazy({
				Pseq([
					[ { 0.1.bilinrand+1 }!100 ],
				],1);
			}).loop,
			\octave, 4,
			\rq, 0.5,
			\fspread, ~pmodenv.(Pseq([0.05,0.001,0.005,0.001,0.02],inf), Pwhite(0.7,4)),
			\adsr, Pseq([
				[ Env.adsr(0.09,0.1,0.8,0.1) ],
			],inf),
			\lplfofac, ~pmodenv.(Pseq([0.5,0.05,0.8,0.1]/4,inf), Pwhite(1,7.0)),
			\lpfr, ~pmodenv.(Pseq([0.1,2,1.2,4],inf), Pwhite(1.0,7)),
			\legato, 1.0,
			\oscmix, Pseq([0,1/2,1,Pwhite(0,1.0,1)],inf),
			\oscmix, ~pmodenv.(Pseq([0.8,1/2,0.6,Pwhite(0,1.0,1)],inf), Pwhite(0.5,7)),
			\dur, Pseq([1/2,1,1/2],inf),
			\amp, 0.1/2,
			\out, 0,
			\out, BusDef(\sendbus2, \audio),
		),
		
	])
)).play;
);

(
// drums + rumble bass + widechords
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1474].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[673].value,
			\legato,2,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,1, 1,0,0,0, 1,0,0,0,
				1,0,0,1, 1,0,0,0, 1,0,0,0, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[673].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1268].value,
			\legato,1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.2) ],
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 1,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,1,0,0, 1,0,0,1, 0,0,1,0,
				0,0,1,0, 1,1,0,1, 1,0,1,1, 0,1,1,0,
			],inf).coin.not,
			\pan, 1,
			\dur, 1/16,
			\gain, 0.1 * Pseq([1,0.3,0.7],inf),
		),
		Psched(4,Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[673].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1168].value,
			\legato,2,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 1,1,1,1,
					1,0,1,0, 1,0,1,0, 0,0,0,0, 1,1,1,1,
					1,0,0,1, 0,0,1,0, 0,0,0,0, 1,1,1,1,
					1,0,1,0, 1,0,1,0, 0,0,0,0, 1,1,1,1,
					
					0,0,0,0, 0,0,0,0, 0,0,0,0, 1,1,1,1,
					1,0,0,1, 0,0,1,0, 0,0,0,0, 1,1,1,1,
					1,1,0,1, 1,0,1,1, 0,0,0,0, 1,1,1,1,
					1,0,1,0, 1,0,1,0, 0,0,0,0, 1,1,1,1,
				],5),
				Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				],8),
			],inf).coin.not,
			\pan, 1,
			\dur, 1/16,
			\gain, 0.11,
		)),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[2076].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.31,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.clap[3].value,
			\bufnum, ~buflib.snare[2076].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 1,1,0,1,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,1,0,0, 1,0,0,0, 0,0,0,1, 1,0,1,1,
			],inf).coin.not,
			\dur, 1/16,
			//\lag,0.051,
			\sustain, 0.03 * Prand([1,1.33,1,0.7],inf),
			\gain, 0.21 * Pseq([1,0.3,0.7],inf),
		),
		Psched(8,Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[19].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\bufnum, ~buflib.clap[49].value,
			\isRest, Pseq([
				0,0,1,0, 0,1,0,1,
				0,0,1,0, 1,0,0,1,
				1,1,1,1, 0,0,0,0,
				1,1,0,1, 0,0,1,0,
				0,0,0,0, 1,1,1,1,
				0,1,0,1, 1,0,0,0,
				0,1,0,0, 1,1,0,1,
				Pseq([
					0,0,0,0, 0,0,0,0,
				],15),
			],inf).coin.not,
			\dur, 1/16,
			\lag, 1/32,
			\gain, 0.11,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.4,0.1) ],
			],inf),
			\sustain, 0.02 * Prand([1,1.33,1,0.7],inf),
			\gain, 0.07 * Pseq([1,0.3,0.7],inf),
		)),
		Psched(8+8,Pbind(
			\instrument, \grainephasor,
			\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
			\note, Pseq([
				0,3,1,2,
			],inf).stutter(4),
			\gdur, 0.051,
			\gfreq, Pkey(\freq),
			\endpos, ~pmodenv.(Pseq([0.1],inf), 8),
			\gdur, ~pmodenv.(Pseq([0.01,0.1],inf), 4),
			\pos, 0,
			\phasortrig, Plazy({ arg ev;
				Ndef(\lfo1, { 
					Impulse.kr(
						Line.kr(1,( ev.use{~freq.value}/4 ).postln,1/2/~t)*~t
						//EnvGen.kr(Env([1,1,ev.use{~freq.value},10],[0,8.1,0.8]), Impulse.kr(1/4*~t)).poll
					) 
				}).asPattern.keep(8)
			}).loop,
			\gfreq, 100,
			\legato, Pseq([
				Pseq([
					2,0,0,1, 0,0,0,1,
					1,0,1,0, 0,0,0,0,
					4,0,0,0, 0,0,0,1,
					0,0,2.5,0, 0,1,0,0,
				],4),
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
				Pseq([
					2,0,0,1, 0,0,0,1,
					1,0,1,0, 0,0,0,0,
					4,0,0,0, 0,0,0,1,
					0,0,2.5,0, 0,1,0,0,
				],3),
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1/2,
			\out, BusDef(\sendbus1, \audio),
		)),
		Pbind(
			\instrument, \bolonvib,
			//\note, Pseq([
				//( { rrand(0,12) }!5 ).postln,
				//( { rrand(0,12) }!5 ).postln,
				//( { rrand(0,12) }!5 ).postln,
			//].collect({ arg x;
				//x
			//}),inf).stutter(1),
			\note, Pseq([
				[ 1,  5, 11, 2  ],
				[ 6,  4, 7, 5  ],
				[ 10,  4, 1, 5  ],
			],inf),
			\ctranspose, 5,
			\oscmixtab, Plazy({
				Pseq([
					[ { 0.1.bilinrand+1 }!100 ],
				],1);
			}).loop,
			\octave, 4,
			\rq, 0.5,
			\fspread, ~pmodenv.(Pseq([0.05,0.001,0.005,0.001,0.02],inf), Pwhite(0.7,4)),
			\adsr, Pseq([
				[ Env.adsr(0.09,0.1,0.8,0.1) ],
			],inf),
			\lplfofac, ~pmodenv.(Pseq([0.5,0.05,0.8,0.1]/4,inf), Pwhite(1,7.0)),
			\lpfr, ~pmodenv.(Pseq([0.1,2,1.2,4],inf), Pwhite(1.0,7)),
			\legato, 1.0,
			\oscmix, Pseq([0,1/2,1,Pwhite(0,1.0,1)],inf),
			\oscmix, ~pmodenv.(Pseq([0.8,1/2,0.6,Pwhite(0,1.0,1)],inf), Pwhite(0.5,7)),
			\dur, Pseq([1/2,1,1/2],inf),
			\amp, 0.1/2,
			\out, 0,
			\out, BusDef(\sendbus2, \audio),
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1474].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[673].value,
			\legato,2,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,1, 1,0,0,0, 1,0,0,0,
				1,0,0,1, 1,0,0,0, 1,0,0,0, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[673].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1168].value,
			\legato,2,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 0,0,0,0, 1,1,1,1,
				1,0,1,0, 1,0,1,0, 0,0,0,0, 1,1,1,1,
				1,0,0,1, 0,0,1,0, 0,0,0,0, 1,1,1,1,
				1,0,1,0, 1,0,1,0, 0,0,0,0, 1,1,1,1,

				0,0,0,0, 0,0,0,0, 0,0,0,0, 1,1,1,1,
				1,0,0,1, 0,0,1,0, 0,0,0,0, 1,1,1,1,
				1,1,0,1, 1,0,1,1, 0,0,0,0, 1,1,1,1,
				1,0,1,0, 1,0,1,0, 0,0,0,0, 1,1,1,1,
			],inf).coin.not,
			\pan, 1,
			\dur, 1/16,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[2076].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.31,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.clap[3].value,
			\bufnum, ~buflib.snare[2076].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 0,0,0,0, 1,1,0,1,
				0,1,0,0, 1,0,0,0, 0,0,0,1, 1,0,1,1,
			],inf).coin.not,
			\dur, 1/16,
			//\lag,0.051,
			\sustain, 0.03 * Prand([1,1.33,1,0.7],inf),
			\gain, 0.21 * Pseq([1,0.3,0.7],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[19].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\bufnum, ~buflib.clap[49].value,
			\isRest, Pseq([
				0,0,1,0, 0,1,0,1,
				0,0,1,0, 1,0,0,1,
				1,1,1,1, 0,0,0,0,
				1,1,0,1, 0,0,1,0,
				0,0,0,0, 1,1,1,1,
				0,1,0,1, 1,0,0,0,
				0,1,0,0, 1,1,0,1,
			],inf).coin.not,
			\dur, 1/16,
			\lag, 1/32,
			\gain, 0.11,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.4,0.1) ],
			],inf),
			\sustain, 0.02 * Prand([1,1.33,1,0.7],inf),
			\gain, 0.07 * Pseq([1,0.3,0.7],inf),
		),
		Pbind(
			\instrument, \grainephasor,
			\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
			\note, Pseq([
				0,3,1,2,
			],inf).stutter(4),
			\gdur, 0.051,
			\gfreq, Pkey(\freq),
			\endpos, ~pmodenv.(Pseq([0.1],inf), 8),
			\gdur, ~pmodenv.(Pseq([0.01,0.1],inf), 4),
			\pos, 0,
			\phasortrig, Plazy({ arg ev;
				Ndef(\lfo1, { 
					Impulse.kr(
						Line.kr(1,( ev.use{~freq.value}/4 ).postln,1/2/~t)*~t
						//EnvGen.kr(Env([1,1,ev.use{~freq.value},10],[0,8.1,0.8]), Impulse.kr(1/4*~t)).poll
					) 
				}).asPattern.keep(8)
			}).loop,
			\gfreq, 100,
			\legato, Pseq([
				2,0,0,1, 0,0,0,1,
				1,0,1,0, 0,0,0,0,
				4,0,0,0, 0,0,0,1,
				0,0,2.5,0, 0,1,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1/2,
			\out, BusDef(\sendbus1, \audio),
		),
		
	])
)).play;
);

(
// simple rand chord + rumble bass
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1474].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				1,0,0,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[2076].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.31,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[2076].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0.31,0,0, 0,1,0,1,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,1, 0,0,0,1,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
				0,0,0,0, 0,0,1,0,
			]*0.7,inf).coin.not,
			\dur, 1/16,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1926].value,
			\isRest, Pseq([
				Pseq([
					1,1,1,1, 1,0,1,0,
					1,0,1,0, 1,1,0,1, 
					1,0,1,0, 1,1,1,1,
					1,0,1,0, 1,0,0,0, 
					
					1,1,1,1, 1,0,1,0,
					1,0,1,0, 1,0,1,0, 
					1,0,1,0, 1,1,1,1,
					1,0,1,0, 1,0,1,0, 
					
					1,1,1,1, 1,0,1,0,
					1,0,0,0, 0,0,1,1, 
					0,0,1,1, 1,0,0,1,
					1,0,1,0, 1,0,1,0, 
				],1),
				Prand([
					1,1,1,1, 1,0,1,0,
					1,0,1,0, 1,1,0,1, 
					1,0,1,0, 1,1,1,1,
					1,0,1,0, 1,0,0,0, 
					
					1,1,1,1, 1,0,1,0,
					1,0,1,0, 1,0,1,0, 
					1,0,1,0, 1,1,1,1,
					1,0,1,0, 1,0,1,0, 
					
					1,1,1,1, 1,0,1,0,
					1,0,0,0, 0,0,1,1, 
					0,0,1,1, 1,0,0,1,
					1,0,1,0, 1,0,1,0, 
				].clump(8*4).collect({ arg x; Pseq(x) })*0.8,1),
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.11 * Pseq([
				1,Pwhite(0.5,0.91,1),
				Pwhite(0.7,0.91,1), Pwhite(0.2,0.71,1)
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1927].value,
			\isRest, Pseq([

				1,1,1,1, 1,0,1,0,
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,1,1,1,
				1,0,1,0, 1,0,1,0, 
			]*0.3,inf).coin.not,
			\lag, 1/16/~t,
			\speed, 1/2+Pwhite(0,0.01),
			\legato, Pseq([
				0.11,Pwhite(0.1,0.4,3),
				Pwhite(0.1,0.4,1), 0.41,Pwhite(0.1,0.4,2),
				Pwhite(0.1,0.4,2), 0.41,Pwhite(0.1,0.4,2),
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \grainephasor,
			\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
			\note, Pseq([
				0,3,1,2,
			],inf).stutter(4),
			\gdur, 0.051,
			\gfreq, Pkey(\freq)/8/16*Pseg(Prand([1,16,32,8,64],inf),Pwhite(1/4,1/8)),
			\endpos, ~pmodenv.(Pseq([0.1],inf), 8),
			\gdur, ~pmodenv.(Pseq([0.01,0.1],inf), 4),
			\pos, 0,
			\phasortrig, Plazy({ arg ev;
				Ndef(\lfo1, { 
					Impulse.kr(
						Line.kr(1,( ev.use{~freq.value}/4 ).postln,1/2/~t)*~t
						//EnvGen.kr(Env([1,1,ev.use{~freq.value},10],[0,8.1,0.8]), Impulse.kr(1/4*~t)).poll
					) 
				}).asPattern.keep(8)
			}).loop,
			//\gfreq, 40,
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,2,0,
				8,0,0,0, 0,0,0,0,
				0,0,2,0, 0,0,0,0,
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 4,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1/4,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \chordmito2hpf,
			\note, Pseq([
				[4,7,5,1],
				( { rrand(0,12) }!5 ).postln,
				[4,7,5,1],
				( { rrand(0,12) }!5 ).postln,
			],inf),
			\note, Pseq([
				[ 0,3,7,11, ],
				[ 0,3,7,11, ]+4
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.5) ],
			],inf),
			\hpfr, Ndef(\rbassanalyzer, {
				var sig;
				var in = InFeedback.ar(BusDef(\sendbus1,\audio),2);
				sig = in;
				sig = DelayN.ar(sig,0.4,0.4)+sig;
				sig = DelayN.ar(sig,0.4,0.4)+sig;
				sig = sig/3;
				Amplitude.kr(sig).linlin(0,0.01,1/8,4);
			}),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,4.1) ],
			],inf),
			\dur, 1/1,
			\legato, 0.3,
			\amp, 0.1/2,
			\fspread, ~pmodenv.(Pseq([0.001,0.02,0.007],inf), Pwhite(0.1,4)),
			\out, BusDef(\hasher2, \audio),
			\out, 0,
		),
		Pbind(
			\instrument, \hasher,
			\inbus, BusDef(\hasher2, \audio),
			\out, BusDef(\mixer1, \audio),
			\out, BusDef(\sendbus1, \audio),
			\out, 0,
			\addAction, \addToTail,
			\lag, 0.0009,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\mix, 1,
			\legato, Pseg(Pseq([0.1,1],inf),8),
			\dur, Pwhite(1/16,1),
		),
		
	])
)).play;
);

(
// bouillie chord + rumble bass
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1474].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				1,0,0,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[2076].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.31,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[2076].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0.31,0,0, 0,1,0,1,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,1, 0,0,0,1,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
				0,0,0,0, 0,0,1,0,
			]*0.7,inf).coin.not,
			\dur, 1/16,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1926].value,
			\isRest, Pseq([
				Pseq([
					1,1,1,1, 1,0,1,0,
					1,0,1,0, 1,1,0,1, 
					1,0,1,0, 1,1,1,1,
					1,0,1,0, 1,0,0,0, 
					
					1,1,1,1, 1,0,1,0,
					1,0,1,0, 1,0,1,0, 
					1,0,1,0, 1,1,1,1,
					1,0,1,0, 1,0,1,0, 
					
					1,1,1,1, 1,0,1,0,
					1,0,0,0, 0,0,1,1, 
					0,0,1,1, 1,0,0,1,
					1,0,1,0, 1,0,1,0, 
				],1),
				Prand([
					1,1,1,1, 1,0,1,0,
					1,0,1,0, 1,1,0,1, 
					1,0,1,0, 1,1,1,1,
					1,0,1,0, 1,0,0,0, 
					
					1,1,1,1, 1,0,1,0,
					1,0,1,0, 1,0,1,0, 
					1,0,1,0, 1,1,1,1,
					1,0,1,0, 1,0,1,0, 
					
					1,1,1,1, 1,0,1,0,
					1,0,0,0, 0,0,1,1, 
					0,0,1,1, 1,0,0,1,
					1,0,1,0, 1,0,1,0, 
				].clump(8*4).collect({ arg x; Pseq(x) })*0.8,1),
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.11 * Pseq([
				1,Pwhite(0.5,0.91,1),
				Pwhite(0.7,0.91,1), Pwhite(0.2,0.71,1)
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1927].value,
			\isRest, Pseq([

				1,1,1,1, 1,0,1,0,
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,1,1,1,
				1,0,1,0, 1,0,1,0, 
			]*0.3,inf).coin.not,
			\lag, 1/16/~t,
			\speed, 1/2+Pwhite(0,0.01),
			\legato, Pseq([
				0.11,Pwhite(0.1,0.4,3),
				Pwhite(0.1,0.4,1), 0.41,Pwhite(0.1,0.4,2),
				Pwhite(0.1,0.4,2), 0.41,Pwhite(0.1,0.4,2),
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \grainephasor,
			\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
			\note, Pseq([
				0,3,1,2,
			],inf).stutter(4),
			\gdur, 0.051,
			\gfreq, Pkey(\freq)/8/16*Pseg(Prand([1,16,32,8,64],inf),Pwhite(1/4,1/8)),
			\endpos, ~pmodenv.(Pseq([0.1],inf), 8),
			\gdur, ~pmodenv.(Pseq([0.01,0.1],inf), 4),
			\pos, 0,
			\phasortrig, Plazy({ arg ev;
				Ndef(\lfo1, { 
					Impulse.kr(
						Line.kr(1,( ev.use{~freq.value}/4 ).postln,1/2/~t)*~t
						//EnvGen.kr(Env([1,1,ev.use{~freq.value},10],[0,8.1,0.8]), Impulse.kr(1/4*~t)).poll
					) 
				}).asPattern.keep(8)
			}).loop,
			//\gfreq, 40,
			\legato, Pseq([
				Pseq([
					1,1,1,1, 1,0,0,0,
					1,1,1,0, 0,1,1,1,
					1,1,1,1, 1,0,0,0,
					1,1,0,0, 0,0,1,1,
				]/2,1),

				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,2,0,
				8,0,0,0, 0,0,0,0,
				0,0,2,0, 0,0,0,0,
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 4,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1/4,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \chordmito2hpf,
			\note, Pseq([
				[4,7,5,1],
				( { rrand(0,12) }!5 ).postln,
				[4,7,5,1],
				( { rrand(0,12) }!5 ).postln,
			],inf),
			\note, Pseq([
				[ 0,3,7,11, ],
				[ 0,3,7,11, ]+4
			],inf),
			\note, Pseq([
				[ 1,  5, 11, 2  ],
				[ 6,  4, 7, 5  ],
				[ 10,  4, 1, 5  ],
			],inf),
			\ctranspose, 5,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.5) ],
			],inf),
			\hpfr, Ndef(\rbassanalyzer, {
				var sig;
				var in = InFeedback.ar(BusDef(\sendbus1,\audio),2);
				sig = in;
				sig = DelayN.ar(sig,0.4,0.4)+sig;
				sig = DelayN.ar(sig,0.4,0.4)+sig;
				sig = sig/3;
				Amplitude.kr(sig).linlin(0,0.01,1/8,4);
			}),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,4.1) ],
			],inf),
			\dur, Pseq([1/2,1,1/2],inf),
			\legato, 0.3,
			\amp, 0.1/2,
			\fspread, ~pmodenv.(Pseq([0.001,0.02,0.007],inf), Pwhite(0.1,4)),
			\out, BusDef(\hasher2, \audio),
			\out, 0,
		),
		Pbind(
			\instrument, \hasher,
			\inbus, BusDef(\hasher2, \audio),
			\out, BusDef(\mixer1, \audio),
			\out, BusDef(\sendbus1, \audio),
			\out, 0,
			\addAction, \addToTail,
			\lag, 0.0009,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\mix, 1,
			\legato, Pseg(Pseq([0.1,1],inf),8),
			\dur, Pwhite(1/16,1),
		),
		
	])
)).play;
);

(
// rumble drums full + peaky
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[1238].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1,
			\st, 92.10/4/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, 
			Pseq([
				Pseq([
					Pseg(Pseq([
						0, 1/8,
					]+( 1/8 ),1),3/2),
					Pseg(Pseq([
						1/2, 4,
					],1.1),1/2),

					Pseg(Pseq([
						1/4, 8,
					]+( 0/2 ),1),1/4),
					Pseg(Pseq([
						1/2, 2/8,
					]+( 0/2 ),1),3/4),
					Pseg(Pseq([
						1/2, 4,
					],1.1),1),


					Pseg(Pseq([
						0, 1/8,
					]+( 0/2 ),1),3/2),
					Pseg(Pseq([
						1/2, 4,
					],1.1),1/2),

					Pseg(Pseq([
						1/4, 2/8,
					]+( 0/2 ),1),1/4),
					Pseg(Pseq([
						1/2, 2/8,
					]+( 0/2 ),1),3/4),
					Pseg(Pseq([
						1/2, 4,
					],1.1),1),
				],inf),
			],inf) / Pkey(\st),
			\dur, 1/32,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				2,1,1,1, 1,1,1,1,
				2,1,1,1, 1.3,1,1,1,
				1,1,1,1, 2,1,1,1,
			]*0.7,inf).coin.not,
			\gain, 1,
			\out, BusDef(\comp, \audio),
		),
		Pmono(\simplecomp,
			\inbus, BusDef(\comp, \audio),
			\cpt, 0.1,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[680].value,
			\legato,1/2,
			\isRest, Pseq([
				0,0,1,0,
				1,0,1,0,
				1,0,1,0,
				0,0,0,0,
			]*0.3,inf).coin.not,
			\dur, 1/16,
			\gain, 0.07,
			\out, BusDef(\echo, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[673].value,
			\legato,2,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,1, 1,0,0,0, 1,0,0,0,
				1,0,0,1, 1,0,0,0, 1,0,0,0, 1,0,0,1,
				1,0,0,0, 1,0,0,1, 1,0,0,0, 1,0,0,0,
				1,0,0,1, 1,0,0,0, 1,0,0,0, 1,0,0,1,

				1,0,0,0, 1,0,0,1, 1,0,0,0, 1,0,0,0,
				1,0,0,1, 0,0,1,0, 0,1,0,0, 1,0,0,1,
				1,0,0,0, 1,0,0,1, 1,0,0,0, 1,0,0,0,
				1,0,0,1, 1,0,0,0, 1,0,0,0, 1,0,0,1,
			]*0.7,inf).coin.not,
			\dur, 1/16,
			\gain, 0.11,
			\out, BusDef(\echo, \audio),
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\echo, \audio),
			\addAction, \addToTail,
			\decay, 2,
			\delay, ~pmodenv.(Pwhite(1/20,0.2), Pwhite(0.1,8)),
			\mix, 0.5,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[2076].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.31,
		),
		Pbind(
			\instrument, \peaky,
			\note, Pseq([
				11,10,
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/16,
			\fspread, ~pmodenv.(Pseq([0.05,0.12],inf), Pwhite(0.7,4)),
			\lpfr, ~pmodenv.(Pseq([1,2,1,4]/2,inf), Pwhite(0.7,4)),
			\out, BusDef(\echopeaky, \audio),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \peaky,
			\note, Pseq([
				7,1,
			],inf)+12,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/16,
			\lag, 1/32,
			\fspread, ~pmodenv.(Pseq([0.05,0.12],inf), Pwhite(0.7,4)),
			\lpfr, ~pmodenv.(Pseq([1,2,1,4]/2,inf), Pwhite(0.7,4)),
			\out, BusDef(\echopeaky, \audio),
			\amp, 0.1,
		),
		Pmono(\fx_echopass,
			\inbus, BusDef(\echopeaky, \audio),
			\addAction, \addToTail,
			\decay, 2,
			\delay, ~pmodenv.(Pwhite(1/20,0.2), Pwhite(0.1,8)),
			\mix, 0.5,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \chordmito2,
			//\note, Pseq([
				//( { rrand(0,12) }!5 ).postln,
				//( { rrand(0,12) }!5 ).postln,
				//( { rrand(0,12) }!5 ).postln,
			//].collect({ arg x;
				//x
			//}),inf).stutter(1),
			\note, Pseq([
				[ 1,  5, 11, 2  ],
				[ 6,  4, 7, 5  ],
				[ 10,  4, 1, 5  ],
			],inf),
			\ctranspose, 5,
			\oscmixtab, Plazy({
				Pseq([
					[ { 0.1.bilinrand+1 }!100 ],
				],1);
			}).loop,
			\octave, 4,
			\rq, 0.5,
			\fspread, ~pmodenv.(Pseq([0.05,0.001,0.005,0.001,0.02],inf), Pwhite(0.7,4)),
			\adsr, Pseq([
				[ Env.adsr(0.09,0.1,0.8,0.1) ],
			],inf),
			\lplfofac, ~pmodenv.(Pseq([0.5,0.05,0.8,0.1]/4,inf), Pwhite(1,7.0)),
			\lpfr, ~pmodenv.(Pseq([0.1,2,1.2,4],inf), Pwhite(1.0,7)),
			\legato, 1.0,
			\oscmix, Pseq([0,1/2,1,Pwhite(0,1.0,1)],inf),
			\oscmix, ~pmodenv.(Pseq([0.8,1/2,0.6,Pwhite(0,1.0,1)],inf), Pwhite(0.5,7)),
			\dur, Pseq([1/2,1,1/2],inf),
			\amp, 0.1/2,
			\out, 0,
			\out, BusDef(\sendbus2, \audio),
		),
	])
)).play;
);

(
// rumble drums coin + peaky
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[1238].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1,
			\st, 92.10/4/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, 
			Pseq([
				Pseq([
					Pseg(Pseq([
						0, 1/8,
					]+( 1/8 ),1),3/2),
					Pseg(Pseq([
						1/2, 4,
					],1.1),1/2),

					Pseg(Pseq([
						1/4, 8,
					]+( 0/2 ),1),1/4),
					Pseg(Pseq([
						1/2, 2/8,
					]+( 0/2 ),1),3/4),
					Pseg(Pseq([
						1/2, 4,
					],1.1),1),


					Pseg(Pseq([
						0, 1/8,
					]+( 0/2 ),1),3/2),
					Pseg(Pseq([
						1/2, 4,
					],1.1),1/2),

					Pseg(Pseq([
						1/4, 2/8,
					]+( 0/2 ),1),1/4),
					Pseg(Pseq([
						1/2, 2/8,
					]+( 0/2 ),1),3/4),
					Pseg(Pseq([
						1/2, 4,
					],1.1),1),
				],inf),
			],inf) / Pkey(\st),
			\dur, 1/32,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				2,1,1,1, 1,1,1,1,
				2,1,1,1, 1.3,1,1,1,
				1,1,1,1, 2,1,1,1,
			]*0.7,inf).coin.not,
			\gain, 1,
			\out, BusDef(\comp, \audio),
		),
		Pmono(\simplecomp,
			\inbus, BusDef(\comp, \audio),
			\cpt, 0.1,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[680].value,
			\legato,1/2,
			\isRest, Pseq([
				0,0,1,0,
				1,0,1,0,
				1,0,1,0,
				0,0,0,0,
			]*0.3,inf).coin.not,
			\dur, 1/16,
			\gain, 0.07,
			\out, BusDef(\echo, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[673].value,
			\legato,2,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,1, 1,0,0,0, 1,0,0,0,
				1,0,0,1, 1,0,0,0, 1,0,0,0, 1,0,0,1,
				1,0,0,0, 1,0,0,1, 1,0,0,0, 1,0,0,0,
				1,0,0,1, 1,0,0,0, 1,0,0,0, 1,0,0,1,

				1,0,0,0, 1,0,0,1, 1,0,0,0, 1,0,0,0,
				1,0,0,1, 0,0,1,0, 0,1,0,0, 1,0,0,1,
				1,0,0,0, 1,0,0,1, 1,0,0,0, 1,0,0,0,
				1,0,0,1, 1,0,0,0, 1,0,0,0, 1,0,0,1,
			]*0.7,inf).coin.not,
			\dur, 1/16,
			\gain, 0.11,
			\out, BusDef(\echo, \audio),
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\echo, \audio),
			\addAction, \addToTail,
			\decay, Pseg(Pseq([0,2],inf),8),
			\delay, ~pmodenv.(Pwhite(1/20,0.2), Pwhite(0.1,8)),
			\mix, 0.5,
			\lag, 0.0009,
			\dur, 1/4,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[2076].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.31,
		),
		Pbind(
			\instrument, \peaky,
			\note, Pseq([
				11,10,
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,

				Pseq([
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
				],8),
				Pseq([
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
				]*0.7,16),
			],inf).coin.not,
			\dur, 1/16,
			\fspread, ~pmodenv.(Pseq([0.05,0.12],inf), Pwhite(0.7,4)),
			\lpfr, ~pmodenv.(Pseq([1,2,1,4]/2,inf), Pwhite(0.7,4)),
			\out, BusDef(\echopeaky, \audio),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \peaky,
			\note, Pseq([
				7,1,
			],inf)+12,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],8),
				Pseq([
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
				]*0.7,16),
			],inf).stutter(8).coin.not,
			\dur, 1/16,
			\lag, 1/32,
			\fspread, ~pmodenv.(Pseq([0.05,0.12],inf), Pwhite(0.7,4)),
			\lpfr, ~pmodenv.(Pseq([1,2,1,4]/2,inf), Pwhite(0.7,4)),
			\out, BusDef(\echopeaky, \audio),
			\amp, 0.1,
		),
		Pmono(\fx_echopass,
			\inbus, BusDef(\echopeaky, \audio),
			\addAction, \addToTail,
			\decay, Pseg(Pseq([0,1,2,0.51],inf),7),
			\delay, ~pmodenv.(Pwhite(1/5,0.7), Pwhite(0.1,8)),
			\mix, 0.5,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \chordmito2,
			//\note, Pseq([
				//( { rrand(0,12) }!5 ).postln,
				//( { rrand(0,12) }!5 ).postln,
				//( { rrand(0,12) }!5 ).postln,
			//].collect({ arg x;
				//x
			//}),inf).stutter(1),
			\note, Pseq([
				[ 1,  5, 11, 2  ],
				[ 6,  4, 7, 5  ],
				[ 10,  4, 1, 5  ],
			],inf),
			\ctranspose, 5,
			\oscmixtab, Plazy({
				Pseq([
					[ { 0.1.bilinrand+1 }!100 ],
				],1);
			}).loop,
			\octave, 4,
			\rq, 0.5,
			\fspread, ~pmodenv.(Pseq([0.05,0.001,0.005,0.001,0.02],inf), Pwhite(0.7,4)),
			\adsr, Pseq([
				[ Env.adsr(0.09,0.1,0.8,0.1) ],
			],inf),
			\lplfofac, ~pmodenv.(Pseq([0.5,0.05,0.8,0.1]/4,inf), Pwhite(1,7.0)),
			\lpfr, ~pmodenv.(Pseq([0.1,2,1.2,4],inf), Pwhite(1.0,7)),
			\legato, 1.0,
			\oscmix, Pseq([0,1/2,1,Pwhite(0,1.0,1)],inf),
			\oscmix, ~pmodenv.(Pseq([0.8,1/2,0.6,Pwhite(0,1.0,1)],inf), Pwhite(0.5,7)),
			\dur, Pseq([1/2,1,1/2],inf),
			\amp, 0.1/2,
			\out, 0,
			\out, BusDef(\sendbus2, \audio),
		),
	])
)).play;
);

(
// rumble drums coin + acidbass + widechords
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[1238].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1,
			\st, 92.10/4/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, 
			Pseq([
				Pseq([
					Pseg(Pseq([
						0, 1/8,
					]+( 1/8 ),1),3/2),
					Pseg(Pseq([
						1/2, 4,
					],1.1),1/2),

					Pseg(Pseq([
						1/4, 8,
					]+( 0/2 ),1),1/4),
					Pseg(Pseq([
						1/2, 2/8,
					]+( 0/2 ),1),3/4),
					Pseg(Pseq([
						1/2, 4,
					],1.1),1),


					Pseg(Pseq([
						0, 1/8,
					]+( 0/2 ),1),3/2),
					Pseg(Pseq([
						1/2, 4,
					],1.1),1/2),

					Pseg(Pseq([
						1/4, 2/8,
					]+( 0/2 ),1),1/4),
					Pseg(Pseq([
						1/2, 2/8,
					]+( 0/2 ),1),3/4),
					Pseg(Pseq([
						1/2, 4,
					],1.1),1),
				],inf),
			],inf) / Pkey(\st),
			\dur, 1/32,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				2,1,1,1, 1,1,1,1,
				2,1,1,1, 1.3,1,1,1,
				1,1,1,1, 2,1,1,1,
			]*0.7,inf).coin.not,
			\gain, 1,
			\out, BusDef(\comp, \audio),
		),
		Pmono(\simplecomp,
			\inbus, BusDef(\comp, \audio),
			\cpt, 0.1,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[680].value,
			\legato,1/2,
			\isRest, Pseq([
				0,0,1,0,
				1,0,1,0,
				1,0,1,0,
				0,0,0,0,
			]*0.3,inf).coin.not,
			\dur, 1/16,
			\gain, 0.07,
			\out, BusDef(\echo, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[673].value,
			\legato,2,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,1, 1,0,0,0, 1,0,0,0,
				1,0,0,1, 1,0,0,0, 1,0,0,0, 1,0,0,1,
				1,0,0,0, 1,0,0,1, 1,0,0,0, 1,0,0,0,
				1,0,0,1, 1,0,0,0, 1,0,0,0, 1,0,0,1,

				1,0,0,0, 1,0,0,1, 1,0,0,0, 1,0,0,0,
				1,0,0,1, 0,0,1,0, 0,1,0,0, 1,0,0,1,
				1,0,0,0, 1,0,0,1, 1,0,0,0, 1,0,0,0,
				1,0,0,1, 1,0,0,0, 1,0,0,0, 1,0,0,1,
			]*0.7,inf).coin.not,
			\dur, 1/16,
			\gain, 0.11,
			\out, BusDef(\echo, \audio),
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\echo, \audio),
			\addAction, \addToTail,
			\decay, Pseg(Pseq([0,2],inf),8),
			\delay, ~pmodenv.(Pwhite(1/20,0.2), Pwhite(0.1,8)),
			\mix, 0.5,
			\lag, 0.0009,
			\dur, 1/4,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[2076].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.31,
		),
		Pbind(
			\instrument, \peaky,
			\note, Pseq([
				11,10,
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,

				Pseq([
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
				],8),
				Pseq([
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
				]*0.7,16),
			],inf).coin.not,
			\dur, 1/16,
			\fspread, ~pmodenv.(Pseq([0.05,0.12],inf), Pwhite(0.7,4)),
			\lpfr, ~pmodenv.(Pseq([1,2,1,4]/2,inf), Pwhite(0.7,4)),
			\out, BusDef(\echopeaky, \audio),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \peaky,
			\note, Pseq([
				7,1,
			],inf)+12,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],8),
				Pseq([
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
				]*0.7,16),
			],inf).stutter(8).coin.not,
			\dur, 1/16,
			\lag, 1/32,
			\fspread, ~pmodenv.(Pseq([0.05,0.12],inf), Pwhite(0.7,4)),
			\lpfr, ~pmodenv.(Pseq([1,2,1,4]/2,inf), Pwhite(0.7,4)),
			\out, BusDef(\echopeaky, \audio),
			\amp, 0.1,
		),
		Pmono(\fx_echopass,
			\inbus, BusDef(\echopeaky, \audio),
			\addAction, \addToTail,
			\decay, Pseg(Pseq([0,1,2,0.51],inf),7),
			\delay, ~pmodenv.(Pwhite(1/5,0.7), Pwhite(0.1,8)),
			\mix, 0.5,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \basicbass,
			\note, Pstep(Pseq([
				2,6,6,10,
				5,4,4,10,
				11,7,7,10,
			],inf),1/2),
			\ctranspose, 5,
			\legato, Pseq([
				Prand([
					Pseq([
						1,0.3,0.51,
					],1),
					Pseq([
						1,0.7,
					],1),
					Pseq([
						1,0.7,0.21,
					],1),
				],1),
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.01) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\lpf, ~pmodenv.(Pseq([300,700,100,1000],inf), Pwhite(0.1,8)),
			\rq, ~pmodenv.(Pseq([0.5,0.1,0.8],inf), Pwhite(0.1,8)),
			\octave, 2,
			\dur, 1/8,
			\dur, PdurStutter(Pseq([8,8,8,8, 8,8,8,4],inf), 1/2),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \organ_donorenv,
			//\note, Pseq([
				//( { rrand(0,12) }!5 ).postln,
				//( { rrand(0,12) }!5 ).postln,
				//( { rrand(0,12) }!5 ).postln,
			//].collect({ arg x;
				//x
			//}),inf).stutter(1),
			\note, Pseq([
				[ 1,  5, 11, 2  ],
				[ 6,  4, 7, 5  ],
				[ 10,  4, 1, 5  ],
			],inf).collect({ arg x; x.choose }),
			\ctranspose, 5,
			\oscmixtab, Plazy({
				Pseq([
					[ { 0.1.bilinrand+1 }!100 ],
				],1);
			}).loop,
			\octave, 6,
			\rq, 0.5,
			\fspread, ~pmodenv.(Pseq([0.05,0.001,0.005,0.001,0.02],inf), Pwhite(0.7,4)),
			\adsr, Pseq([
				[ Env.adsr(0.09,0.1,0.2,0.1) ],
			],inf),
			\legato, 0.5,
			\lplfofac, ~pmodenv.(Pseq([0.5,0.05,0.8,0.1]/4,inf), Pwhite(1,7.0)),
			\lpfr, ~pmodenv.(Pseq([0.1,2,1.2,4],inf), Pwhite(1.0,7)),
			\legato, 1.0,
			\oscmix, Pseq([0,1/2,1,Pwhite(0,1.0,1)],inf),
			\oscmix, ~pmodenv.(Pseq([0.8,1/2,0.6,Pwhite(0,1.0,1)],inf), Pwhite(0.5,7)),
			\dur, Pseq([1/2,1,1/2],inf),
			\amp, 0.1/6,
			\dur, PdurStutter(Pseq([1,4,2,8],inf), 1/2),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\out, 0,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \bolonvib,
			//\note, Pseq([
				//( { rrand(0,12) }!5 ).postln,
				//( { rrand(0,12) }!5 ).postln,
				//( { rrand(0,12) }!5 ).postln,
			//].collect({ arg x;
				//x
			//}),inf).stutter(1),
			\note, Pseq([
				[ 1,  5, 11, 2  ],
				[ 6,  4, 7, 5  ],
				[ 10,  4, 1, 5  ],
			],inf),
			\ctranspose, 5,
			\oscmixtab, Plazy({
				Pseq([
					[ { 0.1.bilinrand+1 }!100 ],
				],1);
			}).loop,
			\octave, 4,
			\rq, 0.2,
			\fspread, ~pmodenv.(Pseq([0.05,0.001,0.005,0.001,0.02],inf), Pwhite(0.7,4)),
			\adsr, Pseq([
				[ Env.adsr(0.09,0.1,0.8,0.1) ],
			],inf),
			\lplfofac, ~pmodenv.(Pseq([0.5,0.05,0.8,0.1]/4,inf), Pwhite(1,7.0)),
			\lpfr, ~pmodenv.(Pseq([0.1,2,1.2,4],inf), Pwhite(1.0,7)),
			\legato, 1.0,
			\oscmix, Pseq([0,1/2,1,Pwhite(0,1.0,1)],inf),
			\oscmix, ~pmodenv.(Pseq([0.0,1/2,0.6,Pwhite(0,1.0,1)],inf), Pwhite(0.5,7)),
			\dur, Pseq([1/2,1,1/2],inf),
			\amp, 0.1/2,
			\out, 0,
			\out, BusDef(\sendbus2, \audio),
		),
	])
)).play;
);

Pdef


/////////////////// FX manager

ProtoDef(\FxManager).presetCompileString.editorInsert
(
ProtoDef('rdn').inbus = BusDef('sendbus1');
ProtoDef('rdn').outBus = 0;
ProtoDef('rdn').make('deldefault', 'rdn', "5-U7S3-FT52", BusDef('sendbus1'));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.61764705882353,
	'gain', 0.53445378151261,
	'fb', 0.0001,
	'delay', 0.0001,
	'delay2', 0.0001,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 0.45233707447721,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 1.0259630501905,
	'fbdistmix', 0.0,
	'postlpf', 15855.854778901,
	'posthpf', 17,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
	'distamp3', 3.9466141732283,
	'brfrqfac', 0.37940593233798,
	'brffac', 0.60195390291997,
	'shift3', -2.4789915966387,
	'shiftmix', 0.0,
	'stereo', 0.0,
	'delay3', 0.0001,
	'distamp2', 3.9466141732283,
).keep(1));


Ndef('fx1').source = 'fx_freeverb2';
PlayerWrapper(Ndef('fx1')).outBus = 0;
Ndef('fx1').set('inbus', BusDef('sendbus1'));
Ndef('fx1').set('verbmix', 1.0);
Ndef('fx1').set('room', 0.5);
Ndef('fx1').set('damp', 0.1);
Ndef('fx1').set('mix', 0.15656565656566);
Ndef('fx1').set('gain', 1.0);

Ndef('fx2').source = 'fx_freeverb2';
PlayerWrapper(Ndef('fx2')).outBus = 0;
Ndef('fx2').set('inbus', BusDef('sendbus2'));
Ndef('fx2').set('verbmix', 0.50505050505051);
Ndef('fx2').set('room', 1.4165561271907);
Ndef('fx2').set('damp', 2.0505532865581);
Ndef('fx2').set('mix', 0.71212121212121);
Ndef('fx2').set('gain', 1.0);

Ndef('fx3').source = nil;
PlayerWrapper(Ndef('fx3')).outBus = 0;


Ndef('fx4').source = nil;
PlayerWrapper(Ndef('fx4')).outBus = 0;


);

// record setup
ProtoDef(\FxManager).presetCompileString.editorInsert
(
ProtoDef('rdn').inbus = BusDef('sendbus1');
ProtoDef('rdn').outBus = BusDef('bus1');
ProtoDef('rdn').make('deldefault', 'rdn', "5-9U22-EOA6", BusDef('sendbus1'));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.42016806722689,
	'gain', 0.73949579831933,
	'fb', 0.0001,
	'delay', 0.28985772146511,
	'delay2', 0.51794746792312,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 4.1062499172443,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 1.0259630501905,
	'fbdistmix', 0.0,
	'postlpf', 15855.854778901,
	'posthpf', 45.078678094696,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

ProtoDef('rdn2').inbus = BusDef('bus1');
ProtoDef('rdn2').outBus = BusDef('sendbus2');
ProtoDef('rdn2').make('deldefault', 'rdn2', "5-MO1N-5CGV", BusDef('bus1'));
Ndef('rdn2').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.4327731092437,
	'gain', 0.61764705882353,
	'fb', 0.0001,
	'delay', 0.018574090746386,
	'delay2', 0.00024353120734334,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 0.21268217472962,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.049373475203846,
	'fbdistmix', 0.067226890756303,
	'postlpf', 17000,
	'posthpf', 135.81970059911,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

ProtoDef('rdn3').inbus = BusDef('zero');
ProtoDef('rdn3').outBus = 0;
ProtoDef('rdn3').make('default', 'rdn3', "4-JBFA-P1HL", BusDef('zero'));
Ndef('rdn3').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'fb', 0.01,
	'delay', 1,
	'delay2', 1,
	'shift', 1,
	'shift2', 1,
	'distamp', 1,
	'pitchlag', 0.125,
	'pitchmix', 0.5,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 1,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 1,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

ProtoDef('rdn4').inbus = BusDef('zero');
ProtoDef('rdn4').outBus = 0;
ProtoDef('rdn4').make('default', 'rdn4', "4-78HO-38E3", BusDef('zero'));
Ndef('rdn4').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'fb', 0.01,
	'delay', 1,
	'delay2', 1,
	'shift', 1,
	'shift2', 1,
	'distamp', 1,
	'pitchlag', 0.125,
	'pitchmix', 0.5,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 1,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 1,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));




Ndef('fx1').source = 'fx_freeverb2';
PlayerWrapper(Ndef('fx1')).outBus = 0;
Ndef('fx1').set('inbus', BusDef('sendbus1'));
Ndef('fx1').set('verbmix', 1.0);
Ndef('fx1').set('room', 0.5);
Ndef('fx1').set('damp', 0.1);
Ndef('fx1').set('mix', 0.15656565656566);
Ndef('fx1').set('gain', 1.0);

Ndef('fx2').source = 'fx_freeverb2';
PlayerWrapper(Ndef('fx2')).outBus = BusDef('sendbus3');
Ndef('fx2').set('inbus', BusDef('sendbus2'));
Ndef('fx2').set('verbmix', 0.6969696969697);
Ndef('fx2').set('room', 1.3318671525419);
Ndef('fx2').set('damp', 0.71900534768712);
Ndef('fx2').set('mix', 0.44949494949495);
Ndef('fx2').set('gain', 1.0);

Ndef('fx3').source = 'fx_reverb';
PlayerWrapper(Ndef('fx3')).outBus = 0;
Ndef('fx3').set('amp', 0.0);
Ndef('fx3').set('inbus', BusDef('sendbus3'));
Ndef('fx3').set('fb', 0);
Ndef('fx3').set('lpf', 16000.0);
Ndef('fx3').set('lpmix', 0.10635866531336);
Ndef('fx3').set('delayfac', 0.14475623289455);
Ndef('fx3').set('decay', 32.858717152454);
Ndef('fx3').set('mix', 0.0);
Ndef('fx3').set('gain', 1.0);

Ndef('fx4').source = nil;
PlayerWrapper(Ndef('fx4')).outBus = 0;


);



///////////////////////////// buffers

ClipTimeline(\rec).edit
ClipTimeline(\rec).presetCompileString.editorInsert
(
ClipTimeline('rec').tracks = [ ( 'index': 0, 'recordArmed': true, 'recordBus': 0, 'muted': false ), ( 'index': 1, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 2, 'recordArmed': false, 'recordBus': 0, 'muted': true ), ( 'index': 3, 'recordArmed': false, 'recordBus': 0, 'muted': false ) ];
{
ClipTimeline('rec').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	PatternEvent((\absTime: 0.0, \dur: 0.0, \midinote: 2.0, \playDur: 0.0, \relDur: 0.0, \sustain: 4.0, \timeline: { SampleTimeline('rec_rec_t0_201215_153343') }, \type: 'pattern', )),
	PatternEvent((\absTime: 0.0, \dur: 5.0, \midinote: 0, \playDur: 5.0, \relDur: 5.0, \sustain: 4.0, \timeline: { SampleTimeline('rec_rec_t0_201215_173158') }, \type: 'pattern', )),
	PatternEvent((\absTime: 5.0, \dur: 3.0, \midinote: 2.0, \playDur: 3.0, \relDur: 3.0, \sustain: 8.0, \timeline: { SampleTimeline('rec_rec_t0_201215_162500') }, \type: 'pattern', )),
	(\absTime: 8, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
 }.value;
ClipTimeline('rec').recordedEvents = [ PatternEvent((playDur: 0.0, dur: 0.0, sustain: 4.0, midinote: 2.0, timeline: { SampleTimeline('rec_rec_t0_201215_153343') }, relDur: 0.0, type: 'pattern', absTime: 0.0)), PatternEvent((playDur: 8.0, dur: 8.0, sustain: 7.0, midinote: 0, timeline: { SampleTimeline('rec_rec_t0_201215_155623') }, relDur: 8.0, type: 'pattern', absTime: 0.0)), PatternEvent((playDur: 8.0, dur: 8.0, sustain: 8.0, midinote: 0, timeline: { SampleTimeline('rec_rec_t0_201215_155755') }, relDur: 8.0, type: 'pattern', absTime: 0.0)), PatternEvent((playDur: 5.0, dur: 5.0, sustain: 12.0, midinote: 0, timeline: { SampleTimeline('rec_rec_t0_201215_160631') }, relDur: 5.0, type: 'pattern', absTime: 3.0)), PatternEvent((playDur: 3.0, dur: 3.0, sustain: 8.0, midinote: 2.0, timeline: { SampleTimeline('rec_rec_t0_201215_162500') }, relDur: 3.0, type: 'pattern', absTime: 5.0)), PatternEvent((playDur: 5.0, dur: 5.0, sustain: 4.0, midinote: 0, timeline: { SampleTimeline('rec_rec_t0_201215_173128') }, relDur: 5.0, type: 'pattern', absTime: 0.0)), PatternEvent((playDur: 5.0, dur: 5.0, sustain: 4.0, midinote: 0, timeline: { SampleTimeline('rec_rec_t0_201215_173158') }, relDur: 5.0, type: 'pattern', absTime: 0.0)) ];

SampleTimeline('rec_rec_t0_201215_153343').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 2.0, \label: 'start', \playDur: 2.0, \relDur: 2.0, \sustain: 0, \type: 'start', ),
	(\absTime: 2.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_rec_t0_201215_153343').buffer = BufDef('./rec_rec_t0_201215_153343.wav');
SampleTimeline('rec_rec_t0_201215_162500').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 8.0, \playDur: 8.0, \relDur: 8.0, \sustain: 0, \type: 'start', ),
	(\absTime: 8.0, \dur: 0, \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_rec_t0_201215_162500').buffer = BufDef('./rec_rec_t0_201215_162500.wav');


);

"reckit/rec_rec_t0_201215_153343.wav"

(
SampleTimeline('rec_rec_t0_201215_153343').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 2.0, \label: 'start', \playDur: 2.0, \relDur: 2.0, \sustain: 0, \type: 'start', ),
	(\absTime: 2.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_rec_t0_201215_153343').buffer = BufDef('cliprec/rec_rec_t0_201215_153343.wav');

SampleTimeline('rec_rec_t0_201215_162500').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 8.0, \playDur: 8.0, \relDur: 8.0, \sustain: 0, \type: 'start', ),
	(\absTime: 8.0, \dur: 0, \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_rec_t0_201215_162500').buffer = BufDef('cliprec/rec_rec_t0_201215_162500.wav');

SampleTimeline('rec_rec_t0_201215_173158').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 4.0, \label: 'start', \playDur: 4.0, \relDur: 4.0, \sustain: 0, \type: 'start', ),
	(\absTime: 4.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_rec_t0_201215_173158').buffer = BufDef('cliprec/rec_rec_t0_201215_173158.wav');
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('cliprec/rec_rec_t0_201215_162500.wav'),
			\legato,1,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.4) ],
			],inf),
			\dur, 4,
			\gain, 1,
		)
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('bla'),
			\legato,1,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.4) ],
			],inf),
			\dur, 4,
			\gain, 1,
		)
		
	])
)).play;
);

BufDef(\bla).asCompileString
BufDef(\bla, "/home/ggz/Musique/test.wav")
BufDef(\bla2, "/home/ggz/Musique/test.wav")
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('cliprec/rec_rec_t0_201215_153343.wav'),
			\dur, 1,
			\gain, 1,
		)
		
	])
)).play;
);

(
Pdef(\part2, Pdef(\zedpart2, 
	Ppar([
		
		Pbind(
			\instrument, \bolonvib,
			//\note, Pseq([
				//( { rrand(0,12) }!5 ).postln,
				//( { rrand(0,12) }!5 ).postln,
				//( { rrand(0,12) }!5 ).postln,
			//].collect({ arg x;
				//x
			//}),inf).stutter(1),
			\note, Pseq([
				[ 1,  5, 11, 2  ],
				[ 6,  4, 7, 5  ],
				[ 10,  4, 1, 5  ],
			],inf),
			\ctranspose, 5,
			\oscmixtab, Plazy({
				Pseq([
					[ { 0.1.bilinrand+1 }!100 ],
				],1);
			}).loop,
			\octave, 4,
			\rq, 0.2,
			\fspread, ~pmodenv.(Pseq([0.05,0.001,0.005,0.001,0.02],inf), Pwhite(0.7,4)),
			\adsr, Pseq([
				[ Env.adsr(0.09,0.1,0.8,0.1) ],
			],inf),
			\lplfofac, ~pmodenv.(Pseq([0.5,0.05,0.8,0.1]/4,inf), Pwhite(1,7.0)),
			\lpfr, ~pmodenv.(Pseq([0.1,2,1.2,4],inf), Pwhite(1.0,7)),
			\legato, 1.0,
			\lag, 0.12,
			\oscmix, Pseq([0,1/2,1,Pwhite(0,1.0,1)],inf),
			\oscmix, ~pmodenv.(Pseq([0.0,1/2,0.6,Pwhite(0,1.0,1)],inf), Pwhite(0.5,7)),
			\dur, Pseq([1/2,1,1/2],inf),
			\amp, 0.1/2,
			\out, 0,
			//\out, BusDef(\sendbus2, \audio),
		),
		Pbind(\lag, Pkeyd(\lag,0)+0.12) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1010].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[1474].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,1,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
					0,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.3,
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[1064].value,
				\bufnum, ~buflib.hat[673].value,
				\legato,2,
				\isRest, Pseq([
					1,0,0,0, 1,0,0,1, 1,0,0,0, 1,0,0,0,
					1,0,0,1, 1,0,0,0, 1,0,0,0, 1,0,0,1,
				]*0.7,inf).coin.not,
				\dur, 1/16,
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[673].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[1268].value,
				\legato,1/8,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.4,0.2) ],
				],inf),
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 1,1,1,1, 1,1,1,1,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					1,1,1,1, 1,1,1,1, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,1,0,0, 1,0,0,1, 0,0,1,0,
					0,0,1,0, 1,1,0,1, 1,0,1,1, 0,1,1,0,
				]*0.7,inf).coin.not,
				\pan, 1,
				\dur, 1/16,
				\gain, 0.1 * Pseq([1,0.3,0.7],inf),
			),
			Psched(4,Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[673].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[1168].value,
				\legato,2,
				\isRest, Pseq([
					Pseq([
						0,0,0,0, 0,0,0,0, 0,0,0,0, 1,1,1,1,
						1,0,1,0, 1,0,1,0, 0,0,0,0, 1,1,1,1,
						1,0,0,1, 0,0,1,0, 0,0,0,0, 1,1,1,1,
						1,0,1,0, 1,0,1,0, 0,0,0,0, 1,1,1,1,
			
						0,0,0,0, 0,0,0,0, 0,0,0,0, 1,1,1,1,
						1,0,0,1, 0,0,1,0, 0,0,0,0, 1,1,1,1,
						1,1,0,1, 1,0,1,1, 0,0,0,0, 1,1,1,1,
						1,0,1,0, 1,0,1,0, 0,0,0,0, 1,1,1,1,
					],5),
					Pseq([
						0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					],8),
				]*0.7,inf).coin.not,
				\pan, 1,
				\dur, 1/16,
				\gain, 0.11,
			)),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[2076].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.31,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.clap[3].value,
				\bufnum, ~buflib.snare[2076].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 1,1,0,1,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,1,0,0, 1,0,0,0, 0,0,0,1, 1,0,1,1,
				]*0.7,inf).coin.not,
				\dur, 1/16,
				//\lag,0.051,
				\sustain, 0.03 * Prand([1,1.33,1,0.7],inf),
				\gain, 0.21 * Pseq([1,0.3,0.7],inf),
			),
		]),
	])
)).play;
);

			\bufnum, BufDef('path:/./rec_rec_t0_201215_153343.wav'),
				"./bla".asAbsolutePath
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[19].value,
			\bufnum, ~buflib.clap[170].value,
			\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\lag, 0.04,
			\gain, 0.31,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\out, BusDef(\sendbus1, \audio),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
	
	])
)).play;
);
Pdef(\part).clear;



//////////////



(
// bouillie chord + rumble bass
Pdef(\part, Pdef(\bouilliexp, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1474].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				1,0,0,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[2076].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.31,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[2076].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0.31,0,0, 0,1,0,1,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,1, 0,0,0,1,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
				0,0,0,0, 0,0,1,0,
			]*0.7,inf).coin.not,
			\dur, 1/16,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1926].value,
			\isRest, Pseq([
				Pseq([
					1,1,1,1, 1,0,1,0,
					1,0,1,0, 1,1,0,1, 
					1,0,1,0, 1,1,1,1,
					1,0,1,0, 1,0,0,0, 
					
					1,1,1,1, 1,0,1,0,
					1,0,1,0, 1,0,1,0, 
					1,0,1,0, 1,1,1,1,
					1,0,1,0, 1,0,1,0, 
					
					1,1,1,1, 1,0,1,0,
					1,0,0,0, 0,0,1,1, 
					0,0,1,1, 1,0,0,1,
					1,0,1,0, 1,0,1,0, 
				],1),
				Prand([
					1,1,1,1, 1,0,1,0,
					1,0,1,0, 1,1,0,1, 
					1,0,1,0, 1,1,1,1,
					1,0,1,0, 1,0,0,0, 
					
					1,1,1,1, 1,0,1,0,
					1,0,1,0, 1,0,1,0, 
					1,0,1,0, 1,1,1,1,
					1,0,1,0, 1,0,1,0, 
					
					1,1,1,1, 1,0,1,0,
					1,0,0,0, 0,0,1,1, 
					0,0,1,1, 1,0,0,1,
					1,0,1,0, 1,0,1,0, 
				].clump(8*4).collect({ arg x; Pseq(x) })*0.8,1),
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.11 * Pseq([
				1,Pwhite(0.5,0.91,1),
				Pwhite(0.7,0.91,1), Pwhite(0.2,0.71,1)
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1927].value,
			\isRest, Pseq([

				1,1,1,1, 1,0,1,0,
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,1,1,1,
				1,0,1,0, 1,0,1,0, 
			]*0.3,inf).coin.not,
			\lag, 1/16/~t,
			\speed, 1/2+Pwhite(0,0.01),
			\legato, Pseq([
				0.11,Pwhite(0.1,0.4,3),
				Pwhite(0.1,0.4,1), 0.41,Pwhite(0.1,0.4,2),
				Pwhite(0.1,0.4,2), 0.41,Pwhite(0.1,0.4,2),
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \grainephasor,
			\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
			\note, Pseq([
				0,3,1,2,
			],inf).stutter(4),
			\gdur, 0.051,
			\gfreq, Pkey(\freq)/4/16*Pseg(Prand([64,32,32,1],inf),Pseq([ 1,1/2 ],inf)),
			\endpos, ~pmodenv.(Pseq([0.1],inf), 8),
			\gdur, ~pmodenv.(Pseq([0.01,0.1],inf), 4),
			\pos, 0,
			\phasortrig, Plazy({ arg ev;
				Ndef(\lfo1, { 
					Impulse.kr(
						Line.kr(1,( ev.use{~freq.value}/4 ).postln,1/2/~t)*~t
						//EnvGen.kr(Env([1,1,ev.use{~freq.value},10],[0,8.1,0.8]), Impulse.kr(1/4*~t)).poll
					) 
				}).asPattern.keep(8)
			}).loop,
			//\gfreq, 40,
			\legato, Pseq([

				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,2,0,
				8,0,0,0, 0,0,0,0,
				0,0,2,0, 0,0,0,0,
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 4,0,0,0,
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 4,0,0,0,
				Pseq([
					1,1,1,1, 1,0,0,0,
					1,1,1,0, 0,1,1,1,
					1,1,1,1, 1,0,0,0,
					1,1,0,0, 0,0,1,1,
				]/2,1),
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1/4,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \chordmito2hpf,
			\note, Pseq([
				[4,7,5,1],
				( { rrand(0,12) }!5 ).postln,
				[4,7,5,1],
				( { rrand(0,12) }!5 ).postln,
			],inf),
			\note, Pseq([
				[ 0,3,7,11, ],
				[ 0,3,7,11, ]+4
			],inf),
			\note, Pseq([
				[ 1,  5, 11, 2  ],
				[ 6,  4, 7, 5  ],
				[ 10,  4, 1, 5  ],
			],inf),
			\ctranspose, 5,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.5) ],
			],inf),
			\hpfr, Ndef(\rbassanalyzer, {
				var sig;
				var in = InFeedback.ar(BusDef(\sendbus1,\audio),2);
				sig = in;
				sig = sig/3;
				Amplitude.kr(sig).linlin(0,0.01,0.8,1.8);
			}),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,4.1) ],
			],inf),
			\dur, Pseq([1/2,1,1/2],inf),
			\legato, 0.3,
			\amp, 0.1,
			\fspread, ~pmodenv.(Pseq([0.001,0.02,0.007],inf), Pwhite(0.1,4)),
			\out, BusDef(\hasher2, \audio),
			\out, 0,
		),
		
	])
)).play;
);
