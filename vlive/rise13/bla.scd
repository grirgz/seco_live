(
~molecular_box = { arg lenpat, quant=16, keep=3, pattern;

	Prout({ arg ev;
	
		var lenstr = lenpat.asStream;
		var patstr;
		var buf = Array.fill(quant,{List.new});
		var pat, len;
		var i;
		var basepat;

		patstr = pattern.asStream;

		len = lenstr.next;
                if(len.isNil) {
                    nil.yield;
                };

		i = 0;
		inf.do {
			var n;
			buf[i] = buf[i].keep(0-keep);
			n = buf[i];

			if(n.size != 0) {
				// previous note found, change note length
				len = lenstr.next;
                                if(len.isNil) {
                                   nil.yield;
                                };
			};

			basepat = ev;
			basepat[\legato] = len;
			pat = patstr.next(basepat);
                        if(pat.isNil) {
                           nil.yield;
                        };

			n.add(Pn(pat,1));

			len.do {
				var n = buf[i];

				if(n.size != 0) {
					ev = Ppar(n).embedInStream;
				} {
					var myev;
					myev = ev.deepCopy;
					myev[\isRest] = true;
					ev = Pn(myev,1).embedInStream;
				};
				i = (i+1) % quant;
			};
		}
	})
};
);




(
SynthDef(\simple, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = SinOsc.ar(freq * [1,1.01,2.01,1.02,1/2] * (SinOsc.kr(3)*0.01+1));
	sig = sig + LFTri.ar(freq * [1,1/2,1.01]);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
SynthDef(\saw, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	var env;
	sig = LFSaw.ar(freq * [1,1.01,2.01,1.02]);
	sig = Pulse.ar(freq * [1,1.01,2,2.01,1.002]) + sig;
	env = EnvGen.ar(Env.adsr(0.4,0.3,0.31,0.1),gate,doneAction:0);
	sig = RLPF.ar(sig, \ffreq.kr(1000) * (env+0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
SynthDef(\reverb, {arg out = 0, in=0;
    var sig = In.ar(in, 2);
    sig = FreeVerb.ar(sig,0.5,0.7);
    ReplaceOut.ar(out, sig);
}).add;
);



Synth.tail(1,\reverb); // if you want

TempoClock.default.tempo = 1


(

Pdef(\mol, 

	~molecular_box.(Pseq([4.5,8],inf), 16, 3,
		Pseq([
			Pbind(
				\instrument, Pn(\simple,4),
				\adsr, Pseq([
					[ Env.adsr(0.1,0.1,0.8,0.4) ],
					[ Env.adsr(0.4,0.4,0.6,0.2) ],
				],inf),
				\legato, Pkey(\legato) / 2,
			),
			Pbind(
				\instrument, Pn(\saw,4),
				\ffreq, Pseq([5000,1000,200,2000],inf),
				\adsr, Pseq([
					[ Env.adsr(0.1,0.4,0.4,0.3) ],
				],inf),
				\legato, Pkey(\legato) / 2,
			),
		],inf) 
		<>
		Pbind(
			\degree, Pseq([
				Pseq((0..13)),
				Pseq((0..10)-4),
				Pseq((5..1)),
				Pseq((0..5)*2),
				Pseq((20..10)),
				Pseq((0..10)-10),
			],inf),
		);

	)
	<>
	Pbind(
		\dur, 1/4,
		\scale, Scale.minor,
	)

).play;

)




(

Pdef(\mol, 

	~molecular_box.(Pseq([4.5,2,5,1],inf), 16, 3,
		Pbind(
			\legato, Pseq([
				Pfuncn({ arg ev; ev[\legato] },16),
				Pser([0.5],16)
			],inf)
		)
		<>
		Pseq([
			Pbind(
				\instrument, Pn(\simple,4),
				\adsr, Pseq([
					[ Env.adsr(0.1,0.1,0.8,0.4) ],
					[ Env.adsr(0.4,0.4,0.6,0.2) ],
				],inf),
				\legato, Pkey(\legato) * Pseq([0.2,0.8,1.2],inf).stutter(3),
			),
			Pbind(
				\instrument, Pn(\saw,2),
				\ffreq, Pseq([5000,1000,700],inf),
				\adsr, Pseq([
					[ Env.adsr(0.1,0.4,0.4,0.3) ],
				],inf),
			),
			Pbind(
				\instrument, Pn(\saw,2),
				\ffreq, Pkey(\freq) * 4,
				\adsr, Pseq([
					[ Env.adsr(0.1,0.4,0.4,0.3) ],
				],inf),
			),
		],inf) 
		<>
		Pbind(
			\degree, Pseq([
				Pseq((5..1)),
				Pseq((0..3)),
				Pseq((0..10)-4),
				Pseq((0..5)*3),
				Pseq((2..10)),
				Pseq((0..10)-10),
			],inf),
		);

	)
	<>
	Pbind(
		\dur, 1/4,
		\mtranspose, 2,
		\root, 4,
		\scale, Scale.aeolian,
	)

).play;
)

(

Pdef(\mol, 

	~molecular_box.(Pseq([7,3,4],inf), 16, 3,
		Pbind(
			\legato, Pkey(\legato)/2,
			\instrument, \default,
			\degree, Pseq((0..64),inf),
		);
	)
	<>
	Pbind(
		\dur, 1/8,
		//\mtranspose, 2,
		\octave, 3,
		//\root, 4,
		//\scale, Scale.aeolian,
	)

).play;
)




//PLACE MOUSE CURSOR ON EACH OF THE NUMBERS IN ORDER AND HIT CMD-RETURN

(
// 1):
// Initialize
var currMidiNum, noteNames, octaves, screenRes, yres;
~pitchLo = \a0;
~pitchHi = \c8;

//MIDI NOTE DICTIONARY
////Allows you to input a symbol and get out the midi note number
////Use only these symbols:
//// \c, \cs, \d, \eb, \e, \f, \fs, \g, \gs, \a, \bb, \b

~mnd = ();
currMidiNum = 0;
noteNames = [\c, \cs, \d, \eb, \e, \f, \fs, \g, \gs, \a, \bb, \b];
octaves = [-1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
octaves.do{ |it ix|
	noteNames.do{ |it2 ix2|
		~mnd.put((it2 ++ it).asSymbol, currMidiNum);
		currMidiNum = currMidiNum+1;
	}
};

//FUNCTION TO LOOK UP Y-LOCATION FOR A PITCH

~yres = 1000;

~midiToY = {
	arg midinote;
	~mnd[midinote].linlin(~mnd[~pitchLo].asFloat, ~mnd[~pitchHi].asFloat, ~yres, 0.0).round;
};

//SYNTHDEF
SynthDef(\mouseTheremin, {
	arg pitchLo = 30, pitchHi = 80, pitchres=1.0;
	var osc, freq, env, envgate, pitch, amp;
	amp = MouseX.kr(-40, 10).dbamp;
	pitch = MouseY.kr(minval:pitchHi, maxval:pitchLo, lag:0.0001).round(pitchres);
	envgate = MouseButton.kr(lag:0.0001);
	env = EnvGen.ar( envelope:Env.asr(releaseTime:0.05), gate:envgate );
	freq = pitch.midicps;
	osc = SinOsc.ar( freq );
	Out.ar(0, osc*env*amp);
}).add;

) ///////////////////////////////////////////////////////////

(
// 2):
// Boot Server
s.boot;
)

(
// 3):
// Start Synth
~mt = Synth(\mouseTheremin, [\pitchLo, ~mnd[~pitchLo], \pitchHi, ~mnd[~pitchHi]]);
)


// TO STOP SYNTH OR USE CMD-.
~mt.free;



//UTILITIES

//EXAMPLE OF MIDI NOTE TO Y COORDINATE TO LOOK UP VALUES FOR YOUR PROCESSING PATCH:
////Use only these symbols:
//// \c, \cs, \d, \eb, \e, \f, \fs, \g, \gs, \a, \bb, \b
~midiToY.value(\g5);
~midiToY.value(\fs4);
//Look @ Post Window


//USE THESE TO 'PLAY ALONG' AND THEN FIND MIDI PITCH
~mspoll = {MouseY.kr(~mnd[~pitchHi], ~mnd[~pitchLo]).round.poll}.play;
~mnd.findKeyForValue(66);


~mspoll.free;
