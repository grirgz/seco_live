
Ndef(~stutterfx).set(\stutter, 4);
Ndef(~stutterfx).set(\bufgate, 1);

Veco(~namex).response_off_hook = {
	Ndef(~stutterfx).set(\bufgate, 0);
};

