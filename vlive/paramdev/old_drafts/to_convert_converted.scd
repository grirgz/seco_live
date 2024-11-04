
    ~jorSamples = Array.fill(133,0);
	(
	)
    (
    ~jorSamples = Array.newClear(133);
    ~folder = PathName.new("/Volumes/Samples/Producing/Logic/Creative Files/Jorgalad Sounds/Ambient Sounds/");
     
    ~jorSamples = ~folder.entries.collect({
            arg path;
            Buffer.read(s, path.fullPath);
    });
     
    )


(
	~jorSamples = [
		BufDef(\ukraine, "bruit1/07_ukraine.flac"),
		BufDef(\amen, "vipere/amenbreak.wav"),
		BufDef(\scream, "vipere/scream.flac"),
		BufDef(\moeten, "voices/02_moeten.flac"),
	];

	SynthDef(\source, {
			arg bpm, amp=1, gate=1, rate=0.01, bufnum=0,
			freqshift=0, sliderrate=1, reverb=0.51, out=0;
			var impulsetrigger, env, sig;
			var cutoff;

			cutoff = \cutoff.kr(1000!8);

			//bufnum = BufDef(\amen, "vipere/amenbreak.wav");
	 
			impulsetrigger = Impulse.ar(bpm/60);
			env = EnvGen.kr(Env.adsr(0.01, 0.3, 0.5, 1, 1), gate,doneAction:2);
			sig = BufRd.ar(2, bufnum, Phasor.ar(impulsetrigger, BufRateScale.kr(bufnum) + rate + sliderrate, 0, BufFrames.kr(bufnum)));
	 
			sig = FreqShift.ar(sig, freqshift ,0, 0.5);
			sig = FreeVerb.ar(sig, reverb, 0.8, 0.1);
			sig = LPF.ar(sig, cutoff);
			//sig = SinOsc.ar(400) !2;
			sig.debug("source");
			sig = Pan2.ar(sig, SinOsc.ar(2) * 0.2).flop;
			//sig = Pan2.ar(sig, 0);
			sig.debug("end");
			Out.ar(out, sig * amp * env * 1);
	}, metadata:(specs:(
		cutoff: XArraySpec(\freq ! 8)

	))).add;
	 
	//EffectSynthDef, only for effects and stuff
	 
	SynthDef(\effects, {
			arg amp=1, bpm=1, duration =1, graintrigger=60, in, out=0;
			var impulsetrigger, sig;
			impulsetrigger = Impulse.ar(bpm/60);
			sig = InFeedback.ar(in, 2);
			//sig = GrainIn.ar(2, impulsetrigger, duration, sig);
			sig.debug("fx");
			sig = sig * SinOsc.ar(\freq.kr(400)); 
			sig.debug("fx");
	 
			Out.ar(out, sig * amp);
	 
	}, metadata:(specs:(

	))).add;
	Ndef(\source, \source);
	Ndef(\source).addSpec(\cutoff, XArraySpec(\freq! 8));
	Ndef(\effects, \effects);
	
	~fxplayer = EventPlayerWrapper((
		target: Ndef(\effects),
		label: \effects,
		eventPlay: { arg self;
			BusDef(\fx, \audio,2);
			BusDef(\fx2, \audio,2);
			Ndef(\source).play(BusDef(\fx2).index,2);
			Ndef(\effects).set(\in, BusDef(\fx2));
			Ndef(\effects).play(numChannels:2);
		},

		eventStop: { arg self;
			Ndef(\source).play(0);
			Ndef(\effects).stop(1);
		},

		eventIsPlaying: { arg self;
			self.target.monitor.isPlaying;
		},

	));

~bufnum_spec = MenuSpec(~jorSamples.collect({ arg x,i; i -> x.bufnum }));
Ndef(\source).addSpec(\bufnum, ~bufnum_spec);
//~bufnum_spec = MenuSpec(~jorSamples.collect({ arg x,i; i -> x }));

WindowLayout({

	VLayout(* [
		HLayout(
			PlayerWrapper(Ndef(\source)).asView,
			~fxplayer.asView,
			Slider.new.orientation_(\horizontal).mapParam(Param(Ndef(\source), \bufnum, ~bufnum_spec)),
			StaticText.new.mapParam(Param(Ndef(\source), \bufnum, ~bufnum_spec)),
		),
		StaticText.new.string_(" source").background = ParamView.color_dark,
		ParamGroupLayout.two_panes(Ndef(\source).asParamGroup.select({ arg pa; pa.type != \other }), \property),
		StaticText.new.string_(" effects").background = ParamView.color_dark,
		ParamGroupLayout.two_panes(Ndef(\effects).asParamGroup.select({ arg pa; pa.type != \other }), \property),
	])
	
});
)

Param(Ndef(\source), \bufnum, MenuSpec(~jorSamples.collect({ arg x,i; i -> x }))).edit
MenuSpec(~jorSamples.collect({ arg x,i; i -> x })).map(1)
~bufnum_spec.map(0.5)
~bufnum_spec.map(0.51)
~jorSamples

Ndef(\source).set(\bufnum, ~jorSamples[0].bufnum)
Ndef(\source).set(\bufnum, 0)

Ndef(\source).numChannels
Ndef(\source).play(numChannels:2)
Ndef(\source).play
Ndef(\source).play(0)
Ndef(\source).numChannels
Ndef(\source).monitor.numChannels
Ndef(\source, { SinOsc.ar(300)!2  })
Ndef(\source).clear

{ SinOsc.ar(200) ! 2 * 0.1}.play;
BusDef(\fx).numChannels
BusDef(\fx)
(
);
Ndef(\effects).stop
Ndef(\source).clear
Ndef(\source).stop
Ndef(\effects).clear
Ndef(\effects).edit
Ndef(\effects).asParamGroup.edit
ParamGroup(Ndef(\effects).asParamGroup.select({ arg pa; pa.type != \other })).edit
ParamGroup(Ndef(\source).asParamGroup.select({ arg pa; pa.type != \other })).edit

(
)


(
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);





(
WindowLayout({
		~gridlayout = GridLayout.rows(*
			[
				Param(Ndef(\source), \amp),
				Param(Ndef(\source), \freq),
			].collect({ arg param;
				[
					param.asStaticTextLabel,
					param.asSlider.orientation_(\horizontal),
					param.asTextField,
				]
			})
		);
		~gridlayout.setColumnStretch(0,2);
		~gridlayout.setColumnStretch(1,6);
		~gridlayout.setColumnStretch(2,2);
	
})
)



MKtl.find;
MKtl('pr2');
a = MKtl('pcr0');
a.explore
a.gui
k = MKtl('nnkn20');
k.gui
k = MKtl(\mcrk)
k = MKtl(\bcf2000)
MKtl.allDescriptions.keys
MKtl.postLoadableDescs
MKtl.openDescriptionFolder
k = MKtl('midi_12_a_pr', 'midi_12_a_pro_port_1')
k.gui
k = MKtl(\microKEY)
k = MKtl(\mk2, "korg-microkey")
k.gui
k
k = MKtl(\, "korg-microkey")



MKtl.postLoadableDescs;
MKtl.postLoadedDescs;
MKtl.descFolders;
MKtl.openDescFolder(0);
MKtl.loadDescsMatching("*microkey");
