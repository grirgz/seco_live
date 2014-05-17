~addnotefx.(~name+++\fx, \filter -> { arg in;
	var sigin, sig;
	sigin = RLPF.ar(in, SinOsc.ar(2).range(100,8000), 0.3);
	sigin;
});

// END
~addnotefx
Ndef(~name+++\fx).quant=1
Ndef(~name+++\fx).stop

~addfx = { arg key, delta, fun;
	var pos;
	Ndef(key).add(fun);
	pos = Ndef(key).objects.lastIndex;
	TempoClock.default.sched(4, {
		Ndef(key).removeAt(pos);
	})
}

~addnotefx = { arg key, delta, fun;
	var pos;
	Ndef(key).add(fun);
	pos = Ndef(key).objects.lastIndex;
	Veco(~namex).response_off_hook = {
		Ndef(key).removeAt(pos);
	}
}

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
