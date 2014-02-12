
Ndef(~name+++\mixer).set(\wet100, 1);
(
Ndef(~name+++\mixer).put(100, \filterIn -> { arg in;
	//in * SinOsc.ar( SinOsc.ar(1).range(100,1000) );
	var sig;
	var delaytab;
	sig = PitchShift.ar(in, 0.01, [1, 1/2, 0.5, 1/2],0,0.0001);
	delaytab = (1..4.0).rand/10;
	sig = DelayC.ar(sig, delaytab,delaytab) + sig;
	4.do { arg time;
		delaytab = (1..4.0).rand/10;
		sig = DelayC.ar(sig, delaytab,delaytab) + sig;
	};
	sig = sig ++ [in];
	sig = sig.sum;
	sig = sig / 1;

});
);
Veco.do { arg name;
	Veco(~namex).response_off_hook = {
		//Ndef(~name+++\mixer).put(100, nil)
		//Ndef(name+++\mixer).removeAt(100)
		Ndef(name+++\mixer).set(\wet100, 0)
	};
};
Veco(~namex).response_mode = \exec;
