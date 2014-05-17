~quant = 1;
TempoClock.default.play ({
	Ndef('39fx').set(\sinfreq, 1);
	nil;
}, ~quant);
// END

Veco.force_init
~quant = 1/2;
~wobblefx = '38fx';
TempoClock.default.play ({
	Ndef(~wobblefx).set(\choose, 2);
	Ndef(~wobblefx).set(\stutter, 8);
	nil;
}, ~quant);
Veco(~namex).response_off_hook = {
	TempoClock.default.play ({
		//~quant.wait;
		Ndef(~wobblefx).set(\choose, 0);
		Ndef(~wobblefx).unset(\choose);
		nil;
	}, [~quant, 1/2]);
};

