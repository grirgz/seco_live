
PatKitDef(\hh1).edit
PatKitDef(\hhloop1).edit
ProtoDef(\recorder).edit
BufDef(\tmp8, s.sampleRate * 8)

(
KitTimeline(\hh1, PatKitDef(\hh1));
KitTimeline(\hh2, PatKitDef(\hh1));
KitTimeline(\hhloop1, PatKitDef(\hhloop1));
KitTimeline(\hhloop2, PatKitDef(\hhloop2));
ProtoDef(\rdn2, ProtoDef(\rdn));
)


(
TrackDef(\grid2, TrackDef(\playergrid));
TrackDef(\grid2).source = [
	[
		KitTimeline(\hh1),
		KitTimeline(\hhloop1),
		KitTimeline(\hh1_p2),
		KitTimeline(\hh2),
		nil,
	],
	[
		KitTimeline(\hhloop2),
		nil,
		nil,
		nil,
	],
	[
		Ndef(\bass),
		Ndef(\gran),
		nil,
		nil,
		nil,
	],
	[
		Ndef(\hi),
		Ndef(\hi2),
		Ndef(\himan),
		Ndef(\cri),
		nil,
		nil,
	],
	[
		Ndef(\mid1),
		Ndef(\splash),
		nil,
		nil,
	],
	[
		ProtoDef(\rdn)
	],
	[
		ProtoDef(\rdn2)
	],
	[
		ProtoDef(\basicrecorder)
	],
];
)
TrackDef(\grid2).edit

(
PatKitDef(\hhloop1).source = 8.collect({ arg idx;
	var pos = idx/2/~t + 0.04;
	StepEvent.newFrom((
		//adsr: Env([ 0, 1, 1, 0 ], [ 0.001, 0, 0.01 ], [ -4, -4, -4 ], 2),
		instrument: 'playersec', bufnum: BufDef('/home/ggz/Musique/sc/reckit/fix3/loop1.flac'), pos:pos)) 
});
)


(
Ndef(\hi, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var env;
	var gate = TDuty.kr(4/~t, 0, Dseq([
		1,
	],inf));
	env = EnvGen.kr(\env.kr(Env([0,0,1,1.1,0],[0,0.01,0.4,0.2].normalizeSum)), gate, timeScale:3.8);
	sig = SinOsc.ar(freq * ( 1 + ( SinOsc.ar(83 * [1,2,3] * env) * 2 * env )));
	sig = CuspN.ar(700 * env) + sig;
	sig = FreqShift.ar(sig, [0,1,2,3]);
	sig = sig * Duty.kr(1/~t, 0, Dseq([
		1,0,1,0,
		1,1,1,0,
	],inf));
	sig = sig * 44;
	sig = sig.tanh/2;
	sig = sig * env;
	sig = HPF.ar(sig, 700);
	sig = Pan2.ar(sig, pan, amp).flop;
}).play;
);

Ndef(\hi).stop

(
Ndef(\hi2, { arg freq=200, pan=0, amp=0.1;
	var sig;
	freq = Duty.kr(1/~t, 0, Dseq([
		0,0,2,1,
	],inf)).midiratio * 200;
	sig = SinOsc.ar(freq * [1,1/2,1.01]);
	sig = Pan2.ar(sig, pan, amp).flop;
}).play;
);

(
Ndef(\hi2, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var lfof;
	freq = Duty.kr(1/~t, 0, Dseq([
		0,0,2,1,
	],inf)).midiratio * 200;

	lfof = Duty.kr(4/~t, 0, Dseq([
		0,1.3,4,16,
		32,freq,freq*2,freq*3,
	],inf));
	sig = LFSaw.ar(freq * [1,1/2,1.01]);
	sig = RLPF.ar(sig, freq * 9.3 * SinOsc.ar(lfof*~t).range(0,1));
	sig = Pan2.ar(sig, pan, amp).flop;
}).play;
);

