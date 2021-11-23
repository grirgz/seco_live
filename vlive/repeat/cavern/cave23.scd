~t = 140/4/60; TempoClock.default.tempo = ~t;
(
SynthDef(\organ_tonewheel0, {
	//additive tonewheel organ with few CPU usage

	arg out=0, freq = 440, amp = 0.7, atk = 0.001, sus = 0.2, rel = 0.01, pan = 0,
	bass = 1, quint = 1, fundamental = 1, oct = 1, nazard = 1, blockFlute = 1, tierce = 1, larigot = 1, sifflute = 1, //organ voices (drawbars) amplitudes
	vrate = 3, vdepth = 0.008; //vibrato arguments
	var sig, env, vibrato;

	vibrato = SinOsc.kr(DC.kr(vrate)).range(1 - DC.kr(vdepth), 1+ DC.kr(vdepth));
	env = EnvGen.ar(Env.linen(atk, sus, rel), doneAction: Done.freeSelf);
	sig = DynKlang.ar(`[[1/12,  1/7, 1, 12, 19, 24, 28, 31, 36].midiratio, ([DC.ar(bass) , DC.ar(quint), DC.ar(fundamental), DC.ar(oct), DC.ar(nazard), DC.ar(blockFlute), DC.ar(tierce), DC.ar(larigot), DC.ar(sifflute)].normalizeSum), nil], vibrato * freq);

	sig = sig * env;
	Out.ar(out, Pan2.ar(sig, pan, amp));
//By Zé Craum
}).add;

SynthDef(\organ_tonewheel1, {
	//additive tonewheel organ with more CPU usage

	arg out=0, freq = 440, amp = 0.7, atk = 0.001, sus = 0.2, rel = 0.01, pan = 0,
	bass = 1, quint = 1, fundamental = 1, oct = 1, nazard = 1, blockFlute = 1, tierce = 1, larigot = 1, sifflute = 1, //organ voices (drawbars) amplitudes
	vrate = 3, vdepth = 0.008, vdelay = 0.1, vonset = 0, vrateVariation = 0.1, vdepthVariation = 0.1; //vibrato arguments
	var sig, env, vibrato;

	vibrato = Vibrato.kr(DC.kr(freq), DC.kr(vrate), DC.kr(vdepth), DC.kr(vdelay), DC.kr(vonset), DC.kr(vrateVariation), DC.kr(vdepthVariation));
	env = EnvGen.ar(Env.linen(atk, sus, rel), doneAction: Done.freeSelf);
	sig = DynKlang.ar(`[[1/12,  1/7, 1, 12, 19, 24, 28, 31, 36].midiratio, ([DC.ar(bass) , DC.ar(quint), DC.ar(fundamental), DC.ar(oct), DC.ar(nazard), DC.ar(blockFlute), DC.ar(tierce), DC.ar(larigot), DC.ar(sifflute)].normalizeSum), nil], vibrato);

	sig = sig * env;
	Out.ar(out, Pan2.ar(sig, pan, amp));
//By Zé Craum
}).add;
)


// chained list of notes like game of life

~el = XEventList()

NoteTimeline(\chain).edit
NoteTimeline(\chain).clear
NoteTimeline(\chain).eventList
NoteTimeline(\chain).eventList.print
NoteTimeline(\chain).eventList.reorder

(
	// idx bugged, wrong approach
~transform_el = { arg el;
	var oldev = nil;
	var elcopy = el.copy;
	elcopy.do { arg ev, idx;
		if([\start,\stop].includes(ev.type).not) {
			if(ev[\dur] > 0.1) {
				var newev = ev.copy;
				newev.midinote = rrand(ev.midinote ?? 60, elcopy[idx+1].midinote ?? 80);
				newev.absTime = rrand(ev.absTime ?? 0, elcopy[idx+1].absTime ?? ev.absTime);
				el.insert(idx+1, newev);
			} {
				if(ev[\dur] <= 0.1) {
					var newev = ev.copy;
					try{
						el.removeAt(idx);
					}
				}

			};
		}
	};
	el.reorder;
};
)
~transform_el.(NoteTimeline(\chain).eventList); NoteTimeline(\chain).editor.refresh
NoteTimeline(\chain).eventList.print
NoteTimeline(\chain).eventList.reorder
NoteTimeline(\chain).edit
NoteTimeline(\chain).editor.refresh

