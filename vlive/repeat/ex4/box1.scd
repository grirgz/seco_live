

(
// init
	s.waitForBoot {
		
		~t = 215/4/60;
		TempoClock.default.tempo = ~t;
		Ndef.defaultQuant = 4;
		Pdef.defaultQuant = 4;
		
		//FileSystemProject.load("ex3/lib.scd");
		//FileSystemProject.load("ex3/barlokkit.scd");
		//FileSystemProject.load("ex3/part1_ndefs.scd");
		//FileSystemProject.load("ex3/part2_ndefs.scd");
		//FileSystemProject.load("ex3/part2_pdefs.scd");
	};
)

(
	ProtoDef(\simple_sequencer, (
		target_: { arg self, val;
			self[\target] = val;
			if(val.notNil) {
				if(self.stepEvent.isNil) {
					self.stepEvent = StepEvent.new;
					self.stepEvent.repeatCount = inf;
					self.stepEvent[\isRest] = StepList[0].stepCount_(8).coinMode_(true);
				};
				self.proxy.source = self.stepEvent.asPattern <> self.target;
			} {
				self.proxy.source = Rest(1);
			};
			self.changed(\target);
		},

		proxy: { arg self;
			self[\_proxy] = self[\_proxy] ?? { EventPatternProxy.new };
			self[\_proxy];
		},

		proxy_: { arg self, val;
			self.[\_proxy] = val;
		},

		play: { arg self;
			self.proxy.play;
		},

		stop: { arg self;
			self.proxy.stop;
		},

		isPlaying: { arg self;
			self.proxy.isPlaying;
		},

		label: { arg self;
			self.key
		},

		edit: { arg self;
			WindowDef(\simple_sequencer, { arg def;
				def.onChange(self, \target, {
					def.updateView;
				});
				if(self.target.notNil) {
					var steplist = self.stepEvent[\isRest];
					VLayout(
						PlayerWrapper(self).asView,
						StepListColorView.new(steplist, \button).asView,
						self.target.asParamGroup.asView,
					)
				} {
					VLayout(
						StaticText.new.string_("No target");
					);
				};
				
			}).front;
		},

	))
)


ProtoDef(\simple_sequencer).stepEvent.asPattern.asStream.nextN(10,())
ProtoDef(\simple_sequencer).proxy.asPattern.asStream.nextN(10,())

~sl = StepList[1,0,1,1,1,0]
~sl.asPattern.

ProtoDef(\simple_sequencer).edit
ProtoDef(\simple_sequencer).target = Pdef(\seq1);
ProtoDef(\simple_sequencer).stepEvent
ProtoDef(\simple_sequencer).clear
(
Pdef(\seq1, Pbind(
	\instrument, \default,
)).play;
);

////////////////////////////////////////::


// why so much code in ProtoDef alors que ca que quelques lignes comme ca:
(
~stepevent = StepEvent.newFrom((
	isRest: StepList[0].stepCount_(8).coinMode_(true)
));
Pdef(\bla,
	~stepevent.asPattern.loop <> Pdef(\seq1)
)
)

(
WindowDef(\simple_sequencer, { arg def;
	var steplist = ~stepevent[\isRest];
	VLayout(
		PlayerWrapper(Pdef(\bla)).asView,
		StepListColorView.new(steplist, \button).asView,
		Pdef(\seq1).asParamGroup.asView,
	)
}).front;
)


