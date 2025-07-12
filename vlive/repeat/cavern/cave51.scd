~t = 165/2/60; TempoClock.default.tempo = ~t;
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
SynthDef(\fmbass2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var freqenv = EnvGen.kr(Env([10,freq,freq],[0.001,0.1]), 1);
	var fmfreq;
	var fmampenv;
	var freqtab, fmfreqtab;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freqtab = [1/2,1,2];
	fmfreqtab = [1/2,1,2];
	fmfreq = EnvGen.kr(Env([freq,freq,freq],[0.051,4.1]), 1);
	fmampenv = EnvGen.kr(Env([0,2.1,1,0],[0.01,3.01,0.1]), 1) * \fmampenvamt.kr(4) + 1;
	sig1 = SinOsc.ar(freqenv * freqtab * ( SinOsc.ar(fmfreq * [ fmfreqtab ] * [1,1+\epsilon.kr(0.01)]) * fmampenv * \fmamp.kr(1) + 1 ));
	sig2 = LFPulse.ar(freqenv * freqtab * ( LFPulse.ar(fmfreq * [ fmfreqtab ] * [1,1+\epsilon.kr(0.01)]) * fmampenv * \fmamp.kr(1) + 1 ));
	sig2 = RLPF.ar(sig2, \lpfr.kr(1.1) * freq, \rq.kr(0.5)) * 1.4;
	sig3 = LFSaw.ar(freqenv * freqtab * ( LFSaw.ar(fmfreq * [ fmfreqtab ] * [1,1+\epsilon.kr(0.01)]) * fmampenv * \fmamp.kr(1) + 1 ));
	sig3 = RLPF.ar(sig3, \lpfr.kr(1.1) * freq, \rq.kr(0.5)) * 1.4;
	sig = SelectXFocus.ar(\wavemix.kr(0.0)*2, [sig1, sig2, sig3], \wavefocus.kr(1), true);
	sig = SelectXFocus.ar(\freqmix.kr(0.5)*2, sig, \freqfocus.kr(1), true);
	sig = SelectXFocus.ar(\fmfreqmix.kr(0.5)*2, sig, \fmfreqfocus.kr(1), true);
	sig.debug("sig");
	sig = sig * 2;
	//sig = sig + ( SinOsc.ar(freqenv * 1/2 * ( LFPulse.ar(fmfreq * 1/2 * [1,1+\epsilon.kr(0.01)]) * fmampenv * \fmamp.kr(1) + 1 )) * 0.5 );
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}, metadata:(specs:(
	wavemix: \unipolar,
	freqmix: \unipolar,
	fmfreqmix: \unipolar,
))).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \fmbass2,
			\degree, Pseq([0,2,4,2],inf),
			\mtranspose, Pstep(Pseq([7, 2, 5, 2],inf),4),
			\dur, Prand([1,1/2,1/4],inf),
			\dur, 1/4,
			\octave, 3,
			\epsilon, ~pmodenv.(Pseq([0.0001,0.007],1), 8).loop,
			//\legato, Pseq([
				//14,0,0,0, 0,0,0,0,
				//0,0,0,0, 0,0,1,0,
			//],inf),
			\legato, Pseq([
				Pseq([
					1,0,0,0.3,
				],5),
				1,1,1,0.3,
				1,0,1,0.3,
				1,1,0,0.3,
			],inf)/5 * Pseq([1,1.2,2,0.4,5],inf).stutter(6),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			//\dur, 1/8,
			\fmampenvamt, 1,
			\wavemix, ~pmodenv.(Pwhite(0,0.0,inf), Pwhite(1.0,4)).loop,
			\wavemix, 0,
			\lpfr, ~pmodenv.(Pseq([1,2.4],1), 8).loop,
			\freqmix, ~pmodenv.(Pwhite(0,1.0,inf), Pwhite(1.0,4)).loop,
			\fmfreqmix, ~pmodenv.(Pwhite(0,1.0,inf), Pwhite(1.0,4)).loop,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \default,
			\degree, Pseq([0,2,4,2],inf),
			\mtranspose, Pseq([7, 2, 5, 2],inf).stutter(4),
			\dur, 1/4,
			\octave, 4,
			\amp, 0.1,
			\isRest, true,
		),

		Pbind(
			//\octave, ~ploop.(Pstep(Prand([4,5,6],inf),1/4),4,4),
			//\octave, 6,
			\octave, Prand([4,5,5,5,5,5,5,6],inf),
			\mtranspose, Pstep(Pseq([7, 2, 5, 2],inf),4),
			\fmr, 4,
			//\amr, Pseq([1,1/2,2,3,5],inf),
			\fmr, ~pmodenv.(Pseq([1,1.002,1.1,7.4,1.04]+0.7,inf), 3),
		) <>
		~ploopdur.(Pbind(
			\instrument, \default,
			\instrument, \freecorde,
			\degree, Prand([0,2,4,2, Prand((0..7),1), Rest(), Rest()],inf),
			\dur, Prand([1/2,1/4,1/8],inf),
			\fspread, 1/Pkey(\freq) * Pseq([1,1.2,4,8]/10,inf).stutter(8),
			//\fspread, 0.000001,
			\fmamp, Pseg(Pseq([0.02,0.1,0,0.4],inf),3),
			//\fmamp, 0.001,
			\amr, Pseq([1,1/2,2,3,5],inf),
			\amamp, 0.5,
			\spread, 0,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.6) ],
			],inf),
			\amp, 0.1/4,
		),2,4),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \fmbass2,
			\degree, Pseq([0,2,4,2],inf),
			\mtranspose, Pstep(Pseq([7, 2, 5, 2],inf),4),
			\dur, Prand([1,1/2,1/4],inf),
			\octave, 3,
			\epsilon, ~pmodenv.(Pseq([0.0001,0.007],1), 8).loop,
			//\legato, Pseq([
				//14,0,0,0, 0,0,0,0,
				//0,0,0,0, 0,0,1,0,
			//],inf),
			\legato, Prand([
				0,1,2,0.1,0.3,0.4,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			//\dur, 1/8,
			\fmampenvamt, 1,
			\wavemix, ~pmodenv.(Pwhite(0,0.0,inf), Pwhite(1.0,4)).loop,
			\wavemix, 0,
			\lpfr, ~pmodenv.(Pseq([1,2.4],1), 8).loop,
			\freqmix, ~pmodenv.(Pwhite(0,1.0,inf), Pwhite(1.0,4)).loop,
			\fmfreqmix, ~pmodenv.(Pwhite(0,1.0,inf), Pwhite(1.0,4)).loop,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \default,
			\degree, Pseq([0,2,4,2],inf),
			\mtranspose, Pseq([7, 2, 5, 2],inf).stutter(4),
			\dur, 1/4,
			\octave, 4,
			\amp, 0.1,
			\isRest, true,
		),

		Pbind(
			//\octave, Prand([4,5,5,5,5,5,5,6],inf),
			//\octave, ~ploop.(Pstep(Prand([4,5,6],inf),1/4),4,4),
			\octave, 6,
			\mtranspose, Pstep(Pseq([7, 2, 5, 2],inf),4),
			\fmr, 4,
			//\amr, Pseq([1,1/2,2,3,5],inf),
			\fmr, ~pmodenv.(Pseq([1,1.002,1.1,7.4,1.04]+0.7,inf), 3),
		) <>
		~ploopdur.(Pbind(
			\instrument, \default,
			\instrument, \freecorde,
			\degree, Prand([0,2,4,2, Prand((0..7),1), Rest(), Rest()],inf),
			\dur, Prand([1/2,1/4,1/8],inf),
			\fspread, 1/Pkey(\freq) * Pseq([1,1.2,4,8]/10,inf).stutter(8),
			//\fspread, 0.000001,
			\fmamp, Pseg(Pseq([0.02,0.1,0,0.4],inf),3),
			//\fmamp, 0.001,
			\amr, Pseq([1,1/2,2,3,5],inf),
			\amamp, 0.5,
			\spread, 0,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.6) ],
			],inf),
			\amp, 0.1/4,
		),Prand([1/2,1,2],inf),Prand((1..4),inf)),
		
	])
)).play;
);

