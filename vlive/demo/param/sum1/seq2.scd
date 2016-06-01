

//////////////////////////// StepNoteEvent (isRest/isRest.coin.not, dur, legato/sustain)
// SeqEventView ?

ParamProto.init

(
Pdef.defaultQuant = 4;
EnvInit(\kick2_step, StepEvent.new);
~kick2_step.addHalo(\instrument, \dr_kick);
Pdef(\kick2, 
	~kick2_step <>
	Pbind(
	\instrument, \dr_kick,
	\degree, Pseq([0],inf),
	\dur, 1/8,
	\amp, Pkeyd(\amp,0.1),
)).play;
Pdef(\kick2).addHalo(\instrument, \dr_kick);
);


~kick2_step
(

WindowDef(\step, {
	~stepEventCoinView.new(~kick2_step).asView
}).front
)

(

WindowDef(\step, {
	StepListView.new(~kick2_step)
}).front
)



(
~stepEventCoinView.new(~kick2_step).edit;
)


~stepEventCoinView.new(~kick2_step)

~kick2_step[\isRest] = ~kick2_step[\isRest] ? 1
~kick2_step[\isRest] = nil

nil ?? { "wtf" }
nil ? "wtf"
StepList.new[1,1,1,1]
StepList[1,1,1,1]

/////////////////////////////////// multitrack

(
Ndef.defaultQuant = 4;
Pdef.defaultQuant = 4;

Ndef(\popop, { arg freq=70, pan=0, amp=0.1;
	var sig;
	var imp = Impulse.kr(16 * TempoClock.default.tempo);
	sig = SinOsc.ar(freq * [1,2]);
	freq = freq * EnvGen.kr(Env([4,1,0.1],[0.1,0.018]), Impulse.kr(16));
	sig = sig + LFSaw.ar(freq * [1,1.0001,2]);
	sig = LPF.ar(sig, 700 * SinOsc.kr(1).range(2,1)) + LPF.ar(sig, 7000, mul:0.1);
	//sig = sig * SinOsc.kr(16).range(0,1);
	sig = sig * EnvGen.kr(Env([0,1,0],[0.0001,0.018]), imp);
	sig = Pan2.ar(sig, pan, amp).flop;
});

Ndef(\hi, { arg freq=770, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = [235,245,520,700,1400]/235 * \freqfac.kr(1) + 1 * freq;
	sig = SinOsc.ar(freq * ( 1 + ( SinOsc.kr(8 * [1,2,4 * SinOsc.kr(1/4).range(0,1)]) * 4 ))) ;
	sig = sig * SinOsc.kr(2).range(0,1);
	sig = sig * LFPulse.kr(1/2, 0,0.8).range(0.1,1).lag(0.1);
	sig2 = LFSaw.ar(freq * ( 1 + ( SinOsc.kr(48 * [1,2,4 * SinOsc.kr(1/4).range(0,1)]) * 4 ))) ;
	sig2 = HPF.ar(sig2, 1000 * SinOsc.kr(1/8).range(0,1));
	sig2 = LPF.ar(sig2, 10000 * SinOsc.kr([1,2.5,1/4]).range(0.01,1));
	sig = sig + sig2;
	sig = sig * LFPulse.kr(8, 0,0.8).range(0.1,1).lag(0.1);
	sig = sig * LFPulse.kr(1/4 * [1,1/8], 0,0.9).range(0.1,1).lag(0.1);
	sig = HPF.ar(sig, 1000);
	sig = Pan2.ar(sig, pan, amp).flop;
});

Pdef(\kick, Pbind(
	\instrument, \dr_kick,
	\degree, Pseq([0],inf),
	\dur, Pkeyd(\dur, 1),
	\amp, Pkeyd(\amp,0.1),
));
Pdef(\kick).addHalo(\instrument, \dr_kick);

Pdef(\kick2, 
	Pbind(
	\instrument, \dr_kick,
	\degree, Pseq([0],inf),
	\dur, 1/8,
	\amp, Pkeyd(\amp,0.1),
));
Pdef(\kick2).addHalo(\instrument, \dr_kick);
);


