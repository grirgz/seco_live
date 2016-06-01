
~ev = (freq:600, sustain:100).play
~ev.isPlaying
~ev.set(\freq, 710)

// instead of using Synth() you can use events directly in your Tasks
(
	Task({
		var fr = 400;
		10.do { arg i;
			var ev;
			fr = fr + ( i*10 );
			ev = (instrument:\default, freq:fr, sustain:inf).play;
			1.wait;
			ev.set(\freq, 1000);
			0.1.wait;
			ev.release;
		}
	}).play;
)

// use pattern in your task
(
	Task({
		var pat = Pseq([400,500,600],inf).asStream;
		10.do { arg i;
			var ev;
			var fr = pat.next + (i * 10);
			ev = (instrument:\default, freq:fr, sustain:inf).play;
			1.wait;
			ev.set(\freq, 1000);
			0.1.wait;
			ev.release;
		}
	}).play;
)

// use event pattern in your task
(
	Task({
		var pat = Pbind(
			\instrument, \default,
			\freq, Pseq([400,500,700],inf)
		).asStream;

		10.do { arg i;
			var ev;
			ev = pat.next(Event.default).play; // note you need to provide default event
			ev.debug("ev");
			0.9.wait;
			ev.set(\freq, 1000);
			0.1.wait;
			ev.release;
		};

	}).play;
)

(
	// replace pattern by a routine if you want
	Tdef(\yep, { // with Pdef, Ndef, comes Tdef for tasks
		var pat = Routine({ 
			var str; 
			str = Pseq([1,2,3,4],inf).asStream; // use a pattern inside the routine if you want
			10.do {
				(instrument: \default, freq: str.next * 10 + 300).yield;
			};
		});

		10.do { arg i;
			var ev;
			ev = pat.next(Event.default).play;
			ev.debug("ev");
			0.9.wait;
			ev.set(\freq, 1000);
			0.1.wait;
			ev.release;
		};

	}).play;
)

(
// use pattern in routine
)
~rout.next; // execute it 6 times too see the end of stream (nil)

(
// use pattern in routine in pattern

~rout.reset; // you have to reset the routine because it remember its state

Pbind(
	\instrument, \default,
	\freq, 200 + ( 100*~rout ),
	\dur, 1,
	\amp, 0.1
).play;

)

// better with Prout which reset at each execution:


(
Pbind(
	\instrument, \default,
	\freq_index, Prout({
		var str; 
		str = Pseq([1,2,3,4],inf).asStream;
		5.do {
			str.next.yield;
		};
	}),
	\freq, 200 + ( 100*Pkey(\freq_index) ),
	\dur, 1,
	\amp, 0.1
).play;
)

(
// use routine to filter event patterns

Pdef(\rout,  // put in a Pdef for easy tweaking
	Prout({ arg inev;
		10.do { arg i;
			inev.freq = inev.freq + (10*i);
			inev.debug("inev");
			inev = inev.yield;
		};
	})
	<>
	Pbind(
		\instrument, \default,
		\freq, Pseq([200,400],inf),
		\dur, 1,
		\amp, 0.1
	);

).play
)

(
Pdef(\rout, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1,
		\finish, { arg ev;
			currentEnvironment.parent.debug("ev");
		
		},
	)
).play;
);



////////////////////

(
~rout = Routine({
	//Pseq([1,2,3]).embedInStream;
	"bla".debug;
	Pbind(
		\instrument, \default,
		\freq, 200,
		\dur, 1,
		\amp, 0.1
	).embedInStream;

}).play
)

(
~rout = Routine({
	10.do { arg i;
		i.yield;
		"bla".debug;
	};

}).play
)

////////////////////////////////////////////


// embed a pattern in a routine
(
~rout = Routine({
	Pseq([1,2,3,4,5,6,7,8]).trace.embedInStream;
});
)
~rout.next; // test

// embed a routine in a pattern
(
~pat = Pseq([
	100,200,
	Prout({ 
		5.do { arg i; 
			i.yield
		}
	})
]).asStream;
)
~pat.next; // test


