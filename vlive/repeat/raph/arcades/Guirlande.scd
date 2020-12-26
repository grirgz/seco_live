
s.reboot;

(


var ampTable, freqTable, b1, b2;

ampTable  = Signal.hanningWindow(128).squared;
freqTable = Signal.newClear(43776).waveFill({ arg i; 0.5 ** i * 15000 }, 10,0);

b1 = Buffer.loadCollection(s, freqTable);
b2 = Buffer.loadCollection(s, ampTable);


SynthDef(\arcade7, {

	|

shift = 1, noisespd = 1, gate = 0, noisemin = 1.004, noisemax = 10.1, phshiftxxxspeed = 0.001,  phshiftxxxspeedmin = 0.012 , phshiftxxxspeedmax = 0.022,  phshift = 0.0002, phstart =10, phend = 1008, phasesx = 100,  harm = 1, noisemaxxxspeed, noisemaxxxmin, noisemaxxxmax, spectral, vol = 0.4, spitch1 = 1.01, spitch2 = 1.01, sss =1,  filtre = 12000, bas = 30, q = 0.4,m1 = 0.1, m2 = 0.4, m3 = 1, m4 = 0.7, mt1 = 1, mt2 =0.4, mt3 = 3, curve = 4

	|

	var sigL, sigR,freqs, amps, phasor, ratescale, rate, phases, sig, env, phshiftxxx, noise, aaa;

	env=EnvGen.kr(Env([0,1],[0.01],[-2]),gate,doneAction:0);

	phshiftxxx = LFDNoise3.kr(phshiftxxxspeed, 0.1).range(phshiftxxxspeedmin,phshiftxxxspeedmax);

	noisemax = LFDNoise3.kr(noisemaxxxspeed, 0.1).range(noisemaxxxmin, noisemaxxxmax);

	noise = LFDNoise3.kr(noisespd, 0.1);

	rate = LFDNoise3.kr(noisespd, 0.1).range(noisemin,noisemax);

    aaa = DemandEnvGen.kr(Drand([m1, m2, m3 , m4 ],inf), Drand([mt1, mt2 , mt3],inf), curve: curve );

	rate = rate * aaa;

	phasor = Phasor.ar(0, rate * phshiftxxx, phstart, phend);

	phases = (0..90) * phasesx + phasor;

	freqs = BufRd.ar(1, b1.bufnum, phases);

	amps = BufRd.ar(1, b2.bufnum, phases);

	sigL=Mix.ar(HPF.ar(LPF.ar(SinOsc.ar(freqs)* amps, filtre), bas)) * 0.1 * env;

	sigR=Mix.ar(HPF.ar(LPF.ar(SinOsc.ar(freqs * shift ) * amps, filtre), bas)) * 0.1 * env;

	Out.ar(0, sigL * vol);

	Out.ar(1, sigR * vol);

}).add;

)


Server.default.record;
Server.default.stopRecording;


/// START

(
~arcade7 =Synth(\arcade7,[\noisespd, 0.1, \noisemin, 0.37, \noisemaxxxspeed, 0.4, \noisemaxxxmin, 0.45, \noisemaxxxmax, 0.45, \phshiftxxxspeed, 0.6,  \phshiftxxxspeedmin, 0.019, \phshiftxxxspeedmax, 0.019, \phshift, 0.12, \phstart,1, \phend, 111000000, \phasesx, 16110, \shift,1.01,\gate,1,\vol, 0.3, \sss, 0.2, \filtre, 11000, \q, 0.08, \bas, 30,\m1,0.92, \m2,0.89, \m3,0.9, \m4,0.9, \mt1,1.051, \mt2, 3, \mt3, 2,\curve, 4]);
~arcaderave2.free;
~arcaderave.free;
~arcade9.free;
~arcade8.free;
~arcade6.free;
~arcade5.free;
~arcade4b.free;
~arcade4.free;
~arcade3.free;
~arcade2.free;
~arcade1.free;
)



~arcade7.set(\noisespd, 0.1, \noisemin, 0.37, \noisemaxxxspeed, 0.4, \noisemaxxxmin, 0.4, \noisemaxxxmax, 0.4, \phshiftxxxspeed, 0.6,  \phshiftxxxspeedmin, 0.019, \phshiftxxxspeedmax, 0.019, \phshift, 0.12, \phstart,1, \phend, 111000000, \phasesx, 16110, \shift,1.01,\gate,1,\vol, 0.6, \sss, 0.2, \filtre, 11000, \q, 0.08, \bas, 30,\m1,0.92, \m2,0.89, \m3,0.9, \m4,0.9, \mt1,1.051, \mt2, 3, \mt3, 2,\curve, 4);








