
~t = 105/2/60; TempoClock.default.tempo = ~t;

(
Ndef(\randfm, { arg pan=0, amp=0.1, freqratio=1, ratio=0.9, rel=0.1, impfreq=1;
	var sig;
	var fun = { arg x; 
		SinOsc.ar(rrand(0.1,1000.0) * [0.99,1.01] * freqratio * ( x * ratio + 1 ) ) 
		* EnvGen.kr(Env([0,1,0],[0.1,rel]), Impulse.kr(rrand(1,16)/2 * ~t));
	};
	sig = DC.ar(0);
	16.do {
		sig = fun.(sig);
	};
	sig = sig * 0.5;
	sig = sig * amp;
	sig = sig * \gain.kr(1);
	//sig = Pan2.ar(sig, pan, amp);
});
Ndef(\randfm).addSpec(\rel, ControlSpec(0.01,2,\lin), \ratio, ControlSpec(0.01,20,\lin));

Tdef(\initrandfm, {

	~players = 3.collect { arg idx;
		0.05.wait;
		4.collect { arg idx2;
			0.05.wait;
			Ndef(\player+++idx+++idx2).source_(Ndef(\randfm).source);
		};
	};
	nil
}).play;

~set_randfm_chords = {

	~players.flat.do({ arg p;
		p.quant = 2;
		p[10] = \pset -> Pbind(
			//\instrument, \default,
			\freqratio, Pseq([0,0,-1,-2],inf).midiratio,
			\dur, 1,
			\gain, Pseq([1,0.2,0.6,0.5, 1,1,1,1].scramble,inf),
		)

	});
};

WindowDef(\meter, { arg def, player = Ndef(\zed);
	VLayout (
		HLayout (
			PlayerWrapper(player),
			Button.new.string_("Rebuild").action_({
				player[0] = player.source
			})
		),
		HLayout (
			player.asParamGroup.asView,
			SimpleServerMeterView(nil,0,2,player.bus).asView
		)
	)
});

WindowDef(\MeterFader, { arg def, bus;
	var meterin = SimpleServerMeterView(nil, 0,2, bus ? 0);
	var slider = Slider.new.orientation_(\vertical).background_(Color.clear);
	StackLayout(
		slider, 
		meterin.view,
	).mode_(\stackAll)
		.addUniqueMethod(\slider, { slider })
		.addUniqueMethod(\meter, { meterin });
});

~b = ProtoDef(\BankSequencer);
~b.bank = ~b.bank ?? { { { PstepSeq(true!16) }.dup(3) }.dup(8) };
~b.mainSeq = ~b.mainSeq ?? { PstepSeq(0!16,inf) };

WindowDef(\BankSequencer, { arg def, kit;
	var bank = ProtoDef(\BankSequencer);
	var seqview = View.new;
	var mainseqview = View.new;
	var idxpopup = Param(bank, \currentIndex, ).asIndexPopUpMenu(TagSpec(bank.bank.size.collect({ arg x; "pat "++x -> x })));
	//kit.source.list.collect({ arg drum, idx;
		//drum.at(\isRest).source =  Pindex(bank.bank.flop[idx], bank.mainSeq.trace(prefix:"main")).loop.trace(prefix:idx);
	//});
	idxpopup.addAction({
		seqview.layout = VLayout (
			* bank.bank[idxpopup.value].collect({ arg seq;
				Param(Message(seq), \list, ParamArraySpec(ParamBoolSpec(true))).asMultiSlider.attachOverlayMenu
			}).asArray;
		)
	});
	idxpopup.valueAction = 0;
	
	VLayout (
		PlayerWrapper(kit),
		idxpopup,
		 [
			seqview,
			stretch:1,
		],
		[
			Param(Message(bank.mainSeq), \list, ParamArraySpec( ControlSpec(0,bank.bank.size-1,\lin,1,0))).asMultiSlider.attachOverlayMenu,
			stretch:1,
		]
	);

	
});

WindowDef(\multi, { arg def, players;
	HLayout (
		GridLayout.columns(
			* players.collect { arg playerlist, idx;
				playerlist.collect { arg player, idx2;
					WindowDef(\meter).asView(player)
				}
			}
		),
		VLayout (
			WindowDef(\BankSequencer).asView(Pdef(\kit1)),
			WindowDef(\SampleSeq).asView,
			nil
		)
	)
});

	Pdef(\kitplayer, { arg index;

		topEnvironment.use {

			Ppar([
				PbindProxy(
					\instrument, \playersec,
					\bufnum, ~buflib.kick[1010].value,
					//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
					\bufnum, ~buflib.kick[1472].value,
					\isRest, Pseq([
						1,0,1,0,
					]+0.0,inf).coin.not,
					\isRest, ProtoDef(\BankSequencer).bank[index][0],
					\dur, 1/8,
					\gain, 0.1,
				),
				PbindProxy(
					\instrument, \playersec,
					//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
					\bufnum, ~buflib.hat[1064].value,
					\isRest, Pseq([
						1,1,1,1,
					],inf).coin.not,
					\isRest, ProtoDef(\BankSequencer).bank[index][1],
					\dur, 1/8,
					\gain, 0.1,
				),
				PbindProxy(
					\instrument, \playersec,
					\bufnum, ~buflib.snare[1719].value,
					//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
					\bufnum, ~buflib.snare[1730].value,
					\isRest, Pseq([
						0,0,1,0,
					],inf).coin.not,
					\isRest, ProtoDef(\BankSequencer).bank[index][2],
					\dur, 1/8,
					\gain, 0.1,
				),

			])
		}
	} );

Pdef(\kit1, 
	Pbind(
		\type, \phrase,
		\instrument, \kitplayer,
		\legato, 1,
		\index, Plazy({ arg ev;
			ProtoDef(\BankSequencer).mainSeq
		}).loop,
		\dur, 2,
		\amp, 0.1,
	)
);

	Pdef(\part2,
		Ppar([
			Pbindef(\pigs,
				\instrument, \playersec,
				\bufnum, BufDef('loop/pigs.flac'),
				\legato, 1,
				\st, ( 92.20/4/60 ) ,
				\speed, 1/2 * Pkeyd(\speedStep, 1) * ~t/ Pkey(\st) ,
				//\posStep, PstepSeq((0..15),inf),
				\pos, ( Pkey(\posStep)/Pkey(\st)/4 ).trace,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\isRest, Pseq([
					1,1,1,1,
				],inf).coin.not,
				\dur, 1/2,
				\gain, 1.01,
				\out, BusDef(\comp, \audio),
			)
			<> Pbindef(\sequencer, \dummy, 1),
			Pmono(\simplecomp,
				\inbus, BusDef(\comp, \audio),
				\addAction, \addToTail,
				\lag, 0.0005,
				\cpt, 0.1,
				\pregain, 1,
				\cpabove, 0.01,
				\cpbelow, 1,
				\cpclamp, 0.01,
				\cprelax, 0.1,
				\gain, 1,
				\dur, 1,
			),
		]),
	);

);

