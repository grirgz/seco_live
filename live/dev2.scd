(
s.waitForBoot{
Window.closeAll;
~seq = Mdef.force_init(true);
//~seq.init_midi;
~synthlib = [
	\seqnode,
	\parnode,
	\audiotrack_expander,
	\monosampler,
	\stereosampler,
	\ss_comb,
	\ss_combfreq,

	"ci op_matrix2",
	"ci mosc",
	"ci moscfilter",
	"ci moscfilter_modfx",
	"ci osc3filter2",
	"ci bufosc_filt",
	"ci bufosc_filt_spread",
	"ci samplerfilter2",

	//"ci inlinefx",
	"ci inlinegen",
	"ci inline_genfx",

	\bufsin1,
	\zegrainer,
	\sampleosc1,
	\sampleosc2,

	\osc1,
	\osc_lag,
	\osc_test,
	\moteur,
	\guitar,
	\guitar2,
	\ch,
	\membraneHex,

	\kick1,
	\kick2,
	\kick3,
	\kicklank,
	\snare1,
	\snare2,
	\kraftySnr,

	\lead2,
	\saxo,
	\organ,
	\noisescape,
	\crackle2,
	\randsaw,
	\klankbell,
	\saklangbell,
	\gris1,
	\noisecomb1,
	\noisecomb2,
	\noisecomb3,
].collect({ arg i; i -> i });
~seq.load_patlib( ~synthlib );


~effectlib = [
	\comb1,
	\combline,
	\p_reverb,
	\p_flanger,
	\p_chorus,
	\p_delay,
	\p_comb,
	"ci insertfx3",
	"ci fxsfilter2",
	\dubecho,
	\dubecho_inmix,
	\dubecho_orig,
	\limiter,
	\bufstut,
	\multitap8,
	\ir_reverb,
].collect({arg i; i -> i });
~seq.load_effectlib( ~effectlib );

~modlib = [
	\setbus,
	\modenv,
	\gater,
	\gated_asr,
	\lfo1,
	\lfo_tri,
	\lfo_asr,
	\line1,
	\varline1,
	"ci mod_osc",
	"ci mod_envosc",
	"ci dadsr_kr",
	"ci custom_env",
	"ci selfgated_env",
	\cuspl,
].collect({arg i; i -> i });
~seq.load_modlib( ~modlib );

~inlinegenlib = [
	\empty,
	"ci ingen_osc",
	"ci sin",
];
~seq.load_inlinegenlib( ~inlinegenlib );

~inlinefxlib = [
	\empty,
	"ci infx_filter",
];
~seq.load_inlinefxlib( ~inlinefxlib );

~seq.set_presetlib_path("mypresets");

Mdef.side_gui;

~windowize = { arg layout;
	var win;
	win = Window.new;
	win.layout = layout;
	win.front;
};

Mdef.main.samplekit_manager.parse_samplekit_dir;
Mdef.main.samplekit_manager.parse_samplekit_dir(~seco_root_path +/+ "hydrogenkits/");

}
)


~node = Mdef.node_by_index(0)
~node = Mdef.node_by_index(1)
Mdef.node_by_index(0).is_mono = false;
~node.is_pmonoartic = true;
~node.rebuild_arg_list
~node.get_scoreset.get_notescore.remove_first_rest_if_not_needed = true

(
SynthDef(\osc_lag, { arg out, gate=1, pan=0, freq=300, amp=0.1, ffreq=200, rq=0.1, attack=0.1, release=0.1, doneAction=2, freqlag=0.2;
	var sig, env;
	freq = freq.lag(freqlag);
	sig = LFSaw.ar(freq * [1,1.01,0.99]);
	env = EnvGen.kr(Env.adsr(attack,0.1,1,release), gate, doneAction:doneAction);
	sig = RLPF.ar(sig, [ffreq, freq, ffreq*2, freq*2], rq);
	sig = AllpassC
	sig = sig.sum;
	sig = sig * env;
	sig = Pan2.ar(sig, pan, 1);
	sig = sig * amp;
	Out.ar(out, sig);
}).store;
)

(
SynthDef(\noisecomb, { arg out, gate=1, pan=0, freq=300, amp=0.1, noiselevel=0.2,
		minfreq=100, decaytime=1, doneAction=2, ffreq=500, rq=0.3;
	var sig, env;
	sig = WhiteNoise.ar(noiselevel);
	sig = sig + ClipNoise.ar(noiselevel);
	sig = sig + AllpassC.ar(sig, 1/minfreq, 1/freq, decaytime);
	sig = RLPF.ar(sig, ffreq, rq);
	env = EnvGen.kr(\adsr.kr(Env.adsr(0.6,0.1,0.8,0.1)), gate, doneAction:doneAction);
	sig = sig * env;
	sig = Pan2.ar(sig, pan, 1);
	sig = sig * amp;
	Out.ar(out, sig);
}).store;

SynthDef(\noisecomb2, { arg out, gate=1, pan=0, freq=300, amp=0.1, noiselevel=0.2,
		minfreq=100, decaytime=1, doneAction=2, ffreq=500, rq=0.3, spread=0.8;
	var sig, env;
	sig = WhiteNoise.ar(noiselevel);
	sig = sig + ClipNoise.ar(noiselevel);
	sig = sig + AllpassC.ar(sig, 1/minfreq, 1/freq, decaytime);
	sig = RLPF.ar(sig, ffreq * \ffreqtab.kr(1!10), rq);
	env = EnvGen.kr(\adsr.kr(Env.adsr(0.6,0.1,0.8,0.1)), gate, doneAction:doneAction);
	sig = sig * env;
	sig = Splay.ar(sig, spread, 1, pan);
	sig = sig * amp;
	Out.ar(out, sig);
}).store;
)

(
SynthDef(\noisecomb1, { arg out, gate=1, pan=0, freq=300, amp=0.1, attack=0.1, release=0.1, noiselevel=0.2,
		minfreq=100, decaytime=1, doneAction=2;
	var sig, env;
	sig = WhiteNoise.ar(noiselevel);
	sig = sig + AllpassC.ar(sig, 1/minfreq, 1/freq, decaytime);
	env = EnvGen.kr(Env.adsr(attack,0.1,1,release), gate, doneAction:doneAction);
	sig = sig * env;
	sig = Pan2.ar(sig, pan, 1);
	sig = sig * amp;
	Out.ar(out, sig);
}).store;
)

Ndef(\plop, { AllpassC.ar(Decay.ar(Impulse.ar(80), 0.17, BrownNoise.ar), 0.2, 0.4, 0.71) * 0.1 ! 2}).play;

