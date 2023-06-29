
(
SynthDef(\zed, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	//sig = SinOsc.ar(freq);
	//sig = SinOsc.ar(100) + SinOsc.ar(100) + SinOsc.ar(100) + SinOsc.ar(100) ;
	sig = Mix.ar([ SinOsc.ar(100) , SinOsc.ar(100) , SinOsc.ar(100) , SinOsc.ar(100), SinOsc.ar(100), SinOsc.ar(100)   ]);
	Out.ar(out, sig);
}).dumpUGens;
);


{ SinOsc.ar(100) + SinOsc.ar(100) + SinOsc.ar(100)    }.dumpUGens


(
SynthDef(\zed, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	//sig = SinOsc.ar(freq);
	//sig = SinOsc.ar(100) + SinOsc.ar(100) + SinOsc.ar(100) + SinOsc.ar(100) ;
	sig = Mix.ar({SinOsc.ar(100)}!100);
	Out.ar(out, sig);
}).dumpUGens;
);


(
{
    var withUgen = DC.ar(-1);
    var withInteger = -1;
    var resUgen, resInteger;
    var op = {|x|
		//var y = x < 0 * x.sqrt.neg + (x >= 0 * x.sqrt);
		var y = x.sqrt;
        y = -1 * y + 1;
        y = y.max(0);
    };
    
    resUgen = op.value(withUgen);
    resInteger = op.value(withInteger);
    resUgen.poll;
    resInteger.poll;
}.play;
)

Signal.newFrom([-1,1,0]).squared
Signal.newFrom([-1,1,0]) pow: 2
FloatArray.newFrom([-1,1,0]).squared
