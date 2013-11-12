~quant = 1/2;
TempoClock.default.play ({
	Ndef('afx').set(\choose, 2);
	Ndef('afx').set(\stutter, 8);
	nil;
}, ~quant);
Veco(~namex).response_off_hook = {
	TempoClock.default.play ({
		//~quant.wait;
		Ndef('afx').set(\choose, 0);
		nil;
	}, [~quant, 1/2]);
};
