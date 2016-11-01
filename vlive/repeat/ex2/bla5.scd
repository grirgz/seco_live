
SynthDesc(\playerbeat).asParamGroup(Pdef(\yap))[5].type
~recmodel.edit
~recmodel2 = ~recmodel.copy
~recmodel2.edit
DebugPbind
(
Ndef('fx2').put(110, \filter -> { arg in;
	in + ( HPF.ar(in, \xhpfreq.kr(2000))*\xhpamp.kr(4) );
});
)

(
~loadbufs.([\kick, \kick2, \kick3, \snare, \snare2, \snare3, \hat], "fix1");
~recmodel[\fxkey] = \fx2; ~recmodel[\fxdef] = \multifbdel;
~recmodel.recbus = BusDef(\fx2);
Ndef('fx2').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.071428571428571,
	'gain', 1,
	'fb', 0.00034014403432308,
	'delay', 0.0002006878167665,
	'delay2', 0.0002086064493472,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 1.6072103808883,
	'pitchlag', 0.125,
	'pitchmix', 0.12605042016807,
	'fb1', 0,
	'fb2', 0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'deltran1', 0.41848760755187,
	'deltran2', 0.49514382564655,
	'deltran3', 0.40464376119517,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.67226890756303,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 1,
	'indelay', 0,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));
BufDef(\kick, s.sampleRate * 4);
BufDef(\kick2, s.sampleRate * 4);
BufDef(\kick3, s.sampleRate * 4);
BufDef(\tmp4, s.sampleRate * 4);
BufDef(\snare, s.sampleRate * 4);
BufDef(\snare2, s.sampleRate * 4);
BufDef(\snare3, s.sampleRate * 4);
BufDef(\hat, s.sampleRate * 4);
BufDef(\tmp16, s.sampleRate * 16);
BufDef(\bass, s.sampleRate * 4);
BufDef(\melo, s.sampleRate * 4);
BufDef(\melo2, s.sampleRate * 4);

BufDef(\moeten, "voices/02_moeten.flac");
BufDef(\amen, "vipere/amenbreak.wav");
BufDef(\table, "field/table.flac");
BufDef(\scream, "vipere/scream.flac");
BufDef(\rocksteady, "vipere/rocksteady.flac");

Spec.add(\verbmix, \unipolar);
Spec.add(\adsr, XEnvSpec.adsr);


Ndef(\fx2).put(5, \filter -> { arg in;
	var sig = in;
	FreeVerb2.ar(sig[0], sig[1], \verbmix.kr(0.5), \room.kr(1), \damp.kr(0.4));

});
ParamProto.init;
);

BufDef(\melo2, s.sampleRate * 4).numFrames;
~recmodel.recbuf.sampleRate
~recmodel.recbus

