
(
SynthDef(\bla, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
    var sig;
    var tab;
    tab = \tab.kr(1 ! 15);
    sig = LFSaw.ar(freq * tab.abs);
    sig = sig * LFPulse.ar(freq * tab.abs);
    sig = sig.sum;
    sig = RLPF.ar(sig, Rand(10,freq*2) + 100 * SinOsc.ar(tab.abs/10).range(0.01,Rand(2,17)));
    sig = sig.sum;
    sig = sig / 100;
    sig = sig.tanh;
    sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1+ExpRand(0.001,0.2)),gate,doneAction:2);
    sig = Pan2.ar(sig, pan, amp);
    Out.ar(out, sig);
}).add;
)

(
SynthDef(\bla, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, spread=0.8;
    var sig;
    var tab;
    tab = \tab.kr(1 ! 15);
    sig = LFSaw.ar(freq * tab.abs);
    sig = sig * LFPulse.ar(freq * tab.abs);
    sig = sig.sum;
    sig = RLPF.ar(sig, Rand(10,freq*2) + 100 * SinOsc.ar(tab.abs/10).range(0.01,Rand(2,17)));
    //sig = sig.sum;
    sig = sig / 10;
    sig = sig.tanh;
    sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1+ExpRand(0.001,0.2)),gate,doneAction:2);
    //sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, spread, amp, pan);
	sig = sig.clip2(1);
    Out.ar(out, sig);
}).add;
)

(
Pdef(\plop, Pbind(
    \instrument, \bla,
    \degree, Pstep(Pseq([
        Pseq([0,2,4],4),
        Pseq([0,12,6],4),
        Pseq([0,12,6]+7,1),
    ],inf), 1),
    \degree, Pstep(Pseq([
        Pseq([12],4),
    ],inf), 1),
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
	\tab, [ { arg n; n/(n+1) } ! 15 ],
    \dur, PdurStutter( Prand([1,2,4],inf), Pseq([1,2,3]/2,inf)),
	\dur, 1/4,
    \amp, 0.4
)).play;
);

(
Pdef(\plop, Pbind(
    \instrument, \bla,
    \degree, Pstep(Pseq([
        Pseq([0,2,4],4),
        Pseq([0,12,6],4),
        Pseq([0,12,6]+7,1),
    ],inf), 1),
    \degree, Pstep(Pseq([
        Pseq([01],4),
    ],inf), 1),
	\freq, [
		Ndef(\bla, { CuspN.ar(1.18).distort.range(40,100) }).asMap,
		Ndef(\bla2, { CuspN.ar(10.18).distort.range(240,4900) }).asMap,
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
	\dur, 1/8,
    \amp, 0.2
)).play;
);

(
Pdef(\plop, Pbind(
    \instrument, \bla,
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
    \amp, [0.4,0.09,0.08],
)).play;
);

(
Pdef(\plop, Pbind(
    \instrument, \bla,
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
		Ndef(\bla2, { CuspN.ar(0.18).distort.range(1240,1900) }).asMap,
		Ndef(\bla3, { SinOsc.ar(2.18).distort.range(40,1900) }).asMap,
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
	\tab, [ { arg n; (n*n.asFloat.rand*2)/(2*n+1) } ! 15 ],
    \dur, PdurStutter( Prand([1,2,4],inf), Pseq([1,2,3]/2,inf)),
	\dur, Pseq([1/1,1/2,1/4],inf),
	\lag, [0,0.2,0.4],
    \amp, 0.08
)).play;
);
Pdef(\plop).clear
