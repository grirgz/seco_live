
///////////////// parbank



///////////////// next level:
// + add repeat
// + track selector and common display for stepCount and repeat
// - mixer
// - insert fx
// + stepseq instr parameters
// - envtimeline instr parameters
// - multiple instr in one track
// - copy/paste score
// - support for Ndef

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
	ParamProto.init(true);
);

		PresetDictionary.new(\full_sequencer)
		PresetDictionary.new(\full_sequencer).clear;
		IdentityDictionary
	ParamProto.init;
		PresetDictionary.new(\full_sequencer).clear;
(
		//PresetDictionary.new(\full_sequencer).clear;
		PresetDictionary.new(\full_sequencer).debug("WTF");

	~track_score = (
		new: { arg self;
			self = self.deepCopy;
		
			
			self.scoreEvent = StepEvent.new;
			self.envEvent = StepEvent.new;
			self.stepEvent = StepEvent.new;
			self.stepEvent.repeats_(inf);
		
			self;
		},

		xasPattern: { arg self;
			self.envEvent.asPattern.loop <> self.scoreEvent.asPattern <> self.stepEvent.asPattern
			//self.scoreEvent.asPattern
		},

		asSidePattern: { arg self;
			self.envEvent.asSidePattern;
		},
	);

	~bank_selector_view = { arg bank, new_page_fun, update_page_fun;
		var pageMenu;
		var addButton;
		var remButton;
		pageMenu = PopUpMenu.new.items_(bank.pageKeys).action_({ arg view;
			bank.index = view.value;
			bank.index.debug("bank_selector_view: changed index");
		});
		addButton = XSimpleButton.new.label_("+").action_({
			bank.addPage(new_page_fun);
		});
		remButton = XSimpleButton.new.label_("-").action_({
			bank.removePage(bank.index);
		});
		pageMenu.onChange(bank, \index, {
			"bank_selector_view: update index".debug;
			update_page_fun.();
			pageMenu.items_(bank.pageKeys).value_(bank.index);
		});
		HLayout(
			pageMenu,
			addButton,
			remButton,
		)
	};

	~full_sequencer = (
		all: {PresetDictionary.new(\full_sequencer)},
		new: { arg self, key, instrs;
		
			//if(self.all[key].isNil) { 
			if(true) { // debug
				self = self.deepCopy;
				self.instrs = instrs;
				self.playerWrapper;
				self.coins = IdentityDictionary.new;
				self.players = IdentityDictionary.new;
				self.bank = ParBankDictionary.new;
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

		new_score: { arg self;
			~track_score.new;	
		},

		populate_tracks: { arg self;
			self.instrs.do ({ arg instr;
				var key = self.get_instr_key(instr);
				instr.debug("populate_tracks");
				self.coins[key] = self.coins[key] ? StepEvent.new;
				self.bank[key] = self.bank[key] ? BankList[ self.new_score ];
				case
					{ instr.isKindOf(Pdef) } {
						self.players[key] = self.players[key] ? EventPatternProxy.new;
						self.players[key].addHalo(\label, key);
						self.players[key].source = Ppar([
							Plazy({ self.bank[key].current.xasPattern }).loop <> instr,
							Plazy({ self.bank[key].current.asSidePattern }).loop
						]);

					}
					{ instr.isKindOf(Ndef) } {
						self.players[key] = self.players[key] ? instr;
						self.players[key].addHalo(\label, key);
						instr[100] = \set -> Plazy({ 
							self.bank[key].current.xasPattern.collect({ arg ev;
								ev.debug("yiiiiiiiiiii");
								ev[\out] = nil;
								ev[\group] = nil;
								ev.debug("yiiiiiiiiiii2");
								ev;
							
							})
						}).loop;
					}
				;
			})
		},

		get_current_stepevent: { arg self, key;
			self.bank[key].current.scoreEvent
		},

		get_current_score: { arg self, key;
			self.bank[key].current
		},

		set_current_stepevent: { arg self, key, val;
			//TODO
			//self.bank[key].current = val
		},

		get_instr_playerWrapper: { arg self, instr;
			PlayerWrapper(self.players[self.get_instr_key(instr)]);
		},

		show_track_editor: { arg self, instr;
			var playerWrapper = self.get_instr_playerWrapper(instr);
			var key = self.get_instr_key(instr);
			var stepEventView = View.new;
			var envEventView = View.new;
			var update_track_editor_page;
			var stacklayout = StackLayout(
				View.new.layout_(VLayout(
					[
						ParamGroupLayout.two_panes(instr.asParamGroup, \property),
						stretch:0
					],
					[nil, stretch:1],
				)),
				stepEventView,
				envEventView,
			);
			update_track_editor_page = {
				stepEventView.removeAll;
				stepEventView.layout = 
					~stepEventView.new( self.bank[key].current.stepEvent, instr.asParamGroup).makeLayout;

				envEventView.removeAll;
				envEventView.layout = 
					~envEventView.new( self.bank[key].current.envEvent, instr.asParamGroup).makeLayout;
			};
			update_track_editor_page.();
			stacklayout.mode = 0;
			instr.debug("show_track_editor", "yo");
			WindowDef(playerWrapper.label, {
				"ca swin".debug;
				VLayout(
					HLayout(
						playerWrapper.asView,
						~bank_selector_view.(self.bank, { self.new_score }, { update_track_editor_page.() }),
						Param(Message(stacklayout), \index, MenuSpec(
							//[
							//	"Params" -> 0,
							//	"Steps" -> 1,
							//	"Env" -> 1,
							//]
							[
								"Params",
								"Steps",
								"Env",
							].collect({ arg x, i; x -> i  })
						)).asPopUpMenu,
						XSimpleButton.new.label_("main").action_({
							WindowDef(\main_editor).front
						}).maxWidth_(50)
					),
					stacklayout,
				)
			}).front
		},

		add_page: { arg self;
			self.bank.addPage({
				self.new_score;
			})
		},

		remove_page: { arg self, idx;
			self.bank.removePage(idx);
		},

		updatePage: { arg self;
			if(self.layout.notNil) {
				self.instrs.debug("updatePage");
				self.instrs.collect({ arg track, i;
					var key = self.get_instr_key(track);
					self.coinViews[key].debug(key, "kjkj");
					self.coinViews[key].mapStepEvent(self.get_current_stepevent(key))
				});
				self.bank.index.debug("index");
				//self.pageMenu.items_(self.bank.pageKeys).value_(self.bank.index)
			}
		},

		asView: { arg self;
			var header;
			var track_selector;
			var repeatField;
			repeatField = TextField.new;
			track_selector = ~view_selector.new(self.instrs.size, { arg i;
				var key = self.get_instr_key(self.instrs[i]);
				repeatField.mapParam(Param(Message(self.get_current_score(key).scoreEvent), \repeats, ControlSpec(1,128,\lin)))
			});
			self.coinViews = IdentityDictionary.new;

			header = HLayout(
				~bank_selector_view.(self.bank, { self.new_score }, { self.updatePage }),
				repeatField,
			);

			self.layout = VLayout (
				header,
				ScrollView.new.canvas_(View.new.layout_(
					VLayout (
						GridLayout.rows (
							*self.instrs.collect { arg track, i;
								var key = self.get_instr_key(track);
								var playerWrapper = PlayerWrapper(self.players[key]);
								var stepEvent = self.get_current_stepevent(key);
								var playerWrapperView = PlayerWrapperView(playerWrapper);
								var playerWrapperViewAsView = playerWrapperView.layout;
								var coinView = ~stepEventCoinView.new(stepEvent);
								coinView.hasCursor = true;
								self.coinViews[key] = coinView;
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
									track_selector.views[i],
									playerWrapperViewAsView,
									coinView.asView,
								]
							} ++ [[nil,nil]]
						),
						nil
					)
				)
			));
			self.layout;
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

	WindowDef(\main_editor, {
		~full_sequencer.new(\myseq1, [Pdef(\kick), Pdef(\kick2), Ndef(\popop)]).asView;
	}).front;
)
~full_sequencer.new(\myseq1, [Pdef(\kick), Pdef(\kick2)])
		PresetDictionary.new(\full_sequencer)
~full_sequencer.new(\myseq1, [Pdef(\kick), Pdef(\kick2)]).bank.pageCount
~full_sequencer.new(\myseq1, [Pdef(\kick), Pdef(\kick2)]).get_current_score(\kick).scoreEvent.repeat



//////////////////// stacklayout


WindowLayout({
	var sl = StackLayout(
		Button.new,
		Knob.new,
	);
	sl.mode = 0;
	sl.index = 0;
	VLayout(
		//Param(Message(sl), \index, MenuSpec([0,1].collect({ arg x; x -> x })) ).asPopUpMenu,
		Param(Message(sl), \index, MenuSpec((0..sl.count))).asPopUpMenu,
		sl,
	)
	
})


~sl = StepList[1,0,1,1,0,0,1];
~sl.addSpec(\list, \unipolar)
~sl.addHalo(\seqstyle, \button)
~sl.addHalo(\seqstyle, \cursor)
~sl.addHalo(\seqstyle, \knob)
~sl.addCursor
(
Pdef(\test, Pbind(
	\instrument, \default,
	\freq, 200,
	\isRest, ~sl.asPattern.coin.not.loop,
	\dur, 1/4,
	\amp, 0.1
)).play;
)
(
WindowLayout({
	VLayout (
		//ListParamLayout.button(Param(List[1,0,1,0,0,0], \list, \unipolar)),
		//Button.new,
		//XSimpleButton.new,
		StepListView(~sl).addCursor.asView,
	)
	
})
)


(
Ppar([
	Pbind(
		\instrument, \default,
		\freq, 900,
		\dur, Pn(1/4,4),
		\amp, 0.1
	),
	Plazy({
		~yep
	})
]).loop.play
)

(
~yep = Pbind(
	\instrument, \default,
	\freq, 4200,
	\dur, Pn(1/2,2),
	\amp, 0.1
);
)
~yep = nil

Ndef(\popop).play
Ndef(\popop)[100]
Ndef(\popop).unset(\freq)
Ndef(\popop)[10] = Pbind(
	\instrument, \default,
	\freq, 200,
	\dur, 1,
	\amp, 0.1
	\out, BusDef(\plop, \audio)
);
