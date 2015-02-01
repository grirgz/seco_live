Ndef(~name+++\fx).set(\fxtrig, 1);
Veco.do { arg name;
	{
		Ndef(name+++\fx).set(\fxtrig, 0);
	}.defer
};
Veco(~namex).response_mode = \exec;
