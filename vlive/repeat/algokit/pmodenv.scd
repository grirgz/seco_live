
(
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
~pmodseg = { arg valpat, repeat=inf;
	Prout({ arg ev;
		var bus = Bus.control(s,1);
		var valstr = valpat.asStream;
		var timestr;
		var previous = valstr.next;

		CmdPeriod.doOnce({ bus.free });

		timestr = Plazy({ ev[\dur] }).loop.asStream;

		valstr.do { arg val;
			var time = timestr.next.debug("time");
			var prev = previous;
			val.debug("val");
			previous.debug("previous");
			ev[\finish] = {
				Pbind(
					\instrument, \modenv,
					\out, bus,
					\env, [ Env([0,prev,val],[0,time]/TempoClock.default.tempo) ],
					\bla, Prout({ arg ev; ev[\env][0].asCompileString.debug("kj"); 1.yield }).loop,
					\dur, Pseq([time],1),
				).trace.play;
			};
			previous = val;
			ev = bus.asMap.yield;
		};
	}).repeat(repeat)
};

~pmodenv = { arg valpat, timepat=1, repeat=1;
	Prout({ arg ev;
		var bus = Bus.control(s, 1);
		var timestr;
		var running = true;
		var finfun;

		CmdPeriod.doOnce({ bus.free });

		finfun = ({
			Pspawner({ arg sp;
				var valstr = valpat.asStream;
				var previous = valstr.next;
				var time;
				timestr = if(timepat.isNil) {
					Plazy({ ev[\dur] }).loop.asStream;
				} {
					timepat.asStream;
				};
				valstr.do { arg val;
					var prev = previous;
					time = timestr.next.debug("time");
					val.debug("val");
					previous.debug("previous");
					sp.seq(Pbind(
						\instrument, \modenv,
						\out, bus,
						\env, [ Env([0,prev,val],[0,time]/thisThread.clock.tempo) ],
						//\bla, Prout({ arg ev; ev[\env][0].asCompileString.debug("kj"); 1.yield }).loop,
						\dur, Pseq([time],1),
					).trace);
					previous = val;
					//"kj==========aaa".debug;
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
	}).repeat(repeat)
};

~pmodpat = { arg pat, rate=\control;
	Prout({ arg ev;
		var bus = Bus.alloc(rate, s, 1);
		var timestr;
		var running = true;
		var finfun;

		CmdPeriod.doOnce({ bus.free });

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
	
	})
};


);

// END

Pdef(\bla2, Pbind(
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

// test pmodenv
Pdef(\plop6, Pbind(
	\instrument, \simplefm,
	\degree, Pseq([0],inf),
	\dur, 1/4,
	\legato, 0.7,
	\freq, Pseq([
		1000, 1000, 1000, 1000,
		~pmodenv.(Pseq([400,5000,700,500],1), 1, 1),
	],inf),
	\lpfr, ~pmodenv.(Pseq([1,2,5,1/2,3],inf), 1),
	\fmf, ~pmodenv.(Pseq([1,2,5,1/2,3,10,50,1000],inf), 4),
	\rq, ~pmodenv.(Pseq(1/[1,2,5,2,3],inf), 1/2),
	\amp, 0.1
).trace).play;