(
SynthDef(\moteur, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, impulse_rate=70, 
		noise_decaytime=0.17, decaytime=0.7, doneAction=2, maxdelaytime=0.2, delaytime=0.2;
	var sig;
	sig = AllpassC.ar(Decay.ar(Impulse.ar(impulse_rate), noise_decaytime, BrownNoise.ar), maxdelaytime, delaytime, decaytime);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:doneAction);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).store;
)
Ndef(\plop, { AllpassC.ar(Decay.ar(Impulse.ar(80), 0.17, BrownNoise.ar), 0.2, 0.4, 0.71) * 0.1 ! 2}).play;

~reload_node.("noisecomb_l1038")

Env.adsr(0.3,1,2,3).asCompileString
a = Env.adsr(0.3,1,2,3).asArray
a = Env.adsr(0.3,1,2,3).dump
b = Env.xyc(a.clump(3))
a.dump

(

SynthDef(\osc_test, { arg out, gate=1, freq=300, amp=0.1, ffreq=200, rq=0.1, attack=0.1, release=0.1, doneAction=2, pan=0;
	var sig = LFSaw.ar(freq);
	//var env = EnvGen.kr(Env.adsr(attack,0.1,1,release), gate, doneAction:doneAction);
	var env = EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,1,0.1)), gate, doneAction:doneAction);
	sig = RLPF.ar(sig, ffreq, rq);
	sig = sig * env;

	sig = Pan2.ar(sig, pan, 1);
	sig = sig * amp;
	Out.ar(out, sig);
}).store;
)


"~/code/sc/seco/synthpool.sc".standardizePath.load

(
	Ndef(\fb, {
		var sig;
		sig = SoundIn.ar([0,1]);
		//sig = sig.clip(0.5);
		sig = HPF.ar(sig, 100);
		sig = LPF.ar(sig, SinOsc.ar(0.4).range(300,800));
		//sig = CombL.ar(sig, 0.5,0.125,8.5);
		sig = sig * SinOsc.ar(3.2).range(0,1);
		sig = sig + DelayL.ar(sig, 1, 1);
		sig = LeakDC.ar(sig);
		sig = sig * 0.9;
		sig = Limiter.ar(sig, 0.01, 0.2);
		sig;
	}).play
)


(
	{ SinOsc.ar(300) }.play
)


(
	
	SynthDef(\cuspl, { arg out=0, amp=1, pa=1, pb=1.5, xi=2, ifreq=200;
		var sig;
		sig = CuspL.ar(ifreq, pa, pb, xi);
		sig = sig * amp;
		Out.kr(out, sig);
	}).store;
)




(
	SynthDef(\noisescape, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, doneAction=2,
			lpf_white=5000, hpf_white=200, amp_white=1,
			lpf_clip=5000, hpf_clip=200, amp_brown=1,
			lpf_brown=5000, hpf_brown=200, amp_clip=1;
		var sigw, sigb, sigc;
		var sig;
		sigw = WhiteNoise.ar(amp_white);
		sigw = LPF.ar(sigw, lpf_white);
		sigw = HPF.ar(sigw, hpf_white);
		sigw = sigw * EnvGen.ar(\adsr_white.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:0);

		sigb = WhiteNoise.ar(amp_brown);
		sigb = LPF.ar(sigb, lpf_brown);
		sigb = HPF.ar(sigb, hpf_brown);
		sigb = sigb * EnvGen.ar(\adsr_brown.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:0);

		sigc = ClipNoise.ar(amp_clip);
		sigc = LPF.ar(sigc, lpf_clip);
		sigc = HPF.ar(sigc, hpf_clip);
		sigc = sigc * EnvGen.ar(\adsr_clip.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:0);

		sig = sigw + sigb + sigc;
		sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
		sig = Pan2.ar(sig, pan, amp);
		Out.ar(out, sig);
	}).store;
)

(
SynthDef(\ch, { | out=0, decay = 3, amp = 0.1, freqfactor = 1, doneAction=2, delayfactor=1, shift=(-200) |
	var sig = WhiteNoise.ar;
	var del;
	sig = LPF.ar(sig, (12000*freqfactor).clip(10,15000));
	//sig = sig + DelayC.ar(sig, 0.1,LFNoise2.ar(1/2).range(0.001,0.01)*delayfactor);
	del = DelayC.ar(sig, 0.1,LFNoise2.ar(1/2).range(0.001,0.01)*delayfactor);
	del = FreqShift.ar(del, shift);
	sig = sig + del;
	sig = HPF.ar(sig, (4000*freqfactor).clip(10,15000), 0.05);
	sig = sig * EnvGen.kr(Env.perc(0.01,decay*0.8), doneAction:doneAction);
	Out.ar(out, 15 * sig.dup * amp);
}, metadata: (
	specs: (
		shift: ControlSpec.new((-2000),2000, \lin, 0, 0)
	)
)).store;
)



Mdef.main.save_project("plage");
Mdef.main.load_project("plage");
[1,2].extend(4,0)


(

SynthDef(\saklangbell, {arg out=0, freq=400, amp=0.1, gate=1, pan=0.0, doneAction=2; // we add a new argument

	var arsize=16;
	var signal, env;

	signal = Klang.ar(`[
		freq*\freqs.kr([0.745,2.122,3.453,4.5454,0.878].extend(arsize,1)),
		\amps.kr([0.25, 0.25, 0.25, 0.25, 0.25].extend(arsize,0)), 
		\rings.kr([0.1,0.1,0.1,0.1,0.1].extend(arsize,0))
	]);

	signal = signal * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:doneAction);

	signal = Pan2.ar(signal, pan);

	Out.ar(out, signal);

}).store;

SynthDef(\klankbell, {arg out=0, freq=400, amp=0.1, gate=1, pan=0.0, doneAction=2; // we add a new argument

	var arsize=16;
	var signal, env;
	var input;

	
	//env = EnvGen.ar(Env.adsr(0.01,0.3,0.05,0.7), gate, doneAction:2); // doneAction gets rid of the synth
	input = Decay.ar(Impulse.ar(1), 0.1) * PinkNoise.ar(1);
	input = SinOsc.ar(freq)/2;
	input = Decay.ar(Impulse.ar(1), 0.1) * input;

	signal = DynKlank.ar(`[
		freq*\freqs.kr([0.745,2.122,3.453,4.5454,0.878].extend(arsize,1)),
		\amps.kr([0.25, 0.25, 0.25, 0.25, 0.25].extend(arsize,0)), 
		\rings.kr([0.1,0.1,0.1,0.1,0.1].extend(arsize,0))
	], input);

	signal = signal * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:doneAction);
	signal = Pan2.ar(signal, pan, amp);
	signal = signal / 8;

	Out.ar(out, signal);

}).store;

)