Pdef(\zed).clear
Pdef(\part).clear
(

Pdef(\zed, 
	Prout({ arg event;
		var dur = 1;
		var pattern = Pbind(
			\instrument, \default,
			\degree, Prand((0..12),inf),
			\dur, 1/4,
			\amp, 0.1,
		);
		var tolerance = 0.001;
		var repeat = 4;
		var iterations = 4;

		var item, delta, elapsed = 0.0, nextElapsed, inevent;
		var localdur = dur.value(event);
		var stream = pattern.asStream;
		var cleanup = EventStreamCleanup.new;
		var memory = List.new;

		iterations.do {
			memory = List.new;
			elapsed = 0.0;

			block { arg break;
				loop {
					inevent = stream.next(event).asEvent ?? { ^event };
					cleanup.update(inevent);
					delta = inevent.delta;
					nextElapsed = elapsed + delta;

					if (nextElapsed.roundUp(tolerance) >= localdur) {
						// must always copy an event before altering it.
						// fix delta time and yield to play the event.
						inevent = inevent.copy.put(\delta, localdur - elapsed);
						memory.add(inevent.copy);
						inevent.debug("inevent");
						inevent = inevent.yield;
						//event = inevent.yield;
						//cleanup.exit(inevent);
						break.value;
					};

					elapsed = nextElapsed;
					memory.add(inevent.copy);
					inevent.debug("inevent");
					event = inevent.yield;

				};
			};
			memory.size.postln;
			Pseq(memory,repeat-1).trace.embedInStream;
		};
		cleanup.exit(inevent);
		
	}),
).play;
)

