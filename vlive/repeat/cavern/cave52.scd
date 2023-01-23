(
FileSystemProject.loadOnce("cavern/main.scd");
~t = 165/2/60; TempoClock.default.tempo = ~t;
FileSystemProject('cavern/cave52').loadProject;
FileSystemProject.current.addResource(TrackDef(\cave52));
)
ProtoTemplateDef(\MainProject).parent.keys
TrackDef(\cave52).savePresetCompileString
FileSystemProject.current.fxManager.savePresetCompileString
FileSystemProject.current.fxManager.presetCompileStringSavePath = FileSystemProject.current.dataPath
FileSystemProject.current.fxManager.loadedFromPath = FileSystemProject.current.dataPath

(
SynthDef(\freecorde, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, fspread=0.01, spread=1;
	var sig;
	sig = SinOsc.ar(freq * ((0..7)/7 - 0.5 * fspread + 1) * ( SinOsc.ar(freq*\fmr.kr(1.2)) * \fmamp.kr(1) + 1 )) * ( SinOsc.ar(freq * \amr.kr(0.2)) * \amamp.kr(1) + 1 );
	sig = sig * 0.9;
	sig = SelectX.ar( LFNoise1.ar((1..8)/12).range(0,1), sig  );
	sig = Splay.ar(sig, spread, amp, pan);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,2.1)),gate,doneAction:2);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
SynthDef(\somebass2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\env1.kr(Env([2,2,1/8,1/20],[0.07,1.4,0.8])), 1);
	env2 = EnvGen.kr(\env2.kr(Env([1,1/8,1/10],[0.1,0.8]), 1));
	env3 = EnvGen.kr(\env3.kr(Env([0.1,1/21,1],[0.1,0.8]), 1));
	sig1 = SinOsc.ar(freq);
	sig2 = LFSaw.ar(freq + [0,1]).mean;
	sig2 = RLPF.ar(sig2, \lpf.kr(1000) * env1, \rq2.kr(0.5));
	sig3 = LFNoise1.ar(1000 + [0,1]).mean;
	sig3 = WhiteNoise.ar;
	sig3 = sig3 * ( LFSaw.ar(freq / env2)  * env3 + 1);
	//sig3 = RHPF.ar(sig3, 19000 * env2, \rq.kr(0.5));
	sig3 = BPF.ar(sig3, ( \bpf3.kr(19000) * env2 ).clip(20,19909), \rq3.kr(0.5));
	sig3 = sig3 * EnvGen.kr(Env([0,1/12,0],[0.01,0.3], [1,-1]), 1);
	sig4 = LFSaw.ar(freq * \fmfac4.kr(8) );
	sig4 = RHPF.ar(sig4, \hpf4.kr(8000) * EnvGen.kr(\hpf4env.kr(Env([1,2,3],[0.1,0.8])), 1), \rq4.kr(0.5));
	sig4 = sig4 * EnvGen.kr(\sig4ampenv.kr(Env([0,1/1.2,1],[0.1,4.8])), 1);
	sig = [sig1,sig2,sig3,sig4].sum;
	//sig = sig4;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}, metadata:(specs:(
	env1: ParamEnvSpec(\lofreq),
	env2: ParamEnvSpec(\lofreq),
	env3: ParamEnvSpec(\lofreq),
	sig4ampenv: ParamEnvSpec(\lofreq),
	hpf4env: ParamEnvSpec(\lofreq),
))).add;
);

(
Pdef(\melo, 
	Pbind(
		\instrument, \freecorde,
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1,
	)
);
);
Pdef(\melo).edit
ProtoDef(\piano).startControl(Pdef(\melo))

TrackDef(\cave52, \CustomTrackList)
TrackDef(\cave52).edit;
FileSystemProject.current.addResource(TrackDef(\cave52))

TrackDef(\cave52).elAt(0,0).savePresetCompileString;
TrackDef(\cave52).elAt(0).children

