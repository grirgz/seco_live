
~pmodenv = { arg ...args; PmodEnv(*args) };
// run again infinite pmodenv: no pile up
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\freq, ~pmodenv.(Pseq([100,200,1000,400],inf), 2),
			\dur, 1,
			\amp, 0.1,
		),

	])
)).play;
);

// very fast run again infinite pmodenv: no pile up
// push F5 very fast
// with playload version: no pile up
(
	10.do {
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\freq, ~pmodenv.(Pseq([100,200,1000,400],inf), 2),
			\dur, 1,
			\amp, 0.1,
		),

	])
)).play;
	}
);

// run again when finite Pbind has already ended: BUG! pile up
// watchdog: no pile up
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\freq, ~pmodenv.(Pseq([100,200,1000,400],inf), 2),
			\dur, Pn(1,2),
			\amp, 0.1,
		),
	])
)).play;
);

// use stop on a pattern not finished yet: no pile up

Pdef(\part).stop



// stopped by Pfindur : no pile up
// watchdog: no pile up
// payload: no pile up
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pfindur(1,Pbind(
			\instrument, \default,
			\freq, ~pmodenv.(Pseq([100,200,1000,400],inf), 2),
			\dur, 1,
			\amp, 0.1,
		)).loop,

	])
)).play;
);

// finite pattern with infinite pmodenv : BUG !
// watchdog: no pile up
(
Pdef(\part, Pdef(\zedpart, 
	Pseq([
		Pbind(
			\instrument, \default,
			\freq, ~pmodenv.(Pseq([100,200,1000,400],inf), 2),
			\dur, Pn(1,2),
			\amp, 0.1,
		),
	],100)
)).play;
);

// finite pattern with infinite pmodenv : BUG !
// when pattern really ends
// watchdog: no pile up
(
Pdef(\part, Pdef(\zedpart, 
	Pseq([
		Pbind(
			\instrument, \default,
			\freq, ~pmodenv.(Pseq([100,200,1000,400],inf), 2),
			\dur, Pn(1,2),
			\amp, 0.1,
		),
	],2)
)).play;
);


// finite pattern with infinite pmodenv : OK
// test with parent that might cleanup
// this work
(
Pdef(\part, Pdef(\zedpart, 
	Pseq([
		Pbus(
		Pbind(
			\instrument, \default,
			\freq, ~pmodenv.(Pseq([100,200,1000,400],inf), 2),
			\dur, Pn(1,2),
			\amp, 0.1,
		)),
	],100)
)).play;
);


// put in Pbindef : pile up each time we run it, cleaned when pbindef stop
// watchdog: no pile up
Pbindef(\bla, \freq, 100).play
Pbindef(\bla, \dur, 1/2).play
Pbindef(\bla, \freq, ~pmodenv.(Pseq([100,200,1000,400],inf), 2)).play
Pbindef(\bla).stop


// test finite PmodEnv OK
(
Pdef(\part, Pdef(\zedpart, 
	Pseq([
		Pbind(
			\instrument, \default,
			\freq, ~pmodenv.(Pseq([100,200],1), 1/8).loop,
			\dur, Pn(1,2),
			\amp, 0.1,
		),
	],2)
)).play;
);
(
Pdef(\part, Pdef(\zedpart, 
	Pseq([
		Pbind(
			\instrument, \default,
			\freq, ~pmodenv.(Pseq([100,200],1), 2).loop,
			\dur, Pn(1/4,4),
			\amp, 0.1,
		),
	],2)
)).play;
);




//////////////////////////////////////////////////////////////////////////////

/////////////////////// test dur argument



(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\freq, ~pmodenv.(Pseq([100,1000],inf)),
			\dur, Pseq([1/2,1/2,1/2,4,4,4],inf),
			\amp, 0.1,
		),

	])
)).play;
);

~pat = Pfunc({ arg ev; ev[\bla].postln; 10}) <> (bla:3)

~pat.asStream.next



