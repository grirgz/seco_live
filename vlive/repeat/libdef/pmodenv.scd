
(
SynthDef(\modenv, { arg out=0, amp=0.1, gate=1;
	var sig;
	sig = EnvGen.kr(\env.kr(Env([1,2,1],[0.1,0.8])), gate, doneAction:2);
	Out.kr(out, sig);
}).store;
SynthDef(\modenvlag, { arg out=0, amp=0.1, gate=1;
	var sig;
	var prev = In.kr(out);
	sig = EnvGen.kr(Env([prev,prev,\target.kr],[0,\time.kr]), gate, doneAction:2);
	Out.kr(out, sig);
}).store;
SynthDef(\modenvmono, { arg out=0, amp=0.1, gate=1;
	var sig;
	sig = EnvGen.kr(\env.kr(Env([1,1],[0.1])), \itrig.tr(1), doneAction:0);
	sig = sig * EnvGen.kr(Env([1,1,1],[0.1,0.8], releaseNode:1), gate, doneAction:2);
	Out.kr(out, sig);
}).store;
SynthDef(\simplefm, { arg out=0, amp=0.1, gate=1, pan=0;
	var sig;
	sig = LFSaw.ar(\freq.ar(200) * ( 1 + ( SinOsc.ar(\fmf.kr(1) * [1,1+\fmfmul.kr(0.001)]) * \fma.kr(1) )));
	sig = RLPF.ar(sig, \lpfr.kr(1) * \freq.ar, \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
SynthDef(\sinlfo, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, range=1, center=0;
	var sig;
	sig = SinOsc.ar(freq) * range + center;
	Out.ar(out, sig);
}).add;
);
(
~pmodenv = { arg valpat, timepat=1, repeat=1, curvepat;
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
		curvepat = curvepat ??  { 0 };

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
			ev = bus.asMap.yield;
			//ev.debug("ev");
			if(ev.isNil) {
				"pmodenv: pattern ends".debug; // this never happen
				cleanup_fun.value;
			}
		};
		ev;
	}).repeat(repeat)
};


~pmodenv_old = { arg valpat, timepat=1, repeat=1;
	// doesnt work : there is clicks between segments, new implementation use Pmono
	Prout({ arg ev;
		var bus = Bus.control(s, 1);
		var timestr;
		var running = true;
		var finfun;
		var cleanup = EventStreamCleanup.new;
		var patplayer;

		cleanup.addFunction(ev, {
			//"pmodenv freed !!!".debug;
			patplayer.stop;
			running = false;
			{
				2.wait;
				bus.free;
			}.fork;
		});

		CmdPeriod.doOnce({ 
			if(bus.index.notNil) {
				bus.free 
			}
		});

		finfun = ({
			patplayer = Pspawner({ arg sp;
				var valstr = valpat.asStream;
				var previous = valstr.next;
				var time;
				timestr = if(timepat.isNil) {
					Plazy({ ev[\dur] }).loop.asStream;
				} {
					timepat.asStream;
				};
				block { arg break;

					valstr.do { arg val;
						var prev = previous;
						time = timestr.next;
						if(time.isNil) { 
							time = 2;
							break.value;
						};
						//val.debug("val");
						//previous.debug("previous");

						//-- modenv

						//sp.seq(Pbind(
							//\instrument, \modenv,
							//\out, bus,
							//\env, [ Env([prev,prev,val],[0,time]/thisThread.clock.tempo) ],
							//\legato, 1,
							////\bla, Prout({ arg ev; ev[\env][0].asCompileString.debug("kj"); 1.yield }).loop,
							//\dur, Pseq([time],1),
						//));

						//-- modenvlag

						//sp.seq(Pbind(
							//\instrument, \modenvlag,
							//\out, bus,
							//\target, val,
							//\time, time/thisThread.clock.tempo,
							//\legato, 1,
							////\bla, Prout({ arg ev; ev[\env][0].asCompileString.debug("kj"); 1.yield }).loop,
							//\dur, Pseq([time],1),
						//));

						//-- modenvmono

						sp.seq(Pmono(\modenvmono,
							\out, bus,
							\env, [ Env([prev,val],[time]/thisThread.clock.tempo) ],
							\legato, 1,
							//\bla, Prout({ arg ev; ev[\env][0].asCompileString.debug("kj"); 1.yield }).loop,
							\dur, Pseq([time],1),
						));


						previous = val;
						//"kj==========aaa".debug;
					};
				};
				//"kj==end of loop========aaa".debug;
				running = false;
				sp.wait( time * 2 );
				bus.free;
			}).play;
		});
		if(ev[\finish].isKindOf(Function)) {
			var oldfun = ev[\finish];
			ev[\finish] = { finfun.value; oldfun.value };
		} {
			ev[\finish] = finfun;
		};

		while{ running == true } {
			ev = bus.asMap.yield;
		};
		ev;
	}).repeat(repeat)
};

