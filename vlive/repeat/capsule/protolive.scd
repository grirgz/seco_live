
	(
		ProtoDef(\promise, (
			new: { arg self, object, time=0;
				var me = self.deepCopy;
				me.init(time, object);
				me;
			},

			init: { arg self, time, object;
				self.time = self.clock.beats;
				self.object = object;
			},

			clock: { TempoClock.default },
			quant: { Pdef.defaultQuant },


			nextTimeOnGridFrom: { arg self, beats, quant = 1, phase = 0;
				if (quant == 0) { beats + phase } {
					var baseBarBeat = self.clock.baseBarBeat;
					var beatsPerBar = self.clock.beatsPerBar;
					if (quant < 0) { quant = beatsPerBar * quant.neg };
					if (phase < 0) { phase = phase % quant };
					roundUp(beats - baseBarBeat - (phase % quant), quant) + baseBarBeat + phase
				};
			},

			sched: { arg self, time, fun;
				var cur;
				self.time = time + self.clock.beats;
				cur = time;
				"sched rel:%, time:%, now:%".format(cur, time, self.clock.beats).debug;
				TempoClock.default.sched(( time-0.01 ).clip(0,inf),{
					"RUN rel:%, time:%, now:%".format(cur, time, self.clock.beats).debug;
					fun.value(self.object);
					nil;
				});
				self;
			},

			schedAbs: { arg self, time, fun;
				var cur;
				self.time = time;
				cur = self.time - self.clock.beats;
				"sched rel:%, phase:% time:%, now:%".format(cur, time - self.clock.baseBarBeat % ( self.quant * 8 ) , time, self.clock.beats).debug;
				TempoClock.default.schedAbs(( self.time-0.01 ).clip(0,inf),{
					"RUN rel:%, phase:% time:%, now:%".format(cur, time - self.clock.baseBarBeat % ( self.quant * 8 ) , time, self.clock.beats).debug;
					fun.value(self.object);
					nil;
				});
				self;
			},

			run: { arg self, fun;
				self.sched(self.time, fun);
				self;
			},

			end: { arg self, fun;
				self.schedAbs(
					self.nextTimeOnGridFrom(self.time, self.quant*4, self.quant*3),
					fun
				);
				self;
			},

			mid: { arg self, fun;
				self.schedAbs(
					self.nextTimeOnGridFrom(self.time, self.quant*4, self.quant*2),
					fun
				);
				self;
			},

			start: { arg self, fun;
				self.schedAbs(
					self.nextTimeOnGridFrom(self.time, self.quant*4),
					fun
				);
				self;
			},

			wait: { arg self, time, fun;
				self.schedAbs(
					self.time+time,
					fun
				);
				self;
			},

			quantDo: { arg self, fun;
				self.schedAbs(
					self.nextTimeOnGridFrom(self.time, self.quant),
					fun
				);
				self;
			},

		));


	TrackTemplateDef(\protopat, (

		/////// timing

		then: { arg self, fun;
			//var prom = self.promise;
			//"then".debug(prom);
			//TempoClock.default.sched(prom-0.01,{
				//"NOW".debug(prom);
				//fun.value(self);
				//nil;
			//});
			//self;
			ProtoDef(\promise).new(self).sched(self.promise,fun)
		},

		wait: { arg self, time, fun;
			//self.promise = self.clock.nextTimeOnGrid(time,time) - self.clock.beats;
			//if(fun.notNil) {
				//self.then(fun);
			//};
			//self;
			ProtoDef(\promise).new(self).wait(time,fun)
		},

		end: { arg self, fun;
			//self.promise = self.clock.nextTimeOnGrid(self.quant*4, self.quant*3) - self.clock.beats;
			//self.then(fun);
			//self.promise = self.clock.nextTimeOnGrid(self.quant*4, self.quant*3) - self.clock.beats + self.quant;

			//self;
			ProtoDef(\promise).new(self).end(fun)
		},

		start: { arg self, fun;
			//self.promise = self.clock.nextTimeOnGrid(self.quant*4) - self.clock.beats;
			//self.then(fun);
			//self;
			ProtoDef(\promise).new(self).start(fun)
		},

		mid: { arg self, fun;
			ProtoDef(\promise).new(self).mid(fun)
		},

		promiseAtQuant: { arg self, add=0;
			self.promise = self.clock.timeToNextBeat(self.quant)+add;
			self;
		},

		quantDo: { arg self, fun;
			//TempoClock.default.sched(self.clock.timeToNextBeat(self.quant)-0.01,{
				//fun.value(self);
				//nil;
			//});
			//self;
			ProtoDef(\promise).new(self).quantDo(fun)
		},


		//////////

		outbus: 0,


		clock: { TempoClock.default },
		quant: { Pdef.defaultQuant },


		send: { arg self, target;
			if(target == 0) {
				self.dependOn = nil;
				Pbindef(self.key, 
					\out, 0;
				);
				self.promiseAtQuant;
			} {
				if(target.inbus.notNil) {
					self.dependOn = target;
					target.play;
					Pbindef(self.key, 
						\out, target.inbus,
					);
					self.promiseAtQuant;
				} {
					"ERROR: no inbus found"
				};
			};
			self;
		},

		playDependencies: { arg self;
			var preventLoop = self.dependOn;
			self.dependOn = nil;
			preventLoop.play;
			self.dependOn = preventLoop;
		},

		play: { arg self;
			self.unmute;
			Pdef(self.key).play;
			self.playDependencies;
			self.promiseAtQuant;
			self;
		},

		stop: { arg self;
			PlayerWrapper(Pdef(self.key)).stop;
			self.promiseAtQuant;
			self;
		},


		beatsPerBar_: { arg self, num;
			if(self.beatsPerBar != num) {
				self.clock.schedAbs(self.clock.nextBar, {self.clock.beatsPerBar_(num)}); 
			}
		},
		beatsPerBar: { arg self;
			self.clock.beatsPerBar
		},

		proxy: { arg self;
			Pdef(self.key)
		},

		mix: { arg self;
			Pdef(self.key+++\mixer,
				Pmono(\simpletrackmixer,
					\inbus, BusDef(self.key+++\mix),
					\dur, 1,
				),
			);
			// TODO
			//self.dependOn = Pde
		},

		asPattern: { arg self;
			Prout({ arg ev;
				self.proxy.embedInStream;
			})
		},

	));

	)