(
~pmodenv = { arg valpat, timepat=1, repeat=1, curvepat;
	// return a pattern that append a function to \finish which start a Pmono of modenvmono synth outputing an env curve according to patterns from function parameters
	repeat = repeat.clip(1,inf); // prevent infinite loop when puting negative curve in repeat
	Prout({ arg ev;
		var bus = Bus.control(s, 1);
		var timestr;
		var running = true;
		var cleanup = EventStreamCleanup.new;
		var patplayer;
		var finish_fun;
		var cleanup_fun = {
			patplayer.stop;
			running = false;
			//"pmodenv: CLEANUP".debug;
			{
				2.wait;
				if(bus.index.notNil) {
					bus.free;
				}
			}.fork;
		};

		timepat = timepat ??  { Plazy({ ev[\dur] }).loop };
        timepat = Pchain(timepat, Pfunc({ ev }));
		curvepat = curvepat ??  { 0 };
        curvepat = Pchain(curvepat, Pfunc({ ev }));
        valpat = Pchain(valpat, Pfunc({ ev }));

		cleanup.addFunction(ev, cleanup_fun);

		CmdPeriod.doOnce({ 
			if(bus.index.notNil) {
				bus.free 
			}
		});

		finish_fun = {
			patplayer = Pmono(\modenvmono,
				\out, bus,
				\itrig, 1,
				[ \dur, \env ], Prout({ arg monoev;
					var valstr = valpat.asStream;
					var curvestr = curvepat.asStream;
					var previous = valstr.next;
					var time;
					timestr = timepat.asStream;

					block { arg break;
						valstr.do { arg val;
							var prev = previous;
							var curve;
							//val.debug("pmodenv val");
							time = timestr.next;
							curve = curvestr.next;
							if(time.isNil) { 
								time = 2;
								monoev[\dur] = time;
								break.value;
							};
							if(curve.isNil) { 
								time = 2;
								monoev[\dur] = time;
								break.value;
							};

							//monoev[\dur] = time;
							//Env([prev,val],[time]/thisThread.clock.tempo).asCompileString.debug("env");
							monoev = [time, [ Env([prev,val],[time]/thisThread.clock.tempo, curve) ]].yield;

							previous = val;
						};
					};
					running = false;
					monoev;
				}),
				\legato, 1,
			).play;
		};

		if(ev[\finish].isKindOf(Function)) {
			var oldfun = ev[\finish];
			ev[\finish] = { finish_fun.value; oldfun.value };
		} {
			ev[\finish] = finish_fun;
		};

		while{ running == true } {
			//"pmodenv running".debug;
			var ret = bus.asMap;
			cleanup.update(ev);
			ev = ret.yield;
			//ev.debug("ev");
			if(ev.isNil) {
				"pmodenv: pattern ends".debug; // this never happen
				cleanup_fun.value;
			}
		};
		ev;
	}).repeat(repeat)
};

);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
            \val, Pseq([100,1000,400,400,400],inf),
            \curve, Pseq([-10,10],inf),
			\freq, ~pmodenv.(Pkey(\val), nil, 1, Pkey(\curve)),
			\dur, Pseq([1],inf),
			\amp, 0.1,
		),

	])
)).play;
);

~pat = 0.asPattern <> Pfunc({ arg ev; 3 })
~pat.asStream.next
        Pchain(1, Pfunc({ (bla:3) })).asStream.nextN(4)
        Pchain(nil, Pfunc({ (bla:3) })).asStream.nextN(4)
        Pchain(Pfunc({ arg ev; ev[\bla].debug("BLA") }), Pfunc({ (bla:3) })).asStream.nextN(4)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pbind(
			\instrument, \default,
            \val, Pseq([100,1000,400,400,400],inf),
            \curve, Pseq([-10,10],inf),
			\freq, ~pmodenv.(),
			\amp, 0.1,
		),

	])
)).play;
);


///////////////////// test multiple pmodenv

(
SynthDef(\sh101, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lpenv, lpfreq;
	sig = LFSaw.ar(freq);
	lpenv = EnvGen.kr(\lpadsr.kr(Env.adsr(0.01,0.4,0.1,0.8)), gate, doneAction:0) * \envamt.kr(1) + 1;
	lpfreq = freq * \kbamt.kr(0) + 1;
	//sig = RLPF.ar(sig, ( \lpf.kr(130) * lpenv * lpfreq ).clip(20,20000), \rq.kr(0.8));
	sig = MoogFF.ar(sig, ( \lpf.kr(130).poll * lpenv * lpfreq ).clip(20,20000), 1/\rq.kr(0.8).poll) * 3;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.8)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);
