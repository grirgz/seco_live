
 Ndef(\masterlfo1, {SinOsc.kr(2).range(10,500)});
 //Ndef(\masterlfo1).clear
~quant = 1/4;
TempoClock.default.play ({
	Ndef(~masterfx+++\fx).set(\choose, 2);
	Ndef(~masterfx+++\fx).map(\stutter, Ndef(\masterlfo1).asMap);
	nil;
}, ~quant);
Veco(~namex).response_off_hook = {
	TempoClock.default.play ({
		//~quant.wait;
	//Ndef(~masterfx+++\fx).unmap(\stutter);
		Ndef(~masterfx+++\fx).set(\choose, 0);
		nil;
	}, [~quant, 1/4]);
};

// END

	Ndef(~masterfx+++\fx).set(\choose, 2);
	Ndef(~masterfx+++\fx).set(\stutter, 8);
Veco(~namex).response_off_hook = {
		Ndef(~masterfx+++\fx).set(\choose, 0);
};
