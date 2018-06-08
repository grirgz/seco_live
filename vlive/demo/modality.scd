MKtl.find;
MKtl.find(\midi)

//=== refresh cache when adding desc to directory
MKtlDesc.loadDescs; 

//=== reload modified desc file
MKtlDesc.loadDescs; // no this only do when something is not init yet
k = MKtl(\apc, "akai-apc40mkii"); // no this only do when something is not init yet
k = MKtl(\apc, "akai-apc40mkii", true); // no this only do when something is not init yet

//=== set button color
k.elAt(\bt, \clip, 0,0, \on).value = 123/127 // works!

//////////////////////
/////// BUGS

// execively long or inf loop when the first line run after starting SC
k = MKtl(\apc, "akai-apc40mkii", true); // it's the true which does that


///////////

MKtl('midi_2_launch', 'midi_2_launchpad_s');
MKtl('icon', "icon-icontrols");
MIDIClient.disposeClient
MIDIdef.cc(\bla, {}).learn
k = MKtl('icon')
k.gui;
k[\sl][0].action { arg kn; ~param.normSet(kn.value) } // map first slider to a param

k.elementGroup;
k.postElements;
k[\kn].do { arg k; k.postln }
k[\knobs]
k[\kn].collect({ arg k; k })
k[\kn][0]

k.elAt(\bt, \clip, 0,0)
k.elAt(\bt)
k.elAt(*\bt)

k = MKtl(\lp, "novation-launchpad-s");
k.elAt(\bt).action = { "blalla".postln }
k.elAt(\pad).elAt(0).elAt(0).action = { "0 on pushed".postln; }
k.elAt(\pad).elAt(0).elAt(0).value = 0xd4.linlin(0,127,0,1)
k.elAt(\pad).elAt(2).elAt(0).value = 0x1b/127
k.elAt(\pad).elAt(2).elAt(0).value = 0xb0.linlin(0,127,0,1)
k.elAt(\pad).value = 0x0b.linlin(0,127,0,1)
k.elAt(\bt).flat.do({ arg x; x.value = 0x00.linlin(0,127,0,1)})
k.elAt(\arr).flat.do({ arg x; x.value = 0x00.linlin(0,127,0,1)})
k.elAt(\pad).elAt(0).elAt(0).value = 0.05
k.elAt(\pad).elAt(0).elAt(0).value 
k.postElements
0x3c

m= MIDIOut(0)
m.sysex(Int8Array[ 0xb0,0,0 ]); // clear grid
m.sysex(Int8Array[ 0xb0,0,0x7f ]); // full test
m.sysex(Int8Array[ 0xb0,0,0x28 ]); // turn on flashing mode
m.sysex(Int8Array[ 0xb0,0,0x20 ]); // manual flash on
m.sysex(Int8Array[ 0xb0,0,0x21 ]); // manual flash off
MKtl(\lp).desc.rebuild
MKtl(\lp).sendSpecialMessage(\enableFlashMode)
MKtl(\lp).sendSpecialMessage(\clearAll)
MKtl(\lp).specialMessages


MKtl(\lp).sendSpecialMessage(\enableFlashModex)
MKtl(\lp).sendSpecialMessage(\existnot)

//=== refresh description file:
MKtlDesc.loadDescs; // first do this!
MKtl(\lp).rebuild("novation-launchpad-s"); 
MKtl(\apc).rebuild("akai-apc40mkii");  // error
MKtl(\apc).rebuild;  // error
MKtl(\apc).free;  // error
MKtl(\apc).reload // error Primitive '_DisconnectMIDIOut' failed.
//MKtl(\lp).rebuild;  // doesnt work
MKtl.find

k.elAt(\pad).elAt(2).elAt(0).value = 0x0f/127 - 0x0c // substract 0x0c to make it flash

/////////////////////
// problem: created MKtl icon before connecting it by usb, how to fix it without restarting SC ?
// even if MIDIdef receive messages, MKtl no