(
// if you play a routine, the yielded value is considered as time to wait
~rout = Routine({
	Pseq([1,2,3,4,5,6,7,8]).trace.embedInStream;
}).play;
)

(
// task is an equivalent of routine
~rout = Task({
	Pseq([1,2,3,4,5,6,7,8]).trace.embedInStream;
}).play;
)

///////////////////////////////////

// use pattern in routine/task (independently of this, instead of Synth() you can play an Event directly)
(
	Task({
		var pat = Pseq([400,500,600],inf).asStream;
		10.do { arg i;
			var ev;
			var fr = pat.next + (i * 10);
			//ev = Synth(\default, [\freq, fr]); 
			// note that Event.play have a latency of 0.2 seconds to avoid the timing inaccuracy of Synth()
			ev = (instrument:\default, freq:fr, sustain:inf).play;
			0.5.wait; // wait is in seconds, not in beats
			ev.set(\freq, 1000); // .set have no latency
			0.5.wait;
			ev.release;
		}
	}).play;
)

// use routine in event pattern
(
Pbind(
	\instrument, \default,
	\freq_index, Prout({
		var str; 
		str = Pseq([1,2,3,4],inf).asStream;
		5.do {
			str.next.yield;
		};
	}),
	\freq, 200 + ( 100*Pkey(\freq_index) ),
	\dur, 1,
	\amp, 0.1
).play;
)

///////////////////////////////////

// use routine in event pattern
(
Pdef(\yap, 
	Pseq([
		Prout({ arg in;
			5.do { arg i;
				in = (dur: 0.5, instrument: \default, sustain: 0.1, freq: i*10 + 300).yield;
			};
			in
		}),
		Pbind(
			\instrument, \default,
			\freq, Pseq([200,400]),
			\dur, 1,
			\amp, 0.1
		)
	]).trace
).play
)

// use event pattern in your routine/task
(
	Task({
		var pat = Pbind(
			\instrument, \default,
			\freq, Pseq([400,500,700],inf)
		).asStream;

		10.do { arg i;
			var ev;
			ev = pat.next(Event.default).play; // note you need to provide default event
			ev.debug("ev");
			0.9.wait;
			ev.set(\freq, 1000);
			0.1.wait;
			ev.release;
		};

	}).play;
)


//////////////////////////////////

the key mecanism used when i say "put Ndef in a Pdef" is in fact providing a mapped bus instead of value to the pattern

~bus = Bus.control(s,1);
~bus.set(300);
(
Pdef(\yap, Pbind(
	\instrument, \default,
	\freq, ~bus.asMap,
	\dur, 1,
	\amp, 0.1
)).play;
)
~bus.set(700); // change it

// same with Ndef

(
Pdef(\yap, Pbind(
	\instrument, \default,
	\freq, Ndef(\lfo1, { SinOsc.kr(1).range(300,2301) }),
	\dur, 1,
	\amp, 0.1
)).play;
)
Ndef(\lfo1, { freq = 3; SinOsc.kr(freq).range(330,1331) }); // replace on the fly

Ndef(\lfo1).set(\freq, 5); // change argument

(
// control argument with pattern/pdef
Ndef(\lfo1)[0] = { arg freq = 3; SinOsc.kr(freq).range(330,1331) });
Ndef(\lfo1)[1] = \pset -> Pbind(
	\freq, Pseq([3,5,10],inf)
)
)

see also http://sccode.org/1-509


/////////////////////////////////////////////////////////////////////:
/////////////////////////////////////////////////////////////////////:
/////////////////////////////////////////////////////////////////////:
/////////////////////////////////////////////////////////////////////:

soundcloud message

Your feeling is not so wrong, Routine has his benefits too, the key is to realize that routines and patterns are the same, they are both a stream of values calculated on demand, in the inside, pattern are written using Routines and the pattern player (created when you call .play) just ask for the next value and play it on time. 

With this in mind, you can mix patterns and routines as you want :


// embed a pattern in a routine
(
~rout = Routine({
	Pseq([1,2,3,4,5,6,7,8]).trace.embedInStream;
});
)
~rout.next; // test

