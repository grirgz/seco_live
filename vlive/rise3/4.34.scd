
~quant = 1/4;
TempoClock.default.play ({
	Ndef(~masterfx+++\fx).set(\choose, 2);
	//Ndef(~masterfx+++\fx).set(\stutter, 8);
	nil;
}, ~quant);
Veco(~namex).response_off_hook = {
	TempoClock.default.play ({
		//~quant.wait;
		Ndef(~masterfx+++\fx).set(\choose, 0);
		nil;
	}, [~quant, ~quant]);
};

// END

	Ndef(~masterfx+++\fx).set(\choose, 2);
	Ndef(~masterfx+++\fx).set(\stutter, 8);
Veco(~namex).response_off_hook = {
		Ndef(~masterfx+++\fx).set(\choose, 0);
};
