


(
SynthDef(\plop, { arg out=0, freq=200, amp=0.01, range=0.5, pan=0, doneAction=2, gate=1, ffreq=200, freqmul=1;

	var sig;
	freq = freq.lag(1);
	freq = LFSaw.ar([0.1434,0.2434,0.354,0.155]*freqmul)*range*freq + freq;
	
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, ffreq * ([0.1434,0.2434,0.354,0.155]+1));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:doneAction);
	//sig = sig.sum;
	sig = Splay.ar(sig, 0.8, amp, pan);
	Out.ar(out, sig);

}).store
)

Ndef(\plop).fadeTime = 4;
Ndef(\plop).xfade(\freq, 100)
Ndef(\plop).xset(\freq, 100)
Ndef(\plop).xset(\freq, 50)

p = ProxySpace.push
p.pop

(
~bla = { arg freq=200, amp=0.01, range=0.5, pan=0;

	var sig;
	freq = SinOsc.ar([0.1434,0.2434,0.354,0.155])*range*freq + freq;
	
	sig = SinOsc.ar(freq);
	sig = Pan2.ar(sig, pan, amp);

}
)
~bla.play
~bla <>> ~rah
(

~rah = { arg in;

	//CombL.ar(in, 0.2,0.2,0.2);
	in.tanh;
	in * SinOsc.ar(1)
}
)

~out = Bus.audio(s, 2)

(
SynthDef(\mycomb, { arg in, out=0, mix=1, amp=1, gate=1;
	var sigin, sig;
	sigin = In.ar(in, 2);
	sig = sigin;
	sig = sig * SinOsc.ar(2).range(0,1);
	sig = CombL.ar(sig, 0.7,0.7,2);
	sig = PitchShift.ar(sig, 0.1, SinOsc.ar(1).range(0.1,2.1), 1);
	sig = SelectX.ar(mix, [sigin, sig]);
	sig = sig * EnvGen.ar(Env.asr(0.0001,1,0.0001),gate,doneAction:2);
	ReplaceOut.ar(out, sig);
}).add;
)

~comb.free; ~comb = Synth(\mycomb, [\in, 0], addAction:\addAfter)
~comb.free;


(
Ndef(\rah, { arg in, freq=200, pan=0, amp=0.1, mix=1, delay=0.7, shiftratio=0.1, maxdelay=0.1;
	var sig;
	var sigin;
	sigin = InFeedback.ar(~out,2);
	sig = sigin;
	//sig = sig * SinOsc.ar(freq).range(0,1);
	//sig = SinOsc.ar(freq) *5.4;
	//sig = sig * SinOsc.ar(2).range(0,1);
	sig = CombL.ar(sig, maxdelay,delay,2);
	sig = PitchShift.ar(sig, 0.1, shiftratio, 0.01);
	sig = SelectX.ar(mix, [sigin, sig]);
	sig = sig.tanh;
	sig = sig * 0.1;
	Out.ar(0,sig)
}).play;
);
Ndef(\bla, { Line.ar(0.2,5,10) });
Ndef(\rah).map(\delay, Ndef(\bla))
Ndef(\rah).set(\mix, 0.1);
Ndef(\rah).set(\shiftratio, 4.5);

(
Pdef(\plop, PmonoArtic( \plop,
	\freq, Pseq([Pwhite(20,50,5), Pwhite(200,2000,1)],inf),
	\freq, 100,
	\freqmul, 1,
	\freqmul, Pseq([0.1,1,10,455,5000],inf),
	\ffreq, Pwhite(20,3500),
	\ffreq, 500,
	\legato, Pseq([0.3,1,1,1],inf),
	\dur, 1,
	\out, ~out,
	\amp, 0.035
)).play;
);

p = ProxySpace.puso
NodeProxy