(
Ndef(\hi2, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var lfof;
	freq = Duty.kr(1/~t, 0, Dseq([
		0,0,2,1,
	],inf)).midiratio * 200;

	sig = LFSaw.ar(freq * [1,1/2,1.01]);
	sig = sig * Duty.kr(1/16/~t, 0, Dseq([
		Dser([
			1,1,0,0,
			1,1,0,0,
			1,0,0,0,
			1,1,1,0,
		],16),
		Dseq([
			1,0,1,0,
			1,0,0,0,
			1,1,0,0,
			1,1,0,0,
		],16),
		Dseq([
			1,1,0,0,
			1,1,0,0,
			1,0,0,0,
			1,0,1,1,
		],16),
	],inf));
	sig = RLPF.ar(sig, freq * 2.3);
	sig = Pan2.ar(sig, pan, amp).flop;
}).play;
);

(
Ndef(\hi2, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var lfof;
	freq = Duty.kr(1/~t, 0, Dseq([
		0,0,2,1,
	],inf)).midiratio * 100 * 1;

	sig = SinOsc.ar(freq/1) ;
	sig = sig + SinOsc.ar(freq * ( 1 + ( SinOsc.kr(sig * 233 + 12) * 1 ))) ;
	sig = sig * Duty.kr(1/16/~t, 0, Dseq([
		Dser([
			1,1,0,0,
			1,1,0,0,
			1,0,0,0,
			1,1,1,0,
		],16),
		Dseq([
			1,0,1,0,
			1,0,0,0,
			1,1,0,0,
			1,1,0,0,
		],16),
		Dseq([
			1,1,0,0,
			1,1,0,0,
			1,0,0,0,
			1,0,1,1,
		],16),
	],inf));
	sig = RLPF.ar(sig, freq * 2.3);
	sig = Pan2.ar(sig, pan, amp).flop;
}).play;
);

(
Ndef(\hi2, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var lfof;
	freq = Duty.kr(1/~t, 0, Dseq([
		0,0,2,1,
	],inf)).midiratio * 100 * 1;

	sig = SinOsc.ar(freq/1) ;
	sig = FreqShift.ar(sig, LFPulse.kr([1,2,4]/4).range(0,441));
	sig = RLPF.ar(sig, freq * 2.3);
	sig = sig * Duty.kr(4/~t, 0, Dseq([
		1,1,1,0,
	],inf));
	sig = Pan2.ar(sig, pan, amp).flop;
}).play;
);

(
Ndef(\hi2, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var lfof;
	freq = Duty.kr(1/~t, 0, Dseq([
		0,0,2,1,
	],inf)).midiratio * 100 * 1;

	sig = LFSaw.ar(freq/1) ;
	sig = FreqShift.ar(sig, LFPulse.kr([1,2,4]/4).range(0,441));
	sig = RLPF.ar(sig, freq * 2.3);
	sig = sig * Duty.kr(2/~t, 0, Dseq([
		1,1,1,1,
		1,1,1,0,
	],inf));
	sig = Pan2.ar(sig, pan, amp).flop;
}).play;
);

(
Ndef(\mid1, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var lfof;
	freq = Duty.kr(1/~t, 0, Dseq([
		0,0,2,1,
	],inf)).midiratio * 400 * 1;

	sig = SinOsc.ar(freq/1) ;
	sig = FreqShift.ar(sig, LFPulse.kr([1,2,4]/4).range(0,441));
	sig = sig * Duty.kr(1/16/~t, 0, Dseq([
		1,0,1,0,
	],inf));
	sig = sig * Duty.kr(2/~t, 0, Dseq([
		1,1,1,1,
		1,1,1,0,

	],inf));
	sig = RLPF.ar(sig, freq * 2.3);
	sig = Pan2.ar(sig, pan, amp).flop;
}).play;
);

(
Ndef(\mid1, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var lfof;
	freq = Duty.kr(1/~t, 0, Dseq([
		0,0,2,1,
	],inf)).midiratio * 400 * 1;

	sig = LFSaw.ar(freq * [1,1/2] * ( 1 + SinOsc.ar([1/6,1/9,1/13]).range(0,0.1) ) ) ;
	sig = sig.collect({ arg isig, idx;
		sig.fold( SinOsc.ar(idx)  );
	
	}) + sig;
	//sig = FreqShift.ar(sig, LFPulse.kr([1,2,4]/4).range(0,441));
	sig = sig * Duty.kr(
		Dseq([
			Dseq([
				1/10/~t,
			],16),
			Dseq([
				1/16/~t,
			],16),
		],inf), 0, Dseq([
		1,1,0,0,
	],inf));
	sig = sig * Duty.kr(2/~t, 0, Dseq([
		1,1,1,1,
		1,1,1,0,
	],inf));
	sig = sig /2;
	sig = RLPF.ar(sig, freq * 2.3);
	sig = Pan2.ar(sig, pan, amp).flop;
}).play;
);