MKtl('icon', "icon-icontrols");
MKtl('icon').free; // can't recreate after free: Meta_MKtlDevice:open: can not open - no device candidates found.
MKtl('icon').rebuild // ERROR: Message 'not' not understood.
MKtl('icon').closeDevice // do nothing because device is virtual
MKtl('icon').hasDevice // false
MKtl('icon').reset // reset only actions
MKtl('icon').reload // 
MKtl('icon').trace // 

MKtl.find // works!!!!!!!


////////////////////////::


// pas encore reussi a le faire marcher, utiliser MIDIdef a la place (voir ci dessous)
k = MKtl('midi_10_a_pro', 'midi_10_a_pro_port_1');
k.explore
MKtl('midi_10_a_pro').explore(false); // stop
MKtl('midi_10_a_pro').createDescriptionFile; // must be done in IDE

//////
(
SynthDef(\plop, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	freq = freq  * ( 1 + ( SinOsc.ar(\fmfreq.kr(8)) * \fmamt.kr(1) ));
	sig = SinOsc.ar(freq * [1,1.01,1.001] );
	sig = sig + LFSaw.ar(freq *  [1,1.0001], mul:1/2 * \sawmul.kr(1));
	sig = RLPF.ar(sig, \ffreq.kr(2000), \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.01,0.8,\release.kr(0.01)),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).flop;
	Out.ar(out, sig);
}).add;
Pdef(\plop, Pbind(
	\instrument, \plop,
	\degree, Pseq([0],inf),
	\dur, 1,
));
~str = Pdef(\plop).asStream;
~notes = Array.newClear(128);
~apro_device_id.postln;
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


}, srcID:~apro_device_id);
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
	
}, srcID:~apro_device_id);

FileSystemProject.load("lib/piano.scd");
MIDIdef(\piano).permanent = true;
MIDIdef(\piano_off).permanent = true;
MIDIMap(\apk1,Param(Pdef(\plop), \fmamt, ControlSpec(0,4,\lin)) );
MIDIMap(\apk2,Param(Pdef(\plop), \fmfreq, ControlSpec(0.01,664,\exp)) );
MIDIMap(\apk8,Param(Pdef(\plop), \release, ControlSpec(0.01,4,\exp)) );
[\fmant, \fmfreq, \sawmul, \ffreq, \rq].do { arg key;
	Pdef(\plop).setBusMode(key);
	Param(Pdef(\plop), key).set(Param(Pdef(\plop), key).default); // bus was not initialized
}
)

WindowDef(\PdefEditor).front(Pdef(\plop))
Pdef(\plop).getVal(\fmfreq)
Param(Pdef(\plop), \fmant).set(Param(Pdef(\plop), \fmant).default)


///////////////////// aproche plus Param

(
SynthDef(\plop, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	freq = freq  * ( 1 + ( SinOsc.ar(\fmfreq.kr(8)) * \fmamt.kr(1) ));
	sig = SinOsc.ar(freq * [1,1.01,1.001] );
	sig = sig + LFSaw.ar(freq *  [1,1.0001], mul:1/2 * \sawmul.kr(1));
	sig = RLPF.ar(sig, \ffreq.kr(2000), \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.01,0.8,\release.kr(0.01)),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).flop;
	Out.ar(out, sig);
}).add;
Pdef(\plop, Pbind(
	\instrument, \plop,
	\degree, Pseq([0],inf),
));
~apro_device_id.postln;
~playergroup = ~seqPlayerGroup.new(Pdef(\plop));
MIDIdef.noteOn(\piano, { arg ... args;
	var midinote = args[1];
	"on".debug(args);
	~playergroup.elAt(midinote).play;
}, srcID:~apro_device_id);
MIDIdef.noteOff(\piano_off, { arg ... args;
	var midinote = args[1];
	"off".debug(args);
	~playergroup.elAt(midinote).stop;
}, srcID:~apro_device_id);

MIDIdef(\piano).permanent = true;
MIDIdef(\piano_off).permanent = true;
)

// defined in libdef/piano.scd
ProtoDef(\piano).startControl(Pdef(\melo))
