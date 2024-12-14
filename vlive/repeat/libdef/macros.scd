
// from vlive/lib/main.scd


(
~pEnv = { arg ... args;
	Ptuple( Env(*args).asArray ).collect{ arg x; [x] }
};
~pEnvadsr = { arg ... args;
	Ptuple( Env.adsr(*args).asArray ).collect{ arg x; [x] }
};
);

// END


(
~pnoteEnv_adsr = { arg attack=0.1, decay=0.1, sustainLevel=0.8, release=0.1, peakLevel=1, curves=0, levelScale=1, levelBias=0, timeScale=1;

	Prout({ arg ev;
		var envev;
		var pat;
		var str, levelstr, biasstr, timestr;
		var bus = Bus.control(Server.default, 1);
		var cleanup = EventStreamCleanup.new;
		var cleanup_fun;
		var nextenv, nextlevel, nexttime, nextbias;
		var prevenv;

		cleanup_fun = {
			debug("pnoteEnv_adsr cleanup_fun");
			if(bus.index.notNil) {
				var reltime;
				var env = nextenv ?? { prevenv };
				if(env.notNil) {
					reltime = env.first.asEnv.times.last;
				} {
					reltime = 2;
				};
				{
					if(bus.index.notNil) {
						[bus, reltime].debug("free bus");
						bus.free;
					}
				}.defer(reltime);
				Env.adsr.times.last
				
			};
		};
		//CmdPeriod.doOnce({ 
			//cleanup_fun.();
		//});

		cleanup.addFunction(ev, cleanup_fun);

		bus.debug("new bus");
		pat = Ptuple( 
			Env.adsr(attack, decay, sustainLevel, release, peakLevel, curves).asArray 
		).collect{ arg x; [x] };
		str = pat.asStream;
		levelstr = levelScale.asStream;
		biasstr = levelBias.asStream;
		timestr = timeScale.asStream;


		block { arg break;

			loop {
				envev = ();
				[\sustain, \legato, \dur].do { arg key, idx;
					envev[key] = ev[key];
				};
				envev[\instrument] = \inlineEnv_adsr;
				envev[\out] = bus;
				prevenv = nextenv;
				nextenv = str.next;
				nextlevel = levelstr.next;
				nextbias = biasstr.next;
				nexttime = timestr.next;
				if(nextenv.isNil or: { nextlevel.isNil } or: { nexttime.isNil } or: { nextbias.isNil }) {
					break.value;
					//ev = nil.yield
				};
				envev[\adsr] = nextenv;
				envev[\levelScale] = nextlevel;
				envev[\levelBias] = nextbias;
				envev[\timeScale] = nexttime;
				envev.debug("envev");
				ev[\finish] = ev[\finish].addFunc({
					envev.play;
				});
				cleanup.update(ev, cleanup_fun);
				ev = envev[\out].asMap.yield;
			};
		};
		cleanup.exit(ev);
		//{
			//cleanup_fun.();
		//}.defer(1);
		ev;
	});
}
)