~a = ( 1..4 );
~a.insert(1,10)
~a.insert(4,10)


(
	// manual indexing
~transform_el = { arg el;
	var oldev = nil;
	var elcopy = el.copy;
	var idx = 0;
	block { arg break;
		10000.do {
			var ev = el[idx];
			if(ev.isNil) {
				break.value;
			};
			if([\end].includes(ev.type).not) {
				if(ev[\dur] > 0.1) {
					var newev = ev.copy;
					var nextev = el[idx+1] ?? ();
					newev.midinote = rrand(ev.midinote ?? 60, nextev.midinote ?? 80).round(1);
					newev.absTime = rrand(ev.absTime ?? 0, nextev.absTime ?? (( ev.absTime ?? 0 ) + 1));
					if(newev.type == \start) {
						newev.type = nil;
						newev.sustain = 0.25;
					};
					if(newev.midinote == nextev.midinote) {
						newev.midinote = ( newev.midinote + [12,-12].choose ).clip(30,100);
					};
					el.insert(idx+1, newev);
					idx = idx+2;
				} {
					if(ev[\dur] <= 0.1 and: { ev.type != \start }) {
						var newev = ev.copy;
						try{
							ev.debug("ev to remove");
							el[idx].debug("ev to remove indexed");
							el.removeAt(idx);
							idx = idx; // not need to advance, already next since current removed
						} {
							"ERRORO".throw
						}
					} {
						idx = idx +1;
					}

				};
			} {
				idx = idx+1;
			};
		}
	};
	el.reorder;
};
)

(
	// manual indexing, limit transform
~transform_el = { arg el;
	var oldev = nil;
	var elcopy = el.copy;
	var idx = el.size.rand;
	var delta = 0.6;
	var ev;
	var notemin = 10;
	var notemax = 40
	block { arg break;
		5.do {
			idx = el.size.rand;
			ev = el[idx];
			if(ev.isNil) {
				break.value;
			};
			if([\end].includes(ev.type).not) {
				if(ev[\dur] > delta) {
					var newev = ev.copy;
					var nextev = el[idx+1] ?? ();
					newev.midinote = rrand(ev.midinote ?? notemin, nextev.midinote ?? notemax).round(1);
					newev.absTime = rrand(ev.absTime ?? 0, nextev.absTime ?? (( ev.absTime ?? 0 ) + 1));
					newev.lpf = rrand(ev.lpf ?? 400, nextev.lpf ?? (( ev.lpf ?? 400 ) + 1000));
					if(newev.type == \start) {
						newev.type = nil;
						newev.sustain = 0.25;
					};
					if(newev.midinote == nextev.midinote) {
						newev.midinote = ( newev.midinote + [12,-12].choose ).clip(notemin,notemax);
					};
					el.insert(idx+1, newev);
					idx = idx+2;
				} {
					if(ev[\dur] <= delta and: { ev.type != \start }) {
						var newev = ev.copy;
						try{
							ev.debug("ev to remove");
							el[idx].debug("ev to remove indexed");
							el.removeAt(idx);
							idx = idx; // not need to advance, already next since current removed
						} {
							"ERRORO".throw
						}
					} {
						idx = idx +1;
					}

				};
			} {
				idx = idx+1;
			};
		}
	};
	el.reorder;
};
)
~transform_el.(NoteTimeline(\chain).eventList); NoteTimeline(\chain).editor.refresh
NoteTimeline(\chain).eventList.print
NoteTimeline(\chain).eventList.finish(2)
NoteTimeline(\chain).eventList.reorder
NoteTimeline(\chain).edit
NoteTimeline(\chain).editor.refresh
NoteTimeline(\chain).param = Pdef(\chaininstr)
NoteTimeline(\chain).param


