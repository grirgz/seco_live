
s.reboot;


(


var ampTable, freqTable, b1, b2,ampTable2, freqTable2, b3, b4;

ampTable  = Signal.hanningWindow(1024).squared;
freqTable = Signal.newClear(172345).waveFill({ arg i; 0.5 ** i * 20000 }, 0,10);

b1 = Buffer.loadCollection(s, freqTable);
b2 = Buffer.loadCollection(s, ampTable);


SynthDef(\arcade4b, {


	|

shift = 1, noisespd = 1, gate = 0, noisemin = 1.004, noisemax = 10.1, phshiftxxxspeed = 0.001,  phshiftxxxspeedmin = 0.012 , phshiftxxxspeedmax = 0.022,  phshift = 0.0002, phstart =10, phend = 1008, phasesx = 100,  harm = 1, noisemaxxxspeed, noisemaxxxmin, noisemaxxxmax, spectral, vol2 = 1,  filtre = 12000, bas = 60

	|

	var sigL, sigR,freqs, amps, phasor, ratescale, rate, phases, sig, env, phshiftxxx;

	env=EnvGen.kr(Env([0,1],[10],[-2]),gate,doneAction:0);

	phshiftxxx = LFDNoise3.kr(phshiftxxxspeed).range(phshiftxxxspeedmin,phshiftxxxspeedmax);

	noisemax = LFDNoise3.kr(noisemaxxxspeed).range(noisemaxxxmin, noisemaxxxmax);

	rate = LFDNoise3.kr(noisespd).range(noisemin,noisemax);

	phasor = Phasor.ar(0, rate * phshiftxxx, phstart, phend);

	phases = (0..70) * phasesx + phasor;

	Out.kr(~aaa, rate * phshiftxxx);

	freqs = BufRd.ar(1, b1.bufnum, phases);
	amps = BufRd.ar(1, b2.bufnum, phases);

	sigL=Mix.ar(HPF.ar(LPF.ar(SinOsc.ar(freqs ) * amps, filtre), bas)) * 0.1 * env;
	sigR=Mix.ar(HPF.ar(LPF.ar(SinOsc.ar(freqs * shift ) * amps, filtre), bas)) * 0.1 * env;

	Out.ar(0, sigL * 0.4 * vol2);
	Out.ar(1, sigR * 0.4 * vol2);

}).add;


ampTable2  = Signal.hanningWindow(1024).squared;
freqTable2 = Signal.newClear(40096).waveFill({ arg i; 0.5 ** i * 20000 }, 0, 10);

b3 = Buffer.loadCollection(s, freqTable2);
b4 = Buffer.loadCollection(s, ampTable2);

SynthDef(\arcade4, {

	|

tog = 0, shift = 1, noisespd = 1, gate = 0, noisemin = 1.004, noisemax = 10.1, phshiftxxxspeed = 0.001,  phshiftxxxspeedmin = 0.012 , phshiftxxxspeedmax = 0.022,  phshift = 0.0002, phstart =10, phend = 1008, phasesx = 100,  harm = 1, noisemaxxxspeed, noisemaxxxmin, noisemaxxxmax, spectral, vol = 0.4, spitch1 = 1.01, spitch2 = 1.01,  filtre = 12000, bas = 60

	|

	var sigL, sigR,freqs, amps, phasor, ratescale, rate, phases, sig, env, phshiftxxx, noise, meure;

	env=EnvGen.kr(Env([0,1],[0.01],[-2]),gate,doneAction:0);

	phshiftxxx = LFDNoise1.kr(phshiftxxxspeed).range(phshiftxxxspeedmin,phshiftxxxspeedmax);

	noisemax = LFDNoise1.kr(noisemaxxxspeed).range(noisemaxxxmin, noisemaxxxmax);

	noise = LFDNoise1.kr(noisespd);

	rate = noise.range(noisemin,noisemax);

	phasor = Phasor.ar(0, rate * phshiftxxx , phstart, phend);

	phases = (0..90) * phasesx + phasor;

	freqs = BufRd.ar(1, b3.bufnum, phases);

	amps = BufRd.ar(1, b4.bufnum, phases);

	sigL=Mix.ar(HPF.ar(LPF.ar(SinOsc.ar(freqs) * amps, filtre), bas)) * 0.1 * env;
	sigR=Mix.ar(HPF.ar(LPF.ar(SinOsc.ar(freqs * shift ) * amps, filtre), bas)) * 0.1 * env;

	meure = EnvGen.kr(Env([1, 0], [25], [-3]), gate = tog);

	Out.ar(0, sigL * vol * meure);

	Out.ar(1, sigR * vol * meure);

}).add;

)

~aaa = Bus.control(s,1);

Server.default.record;

Server.default.stopRecording;


/// START

(
~arcade4b = Synth(\arcade4b,[\noisespd, 0.9, \noisemin, 0.9, \noisemaxxxspeed, 1, \noisemaxxxmin, 0.9, \noisemaxxxmax, 1.1,\phshiftxxxspeed, 0.1,  \phshiftxxxspeedmin, 0.024, \phshiftxxxspeedmax, 0.024, \phshift, 0.12, \phstart,1, \phend, 111000000, \phasesx, 133239, \shift,1.01,\gate,1,\vol2, 0.8]);
~arcade4 = Synth(\arcade4, [\noisespd, 0.01, \noisemin, 0.1, \noisemaxxxspeed,0.01, \noisemaxxxmin, 0.03, \noisemaxxxmax, 0.4 ,\phshiftxxxspeed, 0.001, \phshiftxxxspeedmin, 0.012, \phshiftxxxspeedmax, 0.022, \phshift, 0.12, \phstart,1, \phend, 40000000, \phasesx, 12033, \shift,1.007,\gate,1,\vol, 0.26, \filtre, 10000, \bas, 150]);
)









