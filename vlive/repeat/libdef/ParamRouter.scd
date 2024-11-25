
(
FileSystemProject.loadOnce("libdef/ParamSelectDialog.scd");
//FileSystemProject.loadOnce("libdef/ModulatorRack.scd");
ProtoTemplateDef(\ParamRouter, (
	//busList: [
		//BusDef(\zero, \control),
		//BusDef(\bus1, \control),
		//BusDef(\bus2, \control),
		//BusDef(\abus1, \audio, 1),
		//BusDef(\abus2, \audio, 1),
	//],
	busSpec: { arg self;
		if(self.busList.notNil) {
			TagSpec(self.busList.collect({ arg x; x.key -> x }))
		} {
			TagSpecDef(\BusDef_object)
		};
	},
	slotCount: 4,
	init: { arg self, busList, paramList;
		self.busList = self.busList ? busList;
		self.paramList = self.paramList ?? {
			[
				Param(Pdef(\zero), \zero),
				Param(Pdef(\bla), \lpfr),
				Param(Pdef(\bla), \rq),
			]
		};
		self.busSlots = self.busSlots ?? {List.newFrom(BusDef(\zero, \control)!self.slotCount)};
		self.paramSlots = self.paramSlots ?? {List.newFrom(Param(Pdef(\zero),\zero)!self.slotCount)};
		self.rangeSlots = self.rangeSlots ?? {List.newFrom(0!self.slotCount)};
		self.enabledSlots = self.enabledSlots ?? {List.newFrom(true!self.slotCount)};
	},

	// problem:
	// no way to change the already defined Param in another GUI to point to the specConverter
	// a moins d'utiliser le cachedBus mais j'ai bien peur que la logique fasse qu'a un moment le param va recuperer la valeur sur la bus pour la mettre dans cachedBus et du coup on va tout perdre, sans compter le set qui set le mauvais bus quand meme

	//updateRouting: { arg self;
		//self.slotCount.do { arg idx;
			//if(self.busSlots[idx] != BusDef(\zero) and: { self.paramSlots[idx].target != Pdef(\zero) }) {
				//self.patternSlots[idx] = Pmono(
					//\instrument, \specConverter,
					//\inbus, self.busSlots[idx],
					////\base, value, // TODO
					//\out, self.paramSlot[idx].getRaw,
				//)

			//}
		//};
	//},

	// use combinator

	updateRouting: { arg self;
		var combisize = 3;
		// for each param, count the slot where is it used, then set to 0 the remaining
		self.paramList.do { arg param, idx;
			if(param != Param(Pdef(\zero), \zero)) {
				var inputidx = 0;
				var pc;
				if(param.hasCombinator) {
					pc = param.getCombinator;
				};

				self.paramSlots.do { arg slotparam, slotidx;
					if(
						slotparam == param 
						and: { self.busSlots[slotidx] != BusDef(\zero) } 
						and: { self.enabledSlots[slotidx] != false }
					) {
						pc = ParamCombinator(param);
						if(pc.inBusMode == false) {
							pc.setBusMode(true);
						};
						pc.inputParam.at(inputidx).setBus(self.busSlots[slotidx].asMap);
						self.changed(\rangeSlider, slotidx, inputidx);
						inputidx = inputidx + 1;
					};
				};
				if(pc.notNil) { 
					(inputidx..combisize-1).do { arg i;
						[param, inputidx, combisize, i, pc].debug("updateRouting set to 0");
						pc.inputParam.at(i).get.debug("in get");
						pc.inputParam.at(i).setBus(0)
					};
				};
				// should we clear the ParamCombinator ?
				//if(inputidx == 0) {
					//ParamCombinator(param).clear;
				//};

			};
		};
	},

	getRangeParam: { arg self, idx, inputidx;
		if(self.busSlots[idx] != BusDef(\zero) and: { self.paramSlots[idx].target != Pdef(\zero) }) {
			var pc = ParamCombinator(self.paramSlots[idx]);
			pc.rangeParam.at(inputidx);
		} {
			nil;
		}
	},

	edit: { arg self;
		WindowDef(\ParamRouter, { arg def;
			var slotlist = View.new;
			var busspec; 
			var paramspec;
			paramspec = TagSpec(self.paramList.collect({ arg x; 
				x.asLabel(\full) -> x 
			}));
			busspec = self.busSpec;
			self.paramListTagSpec = paramspec;
			slotlist.layout = VLayout (
				* self.slotCount.collect({ arg idx;
					var layout;
					layout = HLayout (
						Button.new.states_([
							["Off", nil, Color.red],
							["On"],
						]).maxWidth_(20).action_({ arg view;
							self.enabledSlots[idx] = view.value.asBoolean;
							self.updateRouting;
						}).value_(self.enabledSlots[idx].asInteger),
						Param(self.busSlots, \list, busspec).at(idx).asPopUpMenu.addAction({
							self.updateRouting;
						}),
						Slider.new.orientation_(\horizontal).followChange(self, \rangeSlider, { arg view, obj, msg, chidx, inputidx;
							//[view, obj, msg, chidx, inputidx].debug("followChange");
							if(idx == chidx) {
								view.mapParam(self.getRangeParam(chidx, inputidx))
							};
						}),
						Param(self.paramSlots, \list, paramspec).at(idx).asPopUpMenu.addAction({ 
							self.updateRouting;
						}),
						BasicButton.new.string_("...").fixedWidth_("20").action_({
							Menu(
								MenuAction("Edit Param", { self.paramSlots[idx].edit }),
								MenuAction("Edit Player", { PlayerWrapper(self.paramSlots[idx].target).edit }),
							).front;
						})
					);
					layout;
				}) ++ [nil]
			);
			self.updateRouting;
			VLayout (
				HLayout (
					BasicButton.new.string_("ModulatorRack").action_({
						TrackDef(\ModulatorRack).edit
					}),
					BasicButton.new.string_("Add param").action_({
						WindowDef(\ParamSelectDialog).front(nil, { arg param; 
							//param.debug("selected param");
							self.paramList = self.paramList.add(param);
							self.paramListTagSpec.add(
								param.asLabel(\full) -> param 
							);
						})
					}),
				),
				slotlist,
			)
		}).front;
	},
));
ProtoDef(\ParamRouter, ProtoTemplateDef(\ParamRouter)).init;
)

