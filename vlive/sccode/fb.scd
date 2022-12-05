(
{
    var fb = InFeedback.ar(0,2);
    var del = MouseX.kr(0.3,0.07,0,1.2);
    var ffreq = 1/del;
    var freq = LFNoise0.kr(ffreq/16).exp.range(55,110) + LFNoise2.kr(4,0.1);
    var chirp, signal;
    freq = [freq,freq*1.5];
    fb = DelayC.ar(fb,0.3,del,[1.05,0.9]);
    chirp = SinOsc.ar(1100,0,LFClipNoise.kr(ffreq*2).range(0,0.05));
    chirp = Pan2.ar(chirp,LFNoise2.kr(ffreq/2));
    signal = SinOsc.ar(freq,fb.reverse*MouseY.kr(0,5),0.3) - chirp + (fb*0.2);
	signal = signal * 0.5;
}.play
);

(
Ndef(\bla, {
    var fb = InFeedback.ar(0,2);
    var del = MouseX.kr(0.3,0.07,0,1.2);
    var ffreq = 1/del;
    var freq = LFNoise0.kr(ffreq/16).exp.range(55,110) + LFNoise2.kr(4,0.1);
    var chirp, signal;
    freq = [freq,freq*1.5];
    fb = DelayC.ar(fb,0.3,del,[1.05,0.9]);
    chirp = LFCub.ar(1100 * LFNoise0.kr(ffreq/8).range(1,0.05),0,LFClipNoise.kr(ffreq*2).range(0,0.05));
    chirp = Pan2.ar(chirp,LFNoise2.kr(ffreq/2));
	signal = SinOsc.ar(freq,fb.reverse*MouseY.kr(0,5),0.3) + chirp + (fb*0.5);
	//signal = signal.softclip(-0.3,0.3);
	signal = signal.clip(-0.3,0.3);
	//signal * 0.5;
}).play
);
