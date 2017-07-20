(
	r = { arg x = 20;
			x.debug("x");
		if (x > 1)
		{
			x = x - 1;
			x.postln;
			{ SinOsc.ar() * EnvGen.kr(Env.perc(releaseTime:0.2), doneAction:2)}.play;
			0.5.wait;
			//r.value(x);
		};
	};
	r.fork;
)

(
	~rout = {
		var recfun;
		recfun = { arg x = 20;
			if (x > 1)
			{
				x = x - 1;
				x.postln;
				{ SinOsc.ar() * EnvGen.kr(Env.perc(releaseTime:0.2), doneAction:2)}.play;
				0.5.wait;
				recfun.value(x);
			};
		};

		recfun.(25)
	};
	~rout.fork;
)
