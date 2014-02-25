(
Ndef(~name+++\env).set(\gatex, 1);
Ndef(~name+++\mixer).map(\amp, Ndef(~name+++\env, { 
	arg gatex = 1;
	EnvGen.kr(Env.adsr(0.1,0.1,1,0.1),gatex,doneAction:0) 
}));
Veco.do { arg name;
	Veco(~namex).response_off_hook = {
		Ndef(name+++\env).set(\gatex, 0)
	}
};
);
// END
~insert_beat.(~name+++\patfx)
Ndef(~name+++\env).clear
Ndef(~name+++\mixer).set(\preamp, 1);
