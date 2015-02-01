
Ndef(~name+++\fx).set(\xfmfreq, 10);

Veco(~namex).response_off_hook = { arg self, name;
	Ndef(name+++\fx).set(\xfmfreq, 0);
};

Veco(~namex).response_mode = \exec;
