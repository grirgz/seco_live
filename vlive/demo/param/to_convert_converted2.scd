
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
	 
	ProxyChain.add(\fx1, \filter -> {
			arg in, amp=1, bpm=1, duration =1, graintrigger=60, out=0;
			var impulsetrigger, sig;
			var sigin;
			impulsetrigger = Impulse.ar(bpm/60);
			//sig = sigin = InFeedback.ar(in, 2);
			sig = sigin = in;
			//sig = GrainIn.ar(2, impulsetrigger, duration, sig);
			sig.debug("fx");
			sig = sig * SinOsc.ar(\freq.kr(400)); 
			sig.debug("fx");

			sig = SelectX.ar(\mix.kr(0.5), [sig, sigin]);
	 
			sig;
	});

	ProxyChain.add(\inReader, { arg in;
		InFeedback.ar(in,2);
	});


	Ndef(\source, \source);
	Ndef(\source).addSpec(\cutoff, XArraySpec(\freq! 8));
	Ndef(\effects, \effects);
	ProxyChain(\pc, [\inReader, \fx1]);
	
	~fxplayer = EventPlayerWrapper((
		target: ProxyChain(\pc).proxy,
		label: \effects,
		eventPlay: { arg self;
			BusDef(\fx, \audio,2);
			BusDef(\fx2, \audio,2);
			//Ndef(\effects) <<>.in Ndef(\source);
			//Ndef(\effects).play(numChannels:2);
			Ndef(\source).play(BusDef(\fx));
			ProxyChain(\pc).proxy.set(\in, BusDef(\fx));
			ProxyChain(\pc).play;
		},

		eventStop: { arg self;
			if(Ndef(\source).isPlaying) {
				Ndef(\source).play(0);
			};
			//Ndef(\effects).stop(1);
			self.target.stop(1);
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

Ndef(\source).play(0,2)
Ndef(\source).play(Bus)
Ndef(\source).clear
Ndef(\effects).clear
Ndef(\source).stop
Ndef(\source).isPlaying

ProxyChain(\pc).get(\in)
ProxyChain(\pc).proxy.get(\duration)
ProxyChain(\pc).proxy.get(\in)
ProxyChain(\pc).gui
ProxyChain(\pc).stop
ProxyChain(\pc).play

IProxyChain(\bla, [ Ndef(\flanger), Ndef(\phaser), Ndef(\dist) ]).inBus_(BusDef(\bla))
IProxyChain.setOrder([0,2,1])
IProxyChain.setOrder([0,2,1])
IProxyChain.disableLink(0)
IProxyChain.enableLink(0, true);
IProxyChain.isLinkEnabled(0)
IProxyChain.inBus_(BusDef(\bla));
IProxyChain.add(Ndef(\bla));
IProxyChain.insert(Ndef(\bla));
IProxyChain.remove(Ndef(\bla));
IProxyChain.removeAt(0);
-route
Spec.add(\inBus)
\inBus.

(

)

(

	~iProxyChain.new(\bla, [Ndef(\fx1), Ndef(\fx2), Ndef(\fx3)]);
	~iProxyChain.new(\bla).inBus = BusDef(\fxbus1, \audio, 2);
	~pc = ~iProxyChain.new(\bla);

	Ndef(\fx1, { arg inBus;
		var sig, sigin;
		sig = sigin = InFeedback.ar(inBus,2);
		sig = sig * SinOsc.ar(\ringfreq.kr(250));
		sig = SelectX.ar(\mix.kr(0.5), [sigin, sig]);
		sig;
	});
	Ndef(\fx2, { arg inBus;
		var sig, sigin;
		sig = sigin = InFeedback.ar(inBus,2);
		sig = sig * SinOsc.ar(\amfreq.kr(4) + SinOsc.ar(1/1.2).range(0,4) ).unipolar ;
		sig = SelectX.ar(\mix.kr(0.5), [sigin, sig]);
		sig;
	});
	Ndef(\fx3, { arg inBus;
		var sig, sigin;
		sig = sigin = InFeedback.ar(inBus,2);
		//sig = sig + SinOsc.ar(80, mul:0.1+ sig);
		//sig = sig + SinOsc.ar(80, mul: 0.1);
		//sig = sig * SinOsc.ar(720); 
		sig = sig + DelayL.ar(sig, 0.4,\delay.kr(0.4));
		sig = SelectX.ar(\mix.kr(0.5), [sigin, sig]);
		//\mix.kr.poll;
		//sig = sigin;
		sig;
	});

	SynthDef(\yapi, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
		var sig;
		sig = LFSaw.ar(freq);
		sig = sig * SinOsc.ar(freq * ( ( (0..7)/7 - 0.5 * \spreadfac.kr(2) ) + 1 )); 
		sig = RLPF.ar(sig, \lpf.kr(7200), \rq.kr(0.5));
		sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
		sig = Pan2.ar(sig, pan, amp).flop;
		Out.ar(out, sig);
	}).add;

	Pdef(\plop, Pbind(
		\instrument, \yapi,
		\degree, Pseq([0,1,4,5],inf),
		\dur, Pkeyd(\dur, 1/2),
		\legato, Pkeyd(\legato, 0.3),
		\amp, Pkeyd(\amp,0.1),
		\out, BusDef(\fxbus1),
	)).play;
	Pdef(\plop).addHalo(\instrument, \yapi);

	~fxblock = { arg name, player, mixparam, pg;
		VLayout(
			HLayout(
				//player.asView, //.background_(ParamView.color_dark);
				~onoff.(player),
				//StaticText.new.string_(name).background_(ParamView.color_dark),
				StaticText.new.string_(name),
				mixparam.asSlider.orientation_(\horizontal).background_(ParamView.color_dark),
			//).spacing_(0),
			),
			ParamGroupLayout.two_panes(pg, \property)
		);
	};

	~onoff = { arg player;
		var p = PlayerWrapperView(player);
		var view = p.view;
		p.states = { [
			["Off", Color.gray, Color.white],
			["On", Color.black, Color.white], 
		] };
		p.button.fixedSize = 30@20;
		p.button.background_(ParamView.color_dark);
		view;
	};

	WindowLayout({
		var sourcegroup = Pdef(\plop).asParamGroup.select({ arg x; x.property != \inBus });
		VLayout(
			VLayout(*
				[ 
					~fxblock.(\plop, PlayerWrapper(Pdef(\plop)), Param(Pdef(\plop), \amp, \unipolar), sourcegroup),
					PlayerWrapper(~pc).asView,
				]
				++
				~pc.slots.collect({ arg proxy, i;
					var group = proxy.asParamGroup.select({ arg x; 
						[\inBus, \mix].includes(x.property).not
					});
					~fxblock.(proxy.key, PlayerWrapper(~pc.enabledLinkParam(i)), Param(proxy, \mix, \unipolar), group);
				})
			),
			nil
		)
		
	});

	//{
	//	~iProxyChain.new(\bla).updateRouting;
	//}.defer(2);








)

Param.freeAllSimpleControllers
			Object.new.label

PlayerWrapper(Pdef(\plop)).label
PlayerWrapper(Pdef(\plop)).target
PlayerWrapper(Pdef(\plop)).wrapper
PlayerWrapper(Pdef(\plop)).play
PlayerWrapper(Pdef(\plop)).stop
PlayerWrapper(Pdef(\plop)).isPlaying
PlayerWrapper(Pdef(\plop)).wrapper.isPlaying
PlayerWrapper(Pdef(\plop)).wrapper.target.isPlaying
PlayerWrapper(Pdef(\plop)).target.isPlaying
Pdef(\plop).isPlaying

PlayerWrapper((label: {"plop"})).label.asCompileString
PlayerWrapper(Pdef(\plop)).label ++ "p"
PlayerWrapper(Pdef(\plop)).label
PlayerWrapper(Ndef(\fx1)).label.asCompileString
PlayerWrapper(~pc).label
PlayerWrapper(Param(Pdef(\plop), \bla)).label.asCompileString

Object.new.isPlaying
Object.new.stop

(
Pdef(\plop, Pbind(
	\instrument, \default,
	\degree, Pseq([0],inf),
	\dur, 1,
	\amp, 0.1
)).play;
);

Ndef(\fx1).send
Ndef(\fx2).send
Ndef(\fx3).send

~iProxyChain.new(\bla).updateRouting
~iProxyChain.new(\bla).monitor.play
~iProxyChain.new(\bla).monitor.set(\inBus, Ndef(\fx3).bus)

///////////////////////////////////

Ndef(\fx1).clear;
Ndef(\fx2).clear;
Ndef(\fx3).clear;

(
	if(~inbus.isNil) {
		~inbus = Bus.audio(s,2);
	};

	Ndef(\fx1, { arg inBus;
		var sig, sigin;
		sig = sigin = InFeedback.ar(inBus,2);
		sig = sig * SinOsc.ar(200);
		sig = SelectX.ar(\mix.kr(0.5), [sigin, sig]);
		sig;
	});
	Ndef(\fx2, { arg inBus;
		var sig, sigin;
		sig = sigin = InFeedback.ar(inBus,2);
		sig = sig * SinOsc.ar(4 + SinOsc.ar(1/1.2).range(0,4) ).unipolar ;
		sig = SelectX.ar(\mix.kr(0.5), [sigin, sig]);
		sig;
	});
	Ndef(\fx3, { arg inBus;
		var sig, sigin;
		sig = sigin = InFeedback.ar(inBus,2);
		//sig = sig + SinOsc.ar(80, mul:0.1+ sig);
		//sig = sig + SinOsc.ar(80, mul: 0.1);
		//sig = sig * SinOsc.ar(720); 
		sig = sig + DelayL.ar(sig, 0.4,0.4);
		sig = SelectX.ar(\mix.kr(0.5), [sigin, sig]);
		\mix.kr.poll;
		//sig = sigin;
		sig;
	});
	Ndef(\final, { arg inBus, mix;
		var sig, sigin;
		sig = sigin = InFeedback.ar(inBus,2);
		//sig = sig + SinOsc.ar(80, mul:0.1+ sig);
		//sig = sig + SinOsc.ar(80, mul: 0.1);
		sig;
	});

	Pdef(\plop, Pbind(
		\instrument, \yapi,
		\degree, Pseq([0,1,4,5],inf),
		\dur, 1,
		\legato, 0.2,
		\amp, 0.1,
		\out, ~inbus.index,
	)).play;


	//Ndef(\fx1).set(\inBus, ~inbus.index);
	//Ndef(\fx2).set(\inBus, Ndef(\fx1).bus);
	//Ndef(\fx3).set(\inBus, Ndef(\fx2).bus);
	//Ndef(\final).set(\inBus, Ndef(\fx3).bus);
	//Ndef(\final).play;
);
	(
	WindowLayout({
		VLayout(
			HLayout(
				PlayerWrapper(Pdef(\plop)).asView
			),
			VLayout(*
				[\fx1, \fx2, \fx3].collect({ arg proxy;
					proxy = Ndef(proxy);
					ParamGroupLayout.block(proxy.key, proxy.asParamGroup.select({ arg x; x.property != \inBus }))
				})
			),
			nil,
		)
		
	})
	)

	Ndef(\fx3).edit
	Ndef(\fx3).set(\mix, 0)

	(
	Ndef(\fx2).set(\inBus, ~inbus.index);
	Ndef(\fx1).set(\inBus, Ndef(\fx2).bus);
	Ndef(\fx3).set(\inBus, Ndef(\fx1).bus);
	Ndef(\final).set(\inBus, Ndef(\fx3).bus);
	Ndef(\final).play;
	)

	(
	Ndef(\fx3).set(\inBus, ~inbus.index);
	Ndef(\fx2).set(\inBus, Ndef(\fx3).bus);
	Ndef(\fx1).set(\inBus, Ndef(\fx2).bus);
	Ndef(\final).set(\inBus, Ndef(\fx1).bus);
	Ndef(\final).play;
	)

	(
	Ndef(\fx3).set(\inBus, ~inbus.index);
	Ndef(\fx2).set(\inBus, Ndef(\fx3).bus);
	Ndef(\fx1).set(\inBus, Ndef(\fx2).bus);
	~np.set(\inBus, Ndef(\fx1).bus);
	~np.play;
	)

	(
	Ndef(\fx1).set(\inBus, ~inbus.index);
	Ndef(\fx2).set(\inBus, Ndef(\fx1).bus);
	Ndef(\fx3).set(\inBus, Ndef(\fx2).bus);
	~np.set(\inBus, Ndef(\fx3).bus);
	~np.play;
	)
	~np = NodeProxy.new.source_({ arg inBus; InFeedback.ar(inBus, 2); })
	Param.freeAllSimpleControllers

	~np.stop
	~np.play

	Ndef(\final).stop;
	Ndef(\final).play;
	Ndef(\fx3).stop;
	Ndef(\fx3).play;
	Ndef(\fx2).play;
	Ndef(\fx2).stop;
	Ndef(\fx1).stop;

///////////////////////////////////


~iProxyChain.new(\bla).proxyOrder_([2,1,0])
~iProxyChain.new(\bla).resetOrder
~iProxyChain.new(\bla).proxyOrder
~iProxyChain.new(\bla).updateRouting
~iProxyChain.new(\bla).monitor.get(\inBus)
~iProxyChain.new(\bla).monitor.set(\inBus, BusDef(\fxbus1));
~iProxyChain.new(\bla).monitor.set(\inBus, Ndef(\fx3).bus);
~iProxyChain.new(\bla).monitor.play(0,2)
~iProxyChain.new(\bla).monitor.stop
Ndef(\fx1).stop
Ndef(\fx1).play
Ndef(\fx2).stop
Ndef(\fx2).play
Ndef(\fx3).stop
Ndef(\fx3).play;
Ndef(\fx3).play(Ndef(\fx3).bus)
~iProxyChain.new(\bla).monitor.group.moveNodeToTail(GroupDef(\mygroup))
~iProxyChain.new(\bla).monitor.group.moveNodeToTail(Group(s))
s.defaultGroup.moveNodeToTail(~iProxyChain.new(\bla).monitor.group)
Group(s)
s
Group
Ndef(\fx3).stop

NdefRouter(
	Sources Ndef,
	Effects Ndef,
)

NdefRouter(
	number of in bus,
	Effects Ndef,
)

NdefRouter(
	number of in bus,
	number of out bus,
)

NdefRouter.setFxOrder([1,0,2,3])
NdefRouter.addFx(Ndef(\plop))
NdefRouter.addSource(Ndef(\bla))
NdefRouter.addSource(BusDef(\rah))

views:
- onoff sources + onoff effects in fixed stack
- onoff sources + onoff effects + specify custom stack order
- routing matrix
- provide mix parameter