TrackDef(\cave52_mainTrackGrid).showMixerView

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[327].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/4,
			\gain, 0.1,
			\out, BusDef(\sendbus5, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2361].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/4,
			\gain, 0.11,
			\out, BusDef(\sendbus5, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2558].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
			],inf).coin.not,
			\dur, 1/4,
			\gain, 0.21,
			\out, BusDef(\sendbus5, \audio),
		),
		
	])
)).play;
);
ProtoDef('cave52_mainMixer').tracks[0].get(\postfader)
ProtoDef('cave52_mainMixer').edit
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[327].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,

				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/4,
			\gain, 0.1,
			\out, BusDef(\mixer0, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2361].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/4,
			\gain, 0.11,
			\out, BusDef(\mixer1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2558].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
				1,0,0,1, 1,1,0,1,
			],inf).coin.not,
			\dur, 1/4,
			\gain, 0.21,
			\out, BusDef(\mixer2, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[687].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,0,0,
				
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,1, 1,0,1,0,
				1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\legato, Pseq([
				0.8,0.4,0.8,0.4,
				0.8,0.4,0.8,0.4,
				2.8,0.4,0.8,0.4,
				0.2,0.1,2.1,0.1,

				0.8,0.4,0.8,0.4,
				0.8,0.4,0.8,0.4,
				0.8,0.4,0.8,0.4,
				0.2,0.1,2.1,0.1,
				
			],inf),
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\mixer3, \audio),
		),
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1383].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 1,0,1,0, 
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,1,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/4,
			\gain, 0.11,
			\out, BusDef(\sendbus6, \audio),
		),
	])
)).play;
);

(
Pdef(\part2, Pdef(\camelcactus1, 
	Ppar([
		Pfindur(16,Pmono( \playersec,
			\bufnum, BufDef('vipere/camelcactus.flac'),
			\pos, 40,
			\dur, 1,
			\gain, 0.7,
			\out, BusDef(\mixer4, \audio),
		)).loop
		
	])
)).play;
);

(
Pdef(\part3, Pdef(\p3drums, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1,
			\st, 92.10/4/60,
			\speed, 1/Pseq([1,1,2,4],inf)/2 * ~t / Pkey(\st),
			\pos, Pseq([
				Pseg(Pseq([
					2, 3,
				],1),4),
				Pseg(Pseq([
					1, 2,
				],1),4),
			],inf)+1 / Pkey(\st),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				//Pseq([0.5],8),
				//1,1,1,1, 1,1,1,1,
				//Plazy({ arg ev;
					//var seq;
					//Pseq([
						//seq = Pseq([
							//1,1,1,1, 0,0,0,0,
						//].scramble,1),
						//Pseq([
							//1,1,1,1, 1,1,0,0,
						//].scramble,1),
						//seq,

						//Pseq([
							//1,1,1,1, 0,0,0,0,
						//].scramble,1),


						//1,1,1,1, 1,1,1,1,
						//1,1,1,1, 1,1,1,1,
						//0,0,0,0, 0,0,0,0,
						//1,1,1,1, 1,1,1,1,
					//],1);
				//}).loop,
			],inf).coin.not,
			//\dur, PdurStutter(Pseq([1,1,1,4,2,1,8],inf), 1/1),
			\dur, 1/4,
			\gain, 0.6,
		),
		
	])
)).play;
);

(
Pdef(\part3, Pdef(\zedpart3, 
	Ppar([

		Pmono(
			 \playersec,
			\bufnum, SampleTimeline('cave52.2.1score').buffer,
			\speed, 1.1,
			\dur, 1,
			\gain, Pseq([0,0,0,1],inf),
		)
		
	])
)).play;
);

(
Pdef(\part3, Pdef(\zedpart3, 
	Ppar([

		Pbind(
			\instrument, \playersec,
			\bufnum, SampleTimeline('cave52.2.1score').buffer,
			\pos, Pseq([11,26,14,44],inf).stutter(8),
			\dur, 1,
			\lag, 1/4/~t,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\gain, 1,
		)
		
	])
)).play;
);


////////////////////////////////
/// base long dist kick

ProtoDef('rdn').inbus = BusDef('sendbus6');
ProtoDef('rdn').outBus = 0;
ProtoDef('rdn').make('deldefault', 'rdn', "5-GI0S-33QC", BusDef('sendbus6'));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 1.0,
	'gain', 1.0,
	'fb', 0.0001,
	'delay', 0.0001,
	'delay2', 1.0,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 3.4499684705497,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 128.16005488832,
	'lpf', 17000,
	'hpf', 651.08102373701,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