(
	~make_multislider = { arg data, keys;

		var layout;
		n=5;
		w = Window.new.front;
		layout = HLayout.new;
		w.layout = layout;
		keys.do { arg key;
			m = MultiSliderView(w,Rect(10,10,n*13+2,100)); //default thumbWidth is 13
			m.value=Array.fill(n, {|v| v*0.05}); // size is set automatically when you set the value
			m.elasticMode = true;
			m.fillColor = Color.green;
			m.indexThumbSize = 100;
			m.isFilled = true;
			m.action = { arg ms;
				data[key] = ms.value
			};
			layout.add(m)
		};
	}

)

SynthDescLib[\kicklank]
SynthDescLib.global.synthDescs[\kicklank].controlDict[\freqs].dump


Synth(\saklangbell, [\freq, 200])

~freqs = [1,1,1,1,1];
~freqs
(

~spec = ControlSpec(0.01,4,\lin,0,1);
~num = 5;
~data = (
	freqs: 1 ! ~num,
	amps: 1 ! ~num,
	rings: 1 ! ~num,
);
)

~make_multislider.(~data, [\freqs, \amps, \rings])

~data

(
Pdef(\plop, Pbind(
	\instrument, \klankbell,
	//\freq, Pseq([300, 201, 243, 215],inf),
	\note, Pseq([0, 1, 2, 3,5],inf),
	\freqs, Pfunc{ [~spec.map(~data.freqs)] },
	\amps, Pfunc{ [~spec.map(~data.amps)] },
	\rings, Pfunc{ [~spec.map(~data.rings)] },
	//\dur, Pwhite(0.02,1/2,inf),
	\dur, Pseq([0.25,0.125,0.25,0.125],inf),
	\amp, 0.1
)).play;
);

(
	n=5;
	w = Window.new.front;
	m = MultiSliderView(w,Rect(10,10,n*13+2,100)); //default thumbWidth is 13
	m.value=Array.fill(n, {|v| v*0.05}); // size is set automatically when you set the value
	m.elasticMode = true;
	m.fillColor = Color.green;
	m.indexThumbSize = 100;
	m.isFilled = true;
	m.action = { arg q;
	    q.value.postln;
	};

)



(
n=40;

w = Window("MultiSlider Options", Rect(200, Window.screenBounds.height-550, 600, 450));
f={ 
    w.view.decorator = FlowLayout( w.view.bounds, 10@10, 10@2 );
    m = MultiSliderView(w,Rect(0,0,580,200)); // default thumbWidth is 13
    m.value=Array.fill(n, {|v| 0.5+((0.3*v).sin*0.25)});
    m.action = { arg q;q.value.postln; };

    StaticText(w,380@18).string_("indexThumbSize or thumbSize");
    Slider(w,580@10).action_({arg sl; m.indexThumbSize=sl.value*24}).value_(0.5);
    StaticText(w,380@18).string_("valueThumbSize");
    Slider(w,580@10).action_({arg sl; m.valueThumbSize=sl.value*24}).value_(0.5);
    StaticText(w,580@18).string_("xOffset or gap");
    Slider(w,580@10).action_({arg sl; m.xOffset=sl.value*50});
    StaticText(w,580@18).string_("startIndex");
    Slider(w,580@10).action_({arg sl; m.startIndex = sl.value *m.size};);

    CompositeView(w,580@10);//spacer
    Button(w,100@20).states_([["RESET",Color.red]])
        .action_({ w.view.removeAll; f.value; });
    h=StaticText(w,450@18).string_("").stringColor_(Color.yellow);
    Button(w,100@20).states_([["elasticMode = 0"],["elasticMode = 1",Color.white]])
        .action_({|b| m.elasticMode = b.value});
    Button(w,160@20).states_([["indexIsHorizontal = false"],["indexIsHorizontal = true",Color.white]])
        .action_({|b| m.indexIsHorizontal = b.value.booleanValue}).value_(1);
    Button(w,120@20).states_([["isFilled = false"],["isFilled = true",Color.white]])
        .action_({|b| m.isFilled = b.value.booleanValue});
    Button(w,120@20).states_([["drawRects = false"],["drawRects = true",Color.white]])
        .action_({|b| m.drawRects = b.value.booleanValue}).valueAction_(1);
    Button(w,100@20).states_([["drawLines = false"],["drawLines = true",Color.white]])
        .action_({|b| m.drawLines = b.value.booleanValue});
    Button(w,160@20).states_([["readOnly = false"],["readOnly = true",Color.white]])
        .action_({|b| m.readOnly = b.value.booleanValue});
    Button(w,120@20).states_([["showIndex = false"],["showIndex = true",Color.white]])
        .action_({|b| m.showIndex = b.value.booleanValue});
    Button(w,120@20).states_([["reference = nil"],["reference filled",Color.white],["reference random",Color.yellow]])
        .action_({|b| b.value.booleanValue.if({
            (b.value>1).if(
                {m.reference=Array.fill(n, {1.0.rand})},
                {m.reference=Array.fill(m.size, {0.5})});
                },{ q=m.value;m.reference=[]; h.string="reference can't be returned to nil presently. please hit RESET."}
            )
        });
    Button(w,180@20).states_([["fillColor = Color.rand"]]).action_({m.fillColor=Color.rand});
    Button(w,180@20).states_([["strokeColor = Color.rand"]]).action_({m.strokeColor=Color.rand});
    Button(w,180@20).states_([["background = Color.rand"]]).action_({m.background=Color.rand});

};
f.value;
w.front;

)




:a!

(
SynthDef(\crackle,
{arg mul=1, bus;
var source, dur, filter, centrefreq, pan;
dur = EnvGen.kr(Env.perc(Rand(1,6), Rand(1,6), 1), 1.0, doneAction:2);
source = Crackle.ar(Rand(1.1,1.9), 1.7*dur);
centrefreq = Rand(100,1000);
filter = Resonz.ar(source, centrefreq, Rand(0.001,0.5));
pan = Pan2.ar(filter, SinOsc.kr(Rand(36,108), Rand(-0.99,0.99)));
Out.ar(bus, pan*mul.lag(12))
}).load(s);

SynthDef(\crackle2, {arg out=0, amp=0.1, ffreq=200, gate=1, crackfreq=1.1, crackmul=1.7, rq=0.05, panfreq=36,
		doneAction=2;
	var source, dur, filter, centrefreq, pan;
	var sig, env;
	env = EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:doneAction);
	sig = Crackle.ar(crackfreq, crackmul);
	sig = Resonz.ar(sig, ffreq, rq);
	sig = sig * env;
	sig = Pan2.ar(sig, SinOsc.kr(panfreq));
	Out.ar(out, sig*amp);
}).store;
)

