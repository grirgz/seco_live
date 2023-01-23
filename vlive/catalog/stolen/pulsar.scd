// I demonstrated how to do pulsar synthesis in SC in this blog post https://nathan.ho.name/posts/pulsar-synthesis/. This might be a good starting point:

(
{
    var snd, freq, formantCount, formantFreq, sineCycles, pulsaretPhase, window, randomLFO, randomLFOs;
    formantCount = 3;
    randomLFO = { LFNoise2.kr(5) };
    randomLFOs = { { randomLFO.() } ! formantCount };
    freq = randomLFO.().linexp(-1, 1, 1, 1000);
    formantFreq = randomLFOs.().linexp(-1, 1, 2, 8000);
    sineCycles = randomLFOs.().linlin(-1, 1, 1, 4);
    pulsaretPhase = LFSaw.ar(freq, iphase: 1).linlin(-1, 1, 0, 1) * formantFreq / freq;
    window = pulsaretPhase.lincurve(0, 1, 1, 0, -2);
    snd = sin(pulsaretPhase * 2pi * sineCycles.floor) * window * (pulsaretPhase < 1);
    snd = snd * randomLFOs.().linlin(-1, 1, 0, 1);
    snd = Pan2.ar(snd, randomLFOs.() * 0.4);
    snd = snd.flop.sum;
    snd = snd * -2.dbamp;
    snd;
}.play(fadeTime: 0);
)
