(
BusDef(\mangle, \audio);
Ndef(\mangle).put(0, { InFeedback.ar(BusDef(\mangle), 2) });
Ndef(\mangle).put(100, \filter -> { arg in, delayrat=1, pitchshift=1;
	var sig;
	var delaytab;
	//var in = \in.ar([0,0]);
	//in = in * SinOsc.ar( SinOsc.ar(1).range(100,200) );
	////in.postln;
	////in;
	sig = PitchShift.ar(in, 0.01, [1, 1/2, 0.5, 1/2]*pitchshift,0,0.0001);
	delaytab = (1..4.0).rand/10 * delayrat;
	sig = DelayC.ar(sig, delaytab,delaytab) + sig;
	4.do { arg time;
		delaytab = (1..4.0).rand/10;
		sig = DelayC.ar(sig, delaytab,delaytab) + sig;
	};
	sig = sig ++ [in];
	sig = sig.sum;
	sig = sig / 6;

});
);

(
	// map the default (play button) macro for knobs
	//ProxyChain(~name).gui(22);
	Veco.do { arg name;
	
		Veco(name).lib.map_it = {
			~midi_macro_manager.map_list(
				[
					[Ndef(\mangle), \delayrat, ControlSpec(0.1,2,\exp,0,1) ],
					[Ndef(\mangle), \pitchshift, ControlSpec(0.1,2,\exp,0,1) ],
				]
			)

		};
		MIDIBoard.map(\play, { Veco(name).lib.map_it.value });
		Veco(name).lib.map_it.value;
	};

);
//Ndef(\mangle) <<> Ndef(~name+++\mixer);
//Ndef(\mangle).play;
Ndef(\mangle).play;
Veco(~namex).response_mode = \exec;

// END

(
	['3mixer',]
)

Ndef(\mangle) <-- Ndef(~name+++\mixer);
Ndef(\mangle).clear;
Ndef(\mangle).stop
Ndef(\mangle).play;
Ndef(\mangle).put(1, { Ndef(~name+++\mixer).ar })
Ndef(\mangle).removeAt(1);
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


(
Ndef(~name+++\mixer).put(100, \filter -> { arg in;
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

});
);
Veco(~namex).response_off_hook = {
	//Ndef(~name+++\mixer).put(100, nil)
	Ndef(~name+++\mixer).removeAt(100)
};
Veco(~namex).response_mode = \exec;


(
Ndef(\sound, {
    RHPF.ar(
        \in1.ar([0, 0]) * \in2.ar([0, 0]),
        \freq.ar(6000, 2),
        \rq.kr(0.2)
    ) * 7
}).play;
Ndef(\sound).fadeTime = 0.2;    // avoid harsh clicks
)

Ndef(\a, { SinOsc.ar(MouseX.kr(300, 1000, 1) * [1, 1.2], \phase.ar([0, 0]) * 0.2) });
Ndef(\b, { LFDNoise3.ar(MouseY.kr(3, 1000, 1) * [1, 1.2]) });
Ndef(\c, { LFTri.ar(MouseY.kr(3, 10, 1) * [1, 1.2]).max(0) });
Ndef(\a).fadeTime = 0.2;    // avoid harsh clicks again

Ndef(\sound) <<>.in1 Ndef(\a);
Ndef(\sound) <<>.in2 Ndef(\b);
Ndef(\sound) <<>.in2 Ndef(\c);
Ndef(\a) <<>.phase Ndef(\a);
Ndef(\a) <<>.phase nil;    // unmap
Ndef(\sound) <<>.freq Ndef(\sound);    // unmap
Ndef(\sound) <<>.freq nil;    // unmap
Ndef.clear(3);        // fade out and clear all Ndefs
