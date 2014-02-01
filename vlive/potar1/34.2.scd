~addfx.(~name+++\fx, 4, \filter -> { arg in;
	var sigin, sig;
	sigin = in * SinOsc.ar(100);
	sigin;
});

// END

~addfx = { arg key, delta, fun;
	var pos;
	Ndef(key).add(fun);
	pos = Ndef(key).objects.lastIndex;
	TempoClock.default.sched(4, {
		Ndef(key).removeAt(pos);
	})
}

(
Ndef(~name+++\fx).add(\filter -> { arg in;
	var sigin, sig;
	sigin = in * SinOsc.ar(100);
	sigin;
});
~pos = Ndef(~name+++\fx).objects.lastIndex;
Veco(~name).do { arg name;
	var pos = ~pos;

	TempoClock.default.sched(4, {
		Ndef(name+++\fx).removeAt(pos);

	})
}
)