(
Pdef(\chaininstr,
	Pbind(
		\instrument, \basicbass,
		\out, BusDef(\sendbus1, \audio),
		//\lpf, Pexprand(100,10000),
	)
)
)


(
	Pdef(\part2,
	Pdef(\randnote, 
		Prout({

			1000.do {

				(Pdef(\chaininstr) <> NoteTimeline(\chain).eventList.asPattern).embedInStream;
				//NoteTimeline(\chain).asPattern.embedInStream;
				"kkkkkkkkkkkkkkkkkkkkkkkkkkkk".debug;
				~transform_el.(NoteTimeline(\chain).eventList); 
				//NoteTimeline(\chain).editor.refresh;
			}

		})
	)).play
)


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				1,0,0,0, 0,0,1,0,
				0,0,0,1, 0,0,0,1,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,1,1,0,
				1,0,0,0, 0,0,1,0,
				0,0,0,1, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1065].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,1, 0,0,1,0,
				1,0,1,0, 0,1,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		
	])
)).play;
);

/////////////



(
	// manual indexing, limit transform
~transform_el_bass = { arg el;
	var oldev = nil;
	var elcopy = el.copy;
	var idx = el.size.rand;
	var delta = 0.6;
	var ev;
	var notemin = 10;
	var notemax = 40;
	block { arg break;
		5.do {
			idx = el.size.rand;
			ev = el[idx];
			if(ev.isNil) {
				break.value;
			};
			if([\end].includes(ev.type).not) {
				if(ev[\dur] > delta) {
					var newev = ev.copy;
					var nextev = el[idx+1] ?? ();
					newev.midinote = rrand(ev.midinote ?? notemin, nextev.midinote ?? notemax).round(1);
					newev.absTime = rrand(ev.absTime ?? 0, nextev.absTime ?? (( ev.absTime ?? 0 ) + 1));
					newev.lpf = rrand(ev.lpf ?? 400, nextev.lpf ?? (( ev.lpf ?? 400 ) + 1000));
					if(newev.type == \start) {
						newev.type = nil;
						newev.sustain = 0.25;
					};
					if(newev.midinote == nextev.midinote) {
						newev.midinote = ( newev.midinote + [12,-12].choose ).clip(notemin,notemax);
					};
					el.insert(idx+1, newev);
					idx = idx+2;
				} {
					if(ev[\dur] <= delta and: { ev.type != \start }) {
						var newev = ev.copy;
						try{
							ev.debug("ev to remove");
							el[idx].debug("ev to remove indexed");
							el.removeAt(idx);
							idx = idx; // not need to advance, already next since current removed
						} {
							"ERRORO".throw
						}
					} {
						idx = idx +1;
					}

				};
			} {
				idx = idx+1;
			};
		}
	};
	el.reorder;
};
)

(
	// manual indexing, limit transform
~transform_el_high = { arg el;
	var oldev = nil;
	var elcopy = el.copy;
	var idx = el.size.rand;
	var delta = 0.3;
	var ev;
	var notemin = 40;
	var notemax = 100;
	block { arg break;
		5.do {
			idx = el.size.rand;
			ev = el[idx];
			if(ev.isNil) {
				break.value;
			};
			if([\end].includes(ev.type).not) {
				if(ev[\dur] > delta) {
					var newev = ev.copy;
					var nextev = el[idx+1] ?? ();
					newev.midinote = rrand(ev.midinote ?? notemin, nextev.midinote ?? notemax).round(1);
					newev.absTime = rrand(ev.absTime ?? 0, nextev.absTime ?? (( ev.absTime ?? 0 ) + 1));
					newev.lpf = rrand(ev.lpf ?? 400, nextev.lpf ?? (( ev.lpf ?? 400 ) + 1000));
					if(newev.type == \start) {
						newev.type = nil;
						newev.sustain = 0.25;
					};
					if(newev.midinote == nextev.midinote) {
						newev.midinote = ( newev.midinote + [12,-12].choose ).clip(notemin,notemax);
					};
					el.insert(idx+1, newev);
					idx = idx+2;
				} {
					if(ev[\dur] <= delta and: { ev.type != \start }) {
						var newev = ev.copy;
						try{
							ev.debug("ev to remove");
							el[idx].debug("ev to remove indexed");
							el.removeAt(idx);
							idx = idx; // not need to advance, already next since current removed
						} {
							"ERRORO".throw
						}
					} {
						idx = idx +1;
					}

				};
			} {
				idx = idx+1;
			};
		}
	};
	el.reorder;
};
)

