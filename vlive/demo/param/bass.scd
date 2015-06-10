
(
SynthDef(\bass, { |outbus, midinote = 42|
  var freq = midinote.midicps;
  var subfreq = freq / 2;
  
  // Envelopes
  var subenv = EnvGen.kr(Env.perc(0, 0.7), doneAction:2);
  var env = EnvGen.kr(Env.perc(0, 0.2), 1);
  
  // Component synthesis
  var pluck = Pluck.ar(PinkNoise.ar, 1, 0.2, subfreq.reciprocal) * subenv * 2;
  var tri = VarSaw.ar(freq) * env;
  var sin = SinOsc.ar(freq) * env;
  var sub = (SinOsc.ar([subfreq, subfreq - 2, subfreq + 2]).sum * subenv).tanh;
  var click = RLPF.ar(Impulse.ar(0), [2000, 8000], 1).sum * 10;
  
  // Initial signal
  var sig = pluck + tri + sub + click;
  
  // Resonant LPFs
  sig = RLPF.ar(sig, XLine.ar(freq * 10, freq * 21, 0.15));
  sig = sig + (MoogFF.ar(sig, freq * 20, 2.5) * 0.1);
  
  // EQ resulting signal
  sig = BPeakEQ.ar(sig, 400, 0.5, -9);
  sig = BPeakEQ.ar(sig, 2000, 0.5, 6);
  sig = BHiShelf.ar(sig, 8000, 1, 3);
  sig = BPeakEQ.ar(sig, 200, 1, 3);
  
  // Apply another envelope to dampen a bit more
  sig = sig * XLine.kr(1, 0.6, 0.1);
  
  // Tanh distortion / limiting
  sig = (sig * 1).tanh;
  
  // Another round of signal coloring, using another RLPF
  // and sine components
  sig = sig + RLPF.ar(sig, XLine.ar(freq * 100, freq * 10, 0.15)) + sin + sub;
  
  // Another round of tanh distortion / limiting
  sig = (sig / 0.3).tanh;

  sig = sig * \amp.kr(1);
  
  // Another resonant LPF
  sig = MoogFF.ar(sig, XLine.ar(freq*15, freq*30, 0.1), 0.1);
  
  Out.ar(outbus, sig!2);
}).add;
)
/////////////////////////////// gui



/////////////////////// sequencing

(
	~make_cursor_line = { arg param;
		HLayout(*
			param.collect({ arg subparam, x;
				Button.new
				.enabled_(false)
				.maxHeight_(10)
				.onChange(param.target, \cursor, { arg view ...args;
					[args[2], x].debug("bbb");
					if(args[2] == x) {
						Task{
							s.latency.wait;
							if(args[3] == 1) {
								view.value = 1;
							} {
								view.value = 0;
							};
							nil
						}.play(AppClock);
					};
					args.debug("cursor!!");
				})
				.states_([
					["", Color.black, Color.white],
					["", Color.black, Color.yellow],
				]);
			})
		)
	};

	~make_sequencer_line = { arg param;
		HLayout(*
			param.collect({ arg subparam;
				subparam.asButton;
			})
		)
	};

	~make_sequencer_val_line = { arg param;
		HLayout(*
			param.collect({ arg subparam;
				VLayout(
					subparam.asButton,
					subparam.asNumberBox,
				)
			})
		)
	};

	~make_slider_line = { arg param;
		HLayout(*
			param.collect({ arg subparam;
				subparam.asSlider;
			})
		)
	};

	~make_slider_val_line = { arg param;
		HLayout(*
			param.collect({ arg subparam;
				VLayout(
					subparam.asSlider,
					subparam.asNumberBox,
				)
			})
		)
	};

	~synth_bass = (
		new: { arg self, name=\bass;
			self = self.deepCopy;
		
			self.msize = 8;
			self.uname = name;
			
			self.model = (
				midinote: List.newFrom(40 ! self.msize).addSpec(\list, ControlSpec(20,100,\lin,1,40)),
				rest:  List.newFrom(1 ! self.msize).addSpec(\list, \unipolar),
			);
			self.model.debug("model");
			self.pat = Pdef(self.uname,
				Pdef(self.uname+++\param, Pbind()) <>
				Pbind(
					\instrument, \bass,
					\midinote, Pseq(self.model.midinote.debug("wtkiii")),
					\isRest, Pseq(self.model.rest.debug("wtk")).coin.not,
				).loop;
			);

			Pdef(self.uname+++\param).addSpec(\dur, ControlSpec(1/8,2,\lin));
			Param(Pdef(self.uname+++\param), \dur).spec.debug("wwwww");
		
			self;
		},

		make_gui: { arg self;
			var window = Window.new;
			var layout;
			layout = self.make_layout;
			window.layout = layout;
			//window.alwaysOnTop = true;
			window.front;
		},

		play_sequencer: { arg self;
			self.pat.play;
		},

		stop_sequencer: { arg self;
			self.pat.stop;
		},

		make_layout: { arg self;
			var seqlayout;
			var layout;
			seqlayout = VLayout(
				HLayout(
					XSimpleButton.new
						.label_("Play")
						.action_({
							self.play_sequencer;
						}),
					XSimpleButton.new
						.label_("Stop")
						.action_({
							self.stop_sequencer;
						}),
					StaticText.new.string_("rate: "),
					Param(Pdef(self.uname+++\param), \dur).asKnob,
					Param(Pdef(self.uname+++\param), \dur).asTextField,

				),
				~make_slider_val_line.(Param(self.model[\midinote], \list)),
				~make_sequencer_line.(Param(self.model[\rest], \list)),
			);
			layout = HLayout(
				seqlayout;
				
			);
			layout;

			
		},
	);

	~bass = ~synth_bass.new;
	~bass.make_gui;
) 