ClipTimeline(\part1).edit
TrackTimline(\part1).edit
~trackTimeline.new(\part2, TrackDef(\grid2)).edit
Ndef.defaultQuant = 0
Pdef.defaultQuant = 0
TrackDef(\grid2).edit
KitTimeline(\hh1).presetCompileString.editorInsert
(
KitTimeline('hh1_p2', PatKitDef(\hh1)).eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	(\absTime: 0.0, \dur: 1.0, \kitIndex: 0.0, \midinote: 0, \playDur: 1.0, \relDur: 1.0, \sustain: 0.5, ),
	(\absTime: 1.0, \dur: 1.0, \kitIndex: 0.0, \midinote: 0, \playDur: 1.0, \relDur: 1.0, \sustain: 0.5, ),
	(\absTime: 2.0, \dur: 0.375, \kitIndex: 3.0, \midinote: 0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.125, ),
	(\absTime: 2.375, \dur: 0.375, \kitIndex: 3.0, \midinote: 0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.125, ),
	(\absTime: 2.75, \dur: 0.25, \kitIndex: 4.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 3.0, \dur: 1.0, \kitIndex: 2.0, \midinote: 0, \playDur: 1.0, \relDur: 1.0, \sustain: 1.0, ),
	(\absTime: 4.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);



(
Ndef(\bass, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var metro = Impulse.kr(1*~t);
	freq = Duty.kr(1/~t, 0, Dseq([
		0,0,2,1,
	],inf)).midiratio * freq;

	env1 = EnvGen.kr(Env([2.5,2.5,2,1]/1.5,[0,0.2,0.8]), metro);
	sig = LFSaw.ar(freq * [1,1.01,1/2]);
	sig = sig + SinOsc.ar(freq).fold(0.82);
	sig = sig * LagUD.kr(Duty.kr(1/4/~t, 0, Dseq([
		1,1,1,1, 1,1,1,1,
		1,1,1,1, 1,1,1,1,
		1,1,1,1, 1,1,1,1,
		1,1,1,1, 1,1,1,1,

		1,1,1,1, 1,1,1,1,
		1,1,1,1, 1,1,1,1,
		1,1,1,1, 1,1,1,1,
		1,1,1,1, 0,0,0,0,
	],inf)), 0,1);
	sig = RLPF.ar(sig, freq * env1, \rq.kr(0.5));
	sig = Pan2.ar(sig, pan, amp).mean;
	sig = sig * 2;
	sig.debug("sig");
}).play;
);


(
Ndef(\himan, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = LFSaw.ar(freq * LFPulse.kr([1,2,1/2,1/23]).range(0,[1,2,3,4]));
	sig = Pan2.ar(sig, pan, amp).mean;
}).play;
);

(
Ndef(\himan, { arg freq=400, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	sig = SinOsc.ar(freq * LFPulse.kr([1,2,1/2,1/23]*~t*2).range(0,[1,2,3,4]));

	sig1 = LFSaw.ar(freq * LFPulse.kr([1,2,1/2,1/23]*~t*2).range(0,[1,2,3,4]));
	lfo1 = SinOsc.kr(1/2 * [1,2,3,0.23]).range(0,1);
	sig = SelectX.ar( lfo1, [sig, sig1]);


	lfo3 = Duty.kr(1/4/~t, 0, Dseq([
		1,1,1,1,
		1,1,1,1,
		1,0,1,0,
		1,1,1,0,
		1,1,0,0,
		1,1,1,1,
	],inf)).lag(0.1);
	sig1 = FreqShift.ar(sig, 410.1);
	sig1 = BRF.ar(sig1, 1200);
	sig1 = BRF.ar(sig1, 4200);
	sig1 = HPF.ar(sig1, 2000);
	sig1 = sig1 * 3;
	sig = SelectX.ar( lfo3, [sig, sig1]);

	lfo2 = SinOsc.ar(1/2*~t * [1,2,1/3,1/4]).range(1,2) * freq; 
	sig = RLPF.ar(sig, lfo2, \rq.kr(0.5));
	sig = sig *8;
	sig = Pan2.ar(sig, pan, amp).mean;
});
);


