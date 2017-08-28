
MIDIMap.learn()
MIDIdef.cc(\testcc, { arg ... args; args.postln; })
MIDIMap([16],Param(Pdef(\plop), \sawmul, ControlSpec(1/4,4,\lin)) )
MIDIMap([17],Param(Pdef(\plop), \ffreq, \freq) );
MIDIMap([18],Param(Pdef(\plop), \rq, \rq) );
MIDIMap([19],Param(Pdef(\plop), \release) );
MIDIMap([20],Param(Pdef(\plop), \fmfreq, \widefreq) );
MIDIMap([21],Param(Pdef(\plop), \fmamt, ControlSpec(0,4,\lin)) );
\release.asSpec
Pdef(\plop).get(\sawmul)
Pdef(\plop).setBusMode(\sawmul)
Pdef(\plop).setBusMode(\ffreq)
Pdef(\plop).setBusMode(\rq)
Pdef(\plop).setBusMode(\fmamt)
Pdef(\plop).setBusMode(\fmfreq)
(
SynthDef(\plop, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	freq = freq  * ( 1 + ( SinOsc.ar(\fmfreq.kr(8)) * \fmamt.kr(1) ));
	sig = SinOsc.ar(freq * [1,1.01,1.001] );
	sig = sig + LFSaw.ar(freq *  [1,1.0001], mul:1/2 * \sawmul.kr(1));
	sig = RLPF.ar(sig, \ffreq.kr(2000), \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.01,0.8,\release.kr(0.01)),gate,doneAction:2);
	sig = sig * \gain.kr(1);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\plop, Pbind(
	\instrument, \plop,
	\degree, Pseq([0],inf),
	\dur, 1,
	\amp, 0.01
));
~str = Pdef(\plop).asStream;
~notes = Array.newClear(128);
MIDIdef.noteOn(\piano, { arg ... args;
	var midinote = args[1];
	var ev;
	args.debug("noteOn");
	ev = ~str.next(Event.default);
	//ev[\type] = \on;
	ev[\latency] = Ref(nil);
	ev[\midinote] = midinote;
	ev[\sustain] = 100;
	//ev[\hasGate] = false;
	if(~notes[midinote].notNil) {
		~notes[midinote][\id].do { arg id;
			s.sendMsg(*[15, id, \gate, 0.0]);
		};
		~notes[midinote] = nil;
	};
	~notes[midinote] = ev.play;


});
MIDIdef.noteOff(\piano_off, { arg ... args;
	var midinote = args[1];
	args.debug("noteoff");
	if(~notes[midinote].notNil) {
		~notes[midinote].debug("noteoff");
		//~notes[midinote].release(-1);
		//~syn = Synth.basicNew(\plop, s, ~notes[midinote][\id]);
		~notes[midinote][\id].do { arg id;
			s.sendMsg(*[15, id, \gate, 0.0]);
		};
		~notes[midinote] = nil;
	};
	
});

FileSystemProject.load("lib/piano.scd");
MIDIMap(\apk1,Param(Pdef(\plop), \fmamt, ControlSpec(0,4,\lin)) );
MIDIMap(\apk2,Param(Pdef(\plop), \fmfreq, \freq) );
MIDIMap(\apk3,Param(Pdef(\plop), \sawmul, ControlSpec(0.01,4,\exp)) );
MIDIMap(\apk4,Param(Pdef(\plop), \ffreq, \freq) );
MIDIMap(\apk5,Param(Pdef(\plop), \rq, \rq) );
MIDIMap(\apk8,Param(Pdef(\plop), \release, ControlSpec(0.01,4,\exp)) );
MIDIMap(\apk9,Param(Pdef(\plop), \gain, ControlSpec(0,4,\lin)) );
Pdef(\plop).setBusMode(\fmamt);
Pdef(\plop).setBusMode(\fmfreq);
Pdef(\plop).setBusMode(\sawmul);
Pdef(\plop).setBusMode(\ffreq);
Pdef(\plop).setBusMode(\rq);
)
WindowDef(\PdefEditor).front(Pdef(\plop))

~syn.free
Synth


(0..9).collect("0" ++ _) ++ (10..20)
_.asStringToBase(10,2)!99
(0..99).collect({arg x; x.asString.padLeft(2,"0")})
