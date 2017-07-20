
(
SynthDef(\bell, { arg out=0, amp=0.1, gate=1, pan=0, freq=4200;
	var sig;
	var sig1;
	//sig = SinOsc.ar(freq + {rrand(-100,100)}!20);
	sig = SinOsc.ar(rrand(200!22,18000) * LFNoise1.kr(rrand(1/10,1/100!5),add:1,mul:0.06) *.t rrand(0.01,1!10),0,0.1*[0.25,1,0.8,0.5,0.9,0.4,0.3,0.6,0.1]).flop.sum;
	sig.debug("sig");
	sig = sig.collect({ arg isig, idx;
		isig = isig.fold2(XLine.kr(1,0.01,rrand(1/2,1/6)));
		isig = isig * EnvGen.ar(Env.dadsr(rrand(0.0001,0.1),0.001,0.1,0.8,exprand(0.041,0.7), 1, -4),gate,doneAction:0);
		isig;
	}).sum;
	sig1 = PinkNoise.ar( EnvGen.kr(\env.kr(Env([0,1,0.4,0],[0.001,0.1,0.1])), gate) );
	sig1 = LPF.ar(sig1, EnvGen.kr(Env([3,0.33,2.1],[0.001,0.7]), 1) * 6000);
	sig = sig + sig1;
	sig1 = PinkNoise.ar( EnvGen.kr(\env2.kr(Env([0,1,0.4,0],[0.001,0.03,0.1])), gate) );
	sig = sig + sig1;
	sig = sig + LPF.ar(Trig.ar(1, SampleDur.ir)!2, 400 * 1);
	sig = LPF.ar(sig, EnvGen.kr(Env([3,0.33,2.1],[0.001,0.7]), 1) * 6000);
	sig = sig * 3;
	DetectSilence.ar(sig, time:0.4, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\bell, Pbind(
	\instrument, \bell,
	\degree, Pseq([0],inf),
	\sustain, 0.05,
	\dur, 1,
	\amp, 0.1
)).play;
);


(
{
}.scope
)
SynthDefp


(
SynthDef(\prayer_bell, { |outbus, t_trig = 1, sing_switch = 0, freq = 2434, amp = 0.5, decayscale = 1, lag = 10, i_doneAction = 0|
  var sig, input, first, freqscale, mallet, sing;
  freqscale = freq / 2434;
  freqscale = Lag3.kr(freqscale, lag);
  decayscale = Lag3.kr(decayscale, lag);

  mallet = LPF.ar(Trig.ar(t_trig, SampleDur.ir)!2, 10000 * freqscale);
  sing = LPF.ar(
    LPF.ar(
      {
        PinkNoise.ar * Integrator.kr(sing_switch * 0.001, 0.999).linexp(0, 1, 0.01, 1) * amp
      } ! 2,
      2434 * freqscale
    ) + Dust.ar(0.1), 10000 * freqscale
  ) * LFNoise1.kr(0.5).range(-45, -30).dbamp;
  input = mallet + (sing_switch.clip(0, 1) * sing);


  sig = DynKlank.ar(`[
    [
      (first = LFNoise1.kr(0.5).range(2424, 2444)) + Line.kr(20, 0, 0.5),
      first + LFNoise1.kr(0.5).range(1,3),
      LFNoise1.kr(1.5).range(5435, 5440) - Line.kr(35, 0, 1),
      LFNoise1.kr(1.5).range(5480, 5485) - Line.kr(10, 0, 0.5),
      LFNoise1.kr(2).range(8435, 8445) + Line.kr(15, 0, 0.05),
      LFNoise1.kr(2).range(8665, 8670),
      LFNoise1.kr(2).range(8704, 8709),
      LFNoise1.kr(2).range(8807, 8817),
      LFNoise1.kr(2).range(9570, 9607),
      LFNoise1.kr(2).range(10567, 10572) - Line.kr(20, 0, 0.05),
      LFNoise1.kr(2).range(10627, 10636) + Line.kr(35, 0, 0.05),
      LFNoise1.kr(2).range(14689, 14697) - Line.kr(10, 0, 0.05)
    ],
    [
      LFNoise1.kr(1).range(-10, -5).dbamp,
      LFNoise1.kr(1).range(-20, -10).dbamp,
      LFNoise1.kr(1).range(-12, -6).dbamp,
      LFNoise1.kr(1).range(-12, -6).dbamp,
      -20.dbamp,
      -20.dbamp,
      -20.dbamp,
      -25.dbamp,
      -10.dbamp,
      -20.dbamp,
      -20.dbamp,
      -25.dbamp
    ],
    [
      20 * freqscale.pow(0.2),
      20 * freqscale.pow(0.2),
      5,
      5,
      0.6,
      0.5,
      0.3,
      0.25,
      0.4,
      0.5,
      0.4,
      0.6
    ] * freqscale.reciprocal.pow(0.5)
  ], input, freqscale, 0, decayscale);
  DetectSilence.ar(sig, doneAction: i_doneAction);
  Out.ar(outbus, sig);
}).add;
)


(
Pdef(\bell_1,
  Pmono(\prayer_bell,
    \dur, Pseq([8, 20], inf),
    \freq, Pseq([2500, 500], inf),
    \amp, 0.5,
    \lag, 0,
    \trig, Pseq([0.1], inf) * Pwhite(0.5, 1, inf) * Pwrand([0, 1], [1, 5].normalizeSum, inf),
    \sing_switch, Pseq((0!4) ++ (1!4), inf)
  )
);

Pdef(\bell_2,
  Pmono(\prayer_bell,
    \dur, Pwhite(8, 20, inf),
    \trig, Pwhite(0.05, 0.09),
    \sing_switch, Pwrand([0, 1], [5, 3].normalizeSum, inf),
    \freq, Prand((240, 360 .. 2000), inf),
    \amp, 0.5
  )
);

Pdef(\bell_3,
  Ppar([
    Pmono(\prayer_bell,
      \freq, 100,
      \dur, 1,
      \trig, 0,
      \sing_switch, Pwrand([0, 1], [10, 3].normalizeSum, inf),
      \amp, Pwhite(0.1, 0.5)
    ),
    Pmono(\prayer_bell,
      \freq, 200,
      \dur, 1,
      \trig, 0,
      \sing_switch, Pwrand([0, 1], [10, 3].normalizeSum, inf),
      \amp, Pwhite(0.1, 0.5)
    ),
    Pmono(\prayer_bell,
      \freq, 300,
      \dur, 1,
      \trig, 0,
      \sing_switch, Pwrand([0, 1], [10, 3].normalizeSum, inf),
      \amp, Pwhite(0.1, 0.5)
    )
  ])
);

Pdef(\bell_1).play;
Pdef(\bell_2).play;
Pdef(\bell_3).play;
)
