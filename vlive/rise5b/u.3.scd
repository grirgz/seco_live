
(
Pdef(~name+++\pre, Pbind(
    \degree, Pstep(Pseq([
        Pseq([0,2,4],4),
        Pseq([0,12,6],4),
        Pseq([0,12,6]+7,1),
    ],inf), 1),
    \degree, Pstep(Pseq([
        Pseq([01],4),
    ],inf), 1),
	\freq, [
		Ndef(\bla, { CuspN.ar(0.18).distort.range(40,100) }).asMap,
		Ndef(\bla2, { CuspN.ar(0.18).distort.range(1240,4900) }).asMap,
		Ndef(\bla3, { SinOsc.ar(2.18).distort.range(240,1900) }).asMap,
	],
    \octave, 3,
    \tab, Pfunc {
        var tab;
        [
            //tab = { arg n; (n + 1.asFloat.rand + 1).tanh / (n.rand+1) } ! 15;
            //tab = { arg n; (n + 2.asFloat.rand + 1) / (n+1) } ! 15;
            tab = { arg n; (n + 70.asFloat.rand + 1) / (n+1*3) } ! 15;
            tab.postln;
        ]
    },
	\tab, [ { arg n; (n*2)/(2*n+1) } ! 15 ],
    \dur, PdurStutter( Prand([1,2,4],inf), Pseq([1,2,3]/2,inf)),
	\dur, 1/1,
    \amp, [0.4,0.09,0.08] * Pkey(\amp) * 8,
));
);