(
~ploopdur.(

		Pbind(
			\instrument, \default,
			\degree, Prand((0..12),inf),
			\dur, Prand(1/(1..8),inf),
			\amp, 0.1,
		),
		1,
		4
).play;
)

(
	~ploop = { arg pattern, count=1, repeats=1, iterations=inf;
		Prout({ arg ev;

			var str = pattern.asStream;
			iterations.do {
				var seq = str.nextN(count,ev);
				Pseq(seq,repeats).embedInStream;
			};

		});
	}
)

(
~ploopdur = { arg pattern, dur=1, repeats=1, iterations=inf, tolerance=0.001;
	Prout({ arg event;
		var item, delta, elapsed = 0.0, nextElapsed, inevent;
		var localdurstr = dur.asStream;
		var localdur;
		var stream = pattern.asStream;
		var cleanup = EventStreamCleanup.new;
		var memory = List.new;
		var localrepeats = repeats.asStream;

		iterations.do {
			memory = List.new;
			elapsed = 0.0;
			localdur = localdurstr.next;

			block { arg break;
				loop {
					inevent = stream.next(event).asEvent ?? { ^event };
					cleanup.update(inevent);
					delta = inevent.delta;
					nextElapsed = elapsed + delta;

					if (nextElapsed.roundUp(tolerance) >= localdur) {
						// must always copy an event before altering it.
						// fix delta time and yield to play the event.
						inevent = inevent.copy.put(\delta, localdur - elapsed);
						memory.add(inevent.copy);
						inevent.debug("inevent");
						inevent = inevent.yield;
						//event = inevent.yield;
						//cleanup.exit(inevent);
						break.value;
					};

					elapsed = nextElapsed;
					memory.add(inevent.copy);
					inevent.debug("inevent");
					event = inevent.yield;

				};
			};
			memory.size.postln;
			Pseq(memory,localrepeats.next-1).trace.embedInStream;
		};
		cleanup.exit(inevent);
		
	});

};
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\degree, Pseq([0,2,4,2],inf),
			\mtranspose, Pstep(Pseq([7, 2, 5, 2],inf),4),
			\dur, Prand([1,1/2,1/4],inf),
			\octave, 3,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \default,
			\degree, Pseq([0,2,4,2],inf),
			\mtranspose, Pseq([7, 2, 5, 2],inf).stutter(4),
			\dur, 1/4,
			\octave, 4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \default,
			\degree, Prand([0,2,4,2, Prand((0..7),1), Rest(), Rest()],inf),
			\mtranspose, Pstep(Pseq([7, 2, 5, 2],inf),4),
			\octave, Prand([4,5,5,5,5,5,5,6],inf),
			\dur, Prand([1/2,1/4,1/8],inf),
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \somebass2,
			\degree, Pseq([
				0,2,2b,1,
			],inf),
			\octave, 3,
			\dur, 2,
			\amp, 0.1,
		),
		
	])
)).play;
);

