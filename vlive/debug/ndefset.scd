
(
Ndef(\plop).put(0, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq);
	sig = Pan2.ar(sig, pan, amp);
}).play;
Ndef(\plop).put(1, \set -> Pbind( 
	\freq, Pseq([100,200,300],inf),
	\dur, 1/4,
	\hey, Pfunc({ "plop".postln; 1 });
));
);



In my workflow, I first define the Ndef, then I launch little patterns
using this Ndef and \set patterns to alter the Ndef. If the Ndef is
not running, it start it.

(
Ndef(\fx, { arg freq=1000;
    SinOsc.ar(freq) * 0.1 ! 2
});
Ndef(\fx).put(1, \pset -> Pbind(\freq, Pseq([100,200,300,400,500],200)));
)

//stop it with cmdPeriod

//then run
Ndef(\fx).quant = nil

(
Ndef(\fx).play;
Ndef(\fx).put(1, \set -> Pbind(\freq, Pseq([100,200,300,400,500],200)));
)

However when running the above code, there is all kind of weird stuff
happening with the \set pattern, like if there is two of them running
or the \set pattern is not synched with the Ndef (the pattern don't
start at \freq == 100)

if I redefine the Ndef each time I run the \set pattern, everything
goes as wanted and sync
(
Ndef(\fx, { arg freq=100;
    SinOsc.ar(freq) * 0.1 ! 2
}).play;
Ndef(\fx).put(1, \set -> Pbind(\freq, Pseq([100,200,300,400,500],200)));
)

But I don't want to redefine the Ndef each time, this cause
duplication of code: if I have multiple \set patterns I want to choose
from, I need to put the Ndef definition in each of theses codes
blocks.

The workaround is to put the function in a variable, like

(
~myfx = { arg freq=100;
    SinOsc.ar(freq) * 0.1 ! 2
}
)

// then

(
Ndef(\fx, ~myfx).play;
Ndef(\fx).put(1, \set -> Pbind(\freq, Pseq([100,200,300,400,500],200)));
)

But what is the point of having an object dedicated to storing things
like Pdef and Ndef and have to also store the thing elsewhere ?

So I ask, is there a way to reset/restart/sync the \set role, or
something like that ?

Thanks




(
Ndef(\rah, \qsetsrc -> Pbind(
	\source, Pseq([
		{ SinOsc.ar(200) ! 2 },
		{ LFSaw.ar(200) ! 2 },
		{ LFTri.ar(200) ! 2 },
		{ LFTri.ar(400) ! 2 },
		
	],inf),
	\dur, 1/4,
)).play
)
Ndef(\rah).quant
Ndef(\rah).clear

1/4


a = NodeProxy(s);
a.play;
(
a[0] = \setsrc -> Pbind(
    \dur, Prand([1, 0.5, 2], inf),
        \source, Prand ([
                { SinOsc.ar(SinOsc.ar({5.rand}.dup + 4) * 50 + 400 + 50.rand) * 0.1 },
                        { SinOsc.ar(LFSaw.ar({5.rand}.dup + 4) * 50 + 400 + 50.rand) * 0.1},
                                { LFSaw.ar(SinOsc.ar({5.rand}.dup + 4) * 50 + 400 + 50.rand) * 0.1 },
                                        { LFSaw.ar(LFSaw.ar({5.rand}.dup + 4) * 50 + 400 + 50.rand) * 0.1 }
                                            ], inf)
                                            )
                                            );

a.clear(3);



a = NodeProxy(s);
a.play;
(
a[0] = \setsrc -> Pbind(
    \dur, Prand([1, 0.5, 2], inf),
    \source, Prand ([
        { SinOsc.ar(SinOsc.ar({5.rand}.dup + 4) * 50 + 400 + 50.rand) * 0.1 },
        { SinOsc.ar(LFSaw.ar({5.rand}.dup + 4) * 50 + 400 + 50.rand) * 0.1},
        { LFSaw.ar(SinOsc.ar({5.rand}.dup + 4) * 50 + 400 + 50.rand) * 0.1 },
        { LFSaw.ar(LFSaw.ar({5.rand}.dup + 4) * 50 + 400 + 50.rand) * 0.1 }
    ], inf)
)
);

a.clear(3);




(
Ndef(\x,
    \setsrc -> Pbind(\source,
        Pseq([
            { LFTri.ar(280 * Line.kr(1.1, 0.4, rrand(2, 3)) + [0,1]) * 0.1 },
            { Pulse.ar(40 + [0,1]) * 0.1 },
            { LFTri.ar(LFTri.kr(1).round(1.0.rand) + 1 * 180 + [0,1], 0.04) * 0.3 },
        ], inf),
        \dur, Prand([3, 2, 4], inf),
		\dur, 1/8,
    )
).play;
)
Ndef(\x).quant = 0
Ndef(\x).fadeTime = 0
