// the goal is to force the task to be replaced only when synth is freed a new synth not yet started

// condition must be set before playing

// this works, because two 0.wait;
~cond = Condition.new;
(
x.source = {
	var s, bpm, beat, tatum;
	bpm = 190;
	beat = 60 / bpm;
	tatum = beat / 4;

	~cond.test.debug("start");
	loop {
		"0123450123450123".do { |i|
			var synth;
			~cond.test.debug("cond0");
			~cond.test = false;
			~cond.test.debug("cond1");
			synth = Synth(\saw, [\freq, rrand(100,200.0), \lpfr, 1]);
			~cond.test.debug("cond2");
			2.wait;
			~cond.test.debug("cond3");
			synth.debug("synth");
			synth.set(\gate, 0);
			~cond.test.debug("cond4");
			~cond.test = true;
			~cond.test.debug("cond5");
			0.wait;
			0.wait;
			~cond.test.debug("cond6");

		};
	}
};
)
x.condition = { arg ...args; args.debug("args");~cond.test.debug("cond test") };
x.play



/////////////////// tidy

~cond = Condition.new;
(
x.source = {

	loop {
		"0123450123450123".do { |i|
			var synth;
			~cond.test = false;
			synth = Synth(\saw, [\freq, rrand(100,200.0), \lpfr, 1]);
			2.wait;
			synth.set(\gate, 0);
			~cond.test = true;
			0.wait;
			0.wait;

		};
	}
};
)
x.condition = { ~cond.test.debug("cond test") };
x.play

/////////////////// use argument

~cond = Condition.new;
(
x.source = {

	loop {
		"0123450123450123".do { |i|
			var synth;
			synth = Synth(\saw, [\freq, rrand(100,200.0), \lpfr, 1.2]);
			2.wait;
			synth.set(\gate, 0);
			0.wait;
			0.wait;

		};
	}
};
)
x.condition = { arg time; ( time == 0 ).debug("test") };
x.play
x.stop

/////////////// solution

x = TaskProxy.new;
x.condition = {|a,b| [a,b].postln; b % 8 == 0};
(
x.source = {
	s = Server.default;
	loop {
		"0123450123450124".do { |i|
			var synth;
			s.makeBundle(s.latency, {
				synth = Synth(\slice, [buf: ~buffer, slice: "0123456789abcdf".indexOf(i), rate: 1.1]);
			});
			1.wait;
			s.makeBundle(s.latency, {
				synth.set(\gate, 0);

			});
		};
	};
	x.play;		
}
)