ProtoDef('rdn2').inbus = BusDef('sendbus2');
ProtoDef('rdn2').outBus = 0;
ProtoDef('rdn2').make('deldefault', 'rdn2', "4-J136-3KJH", BusDef('sendbus2'));
Ndef('rdn2').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 1.0,
	'gain', 0.76890756302521,
	'fb', 0.0015122617483274,
	'delay', 0.60466190090704,
	'delay2', 0.49828635146473,
	'shift', 0.0,
	'shift2', -0.084033613445379,
	'distamp', 57.610839222447,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 16803.499738589,
	'prehpf', 25.227274440749,
	'lpf', 20000.0,
	'hpf', 20.0,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 7900.7560271333,
	'posthpf', 20.0,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

ProtoDef('rdn3').inbus = BusDef('sendbus3');
ProtoDef('rdn3').outBus = 0;
ProtoDef('rdn3').make('deldefault', 'rdn3', "5-ORFO-I9K8", BusDef('sendbus3'));
Ndef('rdn3').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.86554621848739,
	'gain', 0.39075630252101,
	'fb', 0.0001,
	'delay', 0.51794746792312,
	'delay2', 0.18936988889504,
	'shift', -0.16806722689076,
	'shift2', -0.21008403361345,
	'distamp', 0.24589873950613,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

ProtoDef('rdn4').inbus = BusDef('sendbus4');
ProtoDef('rdn4').outBus = 0;
ProtoDef('rdn4').make('deldefault', 'rdn4', "5-2VQK-5MR1", BusDef('sendbus4'));
Ndef('rdn4').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.36134453781513,
	'gain', 1.0,
	'fb', 0.0001,
	'delay', 0.00038746751204561,
	'delay2', 0.0005080218046913,
	'shift', 0.12605042016807,
	'shift2', 0.084033613445378,
	'distamp', 0.85659021536855,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 229.00951398766,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));




Ndef('fx1').source = 'fx_greyhole';
PlayerWrapper(Ndef('fx1')).outBus = BusDef('fxmixer0');
Ndef('fx1').setVal('inbus', BusDef('sendbus5'));
Ndef('fx1').setVal('delay', 0.34375);
Ndef('fx1').setVal('damp', 0.2310979942576);
Ndef('fx1').setVal('size', 0.72735058488109);
Ndef('fx1').setVal('diff', 0.63907036046721);
Ndef('fx1').setVal('fb', 0.214246453173);
Ndef('fx1').setVal('modDepth', 0.10000000149012);
Ndef('fx1').setVal('modFreq', 2.0);
Ndef('fx1').setVal('adsr', Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.10000000149012, 0.10000000149012, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0));
Ndef('fx1').setVal('mix', 1.0);
Ndef('fx1').setVal('gain', 0.75862068965517);

Ndef('fx2').source = 'fx_greyhole';
PlayerWrapper(Ndef('fx2')).outBus = BusDef('fxmixer1');
Ndef('fx2').setVal('inbus', BusDef('sendbus6'));
Ndef('fx2').setVal('delay', 0.171875);
Ndef('fx2').setVal('damp', 0.37297498522064);
Ndef('fx2').setVal('size', 0.1);
Ndef('fx2').setVal('diff', 3.0280995303199);
Ndef('fx2').setVal('fb', 0.71998724194777);
Ndef('fx2').setVal('modDepth', 44.721359549996);
Ndef('fx2').setVal('modFreq', 4.8871275633347);
Ndef('fx2').setVal('adsr', Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.10000000149012, 0.10000000149012, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0));
Ndef('fx2').setVal('mix', 0.71078431372549);
Ndef('fx2').setVal('gain', 0.70098039215686);

Ndef('fx3').source = nil;
PlayerWrapper(Ndef('fx3')).outBus = 0;
Ndef('fx3').setVal('inbus', 0);
Ndef('fx3').setVal('gain', 1);

Ndef('fx4').source = nil;
PlayerWrapper(Ndef('fx4')).outBus = 0;
Ndef('fx4').setVal('inbus', 0);
Ndef('fx4').setVal('gain', 1);


/////////////////// /////////////////// /////////////////// ///////////////////
/////////////////// /////////////////// /////////////////// ///////////////////



Window.allWindows.collect{ arg w; w.name }

WindowDef.all.first



///////////////////////



(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);