(
	~name = \smpdrum1;
	Pdef(~name, Ppar([
		Pbind(
			\instrument, \playerbeat,
			\bufnum, BufDef(\kick),
			\isRest, Pseq([

				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

			],inf).coin.not,
			\pos, 0.04,
			\sustain, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1) * 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/4,
			\gain, 1,
		),
		Pbind(
			\instrument, \playerbeat,
			\bufnum, BufDef(\snare2),
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				],3),
			],inf).coin.not,
			\pos, 0.04,
			\sustain, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1) * 0.3,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/4,
			\gain, 1,
		),
		Pbind(
			\instrument, \playerbeat,
			\bufnum, BufDef(\tmp4),
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,1, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
				],3),
			],inf).coin.not,
			\pos, 0.04 + Pseq([
				0
			],inf)/~t,
			\speed, 1,
			\sustain, Pseq([
				1,1,1,1,
			],inf).stutter(1) * 0.2,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/4,
			\gain, 1/2,
		),
		Pbind(
			\instrument, \playerbeat,
			\bufnum, BufDef(\tmp4),
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,1,0,
				],3),
			],inf).coin.not,
			\pos, 0.04 + Pseq([
				( 1/2 )
			],inf)/~t,
			\speed, 1,
			\sustain, Pseq([
				1,1,1,1,
			],inf).stutter(1) * 0.2,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/4,
			\gain, 1/2,
		),
		Pbind(
			\instrument, \playerbeat,
			\bufnum, BufDef(\hat),
			\isRest, Pseq([
				0,0, 1,0,
			],inf).coin.not,
			\pos, Pseq([0.02],inf).stutter(2) + 0.04,
			\speed, 1,
			\sustain, Pseq([
				6,
			],inf)*0.02,
			\dur, 1/4,
			\gain, 1/1,
			\gain, Pkey(\gain) * Pseq([
				1
			],inf),
		),
		Pbind(
			\instrument, \playerbeat,
			\bufnum, BufDef(\tmp4),
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,1,0,
				],3),
			],inf).coin.not,
			\pos, 0.04 + Pseq([
				( 1+1/4 )
			],inf)/~t,
			\speed, 1,
			\sustain, Pseq([
				1,1,1,1,
			],inf).stutter(1) * 0.2,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/4,
			\gain, 1/2,
		),
		Pbind(
			\instrument, \playerbeat,
			\bufnum, BufDef(\moeten, "voices/02_moeten.flac"),
			\pos, 1/4, 
			\speed, 1,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/4,
			\gain, 1/3,
		),
		Pbind(
			\instrument, \playerbeat,
			\bufnum, BufDef(\moeten, "voices/02_moeten.flac"),
			\pos, 1/2, 
			\speed, 1,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/4,
			\gain, 1/3,
		),
		Pbind(
			\instrument, \playerbeat,
			\bufnum, BufDef(\moeten, "voices/02_moeten.flac"),
			\pos, 1+( 1/4 ), 
			\speed, 1,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/4,
			\gain, 1/3,
		),
		Pbind(
			\instrument, \playerbeat,
			\bufnum, BufDef(\moeten, "voices/02_moeten.flac"),
			\pos, 1+( 1/2 ), 
			\speed, 1,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/4,
			\gain, 1/3,
		),

	].collect({ arg pat;
		//pat
		pat <> Pbind(\out, BusDef(\fx1)) 
		//Pbind(\gain, Pkey(\gain) * 2, \dur, Pkey(\dur) /2) <> pat
		
	})));
	Pdef(~name).set(\out, BusDef(\fx1));
	//Pdef(~name).set(\out, 0);
	//Pdef(\main, Pdef(~name)).play;
	Ndef(\fx2).play;
~drumkit = Pdef(\smpdrum1).source.list.collect({ arg pat; Pbind(\isRest, false) <> pat });
ParamProto.init;
)

BufDef(\tmp16)



"cat > /tmp/scclipboard <<EOD\n%\nEOD".format("hlelelel\nklekle\nemlkleklj\nlele").unixCmd
"vim --servername scvim --remote-send '<Esc>:read /tmp/scclipboard<Enter>'".unixCmd;

Pdef(\main).stop


~kitTimeline.new(\sampler, ~drumkit);
~kitTimeline.new(\sampler).edit
~kitTimeline.new(\sampler).clear
~kitTimeline.new(\sampler).getPresetCompileString.editorInsert
~kitTimeline.new(\sampler).getPresetCompileString
~kitTimeline.new(\sampler).recorder.eventLoop = ~kitTimeline.new(\sampler).eventLoop

BusDef(\fx2, \audio)

~recmodel.edit

~kitTimeline.new(\sampler2, ~drumkit);
~kitTimeline.new(\sampler2).edit

~kitTimeline.new(\sampler3, ~drumkit);
~kitTimeline.new(\sampler3).edit