~transform_el.(NoteTimeline(\chain).eventList); NoteTimeline(\chain).editor.refresh
NoteTimeline(\chain).eventList.print
NoteTimeline(\chain).eventList.finish(2)
NoteTimeline(\chain).eventList.reorder

NoteTimeline(\chain_high).edit
NoteTimeline(\chain_high).presetCompileString.editorInsert
(
NoteTimeline('chain_high').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	(\absTime: 0.0, \dur: 1.0, \midinote: 54.0, \playDur: 1.0, \relDur: 1.0, \sustain: 0.1, ),
	(\absTime: 1.0, \dur: 0.5, \midinote: 63.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.1, ),
	(\absTime: 1.5, \dur: 0.5, \midinote: 51.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.1, ),
	(\absTime: 2.0, \dur: 1.375, \midinote: 57.0, \playDur: 1.375, \relDur: 1.375, \sustain: 0.1, ),
	(\absTime: 3.375, \dur: 0.375, \midinote: 66.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.1, ),
	(\absTime: 3.75, \dur: 0.25, \midinote: 66.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 4.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);

NoteTimeline(\chain_bass).edit
NoteTimeline(\chain_bass).presetCompileString.editorInsert
(
NoteTimeline('chain_bass').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	(\absTime: 0.0, \dur: 0.75, \midinote: 30.0, \playDur: 0.75, \relDur: 0.75, \sustain: 0.1, ),
	(\absTime: 0.75, \dur: 0.375, \midinote: 32.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.1, ),
	(\absTime: 1.125, \dur: 0.875, \midinote: 30.0, \playDur: 0.875, \relDur: 0.875, \sustain: 0.1, ),
	(\absTime: 2.0, \dur: 1.0, \midinote: 30.0, \playDur: 1.0, \relDur: 1.0, \sustain: 0.1, ),
	(\absTime: 3.0, \dur: 0.5, \midinote: 33.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.1, ),
	(\absTime: 3.5, \dur: 0.5, \midinote: 29.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.1, ),
	(\absTime: 4.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);


(
Pdef(\chaininstr_high,
	Pbind(
		\instrument, \organ_tonewheel1,
		\out, BusDef(\sendbus2, \audio),
		//\lpf, Pexprand(100,10000),
	)
)
)

(
Pdef(\chaininstr_bass,
	Pbind(
		\instrument, \organ_tonewheel0,
		\out, BusDef(\sendbus1, \audio),
		\lpf, Prout({ arg ev;
			100.do {

			if(ev[\lpf].notNil) {
				ev[\lpf].yield;
			} {
				ev.use { ( ~freq.value ?? 300 ) + 100 }.yield;
			}
			}
		}).loop,
		//\lpf, Pexprand(100,10000),
	)
)
)


(
	Pdef(\part2,
	Pdef(\randnote, 
		Ppar([

			Prout({

				1000.do {

					(Pdef(\chaininstr_bass) <> NoteTimeline(\chain_bass).eventList.asPattern).embedInStream;
					//NoteTimeline(\chain).asPattern.embedInStream;
					"kkkkkkkkkkkkkkkkkkkkkkkkkkkk".debug;
					~transform_el_bass.(NoteTimeline(\chain_bass).eventList); 
					//NoteTimeline(\chain).editor.refresh;
				}

			}),
			Prout({

				1000.do {

					(Pdef(\chaininstr_high) <> NoteTimeline(\chain_high).eventList.asPattern).embedInStream;
					//NoteTimeline(\chain).asPattern.embedInStream;
					"kkkkkkkkkkkkkkkkkkkkkkkkkkkk".debug;
					~transform_el_high.(NoteTimeline(\chain_high).eventList); 
					//NoteTimeline(\chain).editor.refresh;
				}

			}),
		]),
	)).play
)


(
Pdef(\part, Pdef(\zedpart, 
	Pbind(\lag, 0.04) <>
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				1,0,0,0, 0,0,1,0,
				0,0,0,1, 0,0,0,1,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,1,1,0,
				1,0,0,0, 0,0,1,0,
				0,0,0,1, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1065].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,1, 0,0,1,0,
				1,0,1,0, 0,1,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1,
			\st, 92.10/4/60,
			\speed, 1/2 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2,
			],1),4).loop / Pkey(\st),
			\isRest, Pseq([
				Pseq([
					1,1,1,1, 1,1,1,1,
				]-0.3,1),
				1,0,0,0, 1,0,0,1,
				1,0,0,1, 0,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.81,
		)
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Pbind(\lag, 0.04) <>
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				1,0,0,0, 0,0,1,0,
				0,0,0,1, 0,0,0,1,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,1,1,0,
				1,0,0,0, 0,0,1,0,
				0,0,0,1, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1065].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,1, 0,0,1,0,
				1,0,1,0, 0,1,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1/2,
			\st, 92.10/4/60,
			\speed, 0.5 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2,
			],1),4).loop / Pkey(\st),
			\isRest, Pseq([
				Pseq([
					1,1,1,1, 1,1,1,1,
				]-0.3,1),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.81,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1/2,
			\st, 92.10/4/60,
			\speed, 0.7 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2,
			],1),4).loop / Pkey(\st),
			\isRest, Pseq([
				Pseq([
					1,1,1,1, 1,1,1,1,
				]-0.4,1),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.61,
		)
		
	])
)).play;
);

