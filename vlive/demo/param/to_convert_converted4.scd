
// player wrapper types
// - PlayerWrapper
// - when playing a subplayer, it start it's parent player
// - when playing a subplayer, it stop others subplayer
// - when the last subplayer is stopped, it stop the parent player
// - a playerwrapper can be initialized (by a function or loading a source file)


(

"/home/ggz/code/sc/seco/vlive/demo/param/lib/timeline.scd".load;

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

	~se = StepEvent.new;
	Pdef(\plop, 
		
		~se <>
		Pbind(
		\instrument, \yapi,
		\degree, Pseq([0,1,4,5],inf),
		\dur, Pkeyd(\dur, 1/2),
		\legato, Pkeyd(\legato, 0.3),
		\amp, Pkeyd(\amp,0.1),
		\out, BusDef(\fxbus1),
	)).play;
	Pdef(\plop).addHalo(\instrument, \yapi);

	~stepEventView = (
		new: { arg self, stepevent, paramGroup;
			self = self.deepCopy;
		
			self.stepevent = stepevent;
			self.paramGroup = paramGroup;
			self.enabledParams = List[];
			
		
			self;
		},

		update_seq: { arg self;
			VLayout(*

				self.enabledParams.collect({ arg param;
					HLayout(
						param.asStaticTextLabel,
						param.asView,
					)
				})
			)
		},

		makeLayout: { arg self;
			var param_popup = PopUpMenu.new.items_(self.paramGroup.collect({ arg p; p.label }));

			param_popup.action({})

			self.seq = View.new;
			self.update_seq;
			self.layout = VLayout(
				HLayout (
					param_popup,
					XSimpleButton.new.label_("+").action_({
						if(self.enabledParams.includes(self.enabledParams).not) {
							self.enabledParams.add(self.paramGroup[param_popup.value]);
						} {
							"already enabled param".debug;
						}
					}),
					XSimpleButton.new.label_("-").action_({
						if(self.enabledParams.includes(self.enabledParams).not) {
							self.enabledParams.add(self.paramGroup[param_popup.value]);
						} {
							"can't delete: not present".debug;
						}

					}),
				)
				self.seq,
			);
			
		},

	);

	~make_source_fxchain_gui = { arg sources, fxchain;
		WindowLayout({
			var make_source;
			var make_fx;

			make_source = { arg source, i;
				var group = source.asParamGroup.select({ arg x; x.property != \inBus });
				~fxblock.(source.key, PlayerWrapper(source), Param(source, \amp, \unipolar), group);
			};
			make_fx = { arg proxy, i;
				var group = proxy.asParamGroup.select({ arg x; 
					[\inBus, \mix].includes(x.property).not
				});
				~fxblock.(proxy.key, PlayerWrapper(fxchain.enabledLinkParam(i)), Param(proxy, \mix, \unipolar), group);
			};

			HLayout(
				VLayout(*
					sources.collect(make_source)
					++ [ nil ]
				),
				VLayout (*
					[ PlayerWrapper(fxchain).asView, ]
					++ fxchain.slots.collect(make_fx)
					//++ [ ListParamLayout.knob(Param(~sl, \list)) ]
					++ [ nil ]
				),
			)
			
		});

	};

	~make_source_fxchain_gui.([Pdef(\plop)], ~pc);
)