~kitTimeline.new(\sampler4, ~drumkit);
~kitTimeline.new(\sampler4).edit
(
~kitTimeline.new('sampler').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 0, \label: 'start', \playDur: 0, \relDur: 0, \sustain: 0, \type: 'start', ),
	(\absTime: 0, \dur: 0.0, \kitIndex: 4.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.055555555555556, ),
	(\absTime: 0.0, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.045454545454545, ),
	(\absTime: 0.25, \dur: 0.0, \kitIndex: 2.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.055555555555556, ),
	(\absTime: 0.25, \dur: 0.25, \kitIndex: 4.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.055555555555556, ),
	(\absTime: 0.5, \dur: 0.0, \kitIndex: 0.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 0.5, \dur: 0.25, \kitIndex: 4.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.055555555555556, ),
	(\absTime: 0.75, \dur: 0.125, \kitIndex: 4.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.055555555555556, ),
	(\absTime: 0.875, \dur: 0.125, \kitIndex: 3.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.055555555555556, ),
	(\absTime: 1.0, \dur: 0.0, \kitIndex: 1.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.1, ),
	(\absTime: 1.0, \dur: 0.25, \kitIndex: 4.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.055555555555556, ),
	(\absTime: 1.25, \dur: 0.25, \kitIndex: 4.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.055555555555556, ),
	(\absTime: 1.5, \dur: 0.25, \kitIndex: 4.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.055555555555556, ),
	(\absTime: 1.75, \dur: 0.25, \kitIndex: 4.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.055555555555556, ),
	(\absTime: 2.0, \dur: 0.0, \kitIndex: 0.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.1, ),
	(\absTime: 2.0, \dur: 0.125, \kitIndex: 4.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.055555555555556, ),
	(\absTime: 2.125, \dur: 0.125, \kitIndex: 0.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.045454545454545, ),
	(\absTime: 2.25, \dur: 0.0, \kitIndex: 4.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.055555555555556, ),
	(\absTime: 2.25, \dur: 0.25, \kitIndex: 2.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 2.5, \dur: 0.0, \kitIndex: 0.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.045454545454545, ),
	(\absTime: 2.5, \dur: 0.25, \kitIndex: 4.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.055555555555556, ),
	(\absTime: 2.75, \dur: 0.0, \kitIndex: 3.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 2.75, \dur: 0.25, \kitIndex: 4.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.045454545454545, ),
	(\absTime: 3.0, \dur: 0.0, \kitIndex: 1.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.1, ),
	(\absTime: 3.0, \dur: 0.25, \kitIndex: 4.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.055555555555556, ),
	(\absTime: 3.25, \dur: 0.125, \kitIndex: 4.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.055555555555556, ),
	(\absTime: 3.375, \dur: 0.125, \kitIndex: 1.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.045454545454545, ),
	(\absTime: 3.5, \dur: 0.25, \kitIndex: 4.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.055555555555556, ),
	(\absTime: 3.75, \dur: 0.0, \kitIndex: 1.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 3.75, \dur: 0.25, \kitIndex: 4.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.055555555555556, ),
	(\absTime: 4.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
)


