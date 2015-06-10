
(
SynthDef(\xbass, { |outbus, midinote = 42|
  var freq = midinote.midicps;
  var subfreq = freq / 2;
  var lpfenv1, lpfenv2, moogenv1, moogenv2;
  
  // Envelopes
  var subenv = EnvGen.kr(\subenv.kr(Env.perc(0, 0.7)), doneAction:2);
  var env = EnvGen.kr(\env.kr(Env.perc(0, 0.2)));
  
  // Component synthesis
  var pluck = Pluck.ar(PinkNoise.ar, 1, 0.2, subfreq.reciprocal) * subenv * 2;
  var tri = VarSaw.ar(freq) * env;
  var sin = SinOsc.ar(freq) * env;
  var sub = (SinOsc.ar([subfreq, subfreq - 2, subfreq + 2]).sum * subenv).tanh;
  var click = RLPF.ar(Impulse.ar(0), [2000, 8000], 1).sum * 10;
  
  // Initial signal
  var sig = pluck + tri + sub + click;
  
  // Resonant LPFs
  lpfenv1 = EnvGen.kr(\lpfenv1.kr(Env([1,2,1],[0.1,0.8])), 1);
  sig = RLPF.ar(sig, freq * lpfenv1, \rq1.kr(0.51));
  moogenv1 = EnvGen.kr(\moogenv1.kr(Env([1,2,1],[0.1,0.8])), 1);
  sig = sig + (MoogFF.ar(sig, freq * moogenv1, 2.5) * 0.1);
  
  // EQ resulting signal
  sig = BPeakEQ.ar(sig, 400, 0.5, -9);
  sig = BPeakEQ.ar(sig, 2000, 0.5, 6);
  sig = BHiShelf.ar(sig, 8000, 1, 3);
  sig = BPeakEQ.ar(sig, 200, 1, 3);
  
  // Apply another envelope to dampen a bit more
  sig = sig * XLine.kr(1, 0.6, 0.1);
  
  // Tanh distortion / limiting
  sig = (sig * \distamp1.kr(1)).tanh;
  
  // Another round of signal coloring, using another RLPF
  // and sine components
  lpfenv2 = EnvGen.kr(\lpfenv2.kr(Env([1,2,1],[0.1,0.8])), 1);
  sig = sig + RLPF.ar(sig, lpfenv2, \rq2.kr(0.5)) + sin + sub;
  
  // Another round of tanh distortion / limiting
  sig = (sig * \distamp2.kr(1)).tanh;

  sig = sig * \amp.kr(1);
  
  // Another resonant LPF
  moogenv2 = EnvGen.kr(\moogenv2.kr(Env([1,2,1],[0.1,0.8])), 1);
  sig = MoogFF.ar(sig, freq * moogenv2, 0.1);
  
  Out.ar(outbus, sig!2);
}).add;
)

(
Pdef(\xbass, 
	Pbind(
		\instrument, \xbass,
	) <>
	~bass.pat <>
	
	Pbind(
	\instrument, \xbass,
	\degree, Pseq([0],inf),
	\dur, 1,
	\amp, 0.1
)).play;
);

Spec.add(\freqenv, XEnvSpec(ControlSpec(0,20,\lin)!3));

Pdef(\xbass).addHalo(\instrument, \xbass);
Pdef(\xbass).addSpec(\subenv, XEnvSpec( ControlSpec(0,4,\lin)!3 ));
Pdef(\xbass).addSpec(\env, XEnvSpec( ControlSpec(0,4,\lin)!3 ));
Pdef(\xbass).addSpec(\lpfenv1, \freqenv );
Pdef(\xbass).addSpec(\lpfenv2, \freqenv );
Pdef(\xbass).addSpec(\moogenv1, \freqenv );
Pdef(\xbass).addSpec(\moogenv2, \freqenv);
Pdef(\xbass).addSpec(\rq1, \rq);
Pdef(\xbass).addSpec(\rq2, \rq);
Pdef(\xbass).asParamGroup.edit

Env.perc(0,4).asArray
Param(Env.perc(0,4), 
~bass.make_gui

~sequencer.(\seq1,
	\midinote,
	\rq1,
)

Pdef(\seq1,
	\midinote, Pseq(~model[\midinote],inf)
	\rq1, Pseq(~model[\rq1],inf)
)

~sequencer.([
	Param(~model[\midinote], \list),
	Param(~model[\rq1], \list),
])

(
ParamGroup([
	Param(~model[\midinote], \list),
	Param(~model[\rq1], \list),
]).edit
)

Pdef(\seq).set(\degree, [[]])

(
	Pdef(\test, Prout({
		arg ev;
		ev.debug("ev");
		ev.yield;
	})).play;
);
(
	Pdef(\test, Prout({
		arg ev;
		var ret;
		var bind = List.new;
		var str;
		ev.keysValuesDo { arg key, val;
			bind.add(key);
			if(val.isSequenceableCollection) {
				bind.add(Pseq(val));
			} {
				bind.add(val);
			}
		};
		ev.debug("ev");
		bind.debug("bind");
		str = Pbind(*bind);
		str = Pbind(\freq, 250);
		str.embedInStream;
		
	})).trace.play;
);

~a = Prout({ arg ev; var str = Pbind(\freq, 250).asStream; ev = str.next(ev)  })
~s = ~a.asStream;
~s.next(Event.default)

Pdef(\ttt, Pbind(\freq, 250)).play
Pdef(\test).set(\freq, [411,411,744,200])

(
Pdef(\plop, Pbind(
	\instrument, \default,
	\degree, Pseq([0],inf),
	\dur, 1,
	\amp, 0.1
)).play;
);
