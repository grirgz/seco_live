
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



// stopped by Pfindur : no pile up
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


// put in Pbindef : pile up each time we run it, cleaned when pbindef stop
Pbindef(\bla, \freq, 100).play
Pbindef(\bla, \dur, 1/2).play
Pbindef(\bla, \freq, ~pmodenv.(Pseq([100,200,1000,400],inf), 2)).play
Pbindef(\bla).stop



//////////////////////////////////////////////////////////////////////////////
//////// class PmodEnv
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\freq, PmodEnv(Pseq([100,200,1000,400],inf), 2),
			\dur, 1,
			\amp, 0.1,
		),

	])
)).play;
);


/////////////////////// test dur argument



(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\freq, ~pmodenv.(Pseq([100,1000],inf), nil),
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