(
Ndef(\cri, { arg freq=400, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	sig = LFSaw.ar(freq * [1,1.1]); 
	sig = sig * Duty.kr(1/2/~t, 0, Dseq([
		1,1,1,0,
	],inf));
	sig = Pan2.ar(sig, pan, amp).mean;
});
);

(
Ndef(\cri, { arg freq=400, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	sig = LFSaw.ar(freq * [1,1.1] * [0,-3].midiratio); 
	sig = sig * Duty.kr(1/2/~t, 0, Dseq([
		1,1,1,0,
	],inf));
	sig = Pan2.ar(sig, pan, amp).mean;
});
);

(
Ndef(\cri, { arg freq=400, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = Duty.kr(1/~t, 0, Dseq([
		4,4,3,2,
	],inf));
	sig = LFSaw.ar(freq * [1,1.1] * [0,-3, lfo1].midiratio); 
	sig = sig * Duty.kr(1/2/~t, 0, Dseq([
		1,1,1,0,
	],inf));
	sig = Pan2.ar(sig, pan, amp).mean;
});
);

Ndef.defaultQuant


(
Ndef(\splash, { arg freq=400, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var fbnode;
	var fbsig;
	fbnode = FbNode(2);
	sig = LFSaw.ar(freq * [1,1.1] * LFSaw.kr(1/16*~t, 3*pi/2).range(0.1,1)); 
	sig = sig + ( fbnode * \fb.kr(0.8) );
	sig = sig * Duty.kr(1/4/~t, 0, Dseq([
		1,0,1,0,
	],inf));
	fbsig = sig;
	fbsig = DelayL.ar(fbsig, 0.1,0.1) + fbsig;
	fbsig = DelayL.ar(fbsig, 0.1,0.01) + fbsig;
	fbsig = fbsig.tanh;
	fbnode.write(fbsig);
	sig = Pan2.ar(sig, pan, amp).mean;
});
);


grainfm	
BufDef.mono(\moeten).play
BufDef.mono(\moeten, "voices/02_moeten.flac")

(
Ndef(\gran, { arg freq=200, pan=0, amp=0.1, pitch_stretch=1, pos=0.2, dur=0.1;
	var sig;
	var clk = Impulse.ar(\clk.kr(70));
	var bufnum = \bufnum.kr(BufDef.mono(\moeten));
	pos = pos + ( LFNoise1.kr(4) * \posrange.kr(0.1) );
	//pitch_stretch = SinOsc.kr(2).range(0.3,1) * pitch_stretch;
	pitch_stretch = pitch_stretch * EnvGen.kr(Env([2,1.5,1,0.7,0.5],[0.31,0.18,0.2,0.4]), Impulse.kr(1/2*~t));
	pitch_stretch = LFTri.kr(1/8*~t).range(1/2,1).lag(0.1);
	pitch_stretch = Duty.kr(4/~t, 0, Dseq([
		1,1,0.8,0.8,
		1,1,0.4,0.8,
		1,1,0.8,0.8,
		1,0.4,1.4,1.60,
		1,1,0.8,0.8,
		1,1,0.4,0.8,
		1,1,0.8,0.8,
		1,0.4,0,0,
	],inf));
	sig = TGrains.ar(2, clk, bufnum, pitch_stretch, pos % BufDur.kr(bufnum), dur, pan, 1);
	//sig = Pan2.ar(sig, pan, amp);
}).play;
);
Ndef(\gran).edit


BufDef.abspath_to_relpath("fix3/kick1.flac")
BufDef.abspath_to_relpath(BufDef.relpath_to_abspath("fix3/kick1.flac"))
"kjkj".beginsWith("kjk")
~rel = "fix3/kick1";
(
BufDef.paths.do { arg folder;
		( "kk"++(folder +/+ ~rel) ).postln;
	if(PathName(folder +/+ ~rel).isFile) {
		(folder +/+ ~rel).postln;
	}
}
)
