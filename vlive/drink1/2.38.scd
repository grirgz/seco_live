
(
Ndef(~name+++\mixer).put(~index, Ndef(\mangle)[100].source );

~index.debug("delire!!!");
Veco.do { arg name, namex, index;

	Veco(~namex).response_off_hook = {
		index.debug("remove!!");
		Ndef(name+++\mixer).removeAt(index);
	};
};
Veco(~namex).response_mode = \exec;
)
//Ndef(\mangle) <<> Ndef(~name+++\mixer);
//Ndef(\mangle).play;

// END
Ndef(~name+++\mixer).edit
Ndef(\mangle)[100].source
Ndef(\mangle).play;

(
Ndef(\mangle).put(100, \filter -> { arg in;
	var sig;
	var delaytab;
	//var in = \in.ar([0,0]);
	//in = in * SinOsc.ar( SinOsc.ar(1).range(100,200) );
	////in.postln;
	////in;
	sig = PitchShift.ar(in, 0.01, [1, 1/2, 0.5, 1/2],0,0.0001);
	delaytab = (1..4.0).rand/10;
	sig = DelayC.ar(sig, delaytab,delaytab) + sig;
	4.do { arg time;
		delaytab = (1..4.0).rand/10;
		sig = DelayC.ar(sig, delaytab,delaytab) + sig;
	};
	sig = sig ++ [in];
	sig = sig.sum;

});
);

(
	['3mixer',]
)

Ndef(\mangle) <-- Ndef(~name+++\mixer);
Ndef(\mangle).clear;
Ndef(\mangle).stop
Ndef(\mangle).play;
Ndef(\mangle).put(1, { Ndef(~name+++\mixer).ar })
Ndef(\mangle).put(1, { Ndef(~name+++\mixer).ar + Ndef('3mixer').ar })
(

Ndef(\mangle).put(1, [
	Ndef(~name+++\mixer),
	Ndef('3mixer'),
])
)
Ndef(\mangle).put(1, { SinOsc.ar(100)!2 })
Ndef(\mangle) <<>.in nil;
Ndef(~name+++\mixer).play;
Ndef(~name+++\mixer).put(100, \filter -> { arg in;  })
Ndef(~name+++\mixer).put(100, \filter -> { arg in;  })
Ndef(~name+++\mixer).stop;
