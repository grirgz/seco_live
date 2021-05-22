(
// Set things up, and start the Synth
s.waitForBoot {
f = SoundFile.openRead("/home/ggz/Musique/sc/wavetable/archwavetable/Architecture Waveforms 2010 Wav24/Classic - Sine/Sine.wav");
a = FloatArray.newClear(f.numFrames.clip(0,2.pow(13)));
f.readData(a);
f.close; // close the file
a = a.as(Signal);

    a = a ! 2;
    // a[0] is the start waveform, a[1] is the target to morph to...
    a.plot;

    c = a[0].asWavetable;
    b.free; b = Buffer.alloc(s, c.size);  // 1024: twice the size of the 512-element signal!
    s.sync;
    b.setn(0, c);
s.sync;
//Ndef(\a)[0]={|bufnum, freq=200|Osc.ar(b.bufnum, freq)}.play;
    //Ndef(\a,{|bufnum, freq=200|Osc.ar(b.bufnum, freq)!2}).mold(2,'audio').play;
};
)

    Ndef(\a,{|bufnum, freq=200|Osc.ar(b.bufnum, freq)!2}).mold(2,'audio').play;

Ndef(\lfo,{LFNoise1.kr(10).range(10, 300)});
Ndef(\a).map(\freq, Ndef(\lfo));