TrackDef(\cave51).elAt(1,0).score.target.presetCompileString.editorInsert
(
Pdef('NoteTimelineTrack.1.instr').setVal('out', BusDef('sendbus1'));
Pdef('NoteTimelineTrack.1.instr').setVal('env1', Env([ 0.1, 3.2757884532109, 0.11049395562977, 0.1 ], [ 0.35649024578396, 0.65100278765181, 0.86250697878318 ], [ 0.0, 0.0, 0.0 ]));
Pdef('NoteTimelineTrack.1.instr').setVal('env2', Env([ 2.4709112279856, 0.30348892740949, 0.92105529060162 ], [ 0.57353758811951, 0.33203345537186 ], [ 0.0, 0.0 ]));
Pdef('NoteTimelineTrack.1.instr').setVal('env3', Env([ 3.1622776601684, 0.34333201192545, 0.78137088319053 ], [ 0.3228412270546, 0.5437325835228 ], [ 0.0, 0.0 ]));
Pdef('NoteTimelineTrack.1.instr').setVal('lpf', 568.99916400934);
Pdef('NoteTimelineTrack.1.instr').setVal('rq2', 2.7129499675592);
Pdef('NoteTimelineTrack.1.instr').setVal('bpf3', 3087.7906902725);
Pdef('NoteTimelineTrack.1.instr').setVal('rq3', 0.39356237339846);
Pdef('NoteTimelineTrack.1.instr').setVal('fmfac4', 0.50489126433682);
Pdef('NoteTimelineTrack.1.instr').setVal('hpf4', 50.653229585728);
Pdef('NoteTimelineTrack.1.instr').setVal('hpf4env', Env([ 0.1, 17.782794100389, 0.1 ], [ 0.4203342795372, 0.54902505193912 ], [ 4.6, -0.5 ]));
Pdef('NoteTimelineTrack.1.instr').setVal('rq4', 0.39356237339846);
Pdef('NoteTimelineTrack.1.instr').setVal('sig4ampenv', Env([ 0.1, 3.1622776601684, 0.1 ], [ 0.80167134512781, 0.29832865636231 ], [ -8.9, -4.8 ]));

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

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		
	])
)).play;
);

TrackDef(\cave51, \CustomTrackList).edit
FileSystemProject.current.addResource(TrackDef(\cave51))
//TagSpecDef(\synthdef -> \fx).addUnique(\bla)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\sendbus4, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\sendbus4, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\sendbus4, \audio),
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1129].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/4,
			\gain, 0.1,
			\out, BusDef(\sendbus4, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1383].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/4,
			\gain, 0.21,
			\out, BusDef(\sendbus4, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1743].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\legato, Pseq([
				0.3,0.2,0.3,0.32,
				0.3,0.7,0.3,2,
				0.3,0.2,0.3,0.32,
				0.3,2.7,0.3,0.2,
			],inf).stutter(2),
			\dur, 1/4,
			\gain, 0.11,
			\out, BusDef(\sendbus4, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 1,1,1,1,
				1,0,1,0, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\sendbus4, \audio),
		),
		
	])
)).play;
);