(
	// with fx
Pdef(\part, Pdef(\zedpart, 
	Pbind( \out, BusDef(\sendbus3, \audio)) <>
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				1,0,0,0, 0,0,1,0,
				0,0,0,1, 0,0,0,1,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,1,1,0,
				1,0,0,0, 0,0,1,0,
				0,0,0,1, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1065].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,1, 0,0,1,0,
				1,0,1,0, 0,1,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1/2,
			\st, 92.10/4/60,
			\speed, 0.5 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2,
			],1),4).loop / Pkey(\st),
			\isRest, Pseq([
				Pseq([
					1,1,1,1, 1,1,1,1,
				]-0.3,1),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.81,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1/2,
			\st, 92.10/4/60,
			\speed, 0.7 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2,
			],1),4).loop / Pkey(\st),
			\isRest, Pseq([
				Pseq([
					1,1,1,1, 1,1,1,1,
				]-0.4,1),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.61,
		)
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Pbind(\lag, 0.04) <>
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1065].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,1, 0,0,1,0,
				1,0,1,0, 0,1,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1/2,
			\st, 92.10/4/60,
			\speed, 0.5 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2,
			],1),4).loop / Pkey(\st),
			\isRest, Pseq([
				Pseq([
					2,1,1,1, 1,1,1,1,
					0,0,0,0, 0,0,0,0,
				] * 0.7,1),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.81,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1/2,
			\st, 92.10/4/60,
			\speed, 0.7 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2,
			],1),4).loop / Pkey(\st),
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
					1,1,1,1, 1,1,1,1,
				] * 0.6,1),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.61,
		)
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Pbind(\lag, 0.04) <>
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1065].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,1, 0,0,1,0,
				1,0,1,0, 0,1,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1/2,
			\st, 92.10/4/60,
			\speed, 0.5 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				2, 2,
			],1),4).loop / Pkey(\st),
			\pos, 0.1,
			\isRest, Pseq([
				Pseq([
					1,0,1,0, 1,0,1,0,
				],1),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.81,
		),
		
	])
)).play;
);

