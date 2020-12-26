
s.reboot;

(


var ampTable, freqTable, b1, b2;

ampTable  = Signal.hanningWindow(1024).squared;
freqTable = Signal.newClear(40096).waveFill({ arg i; 0.5 ** i * 20000 }, 0,10);

b1 = Buffer.loadCollection(s, freqTable);
b2 = Buffer.loadCollection(s, ampTable);


SynthDef(\arcade3, {

	|

shift = 1, noisespd = 1, gate = 0, noisemin = 1.004, noisemax = 10.1, phshiftxxxspeed = 0.001,  phshiftxxxspeedmin = 0.012 , phshiftxxxspeedmax = 0.022,  phshift = 0.0002, phstart =10, phend = 1008, phasesx = 100,  harm = 1, noisemaxxxspeed, noisemaxxxmin, noisemaxxxmax, spectral, vol = 0.4, spitch1 = 1.01, spitch2 = 1.01, sss =1,  filtre = 12000, bas = 30, q = 0.4

	|

	var sigL, sigR,freqs, amps, phasor, ratescale, rate, phases, sig, env, phshiftxxx, noise;

	env=EnvGen.kr(Env([0,1],[0.01],[-2]),gate,doneAction:0);

	phshiftxxx = LFDNoise3.kr(phshiftxxxspeed, 0.1).range(phshiftxxxspeedmin,phshiftxxxspeedmax);

	noisemax = LFDNoise3.kr(noisemaxxxspeed, 0.1).range(noisemaxxxmin, noisemaxxxmax);

	noise = LFDNoise3.kr(noisespd, 0.1);

	rate = LFDNoise3.kr(noisespd, 0.1).range(noisemin,noisemax);

	rate = rate * EnvGen.kr(Env([1, 0.2], [300], [5]));


	phasor = Phasor.ar(0, rate * phshiftxxx, phstart, phend);

	phases = (0..90) * phasesx + phasor;

	freqs = BufRd.ar(1, b1.bufnum, phases);

	amps = BufRd.ar(1, b2.bufnum, phases);

	sigL=Mix.ar(HPF.ar(MoogFF.ar(SinOsc.ar(freqs)* amps, filtre, 0), bas)) * 0.1 * env;

	sigR=Mix.ar(HPF.ar(MoogFF.ar(SinOsc.ar(freqs * shift ) * amps, filtre, 0), bas)) * 0.1 * env;

	//sigL = DelayC.ar(sigL,0.1, mul:0.25) + sigL;
	//sigR = DelayC.ar(sigR,0.1, mul:0.25) + sigR;

	Out.ar(0, sigL * vol);

	Out.ar(1, sigR * vol);

}).add;

)



Server.default.record;
Server.default.stopRecording;




(
~arcade3 =Synth(\arcade3,[\noisespd, 1, \noisemin, 0.7, \noisemaxxxspeed,1, \noisemaxxxmin, 0.61, \noisemaxxxmax, 1.4,\phshiftxxxspeed, 3, \phshiftxxxmin, 0.017, \phshiftxxxmax, 0.022, \phshift, 0.012, \phstart,1, \phend, 400000, \phasesx, 1303, \shift,1.007,\gate,1, \vol, 0.3,\filtre,15000, \q, 00.1,\bas, 70]);
~arcade9.free;
~arcade8.free;
~arcade7.free;
~arcade6.free;
~arcade5.free;
~arcade4.free;
~arcade2.free;
~arcade1.free;
)
~arcade3.set(\noisespd, 0.1, \noisemin, 0.01, \noisemaxxxspeed,1, \noisemaxxxmin, 1, \noisemaxxxmax, 4 ,\phshiftxxxspeed, 0.001, \phshiftxxxmin, 0.022, \phshiftxxxmax, 0.022, \phshift, 0.012, \phstart,1, \phend, 400000, \phasesx, 1303, \shift,1.007,\gate,1, \vol, 0.3,\filtre,15000, \q, 00.1,\bas, 20);



~arcade3.set(\noisespd, 0.1, \noisemin, 0.01, \noisemaxxxspeed,1, \noisemaxxxmin, 0.07, \noisemaxxxmax, 1.4 ,\phshiftxxxspeed, 0.001, \phshiftxxxmin, 0.022, \phshiftxxxmax, 0.022, \phshift, 0.012, \phstart,1, \phend, 400000, \phasesx, 1303, \shift,1.007,\gate,1, \vol, 0.3,\filtre,15000, \q, 00.1,\bas, 20);