WindowDef(\multi).front(~players)
~set_randfm_chords.();

Pbindef(\sequencer, \speedStep, PstepSeq(1!16,inf))
Pbindef(\sequencer, \posStep, PstepSeq((0..15),inf))
Pdef(\pigs).clear;

(
WindowDef(\SampleSeq, { arg def, param;
	var mslider;
	param = Param(Message( Pdef(\sequencer).source.at(\posStep).source ), \list, ControlSpec(0,15,\lin,1,0));
	mslider = param.asMultiSlider;
	VLayout (
		PlayerWrapper(Pdef(\part2)),
		mslider,
		Param(Message( mslider ), \size, ControlSpec(1,16,\lin,1,1)),
		Param(Message( Pdef(\sequencer).source.at(\speedStep).source ), \list, ControlSpec(-4,4,\lin,0,1)).asMultiSlider.attachOverlayMenu,
	)
}).front();
);



//////////////////////////
(
Ndef(\zed, { arg pan=0, amp=0.1, freqratio=1, ratio=0.9, rel=0.1, impfreq=1;
	var sig;
	var fun = { arg x; 
		SinOsc.ar(rrand(0.1,1000.0) * freqratio * ( x * ratio + 1 ) ) 
		* EnvGen.kr(Env([0,1,0],[0.1,rel]), Impulse.kr(rrand(1/8,8) * impfreq));
	};
	sig = DC.ar(0);
	16.do {
		sig = fun.(sig);
	};
	sig = Pan2.ar(sig, pan, amp);
}).play;
Ndef(\zed).addSpec(\rel, ControlSpec(0.01,2,\lin), \ratio, ControlSpec(0.01,20,\lin))
);

Ndef(\zed).edit
Ndef(\zed).send
Ndef(\zed).edit

Ndef(\zed2, Ndef(\zed))

(
	Tdef(\bla, {

		~players = 3.collect { arg idx;
			0.05.wait;
			4.collect { arg idx2;
				0.05.wait;
				Ndef(\player+++idx+++idx2).source_(Ndef(\zed).source);
			};
		};
		nil
	}).play;
)

~players.flat.do(_.set(\freqratio, 1*1.3))
(
~players.flat.do({ arg p;
	p.quant = 2;
	p[10] = \pset -> Pbind(
		\instrument, \default,
		\freqratio, Pseq([0,0,-1,-2],inf).midiratio,
		\dur, 1,
		\amp, 0.1,
	)

})
)

(
)

(

)

(
);

(
);

(
)


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1472].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
			]+0.2,inf).coin.not,
			\dur, 1/8,
			\gain, 0.3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[1730].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.31,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1472].value,
			\isRest, Pseq([
				1,0,1,0,
			]+0.0,inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[1730].value,
			\isRest, Pseq([
				0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\kit1, 
	Ppar([
		PbindProxy(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1472].value,
			\isRest, Pseq([
				1,0,1,0,
			]+0.0,inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		PbindProxy(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[805].value,
			\isRest, Pseq([
				1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		PbindProxy(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[1730].value,
			\isRest, Pseq([
				0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		
	])
)).play;
);


(
Pdef(\kit1, 
	Pbind(
		\type, \phrase,
		\instrument, \kitplayer,
		\legato, 1,
		\index, Plazy({ arg ev;
			ProtoDef(\BankSequencer).mainSeq
		}).loop,
		\dur, 2,
		\amp, 0.1,
	)
).play;
);