(
SynthDef(\ramphi, { arg out=0,freq = 440, amp = 0.9, atk = 0.001, sus = 0.4, rel = 0.1, tune = 0.29, tuneRate = 6.0, rq = 1, pan = 0, gate=1;
	var sig, env, vibrato;
	var freqtab = freq * [1,2,1/2,2/3] * LFNoise1.kr(1/8!5).range(0.5,2.0);
	env = EnvGen.kr(\adsr.kr(Env.adsr(2.1,0.1,0.8,0.1)), gate, doneAction:2);

	vibrato = SinOsc.ar(tuneRate).range(freq, freq * (tune.midiratio));
	sig = LFPulse.ar(freqtab, 0, 0.5, 0.2) + LFPulse.ar(freqtab + vibrato, 0, 0.18);
	sig = sig.mean;
	sig = RLPF.ar(sig /*+ PinkNoise.ar(20/freq) */, ((28.midiratio) * (freq)) , rq) ;

	sig = sig * env;
	sig = LeakDC.ar(sig);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part3, Pdef(\zedpart3, 
	Ppar([
		Pmono(\ramphi,
			\freq, 200,
			\dur, Pn(8,1),
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
			\instrument, \organ_tonewheel0,
			\note, Pseq([
				0,1,1,-2,
			],inf).stutter(2),
			\dur, 1/2,
			\octave,3,
			\out, BusDef(\sendbus1, \audio),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \organ_tonewheel1,
			\note, Pseq([
				0,1,1,-2,
			],inf),
			\dur, 1,
			\out, BusDef(\sendbus2, \audio),
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part2, Pdef(\zedpart2, 
	Ppar([
		Pbind(
			\instrument, \organ_tonewheel0,
			\note, Pstep(Pseq([
				0,1,1,-2,
			],inf),1),
			\isRest, Pseq([
				1,0.5,0.5,0.5, 0.5,0.5,0.5,0.5,
			],inf).coin.not,
			\dur, 1/4,
			\octave,3,
			\out, BusDef(\sendbus1, \audio),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \organ_tonewheel1,
			\note, Pstep(Pseq([
				0,1,1,-2,
			],inf),1),
			\dur, 1/8,
			\isRest, Pseq([
				1,0.5,0.5,0.5, 0.5,0.5,0.5,0.5,
			],inf).coin.not,
			\octave, [4,5],
			\sus, Pexprand(0.01,0.3,inf),
			\atk, Pexprand(0.01,0.5,inf),
			\out, BusDef(\fx1, \audio),
			\tierce, Pwhite(0,3.0,inf),
			\larigot, Pwhite(0,3.0,inf),
			\fundamental, Pwhite(0,1.0,inf),

			\amp, 0.1/2,
		),
		
	])
)).play;
);

(
Pdef(\part2, Pdef(\zedpart2, 
	Ppar([
		Pbind(
			\instrument, \organ_tonewheel0,
			\note, Pseq([
				0,1,1,-2,
			],inf),
			\dur, 1,
			\octave,3,
			\out, BusDef(\sendbus1, \audio),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \organ_tonewheel1,
			\note, Pseq([
				0,1,1,-2,
			],inf).stutter(2),
			\dur, 1/2,
			\out, BusDef(\sendbus2, \audio),
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part2, Pdef(\zedpart2, 
	Ppar([
		Pfindur(4,Pbind(
			\dur, 1/Pseq((1..18),inf),
		)).loop<>
		Pbind(
			\instrument, \organ_tonewheel0,
			\note, Pseg(Pseq([
				0,1,1,-2,
			],inf),1),
			\legato, 0.4,
			\dur, 1/2,
			\octave,3,
			\out, BusDef(\sendbus1, \audio),
			\amp, 0.1,
		),
		(Pfindur(4,Pbind(
			\dur, 1/Pseq((1..14).reverse,inf),
		)).loop<>
		Pbind(
			\instrument, \organ_tonewheel1,
			\legato, 0.4,
			\note, Pseg(Pseq([
				0,1,1,-2,
			],inf),1),
			\dur, 1,
			\out, BusDef(\sendbus2, \audio),
			\amp, 0.1,
		)).trace,
		
	])
)).play;
);

(
Pdef(\part2, Pdef(\zedpart2, 
	Ppar([
		Pfindur(4,Pbind(
			\dur, 1/Pseq((1..18),inf),
		)).loop<>
		Pbind(
			\instrument, \organ_tonewheel0,
			\note, Pseg(Pseq([
				0,1,1,-2,
			],inf),1),
			\legato, 0.4,
			\dur, 1/2,
			\octave,3,
			\out, BusDef(\sendbus1, \audio),
			\amp, 0.1,
		),
			Prout({

				1000.do {

					(Pdef(\chaininstr_high) <> NoteTimeline(\chain_high).eventList.asPattern).embedInStream;
					//NoteTimeline(\chain).asPattern.embedInStream;
					"kkkkkkkkkkkkkkkkkkkkkkkkkkkk".debug;
					~transform_el_high.(NoteTimeline(\chain_high).eventList); 
					//NoteTimeline(\chain).editor.refresh;
				}

			}),
		
	])
)).play;
);

(
Pdef(\part2, Pdef(\zedpart2, 
	Ppar([
		Pfindur(4,Pbind(
			\dur, 1/Pseq((1..18),inf),
		)).loop<>
		Pbind(
			\instrument, \organ_tonewheel0,
			\note, Pstep(Pseq([
				0,1,1,-2,
			],inf),1),
			\legato, 0.4,
			\dur, 1/2,
			\octave,3,
			\out, BusDef(\sendbus1, \audio),
			\amp, 0.1,
		),
			Prout({

				1000.do {

					(Pdef(\chaininstr_high) <> NoteTimeline(\chain_high).eventList.asPattern).embedInStream;
					//NoteTimeline(\chain).asPattern.embedInStream;
					"kkkkkkkkkkkkkkkkkkkkkkkkkkkk".debug;
					~transform_el_high.(NoteTimeline(\chain_high).eventList); 
					//NoteTimeline(\chain).editor.refresh;
				}

			}),
		
	])
)).play;
);


(
Pdef(\part3, Pdef(\zedpart3, 
	Ppar([
		Pbind(
			\instrument, \nappy2,
			\note, Pseq([
				0,
				-1,
			],inf),
			\note, Pstep(Pseq([
				0,1,1,-2,
			],inf),1),
			\octave,5,
			//\lpfr, ~pmodenv.(Pseq([1,2,1,4]+18,1), 8).loop,
			\lpf, ~pmodenv.(Pseq([100,1200]+18,1), 8).loop,
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
			\out, BusDef(\fx1, \audio),
		),
		Pmono(\dreamer,
			\inbus, BusDef(\fx1, \audio),
			\mix, 0.2,
			\gain, 2.2,
			\mix, 0.6,
			\gain,1,
			//\delayfac, ~pmodenv.(Pseq([1,2,1,4],1), 8).loop,
			\addAction, \addToTail,
			\lag, 0.0009,
			\out, BusDef(\sendbus4, \audio),
			\dur, 1,
		),
		
	])
)).play;
);

(
Pdef(\part2, Pdef(\zedpart2, 
	Ppar([
		Pbind(
			\instrument, \organ_tonewheel0,
			\note, Pstep(Pseq([
				0,1,1,-2,
			],inf),1),
			\isRest, Pseq([
				1,0.5,0.5,0.5, 0.5,0.5,0.5,0.5,
			],inf).coin.not,
			\dur, 1/4,
			\octave,3,
			\out, BusDef(\sendbus1, \audio),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \organ_tonewheel1,
			\note, Pstep(Pseq([
				0,1,1,-2,
			],inf),1),
			\dur, 1/8,
			\isRest, Pseq([
				1,0.5,0.5,0.5, 0.5,0.5,0.5,0.5,
			],inf).coin.not,
			\octave, [4,5],
			\sus, Pexprand(0.01,0.3,inf),
			\atk, Pexprand(0.01,0.5,inf),
			\out, BusDef(\fx1, \audio),
			\tierce, Pwhite(0,3.0,inf),
			\larigot, Pwhite(0,3.0,inf),
			\fundamental, Pwhite(0,1.0,inf),

			\amp, 0.1/4,
		),
		
	])
)).play;
);