FileSystemProject.load("libdef/pmodenv.scd")
(
// OK
Pdef(\acidbass, 
	Pbind(
		\instrument, \sh101,
		\degree, Pseq([0,3,2,-2],inf),
		\lpadsr, Pseq([
			[ Env.adsr(0.01,0.1,1.2,0.1) ],
		],inf),
		\adsr, Pseq([
			[ Env.adsr(0.01,0.01,1,0.01) ],
		],inf),
		\kbamt, 0,
		\lpf, ~pmodenv.(Pseq([150,400],1), 8).loop,
		\rq, ~pmodenv.(Pseq([0.26,0.4],1), 2).loop,
		\envamt, 2,
		\octave, 4,
		\dur, 1/8,
		\amp, 0.07,
	)
).play;
);
Pdef(\acidbass).clear

//// test several segments
~t = 2; TempoClock.default.tempo = ~t;
(
// OK
Pdef(\acidbass, 
	Pbind(
		\instrument, \sh101,
		\degree, Pseq([0,3,2,-2],inf),
		\lpadsr, Pseq([
			[ Env.adsr(0.01,0.1,1.2,0.1) ],
		],inf),
		\adsr, Pseq([
			[ Env.adsr(0.01,0.01,1,0.01) ],
		],inf),
		\kbamt, 0,
		\lpf, ~pmodenv.(Pseq([150,400,600],1), 8).loop,
		\rq, ~pmodenv.(Pseq([0.26,0.4,0.3],1), 2).loop,
		\envamt, 2,
		\octave, 4,
		\dur, 1,
		\amp, 0.07,
	)
).play;
);

(
Pdef(\acidbass, 
	Pbind(
		\instrument, \sh101,
		\degree, Pseq([0,3,2,-2],inf),
		\lpadsr, Pseq([
			[ Env.adsr(0.01,0.1,1.2,0.1) ],
		],inf),
		\adsr, Pseq([
			[ Env.adsr(0.01,0.01,1,0.01) ],
		],inf),
		\kbamt, 0,
		\lpf, ~testpmodenv.(Pseq([150,400],1), 8).loop,
		\rq, ~testpmodenv.(Pseq([0.3,0.4],1), 2).loop,
		\envamt, 2,
		\octave, 4,
		\dur, 1/8,
		\amp, 0.07,
	)
).play;
);


(
SynthDef(\testpmod, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq 
		+ \test1.kr(0).poll(label:"test1") 
		+ \test2.kr(0).poll(label:"test2")  
		+ \test3.kr(0).poll(label:"test3")  
		+ \test4.kr(0).poll(label:"test4") 
	);
	//[\test1.kr, \test2.kr, \test3.kr, \test4.kr].poll(label:"test");
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\zed, 
	Pbind(
		\instrument, \testpmod,
		\degree, Pseq([0],inf),
		\test1, PmodEnv(Pseq([1,1],inf), 8).loop,
		\test2, PmodEnv(Pseq([2,2],inf), 8).loop,
		\test3, PmodEnv(Pseq([3,3],inf), 8).loop,
		\test4, PmodEnv(Pseq([4,4],inf), 8).loop,
		\dur, Pn(1,1),
		\amp, 0.1,
	).trace
).play;
);

(
Pdef(\zed, 
	Pbind(
		\instrument, \testpmod,
		\degree, Pseq([0],inf),
		\test1, ~testpmodenv.(Pseq([1,1],1), 8).loop,
		\test2, ~testpmodenv.(Pseq([2,2],inf), 8).loop,
		\test3, ~testpmodenv.(Pseq([3,3],inf), 8).loop,
		\test4, ~testpmodenv.(Pseq([4,4],inf), 8).loop,
		\dur, Pn(1,inf),
		\amp, 0.1,
	).trace
).play;
);

FileSystemProject.load("libdef/pmodenv.scd");
(
Pdef(\zed, 
	Pbind(
		\instrument, \testpmod,
		\degree, Pseq([0],inf),
		\test1, ~pmodenv.(Pseq([1,1],inf), 8).loop,
		\test2, ~pmodenv.(Pseq([2,2],inf), 8).loop,
		\test3, ~pmodenv.(Pseq([3,3],inf), 8).loop,
		\test4, ~pmodenv.(Pseq([4,4],inf), 8).loop,
		\dur, Pn(1,1),
		\amp, 0.1,
	).trace
).play;
);

///////////////////// test problematic pmono
// bug solved: \delta is set to 0 in Ppar