(
Ndef(\bass, { arg freq=80, pan=0, amp=0.1;
	var sig;
	var env;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var trig = Impulse.kr(1/8*~t);
	env = EnvGen.kr(Env([1,45,1],[0.1,1.8]), trig);
	env2 = EnvGen.kr(Env([1,10,1],[1.8,0.8]), trig);
	sig = LFSaw.ar(freq * ( 1 + ( SinOsc.ar(42 * env) * 1 )));
	sig = RHPF.ar(sig, \lpf.kr(1000) * env2, \rq.kr(1.5));

	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\bass, { arg freq=80, pan=0, amp=0.1;
	var sig;
	var env;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var trig = Impulse.kr(1/8*~t);
	freq = freq * [1,1.01,1/2];
	env = EnvGen.kr(Env([1,45,1],[0.1,1.8]), trig);
	env2 = EnvGen.kr(Env([1,10,1],[1.8,0.8]), trig);
	sig = LFSaw.ar(freq * ( 1 + ( SinOsc.ar(42 * env) * 1 )));
	sig = RLPF.ar(sig, \lpf.kr(1000) * env2 * [1/2,1.2,1.4], \rq.kr(1.5));

	sig = Pan2.ar(sig, pan, amp).mean;
}).play;
);

(
Ndef(\bass, { arg freq=480, pan=0, amp=0.1;
	var sig;
	var env;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var trig = Impulse.kr(1/8*~t);
	freq = Duty.kr(2/~t, 0, Dseq([
		0,0,1,1,
	],inf)).midicps * freq/4;
	freq = freq * [1,1.0001,2, 2/3, 5/3];
	lfo1 = SinOsc.kr(1*~t).range(1,1/4);
	sig = LFSaw.ar(freq/2); 
	sig = sig * SinOsc.ar(freq);
	sig = sig + SinOsc.ar(freq+1); 
	sig = sig + LFSaw.ar(freq/2); 
	//sig = sig + DelayC.ar(sig, 0.1,1/freq * SinOsc.kr(1/16 * (1..16)/16*~t).range(1.1,1));
	//sig = sig + DelayC.ar(sig, 0.1,1/freq * 2 * SinOsc.kr(1/16 +0.01 * (1..16)/16*~t).range(1.1,1));
	//sig = sig + DelayC.ar(sig, 1/2/~t,1/4/~t);
	sig = sig * Duty.kr(1/8/~t, 0, Dseq([
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
		1,1,1,1, 1,0,0,1,
		0,0,0,0, 0,0,0,0,
		1,1,0,1, 1,0,1,0,
		0,0,0,0, 0,0,0,0,
	],inf));
	//sig = CombL.ar(sig, 4/~t, 1/8/16/~t * SinOsc.kr(1/2*~t).range(0,1),0/~t) + sig;
	lfo2 = Duty.kr(1/~t, 0, Dseq([
		6,4,8,2,
	],inf));
	sig = RHPF.ar(sig, \lpf.kr(100) * SinOsc.kr(lfo2*~t).range(2,1), \rq.kr(0.5));

	//sig = RandDelayNetwork.ar(sig, "4--") + sig;
	sig = (sig * 1000).tanh;

	sig = sig / 3;
	sig = Pan2.ar(sig, pan, amp).mean;
}).play;
);
Ndef(\bass).quant = 4
Ndef(\bass).edit
Ndef(\fx2).play;




//////////////////////////////////::


 ~drawBuf = BufDef(\kick)


 (
	 w = Window.new("DrawBufView", Rect(0, 0, 800, 400));
	 w.view.background_(Color.black);

	 u = UserView(w, w.bounds);

	 //u.frameRate = 10;
	 //u.animate = true;
	 {
			 var arr;
		 ~drawBuf.loadToFloatArray(action: {arg array;
			 arr = FloatArray.new;
			 array.clump(1048).do({ arg val, idx;

				 arr = arr.add(val.select(_ >= 0).mean);
				 arr = arr.add(val.select(_ < 0).mean);
				 //if(idx%1048==0) {
				 //    arr = arr.add(val);
				 //}
			 });
			 ~array = arr;
			 {

			 u.refresh;
			 }.defer;
		 });

	 u.drawFunc = {
		 var size;
		 var hh = 100;
		 "hhh".postln;
		 size = arr.size.debug("size");
		 arr.do{ arg val, index;
			 //val.debug("val");

			 index = index / size * w.bounds.width;
			 Pen.color = Color.white;
			 Pen.moveTo(index@200);
			 Pen.lineTo(index@(200+( val*770 )));
			 Pen.stroke;
		 };
		 "end".postln;
	 };
	 }.value;

	 w.front;
 )
 ~array.size
 ~array
 u.refresh
 w.bounds.width
 u.bounds.width
 BufDef(\kick).plot
 BufDef(\kick).path