(
SynthDef(\tump, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = FSinOsc.ar(freq* (1..8) * [ [1,3/2] ]) * (LFNoise1.kr(6!8!2) * ( 1/( (1..8)+1 ) ) * 0.8).max(0);
	sig = sig.mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.3,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp).mean;
	sig = sig * amp;
	sig.debug("sig");
	Out.ar(out, sig);
}).add;
);
( 1/((1..8)) ).plot;
( 1/((1..8)**(18)) ).plot;
( ((1..8)) ).plot;
(1..8) * [[1,2]] * ( 6!2!8 )
(
SynthDef(\tump2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = FSinOsc.ar(freq* (1..8) * [ \chord.kr([1,3/2]) ]) * (LFNoise1.kr(6!2!8) * ( 1/( (1..8)**(\harm.kr(1))+1 ) ) * 0.8).max(0);
	sig = sig.mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.3,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp).mean;
	sig = sig * amp;
	sig.debug("sig");
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\tump, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,1,0],[0.01,0.1]), 1);
	//sig = SinOsc.ar( (freq* (1..8) * [ [1,3/2] ] * ( SinOsc.ar([[3/2,1]*freq*1]) * (LFNoise1.kr(1!8!2) * ( 1/( (1..8)+1 ) ) * 2.8).max(0) + 1 )) ) * (LFNoise1.kr(6!8!2) * ( 1/( (1..8)+1 ) ) * 0.8).max(0);
	sig = SinOsc.ar( (freq* (1..8) * [ [1,3/2] ] * ( SinOsc.ar([[3/2,1]*freq*\fmfac.kr(1)]) * (LFNoise1.kr(1!8!2) * ( 1/( (1..8)+1 ) ) * 8.8).max(0) + 1 )) ) * 0.1 ;
	sig = sig + ( FSinOsc.ar(freq* (1..8) * [ [1,3/2] ]) * (LFNoise1.kr(6!8!2) * ( 1/( (1..8)+1 ) ) * 0.8).max(0) );
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * (env1 + 1) * freq, \rq.kr(0.5));
	//sig = sig + SinOsc.ar(freq, mul:0.05); 
	sig = sig.mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.3,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp).mean;
	sig = sig * amp;
	sig.debug("sig");
	Out.ar(out, sig);
}).add;
);

(
Pdef(\demo, 
	Pbind(
		\instrument, \tump,
		\degree, Pstep(Pseq([0,4],inf),4),

		\octave, 3,
		//\freq, 70,
		\legato,1,
		\adsr, Pseq([
			[ Env.adsr(0.001,0.01,0.4,2.1) ],
		],inf),
		\dur, Plazy({ Pseq([3,3,2].scramble/8,8) }).loop,
		\amp, 2.8,
	)
).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \tump2,
			\chord, [[1/2,1]],
			\note, Pfunc({ ~melo1 }),
			\octave, 3,
			//\freq, 70,
			\legato,1,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.01,0.4,2.1) ],
			],inf),
			\dur, Plazy({ Pseq([3,3,2].scramble/8,8) }).loop,
			\amp, 2.8,
		)
		
	])
)).play;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \tump2,
			\chord, Pseq([
				[[1.01,1]],
				[[1/2,2]],
				[[2,1]],
				[[1,3.midiratio]],
			],inf),
			\note, Pstep(Pseq([0,-1, 0,-6, -9,-1, -10,-9],inf),Pseq([3,1],inf))+8,
			\harm, Pseg(Pseq([0,0.01,1,10],inf),8),
			\harm, Pseq([0.01,10,10],inf),
			\octave, 3,
			//\freq, 70,
			\legato,1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,0.4,2.1) ],
				[ Env.adsr(0.01,0.21,0.4,0.1) ],
			],inf),
			\dur, Plazy({ Pseq([3,3,2].scramble/8,8) }).loop,
			\amp, 2.8,
		),
		Pbind(
			\instrument, \tump2,
			\chord, Pseq([
				[[1.01,1]],
				[[1/2,2]],
				[[2,1]],
				[[1,3.midiratio]],
			],inf),
			\note, Pstep(Pseq([0,-1, 0,-6, -9,-1, -10,-9],inf),Pseq([3,1],inf))+8,
			\harm, Pseg(Pseq([1,10],inf),8),
			//\harm, Pseq([10,10],inf),
			\octave, 5,
			//\freq, 70,
			\legato,1,
			\adsr, Pseq([
				//[ Env.adsr(0.001,0.01,0.4,2.1) ],
				[ Env.adsr(0.01,0.21,0.4,1.1) ],
			],inf),
			\dur, Plazy({ Pseq([3,3,2].scramble/8,8) }).loop,
			\amp, 2.8,
		),
		
	])
)).play;
);




