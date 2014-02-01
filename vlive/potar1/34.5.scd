~my_addnotefx_delay = { arg key, delay, fun;
	var pos;
	Ndef(key).add(fun);
	pos = Ndef(key).objects.lastIndex;
	[~name, ~index, ~namex].debug("namemmmmmmmmmmm");
	Veco(~namex).response_off_hook = {
		Ndef(key).set(\wet+++pos, 0);
		
		TempoClock.default.sched(delay, {
			Ndef(key).removeAt(pos);
			Ndef(key).set(\wet+++pos, 1);
		})
	}
};
~my_addnotefx_delay.(~name+++\fx, 4, \filterIn -> { arg in;
	var sigin, sig;
	sigin = FreeVerb.ar(in, 0.5, 2, 0.3);
	sigin;
});

// END
~addnotefx
Ndef(~name+++\fx).quant=0

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