List[1,40].addSpec(\bla, \unipolar)

P
			Pdef(self.uname+++\param).addSpec(\dur, ControlSpec(1/8,2,\lin));
			Param(Pdef(\bass+++\param), \dur).spec.debug("wwwww");
			Param(Pdef(\bass+++\param), \dur).spec.clipLo
			
			
			(
			{
				
				var window = Window.new;
				var layout;
				var nb;
				layout = 
				HLayout(
					~nb = Param(Pdef(\bass+++\param), \dur).asNumberBox
				)
				
				;
				window.layout = layout;
				//window.alwaysOnTop = true;
				window.front;
			}.value
			)
Param(Pdef(\bass+++\param), \dur).asNumberBox.step = 
~nb.scroll_step = 0.001
~nb.scroll_step 


~n = NodeMap.new
~n.set(\midinote, [1,0,2,3])
~n[\mininote]
~n.get(\midinote)
~n.edit

(
	Pdef(\plop, Pbind(
		\yep, Pfunc({ arg ev; 
			ev.debug("dddd");
			ev[\haha].debug("heh"); 
			ev.parent[\haha].debug("heh2"); 
			//ev.parent.parent[\haha].debug("heh3"); 
			ev.parent.keys.asArray.sort.debug("what"); 
			1;
		})
	)
).play
)

(
	Pdef(\plop,
		Prout({ arg ev;
			ev.collect({ arg a, b, c;
				[a,b,c].debug("abc");
				Pseq(a.asArray,inf)
			}).debug("end").embedInStream;
		})
	
	)
).play
)

Pdef(\plop).set(\haha, 1)
Pdef(\plop)


(
Pdef(\birdx, Pbind(
	\instrument, \default,
	//\degree, Pseq([0],inf),
	\dur, 1,
	\amp, 0.1
)).play;
);

Pdef(\bird).set(\degree, Pseq([1,0,5],inf))
Pdef(\bird).clear

Pbindef(\birdx, \degree, Pseq([1,0,5],inf))



PbindSeq(\bird,
	\degree, 

)


- synthdef argument name
- pattern object
- pseq object
- list object
- spec
- param


Bird(\bla,
	\midinote, ControlSpec(0,1,\lin) ! 4,
	\isRest, ControlSpec(0,1,\lin) ! 4,
)

Bird.set(\midinote, [1,0,5]);
Param(Bird(\bla), \midinote)

Bird(\bla,
	\midinote, Pseq(ControlSpec(0,1,\lin)) ! 4,
	\isRest, ControlSpec(0,1,\lin) ! 4,
)

(
Pdef(\chat, Pbind(
	\instrument, \default,
	//\degree, Pseq(Pfunc({ arg ev; ev[\degree_seq][0] }),inf),
	\degree, Plazy({ arg ev; Pseq(ev[\degree_seq][0],inf) }),
	\dur, 1,
	\amp, 0.1
)).play;
);

(
Pdef(\chat, Pbind(
	\instrument, \default,
	//\degree, Pseq(Pfunc({ arg ev; ev[\degree_seq][0] }),inf),
	\degree, Pseq(Pcontrol(\degree_seq)),
	\dur, 1,
	\amp, 0.1
)).play;
);



(var a, b;a = Pfset({    ~legato = 0.3;    ~detune = rrand(0, 30);}, Pbind(\dur, 0.5));x = a.asStream;9.do({ x.next(Event.new).postln; });)


(var a, b;a = Pfset({    ~legato = 0.3;    ~detune = rrand(0, 30);}, Pbind(\dur, 0.5));x = a.asStream;9.do({ x.next(Event.new).postln; });)


(
	var a, b;
	a = Pfset({ 
		~legato = 0.3;
		~degree = Pseq([1,0,5,5,6],inf);
		~detune = rrand(0, 30);
	}, 
	Pbind(\dur, 0.5)
	);
	x = a.asStream;
	9.do({ x.next(Event.new).postln; });
)


Pchien({
	~degree = Pseq(~degree_seq)
})


(
Pdef(\crash, { arg degseq;
	degseq.debug("degseq");
	Pbind(
		\degree, Pseq(degseq),
		\dur, 1/8,
	)
})
)

(
Pdef(\rah, Pbind(
	\type, \phrase,
	\instrument, \crash,
	\degseq, Pseq([
		[[1,0,5]],
		[[7,2,5]],
	],inf),
	\dur, 1/2,

)).play;
)

Pdef(\rah).set(\degseq, [[1,1,5,7]])

Pj

(
Pdef(\mori, Pbind(
	\instrument, \default,
	\degree, Pseq(Pdefn(\yap, [0,4,7,5])0],inf),
	\dur, 1,
	\amp, 0.1
)).play;
)

Env.perc(0, 0.7);