// END
///////////////////////////
ProtoDef(\ParamRouter).edit; // debug
Pdef(\bla).addSpec(\seq, \degree)
~p = Param(Pdef(\bla), \lpfr)
~pc = ParamCombinator(~p)
~pc.resultParam
~pc.inputParam.wrapper
~pc.inputParam.spec
~pc.inputParam.target.changed(\set)
~pc.inputParam.target.dependants.do(_.dumpMethodList)
~ii = ~pc.inputParam.target.dependants
~ii.do({ arg x;  ~ii.remove(x)})
~pc.inputParam.target.dependants.removed = nil
IdentitySet
SimpleController

~list = List[1,2,3,4];
~x = Param(~list, \list, \unipolar)
~x.at(0).set(0)
~x.spec
~x.changed(\set)
~pc.busMode
~pc.inputParam.at(0).setBus(0)
~pc.inputParam.at(0).set(0)
~pc.inputParam.set([0,1,3])
~pc.inputParam.at(0).wrapper
~pc.inputParam.at(0).property
~pc.inputParam.at(0).accessor

(
Pdef(\bla, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

ProtoDef(\ParamRouter).paramList = nil
ProtoDef(\ParamRouter).busList
ProtoDef(\ParamRouter).clear

// ideas
// - right clic on a param, clic sur "Add to ParamRouter", it open this window
// - ParamRouter window should have a "Modulators" button that open the modulator rack
// - modulator rack allow to add a new modulator by choosing between synthdefs and control its parameters
// - if a param is modulated, the range slider should appear when right click
// - right clic on a param, there is a popupmenu to choose a modulator, then a range slider appear
//		and its added to modulation manager

// other ideas:
// - right click on the out parameter, "Add to MixerRack", then you can have fx

(
SynthDef(\saw, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200,  doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = LFSaw.ar(freq * [1.01,1,0.99]);
	sig = RLPF.ar(sig, ( \lpfr.kr(1.1) * freq ).clip(20,20000), \rq.kr(0.5).clip(0.1,1));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}, metadata:(specs:(
	lpfr: ControlSpec(0.1,4,\lin, 0, 1),
	rq: ControlSpec(0.1,0.9,\lin, 0, 0.5),
))).add;
Pdef(\bla, 
	Pbind(
		\instrument, \saw,
		\degree, Pseq([0,5,4,Pwhite(0,8,1)],inf),
		\dur, 1/2,
		\amp, 0.1,
	)
).play;
Pdef(\bla2, 
	Pbind(
		\instrument, \saw,
		\degree, Pseq([0,1,2,3,2,Pwhite(0,8,3)],inf),
		\dur, 1/8,
		\amp, 0.1,
	)
).play;
);



(
Ndef(\modsin, { arg freq=2, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.kr(freq);
	Out.kr(BusDef(\bus1, \control), sig);
}).quant_(1);
Ndef(\modsaw, { arg freq=3, pan=0, amp=0.1;
	var sig;
	sig = LFSaw.kr(freq);
	Out.kr(BusDef(\bus2, \control), sig);
}).quant_(1);
);

(
);

(
);

~p = Param(Pdef(\bla), \lpfr)
~p.combinatorEnabled
~p2 = Param(Pdef(\bla), \rq)
ParamCombinator(~p).edit
ParamCombinator(~p).size
ParamCombinator(~p).inputParam.at(0).get
ParamCombinator(~p).inputParam.getRaw
ParamCombinator(~p).inputParam.at(0).setBus(BusDef(\bus1).asMap)
ParamCombinator(~p2).inputParam.at(0).setBus(BusDef(\bus2).asMap)
~pc.inputParam.getRaw

ParamCombinator(Param(Pdef(\bla), \rq)).edit
BusDef(\bus1).asMap
//////////////////
(
	// test modsin
Pdef(\bla, 
	Pbind(
		\instrument, \saw,
		\degree, Pseq([0],inf),
		\lpfr, BusDef(\bus1, \control).asMap,
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

(
SynthDef(\specConverter, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var in = InBus.kr(\inbus.kr, 1);
	sig = in;
	sig = sig.linlin(-1,1,\fromVal.kr(0), \toVal.kr(1))
	Out.kr(out, sig);
}).add;
);