(
Pdef(\testme, 
		Pmono(\fxcorpus,
			\inbus, BusDef(\pifx2, \audio),
			\out, BusDef(\pifx3, \audio),
			\addAction, \addToTail,
			\freq, PmodEnv(Pseq([10,100,800],1), 8).loop,
			\bwr, PmodEnv(Pseq([0.1,4,0.5],1), 8).loop,
			\rgain, 15,
			//\lag, 0.0009,
			\dur, 1,
		),
).play;
);

PmodEnv.watchdogEnabled = true;
PmodEnv.watchdogEnabled = false; // disabling watchdog hide the bug

(
~pmodenv = { arg ...args; PmodEnv(*args) };
~t = 2; TempoClock.default.tempo = ~t; // tempo doesn't seem to change
FileSystemProject.loadOnce("sndlib/buflib.scd");
FileSystemProject.loadOnce("libdef/synthplayrec.scd");
// FAIL!
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[688].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\degree, Pseq([0,3,2,-2],inf),
			\lpadsr, Pseq([
				[ Env.adsr(0.01,0.1,1.2,0.1) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,1,0.01) ],
			],inf),
			\kbamt, 0,
			\lpf, ~pmodenv.(Pseq([150,400,600],1), 8).loop,
			\rq, ~pmodenv.(Pseq([0.26,0.4,0.3],1), 2).loop,
			\envamt, 2,
			\octave, 4,
			\dur, 1/4,
			\amp, 0.07/3,
		)
	])
)).play;
);


//////////////////

///

(
	// with added watchdog
	~testpmodenv = { arg valPat, timePat, curvePat, repeats=1;

		Prout({ arg ev;

			var bus = Bus.control(Server.default, 1);
			var timestr;
			var running = true;
			var cleanup = EventStreamCleanup.new;
			var patplayer;
			var finish_fun;
			var cmdperiod_fun;
			var watchdog;
			var watchdogEnabled = true;
			var cleanup_fun = {
				[valPat, bus].debug("pmodenv: CLEANUP");
				patplayer.stop;
				running = false;
				{
					2.wait;
					//CmdPeriod.objects.do { arg obj, idx;
						////idx.debug("cmdperiod obj");
						//if(obj.isKindOf(Function)) {
							////obj.dump
						//};
					//};
					//cmdperiod_fun.dump;
					//CmdPeriod.remove(cmdperiod_fun);
					//CmdPeriod.objects.debug("cmdperiod after");
					if(bus.index.notNil) {
						bus.free;
					}
				}.fork;
			};

			//[valPat, bus].debug("pmodenv: NEW PAT");

			//if(timePat == \dur) {
				//timePat = Pfunc({ arg ev; ev.delta.value });
			//} {
				//timePat = timePat ??  1;
			//};
			timePat = timePat ??  { Plazy({ ev[\dur] }).loop };
			curvePat = curvePat ??  { 0 };

			cleanup.addFunction(ev, cleanup_fun);

			cmdperiod_fun = { 
				[valPat, bus].debug("cmdperiod: free bus");
				if(bus.index.notNil) {
					bus.free 
				}
			};
			CmdPeriod.doOnce(cmdperiod_fun);

			watchdog = (
				alive: { arg self, dur;
					dur.debug("alive");
					self.aliveDur = dur * 2; // times 2 for security
					self.aliveTime = thisThread.clock.beats;
				},

				isDead: { arg self;
					[self.aliveTime, self.aliveDur].debug("isDead");
					if(watchdogEnabled == true) {
						if(self.aliveTime.notNil and: {self.aliveDur.notNil}) {
							if(thisThread.clock.beats - self.aliveTime > self.aliveDur ) {
								true
							} {
								false
							}
						} {
							false
						};
					} {
						false
					};
				},
			);

			finish_fun = {
				patplayer = Pmono(\PmodEnv_mono,
					\out, bus,
					\itrig, 1,
					[ \dur, \env ], Prout({ arg monoev;
						var valstr = valPat.asStream;
						var curvestr = curvePat.asStream;
						var previous = valstr.next;
						var time;
						timestr = timePat.asStream;

						block { arg break;
							valstr.do({ arg val;
								var prev = previous;
								var curve;
								//val.debug("pmodenv val");
								//ev.debug("ev inside modenvmono");
								time = timestr.next;
								curve = curvestr.next;
								if(time.isNil) { 
									time = 2;
									monoev[\dur] = time;
									break.value;
								};
								if(curve.isNil) { 
									time = 2;
									monoev[\dur] = time;
									break.value;
								};

								//monoev[\dur] = time;
								//Env([prev,val],[time]/thisThread.clock.tempo).asCompileString.debug("env");
								if(watchdog.isDead) {
									"dead!".debug;
									break.value;
								};
								monoev = [time, [ Env([prev,val],[time]/thisThread.clock.tempo, curve) ]].yield;

								previous = val;
							});
						};
						//cmdperiod_fun.(); // cleanup only bus since other are already cleaned
						running = false; // required else pattern never finish
						monoev;
					}),
					\legato, 1,
				).play;
			};

			if(ev[\finish].isKindOf(AbstractFunction)) {
				var oldfun = ev[\finish];
				ev[\finish] = oldfun.addFunc(finish_fun);
			} {
				ev[\finish] = finish_fun;
			};

			while{ running == true } {
				cleanup.update(ev);
				ev[\finish] = ev[\finish].addFunc({ arg iev;
					watchdog.alive(iev.delta ?? iev.dur);
				});
				ev = bus.asMap.yield;
			};
			//[valPat.asCompileString, bus].debug("pmodenv: cleanup");
			cleanup_fun.();
			//cleanup.exit(ev); // this cleanup all PmodEnv of the pattern
			ev;
		}).repeat(repeats.clip(1,inf))
	};
~pmodenv = ~testpmodenv;
)