(
Pdefn(\melo1, Pseq([0,3,4,0],inf));
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \tump,
			\degree, Pstep(Pdefn(\melo1),4),

			\octave, 3,
			\lpfr, Pseg(Pseq([1,4],inf),16),
			//\freq, 70,
			\legato,1,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.01,0.4,2.1) ],
			],inf),
			\dur, Plazy({ Pseq([3,3,2].scramble/8,8) }).loop,
			\amp, 3.8,
		),
		Pbind(
			\instrument, \tump,
			\degree, Pstep(Pdefn(\melo1),4),

			\octave, 6,
			//\freq, 70,
			\legato,1,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.01,0.4,0.1) ],
			],inf),
			\dur, Plazy({ Pseq([3,3,2].scramble/8,8)*2 }).loop,
			\amp, 0.8,
		),
		Pbind(
			\instrument, \tump,
			\degree, Pstep(Pdefn(\melo1),4),

			\octave, 5,
			\lpfr, Pseg(Pseq([1/2,2],inf),16),
			//\freq, 70,
			\legato,1,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.01,0.4,0.1) ],
			],inf),
			\dur, Plazy({ Pseq([3,3,2].scramble/8,8) }).loop,
			\amp, 0.8,
		),
		
	])
)).play;
);

~melo1 = 0;

(
MIDIdef.noteOn(\track1, { arg velocity, noteNum, channel, deviceId;
	[ velocity, noteNum, channel, deviceId ].debug;
	~melo1 = noteNum - 60;
	~melo1.postln;
	
}).permanent_(true);
)

(
Pdefn(\melo1, Pfunc({ ~melo1 }));
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \tump,
			\note, Pstep(Pdefn(\melo1),4),

			\octave, 3,
			\lpfr, Pseg(Pseq([1,4],inf),16),
			//\freq, 70,
			\legato,1,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.01,0.4,2.1) ],
			],inf),
			\dur, Plazy({ Pseq([3,3,2].scramble/8,8) }).loop,
			\amp, 3.8,
		),
		Pbind(
			\instrument, \tump,
			\note, Pstep(Pdefn(\melo1),4),

			\octave, 6,
			//\freq, 70,
			\legato,1,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.01,0.4,0.1) ],
			],inf),
			\dur, Plazy({ Pseq([3,3,2].scramble/8,8)*2 }).loop,
			\amp, 0.8,
		),
		Pbind(
			\instrument, \tump,

			\octave, 5,
			\lpfr, Pseg(Pseq([1/2,2],inf),16),
			//\freq, 70,
			\legato,1,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.01,0.4,0.1) ],
			],inf),
			\dur, Plazy({ Pseq([3,3,2].scramble/8,8) }).loop,
			\amp, 0.8,
		),
		
	].collect({ arg pat;
		Pbind(
			\note, Pstep(Pdefn(\melo1),1),
			\note, Pfunc({ ~melo1 }),
		)<>
		pat
   
	}))
)).play;
);


(
Pdef(\demo, 
	Pbind(
		\instrument, \tump,
		\degree, Pseq([0,4+7,2b,4,0+7,4-7],inf),
		\mtranspose, Pstep(Pseq([0,5],inf),8),
		\fmfac, Pseq([1,1/2,2,1,1/3,1,1/4,1],inf),
		\lpfr, 3,
		//\freq, 70,
		\octave, 3,
		\legato,5,
		\dur, Pwhite(1.2,2),
		\amp, 1.8,
	)
).play;
);


(
Ndef(\bla, { SinOsc.ar(ExpRand(10,4000))!2*0.1  });
Ndef(\bla)[1] = Ndef(\bla)[0].source;
Ndef(\bla)[2] = Ndef(\bla)[0].source;
)
Ndef(\bla).sendEach
Ndef(\bla).play
Ndef(\bla).spawn
Ndef(\bla).clear


///////////////////////////////////////////////////