~pmodsynth = { arg fun, dur, repeat=1, chainpat;

	Prout({ arg ev;
		var bus = Bus.control(s, 1);
		var running = true;
		var finfun;
		var cleanup = EventStreamCleanup.new;
		var patplayer;
		var instrname;
		var pattern;
		var xdur; // use local variable to escape closure

		//"starting pmodsynth".debug(ev);

		cleanup.addFunction(ev, {
			//"pmodsynth freed !!!".debug;
			patplayer.stop;
			running = false;
			{
				2.wait;
				bus.free;
			}.fork;
		});

		if(dur.isNil) {
			xdur = 1;
		} {
			xdur = Pseq([dur],1)
		};

		instrname = \pmodsynth_+++fun.hash;

		SynthDef(instrname, { arg out=0, gate=1;
			var sig;
			var env;
			sig = SynthDef.wrap(fun);
			//sig.poll;
			sig = sig * EnvGen.kr(Env([1,1,1],[1,1]/50,releaseNode:1), gate, doneAction:2);
			Out.kr(out, sig);
		}).add;

		CmdPeriod.doOnce({ 
			if(bus.index.notNil) {
				bus.free 
			}
		});

		pattern = Pseq([
			Pmono( instrname,
				\legato, 1,
				\dur, xdur,
				\out, bus,
			),
			Prout({
				running = false;
				(isRest:true).yield;
			})
		]);
		if(chainpat.notNil) {
			pattern = chainpat <> pattern
		};

		finfun = ({
			patplayer = pattern.play;
		});

		if(ev.notNil) {
			if(ev[\finish].isKindOf(Function)) {
				var oldfun = ev[\finish];
				ev[\finish] = { finfun.value; oldfun.value };
			} {
				ev[\finish] = finfun;
			};

			while{ running == true } {
				//[running,bus.asMap].debug("runningx ?");

				ev = bus.asMap.yield;
			};
			//[running,bus.asMap].debug("no more runningx");
		} {
			debug("~pmodsynth: input event is nil");
			ev = BusDef(\zero, \control).asMap.yield;
		};
		ev; // dont forget to return event
	});

};

////////

~pmodseg = { arg valpat, repeat=inf;
	Prout({ arg ev;
		var bus = Bus.control(s,1);
		var valstr = valpat.asStream;
		var timestr;
		var previous = valstr.next;

		CmdPeriod.doOnce({ bus.free });

		timestr = Plazy({ ev[\dur] }).loop.asStream;

		valstr.do { arg val;
			var time = timestr.next;
			var prev = previous;
			//val.debug("val");
			//previous.debug("previous");
			ev[\finish] = {
				Pbind(
					\instrument, \modenv,
					\out, bus,
					\env, [ Env([0,prev,val],[0,time]/TempoClock.default.tempo) ],
					\legato, 1,
					//\bla, Prout({ arg ev; ev[\env][0].asCompileString.debug("kj"); 1.yield }).loop,
					\dur, Pseq([time],1),
				).play;
			};
			previous = val;
			ev = bus.asMap.yield;
		};
		ev;
	}).repeat(repeat)
};

~pmodpat = { arg pat, rate=\control;
	Prout({ arg ev;
		var bus = Bus.alloc(rate, s, 1);
		var timestr;
		var running = true;
		var finfun;

		CmdPeriod.doOnce({ if(bus.index.notNil) {bus.free} });

		finfun = ({
			Pspawner({ arg sp;
				sp.seq(
					Pbind(\out, bus)  <> pat <> Pbind(\superEvent, Plazy({ ev }).loop)
				);
				running = false;
				sp.wait( 2 );
				bus.free;
			}).play;
		});
		if(ev[\finish].isKindOf(Function)) {
			var oldfun = ev[\finish];
			ev[\finish] = { finfun.value; oldfun.value };
		} {
			ev[\finish] = finfun;
		};

		while{ running == true } {
			ev = bus.asMap.yield;
		};
		ev;
	
	})
};


);

// END

// test simple pmodenv
(
	// SUCCESS
Pdef(\testmod, Pbind(
	\instrument, \default,
	\freq, ~pmodenv.(Pseq([1,2,1,4]*400,inf), 1),
	\legato, 0.7,
	\isRest, Pseq([
		1,1,1,1, 1,1,1,0,
	],inf).coin.not,
	\dur, 1/4,
	\amp, 0.1,
)).play;
);

// test pmodpat with pmodenv inside
(
	// SUCCESS
Pdef(\testmod, Pbind(
	\instrument, \simplefm,
	\degree, Pseq([0],inf),
	\dur, 1/8,
	\isRest, Pseq([
		Pseq({[
			1,0,0,0, 0,0,0,0,
			1,0,1,1, 0,1,1,0,
			1,0,1,0, 1,0,1,0, 
			1,1,1,1, 1,1,1,1,
		].clump(8).choose}.dup(4).flat,inf)
	],inf).coin.not,
	\legato, 0.7,
	\fcenter, Pseq([
		700,
	].flat,inf),
	\rq, 0.4,
	\lpfr, 1,
	\freq, ~pmodpat.(
		Pmono( \sinlfo,
			\freq, 3000,
			\freq, ~pmodenv.(Pseq([7,1000,1,1/20,2,4],inf), 1),
			\range, 620,
			//\center, ~pmodenv.(Pseq([70,1000,3000,400],inf), 2),
			\center, Pkey(\superEvent).collect({ arg ev; ev.debug("superev"); ev[\fcenter] }),
			\dur, 1/2,
			\amp, 0.1
		).trace,
		\audio,
	),
	\amp, 0.1
)).play;
)