// embed a routine in a pattern
(
~pat = Pseq([
	100,200,
	Prout({ 
		5.do { arg i; 
			i.yield
		}
	})
]).asStream;
)
~pat.next; // test


(
// if you play a routine, the yielded value is considered as time to wait
~rout = Routine({
	Pseq([1,2,3,4,5,6,7,8]).trace.embedInStream;
}).play;
)

(
// task is an equivalent of routine
~rout = Task({
	Pseq([1,2,3,4,5,6,7,8]).trace.embedInStream;
}).play;
)

///////////////////////////////////

// use pattern in routine/task
(
	Task({
		var pat = Pseq([400,500,600],inf).asStream;
		10.do { arg i;
			var ev;
			var fr = pat.next + (i * 10);
			//ev = Synth(\default, [\freq, fr]);  //  instead of Synth() you can play an Event directly
			// note that Event.play have a latency of 0.2 seconds to avoid the timing inaccuracy of Synth()
			ev = (instrument:\default, freq:fr, sustain:inf).play;
			0.5.wait; // wait is in seconds, not in beats
			ev.set(\freq, 1000); // .set have no latency
			0.5.wait;
			ev.release;
		}
	}).play;
)

// use routine in event pattern
(
Pbind(
	\instrument, \default,
	\freq_index, Prout({
		var str; 
		str = Pseq([1,2,3,4],inf).asStream;
		5.do {
			str.next.yield;
		};
	}),
	\freq, 200 + ( 100*Pkey(\freq_index) ),
	\dur, 1,
	\amp, 0.1
).play;
)

///////////////////////////////////

// use event routine in event pattern
(
Pdef(\yap, 
	Pseq([
		Prout({ arg in;
			5.do { arg i;
				in = (dur: 0.5, instrument: \default, sustain: 0.1, freq: i*10 + 300).yield;
			};
			in
		}),
		Pbind(
			\instrument, \default,
			\freq, Pseq([200,400]),
			\dur, 1,
			\amp, 0.1
		)
	]).trace
).play
)

// use event pattern in your routine/task
(
	Task({
		var pat = Pbind(
			\instrument, \default,
			\freq, Pseq([400,500,700],inf)
		).asStream;

		10.do { arg i;
			var ev;
			ev = pat.next(Event.default).play; // note you need to provide default event
			ev.debug("ev");
			0.9.wait;
			ev.set(\freq, 1000);
			0.1.wait;
			ev.release;
		};

	}).play;
)


-In my above example of a Pfunc in a Pdef, would a Ndef work in stead?
yes

-Ndefs essentially allow me to use Non pattern UGens inside of a pattern? Like a LFSinOsc? If so THAT'S INCREDIBLE
not exactly, the pattern never see the value of the UGen, the UGen write in a bus and the pattern give the bus to the synth

the key mecanism used when i say "put Ndef in a Pdef" is in fact providing a mapped bus instead of value to the pattern

~bus = Bus.control(s,1);
~bus.set(300);
(
Pdef(\yap, Pbind(
	\instrument, \default,
	\freq, ~bus.asMap,
	\dur, 1,
	\amp, 0.1
)).play;
)
~bus.set(700); // change it

// same with Ndef

(
Pdef(\yap, Pbind(
	\instrument, \default,
	\freq, Ndef(\lfo1, { SinOsc.kr(1).range(300,2301) }),
	\dur, 1,
	\amp, 0.1
)).play;
)
Ndef(\lfo1, { freq = 3; SinOsc.kr(freq).range(330,1331) }); // replace on the fly

Ndef(\lfo1).set(\freq, 5); // change argument

(
// control argument with pattern/pdef
Ndef(\lfo1)[0] = { arg freq = 3; SinOsc.kr(freq).range(330,1331) });
Ndef(\lfo1)[1] = \pset -> Pbind(
	\freq, Pseq([3,5,10],inf)
)
)

you can also put busses/Ndef in patterns : 

\freq, Pseq([ Ndef(\lfo1), Ndef(\lfo2) ],inf),

see also http://sccode.org/1-509