(
Ndef(\niark, { arg freq=200, pan=0, amp=0.05, ffreq=200,
		oscmin=0.9, oscmax=1.1, filmin=0.9, filmax=1.1, klankmin=0.9, klankmax=1.1;
	var sig;
	var tab;
	tab = 16.collect { arg i; i = i + 1; LFNoise1.ar(i*5).range(oscmin,oscmax) };
	sig = LFPulse.ar(freq*[1.1,1.0154,1.24,1.524,1.4154]);
	sig = LFPulse.ar(freq*tab);
	tab = 26.collect { arg i; i = i + 1; LFNoise1.ar(i*0.5).range(filmin,filmax) };
	sig = RLPF.ar(sig, ffreq*tab);
	tab = 6.collect { arg i; i = i + 1; LFNoise1.ar(i*5).range(klankmin,klankmax) };
	sig = DynKlank.ar(Ref([tab * 50]), sig);
	sig = sig.tanh;
	0.do { arg x;
		sig = sig * 10;
		sig = sig.tanh;
		sig = sig / 1;
	};
	sig = Splay.ar(sig, 0.8, amp, pan);
}).play;
);

Ndef(\niark)[1] = {SinOsc.ar(500)*0.01}

Ndef(\bla, { Line.ar(0.2,500,10) });
Ndef(\bla2, { LFNoise1.ar(7.2).range(20,50) });
Ndef(\bla, { LFNoise1.ar(7.2).range(50,150) });
Ndef(\bla, { EnvGen.kr(Env([0.1,1,0.2,1],[0.1,0.2,1])) * ExpRand(10,9500) });
Ndef(\niark).map(\freq, Ndef(\bla))
Ndef(\niark).map(\ffreq, Ndef(\bla))
Ndef(\niark).set(\freq, 500)
Ndef(\niark).set(\freq, 100)
Ndef(\niark).set(\amp, 0.15)
Ndef(\niark).set(\amp, 0.02)
Ndef(\niark).edit
Ndef(\niark)[1] =
	\set -> Pmono(
		\freq, Pseq([100,1000],inf),
		\dur, 1,
	)

{ SinOsc.ar(100) }.plot(0.01)
{ LFTri.ar(100) }.play
{ (SinOsc.ar(100)*50).tanh }.play
Ndef(\bla, { Line.ar(100,1000,1) })
a = NodeProxy.new
a.source = { Line.ar(100,1000,1) }
a.play
(
Pdef(\chui,
	Pbind(
		\instrument, \osc1,
		\degree, Pseq([0,1,2,3],inf),
		\ffreq, a
	)
).play
)

GenericGlobalControl



~lfo = GenericGlobalControl(\lfo, nil, 1, #[0.1, 10, \exp]);
~lfo.gui;
~lfo.watch.automate {
    var width = LFNoise1.kr(0.5).exprange(1.1, 3.0);
    SinOsc.kr(LFDNoise1.kr(0.3).range(1.0,
5.0)).exprange(width.reciprocal, width);
};

// by default, gui updates are twice per second
// faster:
KrBusWatcher.newFrom(s).updateFreq = 8;

// crib default synthdef, add lfo parameter
SynthDef(\default2, { arg out=0, freq=440, amp=0.1, pan=0, gate=1, lfo = 1;
    var z;
    z = LPF.ar(
        Mix.new(VarSaw.ar((freq * lfo) + [0, Rand(-0.4,0.0),
Rand(0.0,0.4)], 0, 0.3, 0.3)),
        XLine.kr(Rand(4000,5000), Rand(2500,3200), 1)
    ) * Linen.kr(gate, 0.01, 0.7, 0.3, 2);
    OffsetOut.ar(out, Pan2.ar(z, pan, amp));
}, [\ir]).add;

p = Pbind(
    \instrument, \default2,
    \freq, Pexprand(200, 800, inf),
    \lfo, ~lfo,
    \dur, Pwhite(0.5, 2.0, inf),
    \legato, Pwhite(1.5, 3.0, inf)
).play;

// all synths follow the same lfo curve

~lfo.value = 1;  // explicitly setting the global control stops automation

~lfo.value = 1.5;  // all synths change

// grab the slider and move it -- all synths respond -- nothing hard about that

p.stop;

~lfo.free;  // this will automatically do g.stopWatching and
g.stopAuto as well, if still active