// test breaks
(
	// FAIL: use sequencing instead, Pmono skip the 0
Pdef(\testmod, Pbind(
	\instrument, \default,
	\freq, ~pmodenv.(Pseq([
		1,4,
	]*500,inf), Pseq([
		1,1,1,0,0,
	],inf)),
	\legato, 1,
	\isRest, Pseq([
		1,1,1,1, 1,1,1,1,
	],inf).coin.not,
	\dur, 1/4,
	\amp, 0.1,
)).play;
);

// test sequencing
(
	// SUCCESS
Pdef(\testmod, Pbind(
	\instrument, \default,
	\freq, Pseq([
		~pmodenv.(Pseq([1,2,4,2]*500,1), 1,1),
		~pmodenv.(Pseq([1,2,4,2]*200,1), 1,1),
	]),
	\legato, 1,
	\isRest, Pseq([
		1,1,1,1, 1,1,1,0,
	],inf).coin.not,
	\dur, 1/4,
	\amp, 0.1,
)).play;
);

// test sequencing for break
(
	// SUCCESS
Pdef(\testmod, Pbind(
	\instrument, \default,
	\freq, Pseq([
		~pmodenv.(Pseq([1,4]*500,1), 1,1),
	],inf),
	\legato, 0.71,
	\isRest, Pseq([
		1,1,1,1, 1,1,1,0,
	],inf).coin.not,
	\dur, 1/4,
	\amp, 0.1,
)).play;
);

// test sequencing with other patterns
(
Pdef(\testmod, Pbind(
	\instrument, \simplefm,
	\degree, Pseq([0],inf),
	\dur, 1/4,
	\legato, 0.7,
	\freq, Pseq([
		1000, 1000, 1000, 1000,
		4000, 1000, Pwhite(100.0,5000,2),
		~pmodenv.(Pseq([400,5000,700,500],1), 1, 1),
	],inf),
	\lpfr, ~pmodenv.(Pseq([1,2,5,1/2,3],inf), 1),
	\fmf, ~pmodenv.(Pseq([1,2,5,1/2,3,10,50,1000],inf), 4),
	\rq, ~pmodenv.(Pseq(1/[1,2,5,2,3],inf), 1/2),
	\amp, 0.1
).trace).play;
)


// test cleanup
(
	// SUCCESS
Pdef(\testmod, Pbind(
	\instrument, \default,
	\freq, ~pmodenv.(Pseq([1,2,4,2]*500,inf), 1),
	\legato, 1,
	\isRest, Pseq([
		1,1,1,1, 1,1,1,0,
	],inf).coin.not,
	\dur, 1/4,
	\amp, 0.1,
)).play;
);
Pdef(\testmod).stop;

// test cleanup when pattern end
(
	// FAIL
Pdef(\testmod, Pbind(
	\instrument, \default,
	\legato, 1,
	\isRest, Pseq([
		1,1,1,1, 1,1,1,0,
	],1).coin.not,
	\freq, ~pmodenv.(Pseq([1,2,4,2]*500,inf), 1),
	\dur, 1/4,
	\amp, 0.1,
)).play;
);

// test cleanup when pattern is ended by parent
(
	// SUCCESS
Pdef(\testmod, Pfindur(1,Pbind(
	\instrument, \default,
	\freq, ~pmodenv.(Pseq([1,2,4,2]*500,inf), 1),
	\legato, 1,
	\isRest, Pseq([
		1,1,1,1, 1,1,1,0,
	],inf).coin.not,
	\dur, 1/4,
	\amp, 0.1,
))).play;
);


//////// test with mono env

(
	Pdef(\testmonox, 
		Ppar([
			Pmono(\modenvmono,
				\out, BusDef(\lfo1, \control),
				\itrig, 1,
				\env,
				Pseq([
					[ Env([1,2]*400,[1]/~t) ],
					[ Env([2,1]*400,[1]/~t) ],
					[ Env([1,4]*400,[1]/~t) ],
					[ Env([4,1]*400,[1]/~t) ],
				],inf),
				\legato, 1,
				//\bla, Prout({ arg ev; ev[\env][0].asCompileString.debug("kj"); 1.yield }).loop,
				\dur, Pseq([1],inf),
			),
			Pbind(
				\instrument, \default,
				\freq, BusDef(\lfo1, \control).asMap,
				\legato, 0.5,
				\latency, 
				\dur, 4,
				\amp, 0.1,
			),

		])
	).play;
);


//////////////////////////


(
~bla = { arg pok;
	Prout({
		pok = pok+1;
		4.do {
			pok.yield;
		}
	})
};
~rr = ~bla.(1);
~rs = ~rr.asStream;
)
~rs.next