(
	~sequencer = (
		all: {PresetDictionary.new(\Sequencer)},
		new: { arg self, key, instrs;
		
			if(self.all[key].isNil) {
				self = self.deepCopy;
				self.instrs = instrs;
				self.playerWrapper;
				self.coins = IdentityDictionary.new;
				self.players = IdentityDictionary.new;
				self.populate_tracks;
				self.key = key;
				self.all[key] = self;

			} {
				self = self.all[key];
				self.instrs = instrs;
				self.populate_tracks;
			};
			
			self;
		},

		populate_tracks: { arg self;
			self.instrs.do ({ arg instr;
				var key = self.get_instr_key(instr);
				instr.debug("populate_tracks");
				self.coins[key] = self.coins[key] ? StepEvent.new;
				self.players[key] = self.players[key] ? EventPatternProxy.new;
				self.players[key].addHalo(\label, key);
				self.players[key].source = self.coins[key].asPattern.loop <> instr
			})
		},

		get_instr_playerWrapper: { arg self, instr;
			PlayerWrapper(self.players[self.get_instr_key(instr)]);
		},

		show_track_editor: { arg self, instr;
			var playerWrapper = self.get_instr_playerWrapper(instr);
			instr.debug("show_track_editor", "yo");
			WindowDef(playerWrapper.label, {
				"ca swin".debug;
				VLayout(
					VLayout (
						HLayout(
							playerWrapper.asView,
							XSimpleButton.new.label_("main").action_({
								WindowDef(\main_editor).front
							}).maxWidth_(50)
						),
						ParamGroupLayout.block(playerWrapper.label, instr.asParamGroup),
					),
					[nil, stretch:1],
				)
			}).front
		},

		asView: { arg self;
			VLayout (
				GridLayout.rows (
					*self.instrs.collect { arg track;
						var playerWrapper = PlayerWrapper(self.players[self.get_instr_key(track)]);
						var stepEvent = self.coins[self.get_instr_key(track)];
						var playerWrapperView = PlayerWrapperView(playerWrapper);
						var playerWrapperViewAsView = playerWrapperView.layout;
						playerWrapperView.button.mouseDownAction_({arg view, x, y, modifiers, buttonNumber, clickCount;
							if(buttonNumber == 1) {
								[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
								self.show_track_editor(track);
								"hinn".debug;
							}
						});
						stepEvent.debug("stepEvent", track);
						[
							//StaticText.new.string_(playerWrapper.label),
							playerWrapperViewAsView,
							~stepEventCoinView.new(stepEvent).asView,
						]
					}
				),
				nil
			)
		},

		edit: { arg self;
			var window = Window.new;
			var layout;
			layout = self.asView;
			window.layout = layout;
			//window.alwaysOnTop = true;
			window.front;
		},

		get_instr_key: { arg self, instr;
			PlayerWrapper(instr).label.asSymbol;
		},
	);

	WindowDef(\yep, {
		~sequencer.new(\myseq1, [Pdef(\kick), Pdef(\kick2)]).asView;
	}).front;
)
~sequencer.all.clear;

~sequencer.new(\myseq1, [Pdef(\kick), Pdef(\kick2)]).edit
~sequencer.new(\myseq1, [Pdef(\kick), Pdef(\kick2)]).coins
~sequencer.new(\myseq1, [Pdef(\kick), Pdef(\kick2)]).populate_tracks
~sequencer.new(\myseq1, [Pdef(\kick), Pdef(\kick2)]).players[\kick].source.asCompileString
~sequencer.new(\myseq1, [Pdef(\kick), Pdef(\kick2)]).coins[\kick]
~sequencer.new(\myseq1, [Pdef(\kick), Pdef(\kick2)]).coins
~sequencer.new(\myseq1, [Pdef(\kick), Pdef(\kick2)]).all
~sequencer.new(\myseq1, [Pdef(\kick), Pdef(\kick2)]).coins[\kick].asPattern.asStream.nextN(10,Event.default)
(~sequencer.new(\myseq1, [Pdef(\kick), Pdef(\kick2)]).coins[\kick].asPattern <> Pdef(\kick)).play
(~sequencer.new(\myseq1, [Pdef(\kick), Pdef(\kick2)]).coins[\kick].asPattern <> Pdef(\kick)).play

~sequencer.new.all
~sequencer.all
PresetDictionary(\Sequencer)


(
Ndef(\plop)[0] =  
	Pbind(
		\instrument, \default,
		\degree, Pseq((-4..0).mirror1,inf),
		\dur, 1/8,
		\amp, 0.1
	);
);
Ndef(\plop).play
(
Ndef(\plop)[1] = \filter -> { arg in;
	var sig;
	sig = in + CombL.ar(in, 0.3,0.0003 * [1,2,3,4,5] 
		* SinOsc.kr((1..5)).range(0.7,1)
		* SinOsc.kr(1/8).range(0.7,2) 
		,0.1 *  SinOsc.kr((1..5)).range(0,2) );
}
)
(
Ndef(\plop)[2] = \filter -> { arg in;
	var sig = in;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig1 = (sig * 100 * SinOsc.kr([1,3,4,2,5]/40).range(0,1)).tanh/7;
	sig = SelectX.ar(\f2mix.kr(0), [sig, sig1]);
	sig = Splay.ar(sig, \spread.kr(0.8), 1, \pan.kr(0));
}
)
(
Ndef(\plop)[20] = \set -> Pbind(
	\f2mix, Pseq([1,0,1,0,1,1,1,1],inf),
	\dur, 1/8,
);
)

Ndef(\plop).unset(\amp)
PlayerWrapperView(Pdef(\kick)).button
PlayerWrapperView(Pdef(\kick))
PlayerWrapperView(Pdef(\kick)).model

~p = PlayerWrapper(Pdef(\kick))
~pv = PlayerWrapperView(~p)
~pv.button
~pv.layout
~p.label
~pv.model.label
~pv.model.target
~pv.model.wrapper
~se