(
Pdef(\plop, Pbind(
	\instrument, \crackle2,
	\degree, Pseq([0],inf),
	\dur, 3,
	\amp, 0.8
)).play;
);

(
~task=Task({
inf.do({
Synth(\crackle, [\bus, 0]);
rrand(16,12).wait;
});
});
~task.start;
)



(
	~notes = Pbind(
		\noteline, Pseq([

			(
				midinote: 64,
				sustain: 0.25,
				velocity: 0.8,
				dur: 0.5
			),
			(
				midinote: 65,
				sustain: 0.25,
				velocity: 0.8,
				dur: 0.25
			),
			(
				midinote: 68,
				sustain: 0.25,
				velocity: 0.8,
				dur: 0.5
			),
			(
				midinote: 69,
				sustain: 0.25,
				velocity: 0.8,
				dur: 0.25
			),
		],inf),
		\midinote, Pfunc{ arg ev; ev[\noteline].midinote },
		\dur, Pfunc{ arg ev; ev[\noteline].dur },
		\sustain, Pfunc{ arg ev; ev[\noteline].sustain },
	);

	~instr1 = Pbind(
		\instrument, \osc1, 
		\ffreq, Pseq([800,200]),
		\rq, 0.7,
	);
	~instr2 = Pbind(
		\instrument, \osc2, 
		\ffreq, Pseq([800,200,400,300]+1,inf),
		//\rq, 0.8,
	);
	~instrb = Pbind(
		\instrument, \osc2, 
		\ffreq, 204,
		\rq, 0.2,
	);

	~player = ~notes <> Pstep(Pseq([~instr1, ~instr2],inf), 2);
	~player = Pstep(Pseq([~instr1, ~instr2],inf), 2) <> ~notes;
	~player = ~notes <> ~instr1;
	~player = Pseq([
		Psync(~instr1, 4, 4), 
		Psync(~instr2, 4, 4), 
	],inf) <> ~instrb <> ~notes;
	~player = ~notes <> Pseq([
		Psync(~instr1, 4, 4), 
		Psync(~instr2, 4, 4), 
	],inf);
	~player.trace.play;
)


(
	~vla = Prout({ arg inval;
		loop {
			elapsed.postln;
			inval = inval.yield
		}
	});
	~pla = ~vla <> ~notes;

	~pla.trace.play
)
Pdur

(
SynthDef(\osc2, { arg out, gate=1, freq=300, amp=0.1, ffreq=200, rq=0.1, attack=0.1, release=0.1, doneAction=2, pan=0;
	var sig = LFSaw.ar(freq * [1,1.01]);
	var env = EnvGen.kr(Env.adsr(attack,0.1,1,release), gate, doneAction:doneAction);
	sig = RLPF.ar(sig, ffreq, rq);
	//sig = sig + SinOsc.ar(ffreq);
	//ffreq.poll;
	//rq.poll;
	sig = sig * env;
	sig = Pan2.ar(sig, pan, 1);
	sig = sig * amp;
	//sig.poll;
	Out.ar(out, sig);
}).store;
)


Pspawn



Ppar


Ptimeline(
	[
		(
			pattern: \notes1,
			dur: 5,
			sustain: 3,
		),
		(
			pattern: \notes2,
			dur: 5,
			sustain: 3,
		),
	]
)

(
var	patternChoices = (
	up: { Pbind(\degree, Pseries(rrand(-4, 5), 1, rrand(4, 10)), \dur, 0.125) },
	down: { Pbind(\degree, Pseries(rrand(4, 11), -1, rrand(4, 10)), \dur, 0.125) }
);

p = Pspawn(Pbind(
	\pattern, Prand([\up, \down], inf),
	\delta, 0.0,
	\method, \seq,
), (dict: patternChoices)).play;
)





SynthDef(\plop, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = S;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

(
~tab = { arg n; n.tanh * (n+1).cos / (n.rand+9) + 1 / (n+2).tanh * 30 - 27 } ! 15;
~tab.postln;
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	//freq = Demand.kr(Dust.kr(10), 0, Dseq([1,2,4]*100,inf));
	//freq = freq.lag(freq/1000);
	sig = LFSaw.ar(freq * ~tab.abs);
	sig = sig.sum;
	sig = RLPF.ar(sig, 100 * SinOsc.ar(~tab.abs/7).range(0.01,7.2));
	sig = sig.sum;
	sig = sig / 10;
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
SynthDef(\randsaw, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, ffreqmul=1, rq=0.5, ffreqcar=200, ffreqrange=0.5;
	var sig;
	var tab;
	tab = \tab.kr(1 ! 15);
	sig = LFSaw.ar(freq * tab.abs);
	sig = sig.sum;
	//sig = RLPF.ar(sig, Rand(10,freq*2) + 510 * SinOsc.ar(tab.abs * ffreqmul).range(0.01,Rand(2,7)), rq);
	sig = RLPF.ar(sig, SinOsc.ar(tab.abs * ffreqmul) * ffreqcar * ffreqrange + ffreqcar, rq);
	sig = sig.sum;
	sig = sig / 100;
	sig = sig.tanh;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1+ExpRand(0.001,0.2)),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}, metadata:(specs:(
	tab: ControlSpec(0.001,4,\lin, 0, 1)
))).store;
)

(
Pdef(\plop, Pbind(
	\instrument, \randsaw,
	\degree, Pstep(Pseq([
		Pseq([0,2,4],4),
		Pseq([0,12,6],4),
		Pseq([0,12,6]+7,1),
	],inf), 1),
	\octave, 3,
	\tab, Pfunc {
		var tab;
		[ 
			tab = [ 
				tab = { arg n; (n + 2.asFloat.rand + 1) / (n+1) } ! 15,
				tab = { arg n; (n + 1.asFloat.rand + 1).tanh / (n.rand+1) } ! 15,
			].choose;
			tab.postln;
		]
	},
	\dur, PdurStutter( Prand([1,2,4],inf), Pseq([1,2,3]/2,inf)),
	\amp, 0.4
)).play;
);

SynthDescLib.global.synthDescs[\bla].controlDict[\tab].defaultValue
~n = Mdef.node_by_index(0)
~n.get_arg(\tab).spec
~get_spec.(\tab, \randsaw)
~get_special_spec.(\tab, \randsaw)



Mdef.main.save_project("bordel");
Mdef.main.load_project("bordel");

Mdef.main.save_project("bordel_B");
Mdef.main.load_project("bordel_B");

