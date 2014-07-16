
~quant = 1/2;
TempoClock.default.play ({
	Ndef(~tfx4).set(\delay, 1/2);
	Ndef(~name+++\mixer).set(\send4, 1);
	nil;
}, ~quant);
Veco(~namex).response_off_hook = {
	TempoClock.default.play ({
		//~quant.wait;
		Ndef(~name+++\mixer).set(\send4, 0);
		nil;
	}, [~quant, 1/2]);
};
