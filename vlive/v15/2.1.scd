
{ var m = Line.kr(0.01, 0.8, Rand(0.01, 0.04)); SinOsc.ar(LFDNoise3.ar(m.range(18000, 2) ! 2) * (Rand(1, 2) * 600)) * m.exprange(1, 8) * XLine.kr(0.3, 0.0001, 5, doneAction:2)  }.play;
