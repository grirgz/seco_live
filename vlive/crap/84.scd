
(
SynthDef(\bass, { |outbus, midinote = 42|
  var freq = midinote.midicps;
  var subfreq = freq / 2;
  
  // Envelopes
  var subenv = EnvGen.kr(Env.perc(0, 0.7), doneAction:2);
  var env = EnvGen.kr(Env.perc(0, 0.2), 1);
  
  // Component synthesis
  var pluck = Pluck.ar(PinkNoise.ar, 1, 0.2, subfreq.reciprocal) * subenv * 2;
  var tri = VarSaw.ar(freq) * env;
  var sin = SinOsc.ar(freq) * env;
  var sub = (SinOsc.ar([subfreq, subfreq - 2, subfreq + 2]).sum * subenv).tanh;
  var click = RLPF.ar(Impulse.ar(0), [2000, 8000], 1).sum * 10;
  
  // Initial signal
  var sig = pluck + tri + sub + click;
  
  // Resonant LPFs
  sig = RLPF.ar(sig, XLine.ar(freq * 10, freq * 21, 0.15));
  sig = sig + (MoogFF.ar(sig, freq * 20, 2.5) * 0.1);
  
  // EQ resulting signal
  sig = BPeakEQ.ar(sig, 400, 0.5, -9);
  sig = BPeakEQ.ar(sig, 2000, 0.5, 6);
  sig = BHiShelf.ar(sig, 8000, 1, 3);
  sig = BPeakEQ.ar(sig, 200, 1, 3);
  
  // Apply another envelope to dampen a bit more
  sig = sig * XLine.kr(1, 0.6, 0.1);
  
  // Tanh distortion / limiting
  sig = (sig * 1).tanh;
  
  // Another round of signal coloring, using another RLPF
  // and sine components
  sig = sig + RLPF.ar(sig, XLine.ar(freq * 100, freq * 10, 0.15)) + sin + sub;
  
  // Another round of tanh distortion / limiting
  sig = (sig / 0.3).tanh;

  sig = sig * \amp.kr(1);
  
  // Another resonant LPF
  sig = MoogFF.ar(sig, XLine.ar(freq*15, freq*30, 0.1), 0.1);
  
  Out.ar(outbus, sig!2);
}).add;
)

(
TempoClock.default.tempo = 2.8;

Pbind(
  \instrument, \bass,
  \midinote, Pseq([
    Pseq([Rest, 42, 42], 3),
    Pseq([Rest, 42, 42, 42]),
    Pseq([Rest, 42, 42], 3),
    Pseq([Rest, 45, 45, 42])
  ], inf),
  \dur, Pseq([
    Pseq([0.75, 0.75, 0.5], 3),
    Pseq([0.5, 0.25, 0.75, 0.5])
  ], inf),
  \dur, 1/1,
  \amp, 1/4,
).play
)

(
	Task{
		4.do {
			Environment.make {
				~task = Task{
					~codes = List.new;
					~loop = 10;
					~loop.do { arg x;
						var code;
						~dur = 4 + 2.0.rand;
						~SILENCE = 1/5 + 1.0.RAnd;
						~file = "/tmp/test.scd";
						code = MCElectronique.newDef;
						~codes.add(code);
						( "----------------- " ++ x ).postln;
						code.postln;
						"".postln;
						( "~sound = " ++ MCElectronique.newDef ).interpret;
						~dur.wait;
						~sound.free;
						~silence.wait;
					};
					nil
				}.play;
			};
			7.rand.wait;
		};
		nil;
	}.play

)


{
        var v0=Pulse.ar(234,0.33061950206757);
        var v1=Fold.ar(v0,v0.clip(0,0.5),0.85790377855301);
        var v2=Saw.ar(955);
        var v3=Gendy3.ar(1,1,0,0,381,28103,1,0,12,6);
        var v4=LFPar.ar(v1.clip(1,44100));
        var v5=BrownNoise.ar();
        var v6=RunningMax.ar(v3,v4);
        var v7=Peak.ar(v3,v1);
        var v8=Lag3.ar(v0,0.34678506851196);
        var v9=ToggleFF.ar(v5);

        Out.ar(0,LeakDC.ar(Pan2.ar(Mix.ar(Limiter.ar([ v6, v7, v8, v9 ])))));
}.play


(
{
		var v0=Vibrato.ar(569,5.6833888530731,0.10730350017548,0.2537602186203,0.41209483146667,0,0);
		var v1=LinCongL.ar(42173,v0.clip(0.8,1.2),v0.clip(-0.2,0.2),0.79986882209778);
		var v2=DelayN.ar(v0,1,v0.clip(0,1));
		var v3=Dust.ar(8);
		var v4=Formant.ar(550,1506,1106);
		var v5=Logistic.ar(v0.clip(0,4),v2.clip(1,44100),0);
		var v6=Gendy1.ar(1,1,v0.clip(0,1),0,v0.clip(1,44100),34974,v0.clip(0,1),0,12,v4.clip(1,12));
		var v7=DelayN.ar(v3,1,v0.clip(0,1));
		var v8=StandardN.ar(v0.clip(1,44100),0.0043079853057861);
		var v9=CoinGate.ar(v8.clip(0,1),v3);

		Out.ar(0,LeakDC.ar(Pan2.ar(Mix.ar(Limiter.ar([ v6, v7, v8, v9 ])))));
}.play
)


(
{
		var v0=Gendy3.ar(1,1,0,0,401,39904,1,1,12,9);
		var v1=LFNoise0.ar(v0.clip(1,44100));
		var v2=InRange.ar(v0,0.21162188053131,0.82094061374664);
		var v3=OnePole.ar(v0,v0.clip(0,1))*v0;
		var v4=Fold.ar(v2,0.36478453874588,v3.clip(0.5,1));
		var v5=RHPF.ar(v4,229,0.55506031513214);
		var v6=Delay1.ar(v3);
		var v7=MoogFF.ar(v1,785,0);
		var v8=DelayN.ar(v5,1,v4.clip(0,1));
		var v9=Gendy1.ar(1,1,0,v3.clip(0,1),1304,33783,v5.clip(0,1),v1.clip(0,1),12,8);

		Out.ar(0,LeakDC.ar(Pan2.ar(Mix.ar(Limiter.ar([ v6, v7, v8, v9 ])))));
}.play
)