///////////////////////////////////
// test watchdog

(
// dur is after: OK
// this free the bus too soon
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\freq, ~pmodenv.(Pseq([100,200,1000,400],inf), 6),
			\dur, Pn(4,2),
			\amp, 0.1,
		).trace,
	])
)).play;
);
(
// bigger pmod dur than pbind dur
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\freq, ~pmodenv.(Pseq([100,200,1000,400],inf), 6),
			\dur, Pn(1,2),
			\amp, 0.1,
		).trace,
	])
)).play;
);

(
// lower pmod dur than pbind dur
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\freq, ~pmodenv.(Pseq([100,200,1000,400],inf), 1/8),
			\dur, Pn(1,4),
			\amp, 0.1,
		),
	],2)
)).play;
);

(
// test stretch before: OK
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\stretch, 4,
			\dur, Pn(1,2),
			\freq, ~pmodenv.(Pseq([100,200,1000,400],inf), 1/8),
			\amp, 0.1,
		),
	],2)
)).play;
);

(
// test stretch after: OK
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\freq, ~pmodenv.(Pseq([100,200,1000,400],inf), 1/8),
			\stretch, 4,
			\dur, Pn(1,2),
			\amp, 0.1,
		),
	],2)
)).play;
);


/////////////////////

(
	// put bus creation in finish func with makePayload
~testpmodenv = { arg valPat, timePat, curvePat, repeats=1;

	Prout({ arg ev;

		var timestr;
		var running = true;
		var cleanup = EventStreamCleanup.new;
		var cleanup_fun;
		var patplayer;
		var finish_fun;
		var cmdperiod_fun;
		var watchdog;
		var bus;
		var watchdogEnabled = true;

		cleanup_fun = {
			[valPat, bus].debug("pmodenv: CLEANUP");
			patplayer.stop;
			running = false;
			{
				2.wait;
				//CmdPeriod.objects.do { arg obj, idx;
				////idx.debug("cmdperiod obj");
				//if(obj.isKindOf(Function)) {
				////obj.dump
				//};
				//};
				//cmdperiod_fun.dump;
				//CmdPeriod.remove(cmdperiod_fun);
				//CmdPeriod.objects.debug("cmdperiod after");
				if(bus.index.notNil) {
					bus.free;
				}
			}.fork;
		};
		cleanup.addFunction(ev, cleanup_fun); // should not be inside \finish

		watchdog = (
			alive: { arg self, dur;
				dur.debug("alive");
				self.aliveDur = dur * 2; // times 2 for security
				self.aliveTime = thisThread.clock.beats;
			},

			isDead: { arg self;
				[self.aliveTime, self.aliveDur].debug("isDead");
				if(watchdogEnabled == true) {
					if(self.aliveTime.notNil and: {self.aliveDur.notNil}) {
						if(thisThread.clock.beats - self.aliveTime > self.aliveDur ) {
							true
						} {
							false
						}
					} {
						false
					};
				} {
					false
				};
			},
		);

		ev = PnoteEnv.makePayload(ev, { arg iev;

			bus = Bus.control(Server.default, 1);

			//[valPat, bus].debug("pmodenv: NEW PAT");

			//if(timePat == \dur) {
			//timePat = Pfunc({ arg iev; iev.delta.value });
			//} {
			//timePat = timePat ??  1;
			//};
			timePat = timePat ??  { Plazy({ ev[\dur] }).loop };
			curvePat = curvePat ??  { 0 };


			cmdperiod_fun = { 
				[ valPat, bus ].debug("cmdperiod: free bus");
				if(bus.index.notNil) {
					bus.free 
				}
			};
			CmdPeriod.doOnce(cmdperiod_fun);

			watchdog.alive(iev.delta ?? iev.dur);

			patplayer = Pmono(\PmodEnv_mono,
				\out, bus,
				\itrig, 1,
				[ \dur, \env ], Prout({ arg monoev;
					var valstr = valPat.asStream;
					var curvestr = curvePat.asStream;
					var previous = valstr.next;
					var time;
					timestr = timePat.asStream;

					block { arg break;
						valstr.do({ arg val;
							var prev = previous;
							var curve;
							//val.debug("pmodenv val");
							//ev.debug("ev inside modenvmono");
							time = timestr.next;
							curve = curvestr.next;
							if(time.isNil) { 
								time = 2;
								monoev[\dur] = time;
								break.value;
							};
							if(curve.isNil) { 
								time = 2;
								monoev[\dur] = time;
								break.value;
							};

							//monoev[\dur] = time;
							//Env([prev,val],[time]/thisThread.clock.tempo).asCompileString.debug("env");
							if(watchdog.isDead) {
								"dead!".debug;
								break.value;
							};
							monoev = [time, [ Env([prev,val],[time]/thisThread.clock.tempo, curve) ]].yield;

							previous = val;
						});
					};
					{
						cmdperiod_fun.(); // cleanup only bus since other are already cleaned
					}.defer(2);
					running = false;
					monoev;
				}),
				\legato, 1,
			).play;
			bus.asMap;
		});


		while{ running == true } {
			ev = PnoteEnv.makePayload(ev, { arg iev;
				watchdog.alive(iev.delta ?? iev.dur);
				cleanup.update(iev);
				bus.asMap
			});
			//ev[\finish] = ev[\finish].addFunc({ arg ev;
			//});
			//ev = bus.asMap.yield;
		};
		//[valPat.asCompileString, bus].debug("pmodenv: cleanup");
		cleanup_fun.();
		//cleanup.exit(ev); // this cleanup all PmodEnv of the pattern
		ev;
	}).repeat(repeats.clip(1,inf))
};
~pmodenv = ~testpmodenv;
)