(
~pnoteEnv = { arg levels, times, curves=0, levelScale=1, levelBias=0, timeScale=1, key;

	Prout({ arg ev;
		var pat;
		var str, levelstr, biasstr, timestr;
		var cleanup = EventStreamCleanup.new;
		var envsize;
		var synthdef;
		levels = levels ?? { [1,1] };
		times = times ?? { [1] };
		envsize = levels.size;
		synthdef = ( \PnoteEnv_size++envsize ).asSymbol;


		//cleanup.addFunction(ev, cleanup_fun);

		pat = Ptuple( 
			Env(levels, times, curves).asArray 
		).collect{ arg x; [x] };
		str = pat.asStream;
		levelstr = levelScale.asStream;
		biasstr = levelBias.asStream;
		timestr = timeScale.asStream;


		block { arg break;
			var nextenv;
			var prevenv;
			var make_cleanup_fun;
			make_cleanup_fun = { arg lbus;
				{
					debug("pnoteEnv_adsr cleanup_fun");
					if(lbus.index.notNil) {
						var reltime;
						var env = nextenv ?? { prevenv };
						if(env.notNil) {
							reltime = env.first.asEnv.times.last;
						} {
							reltime = 2;
						};
						{
							if(lbus.index.notNil) {
								[lbus, reltime].debug("free bus");
								lbus.free;
							}
						}.defer(reltime);
					};
				}
			};

			loop {
				var bus;
				var cleanup_fun;
				var envev;
				var nextlevel, nexttime, nextbias;
				envev = ();
				prevenv = nextenv;
				nextenv = str.next;
				nextlevel = levelstr.next;
				nextbias = biasstr.next;
				nexttime = timestr.next;
				if(nextenv.isNil or: { nextlevel.isNil } or: { nexttime.isNil } or: { nextbias.isNil }) {
					break.value;
					//ev = nil.yield
				};


				[\sustain, \legato, \dur].do { arg key, idx;
					envev[key] = ev[key];
				};
				envev[\instrument] = synthdef;
				envev[\env] = nextenv;
				envev[\levelScale] = nextlevel;
				envev[\levelBias] = nextbias;
				envev[\timeScale] = nexttime;
				envev[\hasGate] = false; // prevent node not found msg
				envev.debug("envev");
				if(key.isNil) { 
					// bus will leak when pattern is unrolled but not played
					bus = Bus.control(Server.default, 1); 
					bus.debug("new static local bus");
					cleanup_fun = make_cleanup_fun.(bus);
				} {
					  
				};

				ev[\finish] = ev[\finish].addFunc({
					var env;
					env = nextenv ? prevenv;
					if(key.notNil) { // use a new bus for each event
						bus = Bus.control(Server.default, 1); // local to each event
						bus.debug("new dynamic local bus");
						currentEnvironment[key] = bus.asMap;
						cleanup_fun = make_cleanup_fun.(bus);
						//CmdPeriod.doOnce({ 
							//cleanup_fun.();
						//});
					};
					bus.set(env.asEnv.levels.first);
					envev[\out] = bus;
					debug("debug5");
					//bus.set(nextenv.first.asEnv.levels.first);
					//envev[\out] = bus.index;
					envev.play;
					debug("debug6");
					cleanup.update(currentEnvironment, cleanup_fun);
					thisThread.clock.sched(envev[\dur], {
						bus.debug("clean local bus");
						cleanup_fun.()
					});
					debug("debug7");
				});

				if(key.isNil) {
					cleanup.update(ev, cleanup_fun);
					ev = bus.asMap.yield;
				} {
					ev = 1.yield; // will be replaced by finish
				};
			};
		};
		cleanup.exit(ev);
		//{
			//cleanup_fun.();
		//}.defer(1);
		ev;
	});
}
)

(
SynthDef(\inlineEnv_adsr, { arg out=0, gate=1, levelScale=1, levelBias=0, timeScale=1;
	var sig;
	sig = EnvGen.kr(\adsr.kr(Env.adsr(0.4,0.1,0.8,0.1)), gate, levelScale: levelScale, levelBias: levelBias, timeScale: timeScale, doneAction:2);
	Out.kr(out, sig);
}).add;

SynthDef(\PnoteEnv_adsr, { arg out=0, gate=1, levelScale=1, levelBias=0, timeScale=1;
	var sig;
	sig = EnvGen.kr(\env.kr(Env.adsr(0.4,0.1,0.8,0.1)), gate, levelScale: levelScale, levelBias: levelBias, timeScale: timeScale, doneAction:2);
	Out.kr(out, sig);
}).add;

(2..10).do { arg num;
	SynthDef(( \PnoteEnv_size++num ).asSymbol, { arg out=0, gate=1, levelScale=1, levelBias=0;
		var sig;
		sig = EnvGen.kr(\env.kr( Env(1!num, 1!(num-1), 0!(num-1)) ), gate, levelScale: levelScale, levelBias: levelBias, doneAction:2);
		ReplaceOut.kr(out, sig);
	}).add;
};
);