Mdef.main.save_project("bordel_B2");
Mdef.main.load_project("bordel_B2");

BufferPool.buffers




(
SynthDef(\plop, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, ffreq=200, rq=0.5;
	var sig;
	sig = LFSaw.ar(freq * \freqs.kr([1,1,1,1,1]));
	sig = RLPF.ar(sig, ffreq, rq);
	sig = sig.sum;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
)


(
Pdef(\plop, Pbind(
	\instrument, \plop,
	\blend, Pseq((1..10).normalizeSum,inf),
	\freqs, Pfunc { arg ev;
		[
			[1.1, 0.99, 1.01, 2, 4].blend(
				[0.1, 0.19, 0.71, 1.2, 0.51],
				ev[\blend]
			)
		]
	},
	//\freq, Pseq([100,200,700],inf)+Pwhite(100,110) / 2,
	\degree, Pstep(Pseq([0,2,4],inf),1),
	\octave, 2,
	\ffreq, Pseq([100,200,300],inf)+Pwhite(100,500),
	\legato, Pseq([1.5,0.5],inf),
	\dur, Pseq([0.1, Pn(0.2,3)],inf),
	\dur, Pseq([0.1, Pn(0.2,3)],inf),
	\amp, 0.1
)).play;
);


(
{
	var sig;
	sig = SoundIn.ar([0,1]);
	sig = sig * 10;
	//sig = CombL.ar(sig, 0.1,0.1,2);
}.play
)

(
	{ SinOsc.ar(200) }.play
)

(
SynthDef(\plop, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
)









(
SynthDef(\master_mixer, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var num_output = 8;
	var offset = 2;
	num_output.do { arg x;
		var outbus = x*2 + offset;
		sig = sig + In.ar(outbus, 2);
	};
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
)

Mdef.node_by_index(1).get_arg(\out)
Mdef.node_by_index(4).get_arg(\out)
Mdef.node_by_index(4).rebuild_arg_list
Mdef.node_by_index(4).out_bus
Mdef.node_by_index(1).sourcepat_list



(
	~group1 = Group.new;
	~group_in1 = Group.new(~group1);
	~group_in1.register;
	~group_in1.addDependant({ arg grp, status; [grp, status].debug("frreed")});

)
	~group_in1.stop;
	~group_in1.free
	~group_in1.release

	~dnw = DebugNodeWatcher(s);
	~dnw.start
	~dnw.stop

	y = Group.new;
	y.run(false);
	y.free;

(
	~group1 = Group.new;
	~group_in1 = Group.new(~group1);
	~nw = DebugNodeWatcher.register(~group_in1);
	~group_in1.addDependant({ arg grp, status; [grp, status].debug("frreed")});

)
	~group_in1.stop;
	~group_in1.free
	~group_in1.release
	Pstutter

Mdef.node(\s1_part1_sect2_var1).assign_out_bus
Mdef.node(\s1_part1_sect1_var1).assign_out_bus


(
~num = 150;
~dur = (~num..1).linexp(1,~num,0.001,0.25);
~dur = (~num..1).collect { arg x; (x / ~num / 2) **2  };
~dur.postln;
Pdef(\plop, Pbind(
	\instrument, \plop,
	//\note, Pstutter(Pseq([Pn(4)]), Pseq((1..~num),inf)) + Pseq([0,1,-1,0],inf),
	//\note, Pstutter(Pseq([Pn(4)]), Pseq((1..~num),inf)) + Pseq([0,3,-1,2],inf),
	//\note, Pstutter(Pseq([Pn(8)]), Pseq((1..~num),inf)) + Pseq([0,3,2,1, -3,-2,-1,0].scramble.postln;,inf),
	//\degree, Pstutter(Pseq([Pn(8)]), Pseq((1..~num),inf)) + Pseq([0,3,2,1, -3,-2,-1,0],inf),
	\mtranspose, Pstutter(Pseq([Pn(4)]), Pseq((1..~num),inf)),
	\degree, Pseq([0,2b,4,0],inf),
	//\freq, Pstutter(Pseq([Pn(8)]), Pseq((1..~num).linlin(1,~num, 50,8000),inf)) * (1+Pseq([0,3,2,1, -3,-2,-1,0]/4,inf)),
	\octave, 3,
	//\dur, Pseq((20..1)/20,inf),
	\dur, Pseq(~dur,inf),
	\lag, Pseq([0,0.2],inf) * Pkey(\dur),
	\amp, 0.01
)).play;
);




(
	~delay= ControlSpec(0.0001,4,\exp,0,0);
	~decay= ControlSpec(0,4,\lin,0,0);
SynthDef(\combline, { arg in, out=0, mix=0.5, amp=1, gate=1,
			combmix1 = 0.5, combmix2 = 0.5,
			maxdelaytime1=0.5, delaytime1=0.5, decaytime1=1,
			maxdelaytime2=0.5, delaytime2=0.5, decaytime2=1,
			maxdelaytime3=0.5, delaytime3=0.5, decaytime3=1
		;
	var sigin, sig;
	var sigc1, sigc2, sigc3;
	sigin = In.ar(in, 2);
	sig = sigin;
	sigc1 = CombL.ar(sig, maxdelaytime1, delaytime1, decaytime1);
	sigc2 = SelectX.ar(combmix1, [sig, sigc1]);
	sigc2 = CombL.ar(sigc2, maxdelaytime2, delaytime2, decaytime2);
	sigc3 = SelectX.ar(combmix2, [sig, sigc2]);
	sigc3 = CombL.ar(sigc3, maxdelaytime3, delaytime3, decaytime3);
	sig = sigc1 + sigc2 + sigc3;
	sig = sig * amp;
	sig = SelectX.ar(mix, [sigin, sig]);
	sig = sig * EnvGen.ar(Env.asr(0.0001,1,0.0001),gate,doneAction:2);
	Out.ar(out, sig);
}, metadata:(specs:(


	combmix1: \unipolar.asSpec,
	combmix2: \unipolar.asSpec,
	maxdelaytime1: ~delay,
	maxdelaytime2: ~delay,
	maxdelaytime3: ~delay,
	delaytime1: ~delay,
	delaytime2: ~delay,
	delaytime3: ~delay,
	decaytime1: ~decay,
	decaytime2: ~decay,
	decaytime3: ~decay,
	//ControlSpec(0.001,4,\lin, 0, 1)
))).store;
)


(
SynthDef(\plop, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	DynKlang
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
)

([5.2,5] *.t [2.2,3.3]).flat
Array.geom(10,0.1,2)
p = ProxySpace.new
p[\bla].play
5/4
4/5
15/14
(
	p[\bla] = {  arg mul=0.4;
		var sig, sig2;
		var sel;
		var ffreq;
		var tab, tab2, tab3;
		sel = SinOsc.ar([1.1,2.2,3.3,0.2,0.987,5,1.55]).range(0,1);
		tab2 = [5,5.2,2.2,3.3,5.5,3.54,0.1,0.201] * mul;
		tab = [0.1,0.201,0.401,0.801,1.601,3.201] * mul;
		tab = Array.geom(5,0.1,2)+0.0;
		tab3 = Array.geom(15,0.1,15/14)+0.0;
		sig = SinOsc.ar(LFSaw.ar(tab).range(50,tab3*1200));
		sig2 = LFSaw.ar(LFSaw.ar(tab).range(50,tab3*1200));
		sig = SelectX.ar(sel, [sig, sig2]);
		ffreq = [1.1,4.2,0.3,1.221,1.21565];
		ffreq = ffreq.collect{ arg x; SinOsc.ar(x).range(x/2,x) };
		sig2 = RLPF.ar(sig, ffreq*4700);
		sig = SelectX.ar(sel, [sig, sig2]);
		sig = Splay.ar(sig, 0.8);
		//sig = EnvGen.ar(Env.adsr(0.1,0.1,1,0.1),gate,doneAction:0);
		sig = sig *0.4;
	})
)

(
p[\bla][1] = \set -> Pbind(
	\mul, Pseq([1,18],inf)	

)
)

p[\rah] = 
p[\bla].dump
p[\bla].busArg
p[\bla].objects[0].synthDef.dump
(
Pdef(\plop, Pbind(
	\instrument, p[\bla].objects[0].synthDef.name,
	\degree, Pseq([0],inf),
	\dur, 1,
	\amp, 0.1
)).play;
);

(
	~tab = [0.1,0.201,0.401,0.801,0.601,1.201].tanh;
	SynthDef(\gris1,{  arg out=0, mul=0.4, gate=1, freq, amp=0.1, doneAction=2;
		var sig, sig2;
		var sel;
		var ffreq;
		var tab, tab2, tab3;
		sel = SinOsc.ar([1.1,2.2,3.3,0.2,0.987,5,1.55]).range(0,1);
		tab2 = [5,5.2,2.2,3.3,5.5,3.54,0.1,0.201] * mul;
		tab = [0.1,0.201,0.401,0.801,1.601,3.201] * mul;
		tab = Array.geom(5,0.1,2)+0.0;
		tab3 = Array.geom(15,0.1,15/14)+0.0;
		tab3 = \coefs.kr(1!10);
		sig = SinOsc.ar(LFSaw.ar(tab).range(50,tab3*freq));
		sig2 = LFSaw.ar(LFSaw.ar(tab).range(50,tab3*freq));
		sig = SelectX.ar(sel, [sig, sig2]);
		ffreq = [1.1,4.2,0.3,1.221,1.21565];
		ffreq = ffreq.collect{ arg x; SinOsc.ar(x).range(x/2,x) };
		sig2 = RLPF.ar(sig, ffreq*freq);
		sig = SelectX.ar(sel, [sig, sig2]);
		sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:doneAction);
		sig = sig *amp;
		sig = Splay.ar(sig, 0.8);
		Out.ar(out, sig)
	}).add
)

(
Mdef(\plop, Pbind(
	\instrument, \gris1,
	//\degree, Pseq([0,2,4],inf),
	\octave, 6,
	\blend, Pseq([0,0.5,1],inf),
	\blend, Pseg(Pseq([0,0.5,1],inf),Pseq([4],inf)),
	\coefs, Pfunc{ arg ev;
		[
			[0.1,0.201,0.401,0.801,4.601,1.201].blend(
				[0.154,1.101,1.601,0.571,1.601,2.201],
				ev[\blend]

			)
		]
	},
	\dur, Pseq([1,1,1,1, 2,2, 1,1,2, 1,4,1,2]/4,inf),
	\amp, 0.1
)).play;
);

(
SynthDef(\noisecomb2, { arg out, gate=1, pan=0, freq=300, amp=0.1, noiselevel=0.2,
		minfreq=100, decaytime=1, doneAction=2, ffreq=500, rq=0.3, spread=0.8;
	var sig, env;
	sig = WhiteNoise.ar(noiselevel);
	sig = sig + ClipNoise.ar(noiselevel);
	sig = sig + AllpassC.ar(sig, 1/minfreq, 1/freq, decaytime);
	sig = RLPF.ar(sig, ffreq * \ffreqtab.kr(1!10), rq);
	env = EnvGen.kr(\adsr.kr(Env.adsr(0.6,0.1,0.8,0.1)), gate, doneAction:doneAction);
	sig = sig * env;
	sig = Splay.ar(sig, spread, 1, pan);
	sig = sig * amp;
	Out.ar(out, sig);
}).store;
)

(
SynthDef(\noisecomb3, { arg out, gate=1, pan=0, freq=300, amp=0.1, noiselevel=0.2,
		minfreq=100, decaytime=1, doneAction=2, ffreq=500, rq=0.3, spread=0.8,
		minrange=0.4, maxrange=1.2;
	var sig, env;
	sig = WhiteNoise.ar(noiselevel);
	sig = sig + ClipNoise.ar(noiselevel);
	sig = sig + AllpassC.ar(sig, 1/minfreq, 1/freq, decaytime);
	sig = RLPF.ar(sig, ffreq * \ffreqtab.kr(1!10) * LFNoise1.ar(\noiseftab.kr([0.82,0.44,0.2,3.2,1.25])).range(minrange,maxrange), rq);
	sig = (sig*10).tanh/5;
	env = EnvGen.kr(\adsr.kr(Env.adsr(0.6,0.1,0.8,0.1)), gate, doneAction:doneAction);
	sig = sig * env;
	sig = Splay.ar(sig, spread, 1, pan);
	sig = sig * amp;
	Out.ar(out, sig);
}).store;
)

nil
Pdef(\plopbla).quant = 1;
Pdef(\plopbla2).quant = 4;
(
Pdef(\plopbla2, Pbind(
	\instrument, \noisecomb3,
	//\note, Pseq([[0,7],[1,8],[-1,5]]-2,inf),
	//\note, Pseq([0,7,1,8,-1,5]-2,inf),
	//\note, Pseq([[0,7],[1,8],[-1,5]]-2,inf),
	//\note, Pseq([[0,7],[1,8],[-1,5]]-2,inf),
	//\degree, Pseq([0,2,4,1,3,5,7,4,2,6],inf),
	//\degree, Pseq([[0,2,4],1,[3,5,7],4,2,6],inf),
	//\scale, Scale.minor,
	//\note, Pseq([0,1,2,3,4],inf)
	\octave, Pstep(Pseq([3,4],inf),Pseq([5,0.75],inf)),
	\minfreq, 50,
	\decaytime, 1.0,
	\adsr, Pseq([
		[Env.adsr(0.02,0.1,0.8,0.4,curve:0.5)],
		[Env.adsr(0.02,0.1,0.8,0.4,curve:0.5)],
		[Env.adsr(0.12,0.1,0.8,0.4,curve:0.5)],
		[Env.adsr(0.03,0.1,0.8,0.1,curve:0.5)],
		[Env.adsr(0.03,0.1,0.8,0.1,curve:0.5)],
		[Env.adsr(0.13,0.1,0.8,0.1,curve:0.5)],
	],inf),
	\legato, 0.9,
	\ffreq, [500,610,820,140,1100],
	\ffreq, 500,
	//\stretch, 1/4,
	//\ffreqtab, [[0.8,1,1.1,1.2, 2,4,5,6, 8,10].scramble.postln],
	//\ffreqtab, [ 6, 4, 5, 10, 1, 1.2, 0.8, 1.1, 2, 8  ], // also nice
	\ffreqtab, Pfunc{ [[ 0.1, 0.2, 0.3, 0.5,  1,2,3,8, 10, 12  ].scramble] + rrand(0.01,1.0); },
	\ffreqtab, [[ 6, 4, 5, 10, 1, 1.2, 0.8, 0.4, 2, 8  ]],
	\ffreqtab, Pfunc{ [{rrand(0.01,15.0);  } ! 10 ]},
	\ffreqtab, [ 1 ! 10],
	\dur, Pseq([3,1,1, 0.25,0.25,0.25],inf),
	\dur, Pseq([1,0.25,1, 0.25,0.25,0.25],inf),
	\amp, 0.2,
));
);

Pdef(\plopbla2).play

Mdef.node_by_index(4).get_arg(\ffreqtab).set_val(1!10)

Interpreter

SequenceableCollection
Object
x = [[2,3], [5,4], [6,3]].blendAt(0.4);

~replace = { arg x; "bla".postln; x.postln; "bli".postln; };

plop

plop

4554


"vimbla "
"vim --servername scvim --remote-send \"<Esc>:'<,'>s/.*/4554/<CR>\"".unixCmd
(
~va = Pbind(
	\instrument, \noisecomb3,
	//\note, Pseq([[0,7],[1,8],[-1,5]]-2,inf),
	//\note, Pseq([0,7,1,8,-1,5]-2,inf),
	//\note, Pseq([[0,7],[1,8],[-1,5]]-2,inf),
	//\note, Pseq([[0,7],[1,8],[-1,5]]-2,inf),
	//\degree, Pseq([0,2,4,1,3,5,7,4,2,6],inf),
	//\degree, Pseq([[0,2,4],1,[3,5,7],4,2,6],inf),
	//\scale, Scale.minor,
	//\note, Pseq([0,1,2,3,4],inf)
	\octave, Pstep(Pseq([3,4],inf),Pseq([5,0.75],inf)),
	\minfreq, 50,
	\decaytime, 1.0,
	\adsr, Pseq([
		[Env.adsr(0.02,0.1,0.8,0.4,curve:0.5)],
		[Env.adsr(0.02,0.1,0.8,0.4,curve:0.5)],
		[Env.adsr(0.12,0.1,0.8,0.4,curve:0.5)],
		[Env.adsr(0.03,0.1,0.8,0.1,curve:0.5)],
		[Env.adsr(0.03,0.1,0.8,0.1,curve:0.5)],
		[Env.adsr(0.13,0.1,0.8,0.1,curve:0.5)],
	],inf),
	\legato, 0.9,
	\ffreq, [500,610,820,140,1100],
	\ffreq, 500,
	//\stretch, 1/4,
	//\ffreqtab, [[0.8,1,1.1,1.2, 2,4,5,6, 8,10].scramble.postln],
	//\ffreqtab, [ 6, 4, 5, 10, 1, 1.2, 0.8, 1.1, 2, 8  ], // also nice
	\ffreqtab, Pfunc{ [[ 0.1, 0.2, 0.3, 0.5,  1,2,3,8, 10, 12  ].scramble] + rrand(0.01,1.0); },
	\ffreqtab, [[ 6, 4, 5, 10, 1, 1.2, 0.8, 0.4, 2, 8  ]],
	\ffreqtab, Pfunc{ [{rrand(0.01,15.0);  } ! 10 ]},
	\ffreqtab, [[ 1 ! 10]],
	\dur, Pseq([3,1,1, 0.25,0.25,0.25],inf),
	\dur, Pseq([1,0.25,1, 0.25,0.25,0.25],inf),
	\amp, 0.2,
)
)

~va.patternpairs[9].list = ~va.patternpairs[9].list ++ [[Env.adsr(1.13,1.1,1.8,1.1,curve:0.5)]]
~va.asCompileString
Padd
Paddpre
Psetpre

Pd

(
Pdef(\plopbla2, Pbind(
	\instrument, \noisecomb2,
	//\note, Pseq([[0,7],[1,8],[-1,5]]-2,inf),
	//\note, Pseq([0,7,1,8,-1,5]-2,inf),
	\note, Pseq([[0,7],[1,8],[-1,5]]-2,inf),
	//\note, Pseq([[0,7],[1,8],[-1,5]]-2,inf),
	//\degree, Pseq([0,2,4,1,3,5,7,4,2,6],inf),
	//\degree, Pseq([[0,2,4],1,[3,5,7],4,2,6],inf),
	//\scale, Scale.minor,
	//\note, Pseq([0,1,2,3,4],inf)
	\octave, Pstep(Pseq([3,4],inf),Pseq([5,0.75],inf)),
	\minfreq, 50,
	\decaytime, 1.0,
	\adsr, Pseq([
		[Env.adsr(0.02,0.1,0.8,0.4,curve:0.5)],
		[Env.adsr(0.02,0.1,0.8,0.4,curve:0.5)],
		[Env.adsr(0.02,0.1,0.8,0.4,curve:0.5)],
		[Env.adsr(0.03,0.1,0.8,0.1,curve:0.5)],
		[Env.adsr(0.03,0.1,0.8,0.1,curve:0.5)],
		[Env.adsr(0.03,0.1,0.8,0.1,curve:0.5)],
	],inf),
	\legato, 0.9,
	\ffreq, [500,610,820,140,1100],
	\ffreq, 500,
	//\stretch, 1/4,
	//\ffreqtab, [[0.8,1,1.1,1.2, 2,4,5,6, 8,10].scramble.postln],
	//\ffreqtab, [ 6, 4, 5, 10, 1, 1.2, 0.8, 1.1, 2, 8  ], // also nice
	\ffreqtab, [[ 6, 4, 5, 10, 1, 1.2, 0.8, 0.4, 2, 8  ]],
	\ffreqtab, Pfunc{ [[ 0.1, 0.2, 0.3, 0.5,  1,2,3,8, 10, 12  ].scramble] + rrand(0.01,1.0); },
	//\ffreqtab, Pfunc{ [{rrand(0.01,15.0);  } ! 10 ]},
	//\ffreqtab, [[ 1 ! 10], [0.1]],
	\dur, Pseq([3,1,1, 0.25,0.25,0.25],inf),
	//\dur, Pseq([1,0.25,1, 0.25,0.25,0.25],inf),
	\amp, 0.4,
)).play;
);







(
Pdef(\plopbla, Pbind(
	\instrument, \noisecomb2,
	\note, Pseq([0,4],inf),
	\note, Pseq([0,5,4,3, 0,2,4,3],inf)+[0,7],
	\dur, Pseq([3,1,1, 0.25,0.25,0.25],inf),
	\dur, Pseq([1,0.3],inf),
	//\note, Pseq([0,1,2,3,4],inf)
	\octave, Pstep(Pseq([3,4],inf),Pseq([5,0.75],inf)),
	\octave, 3,
	\minfreq, 50,
	\decaytime, 1.0,
	\adsr, Pseq([
		[Env.adsr(0.02,0.1,0.8,0.2,curve:0.5)],
		//[Env.adsr(0.02,0.1,0.8,0.4,curve:0.5)],
		//[Env.adsr(0.02,0.1,0.8,0.4,curve:0.5)],
		//[Env.adsr(0.03,0.1,0.8,0.1,curve:0.5)],
		//[Env.adsr(0.03,0.1,0.8,0.1,curve:0.5)],
		//[Env.adsr(0.03,0.1,0.8,0.1,curve:0.5)],
	],inf),
	\legato, 0.7,
	//\ffreq, [500,610,820,140],
	\ffreq, 500,
	//\ffreqtab, [[0.8,1,1.1,1.2, 2,4,5,6, 8,10].scramble.postln],
	//\ffreqtab, Pfunc{ [[ 0.1, 0.2, 0.3, 0.5,  1,2,3,8, 10, 12  ].scramble] + rrand(0.01,1.0); },
	//\ffreqtab, [ 6, 4, 5, 10, 1, 1.2, 0.8, 1.1, 2, 8  ], // also nice
	\ffreqtab, [[ 6, 4, 5, 10, 1, 1.2, 0.8, 0.4, 2, 8  ]],
	\amp, 1.1
)).play;
);


(
Pdef(\plop, Pbind(
	\instrument, \osc1,
	\degree, Pseq([0,2,4, 1,3,5, 2,1],inf),
	\scale, Scale.minor,
	\dur, 1/2,
	\amp, 0.1
)).play;
);

(
SynthDef(\mylfo, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, range=1, offset=100;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig.range(100,1000);
	//sig.poll;
	sig = sig * EnvGen.ar(Env.adsr(0.1,0.1,1,0.1),gate,doneAction:2);
	Out.kr(out, sig);
}).add;
)

(
Pdef(\mod, Pbind(
	\instrument, \mylfo,
	\freq, 1,
	\dur, 1/2,
	//\out, ~bus,
	\amp, 0.1
)).play;
);
Pdef(\mod).stop
Ndef(\mod1).play

~bus = Bus.control(s,1)

Pdef(\mod).asMap
Pdef(\plop).map(\ffreq, Pdef(\mod))
Pdef(\plop).set(\ffreq, ~bus.asMap)
Pdef(\plop).map(\ffreq, ~mod.busArg)
Pdef(\plop).unset(\freq, 100)
Pdef(\plop).set(\ffreq, "c1")
Pdef(\plop).set(\ffreq, Ndef(\mod1))
~mod.busArg.dump
~mod.asMapArg

~bus = Bus.control(s,1)
~bus.set(1500)
a = NodeProxy.new
~mod = NodeProxy.control
(

~mod.source = Pbind(
	\instrument, \mylfo,
	\freq, Pseq([1,4],inf),
	\dur, 2,
	//\out, ~bus,
	\amp, 0.1
);
)


(
Ndef(\mod1).awake = true;
Ndef(\mod1, Pbind(

	\instrument, \mylfo,
	\freq, Pseq([1,4],inf),
	\dur, 2,
	//\out, ~bus,
	\amp, 0.1
))
)



a.play
GenericGlobalControl

~lfo = GenericGlobalControl(\lfo, nil, 1, #[0.1, 10000, \exp]);
~lfo.set(1000)
~lfo.watch
~lfo.gui
~lfo.proxy = Pbind(\instrument, \default, \dur, 0.1, \degree, Pseq([0,1],inf))

Pdef(\plop).edit
"GenericGlobalControl".help
Help("GenericGlobalControl").gui
HelpBrowser.
GenericGlobalControl.methods.do(_.postln)
GenericGlobalControl.makeGUI
HelpBrowser.openHelpFor("LFSaw")

Pdef(\plop).set(\ffreq, ~lfo)
Pdef(\plop).set(\ffreq, ~bus.asMap)
Pdef(\plop).umap(\ffreq, ~bus)



g = PdefGui();            // make a PdefGui
g.object = Pdef(\a);        // show when a Pdef is put in
Pdef(\a, Pbind(\note, 12));     // show whether it has a source
Pdef(\a).play;             // show whether playing, stopped, or ended, and pausable
Pdef(\a).set(\dur, 0.25);     // show whether the Pdef has an envir
g.close;

g = PdefGui(Pdef(\a), 30);    // with an envirgui for 3 items
Pdef(\a).set(\lofreq, [1, 10], \str, "someString", \oops, \oneSymbolTooMany);
Pdef(\a).clear;
Pdef(\a).envir.clear;
g.close;
g.front

(                // put it in an existing window - margin is 0@0
w = Window("my win", Rect(200, 200, 300, 200)).front;
w.addFlowLayout;
PdefGui(Pdef(\a), 0, w);
PdefGui(Pdef(\a), 3, w);
)
$

PdefAllGui(16);


(
Pdef(\plop, Pbind(
	\instrument, \default,
	\degree, Pseq([0],inf),
	\dur, 1,
	\amp, 0.1
)).play;
);

Pdef(\plop).stop


TempoClock.default.tempo
1/4/2.55
Mdef.main.model.latency = 0.31
