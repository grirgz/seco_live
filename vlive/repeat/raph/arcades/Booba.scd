
s.reboot;


(


var ampTable, freqTable, b1, b2;

ampTable  = Signal.hanningWindow(1024).squared;
freqTable = Signal.newClear(172345).waveFill({ arg i; 0.5 ** i * 15000 }, 0,10);

b1 = Buffer.loadCollection(s, freqTable);
b2 = Buffer.loadCollection(s, ampTable);


SynthDef(\arcade5, {


	|

shift = 1, noisespd = 1, gate = 0, noisemin = 1.004, noisemax = 10.1, phshiftxxxspeed = 0.001,  phshiftxxxspeedmin = 0.012 , phshiftxxxspeedmax = 0.022,  phshift = 0.0002, phstart =10, phend = 1008, phasesx = 100,  harm = 1, noisemaxxxspeed, noisemaxxxmin, noisemaxxxmax, spectral, vol2 = 1,  filtre = 12000, bas = 60

	|

	var sigL, sigR,freqs, amps, phasor, ratescale, rate, phases, sig, env, phshiftxxx;

	env=EnvGen.kr(Env([0,1],[0.01],[-2]),gate,doneAction:0);

	phshiftxxx = LFDNoise3.kr(phshiftxxxspeed).range(phshiftxxxspeedmin,phshiftxxxspeedmax);

	noisemax = LFDNoise3.kr(noisemaxxxspeed).range(noisemaxxxmin, noisemaxxxmax);

	rate = LFDNoise3.kr(noisespd).range(noisemin,noisemax);

	phasor = Phasor.ar(0, rate * phshiftxxx, phstart, phend);

	phases = (0..90) * phasesx + phasor;

	freqs = BufRd.ar(1, b1.bufnum, phases);
	amps = BufRd.ar(1, b2.bufnum, phases);

	sigL=Mix.ar(HPF.ar(LPF.ar(SinOsc.ar(freqs ) * amps, filtre), bas)) * 0.1 * env;
	sigR=Mix.ar(HPF.ar(LPF.ar(SinOsc.ar(freqs * shift ) * amps, filtre), bas)) * 0.1 * env;

	Out.ar(0, sigL * 0.4 * vol2);
	Out.ar(1, sigR * 0.4 * vol2);

}).add;

)


Server.default.record;

Server.default.stopRecording;


/// START

(
~arcade5 = Synth(\arcade5,[\noisespd, 1, \noisemin, 1.3, \noisemaxxxspeed, 1.6, \noisemaxxxmin, 1.7, \noisemaxxxmax, 1.4,\phshiftxxxspeed, 0.1,  \phshiftxxxspeedmin, 0.004, \phshiftxxxspeedmax, 0.004, \phshift, 0.12, \phstart,1, \phend, 111000000, \phasesx, 161992, \shift,1.008,\gate,1,\vol2, 0.9]);
//~arcade9b = Synth(\arcade9b,[\noisespd, 0.1, \noisemin, 0.31, \noisemaxxxspeed,0.071, \noisemaxxxmin, 0.31, \noisemaxxxmax, 0.8 ,\phshiftxxxspeed, 0.001, \phshiftxxxmin, 0.012, \phshiftxxxmax, 0.022, \phshift, 0.022, \phstart,1, \phend, 4011000,\endspeed, 1 ,\endmin, 1, \endmax, 100000000, \phasesx, 77171, \shift,1.004,\gate,1, \vol2,0.7,  \filtre, 10000, \bas, 100]);
~arcaderave.free;
~arcaderave2.free;
~arcade9.free;
~arcade8.free;
~arcade7.free;
~arcade6.free;
~arcade4b.free;
~arcade4.free;
~arcade3.free;
~arcade2.free;
~arcade1.free;
)



~arcade5.set(\noisespd, 1, \noisemin, 1.1, \noisemaxxxspeed, 1.6, \noisemaxxxmin, 1.3, \noisemaxxxmax, 1.3,\phshiftxxxspeed, 0.4,  \phshiftxxxspeedmin, 0.004, \phshiftxxxspeedmax, 0.007, \phshift, 0.12, \phstart,1, \phend, 111000000, \phasesx, 161992, \shift,1.007,\gate,1,\vol2, 1.2);






