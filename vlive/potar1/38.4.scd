~wobblefx = ~name+++\fx;
~quant = Veco(~name).lib.fxquant;
TempoClock.default.play ({
	Ndef(~wobblefx).set(\choose, 1);
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