(
// new version using delayed event system
~make_payload = { arg event, fun;
	if(event[\hasPmodEnvPayload] != true) {
		event[\hasPmodEnvPayload] = true;
		event[\finish] = { arg ev;
			"ss".debug("run finish");
			ev.keys.do { arg key;
				if(ev[key].isKindOf(Event)) {
					if([\PmodEnv_payload].includes(ev[key][\type])) {
						ev[key].payload.debug("run finish");
						ev[key] = ev[key].payload.(ev, key);
					};
				};

			};

		};
	};
	(type: \PmodEnv_payload, payload: { fun }).yield;
};
~pnoteEnv = { arg levels, times, curves=0, levelScale=1, levelBias=0, timeScale=1, key;

	Prout({ arg ev;
		var pat;
		var str, levelstr, biasstr, timestr;
		var cleanup = EventStreamCleanup.new;
		var envsize;
		var synthdef;
		levels = levels ?? { [1,1] };
		times = times ?? { [1] };
		envsize = levels.size;
		synthdef = ( \PnoteEnv_size++envsize ).asSymbol;


		//cleanup.addFunction(ev, cleanup_fun);

		pat = Ptuple( 
			Env(levels, times, curves).asArray 
		).collect{ arg x; [x] };
		str = pat.asStream;
		levelstr = levelScale.asStream;
		biasstr = levelBias.asStream;
		timestr = timeScale.asStream;


		block { arg break;
			var nextenv;
			var prevenv;
			var make_cleanup_fun;
			make_cleanup_fun = { arg lbus;
				{
					debug("pnoteEnv_adsr cleanup_fun");
					if(lbus.index.notNil) {
						var reltime;
						var env = nextenv ?? { prevenv };
						if(env.notNil) {
							reltime = env.first.asEnv.times.last;
						} {
							reltime = 2;
						};
						{
							if(lbus.index.notNil) {
								[lbus, reltime].debug("free bus");
								lbus.free;
							}
						}.defer(reltime);
					};
				}
			};

			loop {
				var bus;
				var cleanup_fun;
				var envev;
				var nextlevel, nexttime, nextbias;
				envev = ();
				prevenv = nextenv;
				nextenv = str.next;
				nextlevel = levelstr.next;
				nextbias = biasstr.next;
				nexttime = timestr.next;
				if(nextenv.isNil or: { nextlevel.isNil } or: { nexttime.isNil } or: { nextbias.isNil }) {
					break.value;
					//ev = nil.yield
				};

				~make_payload.(ev, { arg iev, key;
					var env;
					bus = Bus.control(Server.default, 1); 
					env = nextenv ? prevenv;
					bus.debug("new payload local bus");
					cleanup_fun = make_cleanup_fun.(bus);
					bus.set(env.asEnv.levels.first);

					envev[\out] = bus;
					[\sustain, \legato, \dur].do { arg key, idx;
						envev[key] = iev[key];
					};
					envev[\instrument] = synthdef;
					envev[\env] = nextenv;
					envev[\levelScale] = nextlevel;
					envev[\levelBias] = nextbias;
					envev[\timeScale] = nexttime;
					envev[\hasGate] = false; // prevent node not found msg

					debug("debug5");
					envev.play;
					debug("debug6");
					cleanup.update(iev, cleanup_fun);
					thisThread.clock.sched(envev[\dur], {
						bus.debug("clean local bus");
						cleanup_fun.()
					});
					debug("debug7");
					bus.asMap;

				});
			};
		};
		cleanup.exit(ev);
		//{
			//cleanup_fun.();
		//}.defer(1);
		ev;
	});
}
)

