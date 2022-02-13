(

m = SimpleMIDIFile.read( "~/Téléchargements/Super Mario 64 - Medley.mid" );
//[ trackNumber, absTime, type, channel, val1, val2  ]
m.midiEvents.select({ arg x; [\program, \cc].includes(x[3]).not }).collect({ arg event;



})
)

m = SimpleMIDIFile.read( "~/Téléchargements/Super Mario 64 - Medley.mid" ); 


~t = 1; TempoClock.default.tempo = ~t;
m = SimpleMIDIFile.read( "~/Téléchargements/Super Mario Bros 2 - Mario Dreams.mid" ); 

m = SimpleMIDIFile.read( "~/Téléchargements/mikagrace_kelly.mid" ); 


m.tempo
(
	TempoClock.default.tempo = m.tempo/60;
	Pdef(\bla, 
		Pbind(
			\instrument, \default,
			[\midinote, \dur, \sustain, \amp], Prout({ arg ev;
				var timescale = 1/16/60;
				var prevev;
				timescale.debug("timescale");
				m.noteSustainEvents.collect({ arg item, idx;
					// [track, absTime, \noteOn, channel, note, velo, dur, upVelo]
					item.debug("item");
					if(idx == 0) {
						prevev = [item[4], item[1], item[6] * timescale, item[5]/127]
					} {
						prevev[1] = item[1] - prevev[1] * timescale;
						ev = prevev.yield;
						prevev = [item[4], item[1], item[6] * timescale, item[5]/127];
					};
				});
				prevev[1] = prevev[2];
				ev = prevev.yield;
			}).trace,
			\midinote, Pkey(\midinote) + 12, // one octave lower
			\amp, 0.1,
		)
	).play
)

480/60/16
8*60
m.p.play
Pdef(\bla).clear;

	TempoClock.default.tempo = 2.8

~seqs = m.generatePatternSeqs
~seqs.size
Pbind( [\midinote, \dur], Pseq(~seqs[0], 1) ).play;

m.noteSustainEvents.last

m.noteSustainEvents.keep(10)

NoteTimeline(\bla).eventList = TimelineEventList.newFrom( Pdef(\bla),4000 )
NoteTimeline(\bla).edit
NoteTimeline(\bla).presetCompileString.editorInsert
(
NoteTimeline('bla').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	(\absTime: 0.0, \amp: 0.1, \dur: 0.5, \instrument: 'default', \midinote: 60.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.5, ),
	(\absTime: 0.5, \amp: 0.1, \dur: 0.5, \instrument: 'default', \midinote: 67.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.5, ),
	(\absTime: 1.0, \amp: 0.1, \dur: 0.5, \instrument: 'default', \midinote: 64.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.5, ),
	(\absTime: 1.5, \amp: 0.1, \dur: 0.5, \instrument: 'default', \midinote: 67.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.5, ),
	(\absTime: 2.0, \amp: 0.1, \dur: 0.5, \instrument: 'default', \midinote: 59.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.5, ),
	(\absTime: 2.5, \amp: 0.1, \dur: 0.5, \instrument: 'default', \midinote: 67.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.5, ),
	(\absTime: 3.0, \amp: 0.1, \dur: 0.5, \instrument: 'default', \midinote: 62.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.5, ),
	(\absTime: 3.5, \amp: 0.1, \dur: 0.5, \instrument: 'default', \midinote: 67.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.5, ),
	(\absTime: 4.0, \amp: 0.1, \dur: 0.0, \instrument: 'default', \midinote: 57.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.5, ),
	(\absTime: 4.0, \dur: 0.5, \midinote: 71.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.5, ),
	(\absTime: 4.5, \amp: 0.1, \dur: 0.5, \instrument: 'default', \midinote: 67.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.5, ),
	(\absTime: 5.0, \amp: 0.1, \dur: 0.5, \instrument: 'default', \midinote: 64.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.5, ),
	(\absTime: 5.5, \amp: 0.1, \dur: 0.5, \instrument: 'default', \midinote: 67.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.5, ),
	(\absTime: 6.0, \amp: 0.1, \dur: 0.5, \instrument: 'default', \midinote: 59.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.5, ),
	(\absTime: 6.5, \amp: 0.1, \dur: 0.5, \instrument: 'default', \midinote: 67.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.5, ),
	(\absTime: 7.0, \amp: 0.1, \dur: 0.5, \instrument: 'default', \midinote: 62.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.5, ),
	(\absTime: 7.5, \amp: 0.1, \dur: 0.5, \instrument: 'default', \midinote: 67.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.5, ),
	(\absTime: 8, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);


(
SynthDef(\mulo, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var in;
	env1 = EnvGen.kr(Env([0.1,0.2,1],[0.1,0.8]), 1);
	in = LocalIn.ar(2);
	sig = SinOsc.ar(freq * ( SinOsc.ar(2*1*1 * in.reverse) * env1 + 1 ));
	sig = sig * LFSaw.ar(freq);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	LocalOut.ar(sig);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
);
(
	ProtoDef(\simpleMixer).play;
	TempoClock.default.tempo = m.tempo/60;
	Pdef(\bla, 
		Pbind(
			\instrument, \mulo,
			\out, BusDef(\mixer0, \audio),
			[\midinote, \dur, \sustain, \amp], Prout({ arg ev;
				var timescale = 1/16/60;
				var prevev;
				timescale.debug("timescale");
				m.noteSustainEvents.collect({ arg item, idx;
					// [track, absTime, \noteOn, channel, note, velo, dur, upVelo]
					item.debug("item");
					if(idx == 0) {
						prevev = [item[4], item[1], item[6] * timescale, item[5]/127]
					} {
						prevev[1] = item[1] - prevev[1] * timescale;
						ev = prevev.yield;
						prevev = [item[4], item[1], item[6] * timescale, item[5]/127];
					};
				});
				prevev[1] = prevev[2];
				ev = prevev.yield;
			}).loop.trace,
			\midinote, Pkey(\midinote) + Prand([-1,0,1,2,-2]*12,inf), // one octave lower
			\amp, 0.1,
		)
	).play;
	Pdef(\bla2, 
		Pbind(
			\instrument, \default,
			\out, BusDef(\mixer1, \audio),
			[\midinote, \dur, \sustain, \amp], Prout({ arg ev;
				var timescale = 1/16/60;
				var prevev;
				timescale.debug("timescale");
				m.noteSustainEvents.collect({ arg item, idx;
					// [track, absTime, \noteOn, channel, note, velo, dur, upVelo]
					item.debug("item");
					if(idx == 0) {
						prevev = [item[4], item[1], item[6] * timescale, item[5]/127]
					} {
						prevev[1] = item[1] - prevev[1] * timescale;
						ev = prevev.yield;
						prevev = [item[4], item[1], item[6] * timescale, item[5]/127];
					};
				});
				prevev[1] = prevev[2];
				ev = prevev.yield;
			}).loop.trace,
			//\midinote, Pkey(\midinote) + Prand([-1,0,1,2,-2]*12,inf), // one octave lower
			\amp, 0.1,
		)
	).play
)
