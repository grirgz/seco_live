~make_fx_gate1.();

// END
	Ndef(~name+++\mixer).put(~index, \filter -> { arg in; Out.ar(BusDef(\mangle), in); in; });
	Ndef(~name+++\mixer).put(~index, nil);
	Ndef(~name+++\mixer).put(~index+100, \filter -> { arg in; Out.ar(BusDef(\mangle), in); in; });
	Ndef(~name+++\mixer).set(\xfade, 0);
(
~make_fx_gate1 = {

	var index = ~index;
	index = index + 100;
	Ndef(~name+++\mixer).put(index, \filter -> { arg in; Out.ar(BusDef(\mangle), in); in; });
	Ndef(~name+++\mixer).set(\xfade, 0);

	~index.debug("delire!!!");
	Veco.do { arg name, namex;
		Veco(~namex).response_off_hook = {
			//var index = Veco.main.uname_to_index(name);
			Ndef(name+++\mixer).set(\xfade, 0.5);
			index.debug("remove!!");
			//Ndef(\mangle).removeAt(index)
			Ndef(name+++\mixer).removeAt(index);
		};
	};
	Veco(~namex).response_mode = \exec;
}
);

(
~make_fx_gate1 = {

	Ndef(\mangle).put(Veco.main.uname_to_index(~name), { Ndef(~name+++\mixer).ar });

	~index.debug("delire!!!");
	Veco.do { arg name;
		Veco(~namex).response_off_hook = {
			var index = Veco.main.uname_to_index(name);
			index.debug("remove!!");
			Ndef(\mangle).removeAt(index)
		};
	};
	Veco(~namex).response_mode = \exec;
}
);
//Ndef(\mangle) <<> Ndef(~name+++\mixer);
//Ndef(\mangle).play;

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
