
Ndef(~name+++\fx).set(\xfmamp, 3);

Veco(~namex).response_off_hook = { arg self, name;
	Ndef(name+++\fx).set(\xfmamp, 0);
};

Veco(~namex).response_mode = \exec;