(
// final version used in PnoteEnv
// new version using delayed event system
// generic
~make_payload = { arg event, fun;
	if(event[\hasPmodEnvPayload] != true) {
		debug("attach payload");
		event[\hasPmodEnvPayload] = true;
		event[\finish] = event[\finish].addFunc({ arg ev;
			"ss".debug("run finish");
			ev.keys.do { arg key;
				if(ev[key].isKindOf(Event)) {
					if([\PmodEnv_payload].includes(ev[key][\type])) {
						ev[key].payload.debug("run finish");
						ev[key] = ev[key].payload.(ev, key);
					};
				};

			};

		});
	} {
		debug("has already a payload");
	};
	(type: \PmodEnv_payload, payload: { fun }).yield;
};
~pnoteEnv_generic = { arg envpat, synthdef, levelScale=1, levelBias=0, timeScale=1;

	Prout({ arg ev;
		var pat;
		var str, levelstr, biasstr, timestr;
		var envsize;
		envsize = envpat.size;
		synthdef = synthdef ?? { ( \PnoteEnv_size++envsize ).asSymbol };

		pat = Ptuple( 
			envpat.asArray
		).collect{ arg x; [x] };
		str = pat.asStream;
		levelstr = levelScale.asStream;
		biasstr = levelBias.asStream;
		timestr = timeScale.asStream;


		block { arg break;
			var nextenv;
			var prevenv;
			var make_cleanup_fun;
			make_cleanup_fun = { arg lbus;
				{
					debug("pnoteEnv_generic cleanup_fun");
					if(lbus.index.notNil) {
						var reltime;
						var env = nextenv ?? { prevenv };
						if(env.notNil) {
							reltime = env.first.asEnv.times.last;
						} {
							reltime = 2;
						};
						{
							if(lbus.index.notNil) {
								[lbus, reltime].debug("free bus");
								lbus.free;
							}
						}.defer(reltime);
					};
				}
			};

			1000.do { arg loopidx;
				var bus;
				var cleanup_fun;
				var envev;
				var nextlevel, nexttime, nextbias;
				var cleanup = EventStreamCleanup.new;
				loopidx.debug("newloop");
				envev = ();
				prevenv = nextenv;
				nextenv = str.next;
				nextlevel = levelstr.next;
				nextbias = biasstr.next;
				nexttime = timestr.next;
				if(nextenv.isNil or: { nextlevel.isNil } or: { nexttime.isNil } or: { nextbias.isNil }) {
					debug("break");
					break.value;
					//ev = nil.yield
				};

				cleanup.addFunction(ev, { "EventStreamCleanup run".debug; cleanup_fun.() });
				ev = ~make_payload.(ev, { arg iev, key;
					var env;
					bus = Bus.control(Server.default, 1); 
					env = nextenv ? prevenv;
					bus.debug("new payload local bus");
					cleanup_fun = make_cleanup_fun.(bus);
					bus.set(env.asEnv.levels.first);

					envev[\out] = bus;
					[\sustain, \legato, \dur].do { arg key, idx;
						envev[key] = iev[key];
					};
					envev[\instrument] = synthdef;
					envev[\env] = nextenv;
					envev[\levelScale] = nextlevel;
					envev[\levelBias] = nextbias;
					envev[\timeScale] = nexttime;
					envev[\hasGate] = false; // prevent node not found msg

					debug("debug5");
					envev.play;
					debug("debug6");
					cleanup.update(iev);
					thisThread.clock.sched(envev[\dur], {
						bus.debug("clean bus by sched");
						cleanup_fun.()
					});
					debug("debug7");
					bus.asMap;

				});
			};
		};
		//cleanup.exit(ev);
		//{
			//cleanup_fun.();
		//}.defer(1);
		ev;
	});
};
~pnoteEnv = { arg levels, times, curves=0, levelScale=1, levelBias=0, timeScale=1;
	var envsize;
	levels = levels ?? { [1,1] };
	times = times ?? { [1] };
	~pnoteEnv_generic.(Env(levels, times, curves), nil, levelScale, levelBias, timeScale);
};
~pnoteEnv_adsr = { arg attack=0.1, decay=0.1, sustainLevel=0.8, release=0.1, peakLevel=1, curves=0, levelScale=1, levelBias=0, timeScale=1;
	~pnoteEnv_generic.(Env.adsr(attack, decay, sustainLevel, release, peakLevel, curves), \PnoteEnv_adsr, levelScale, levelBias, timeScale);
};
)

(
	// last form
)

(
~make_payload = { arg fun;
	Prout({ arg ev;
		ev[\finally] = { arg ev;
			ev.keys.do { arg key;
				if(ev[key].isKindOf(Event)) {
					if([\PmodEnv_payload, \group, \bus].includes(ev[key][\type])) {
						var res;
						var bus;
						res = ev[key].play;
						bus = res[\out];
						fun.(key, bus);
						ev[key] = bus.asMap;
						res.debug("res");
					};
				};
				
			};

		}
		
	})
};
~pnoteEnv = {
	
}
)

(
~make_payload = { arg fun;
	Prout({ arg ev;
		ev[\finish] = { arg ev;
			"ss".debug("run finish");
			ev.keys.do { arg key;
				if(ev[key].isKindOf(Event)) {
					if([\PmodEnv_payload].includes(ev[key][\type])) {
						ev[key].payload.debug("run finish");
						ev[key] = ev[key].payload.();
					};
				};
				
			};

		};
		(type: \PmodEnv_payload, payload: { fun }).yield;
		
	})
};
~pnoteEnv = {
	
}
)

(
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0],inf),
		\lpfr, Prout({ arg ev;

			"ss".debug("start lpfr prout");
			10.do { arg item, idx;

				ev = ~make_payload.({ 
					var bus = Bus.control(s,1);
					"ss".debug("make_payload");
					(instrument:\saw, freq:300).play;
					bus.set(2);
					bus.asMap;
				}).embedInStream(ev)
			};
		}),
		\dur, 1,
		\amp, 0.1,
	).trace
).play;
);
~s = Pdef(\zed).asStream
~s.next(Event.default)
