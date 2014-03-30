~make_reverb_trigpad.(3);

// END

	Ndef(~masterfx+++\fx).set(\choose, 2);
	Ndef(~masterfx+++\fx).set(\stutter, 8);
Veco(~namex).response_off_hook = {
		Ndef(~masterfx+++\fx).set(\choose, 0);
};


~make_reverb_trigpad