// test bus leak


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\freq, ~pmodenv.(Pseq([100,200,1000,400],inf), 6),
			\dur, Pn(1,2),
			\amp, 0.1,
		).trace,
	])
)).play;
)
BusDef(\aaah,\control).index
Pdef(\part).asStream.nextN(10,Event.default)

// stopped by Pfindur : no pile up
// watchdog: no pile up
// payload: no pile up
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pfindur(1,Pbind(
			\instrument, \default,
			\freq, ~pmodenv.(Pseq([100,200,1000,400],inf), 2),
			\dur, 1,
			\amp, 0.1,
		)).loop,

	])
)).play;
);

(
// OK
Pdef(\acidbass, 
	Pbind(
		\instrument, \sh101,
		\degree, Pseq([0,3,2,-2],inf),
		\lpadsr, Pseq([
			[ Env.adsr(0.01,0.1,1.2,0.1) ],
		],inf),
		\adsr, Pseq([
			[ Env.adsr(0.01,0.01,1,0.01) ],
		],inf),
		\kbamt, 0,
		\lpf, ~pmodenv.(Pseq([150,400],1), 8).loop,
		\rq, ~pmodenv.(Pseq([0.3,0.4],1), 2).loop,
		\envamt, 2,
		\octave, 4,
		\dur, 1/8,
		\amp, 0.07,
	)
).play;
);


/////////////////// doc examples
