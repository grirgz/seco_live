~addfx.(~name+++\fx, 4, \filter -> { arg in;
	var sigin, sig;
	sigin = RLPF.ar(in, SinOsc.ar(2).range(100,8000), 0.3);
	sigin;
});

// END

Veco(~namex).response_off_hook = {
	TempoClock.default.play ({
		//~quant.wait;
		Ndef(~wobblefx).set(\choose, 0);
		Ndef(~wobblefx).unset(\choose);
		nil;
	}, [~quant, 1/2]);
};

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
