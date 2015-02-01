
Ndef(~name+++\fx).set(\xfreq, 4);

Veco(~namex).response_off_hook = { arg self, name;
	Ndef(name+++\fx).set(\xfreq, 1);
};

Veco(~namex).response_mode = \exec;
