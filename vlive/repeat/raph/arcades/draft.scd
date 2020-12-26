(

	// original

var ampTable, freqTable, b1, b2;

ampTable  = Signal.hanningWindow(1024).squared;

freqTable = Signal.newClear(1024).waveFill({ arg i; 0.5 ** i * 20000 }, 0, 10);
//freqTable.plot;

b1 = Buffer.loadCollection(s, freqTable);

b2 = Buffer.loadCollection(s, ampTable);

Ndef(\arcade2, {

	|
amp=0.1

	|

	var sigL, sigR,freqs, amps, phasor, ratescale, rate, phases, sig, env, phshiftxxx,phend;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;

	var num = 9;

	ratescale = 1024 / 44100 / 10;
	rate = 0.4;	// once per 10 sec


	phasor = Phasor.ar(0, rate * ratescale, 0, 1024);

	phases = (0..num) * 0.1 * 1024 + phasor;
	freqs = BufRd.ar(1, b1.bufnum, phases);
	amps = BufRd.ar(1, b2.bufnum, phases);
	sig = SinOsc.ar(freqs ) * amps;
	sig = sig.sum;
	//sig = HPF.ar(sig, 10);
	//sig = LPF.ar(sig, 19010);
	sig = sig * 0.5 * amp;
	sig.debug("sig");


}).play;
)

(


var ampTable, freqTable, b1, b2;

ampTable  = Signal.hanningWindow(1024).squared;

freqTable = Signal.newClear(1024).waveFill({ arg i; 0.5 ** i * 20000 }, 0, 10);
//freqTable.plot;

b1 = Buffer.loadCollection(s, freqTable);

b2 = Buffer.loadCollection(s, ampTable);

Ndef(\arcade2, {

	|
amp=0.1

	|

	var sigL, sigR,freqs, amps, phasor, ratescale, rate, phases, sig, env, phshiftxxx,phend;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;


	ratescale = 1024 / 44100 / 10;
	rate = 0.4;	// once per 10 sec


	phasor = Phasor.ar(0, rate * ratescale, 0, 1024);

	lfo1 = EnvGen.kr(Env([1,1.004,1],[1.4,0.8]), Impulse.kr(1/8));
	//phases = (0..19) * phasesx + phasor;
	phases = (0..14)/lfo1 * 0.1 * 1024 + phasor;
	//phases = ( (0..9) * [[0,4,7].midiratio] ).flat * 0.1 * 1024 + phasor;
	freqs = BufRd.ar(1, b1.bufnum, phases);
	amps = BufRd.ar(1, b2.bufnum, phases);
	sig = SinOsc.ar(freqs ) * amps;
	sig = sig.sum;
	//sig = HPF.ar(sig, 10);
	//sig = LPF.ar(sig, 19010);
	sig = sig * 0.5 * amp;
	sig.debug("sig");


}).play;
)


(


var ampTable, freqTable, b1, b2;

ampTable  = Signal.hanningWindow(1024).squared;

freqTable = Signal.newClear(1024).waveFill({ arg i; 0.5 ** i * 20000 }, 0, 10);
//freqTable.plot;

b1 = Buffer.loadCollection(s, freqTable);

b2 = Buffer.loadCollection(s, ampTable);

Ndef(\arcade2, {

	|
amp=0.1

	|

	var sigL, sigR,freqs, amps, phasor, ratescale, rate, phases, sig, env, phshiftxxx,phend;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;


	ratescale = 1024 / 44100 / 10;
	rate = 0.4;	// once per 10 sec


	phasor = Phasor.ar(0, rate * ratescale, 0, 1024);

	lfo1 = EnvGen.kr(Env([1,1.04,1],[1.4,0.8]), Impulse.kr(1/4));
	//phases = (0..19) * phasesx + phasor;
	phases = ( (0..9) * [[0,3,7,11].midiratio] ).flat + [ [LFNoise1.kr(1/2).range(0.0,17).round.midiratio, LFNoise1.kr(1/2.1).range(0.0,7).round.midiratio] ] * lfo1 * 0.1  * 1024 + phasor;
	freqs = BufRd.ar(1, b1.bufnum, phases);
	amps = BufRd.ar(1, b2.bufnum, phases);
	sig = SinOsc.ar(freqs ) * amps;
	sig = sig.sum;
	//sig = HPF.ar(sig, 10);
	//sig = LPF.ar(sig, 19010);
	sig = sig * 0.5 * amp;
	sig.debug("sig");


}).play;
)
Ndef(\arcade2).clear



(


var ampTable, freqTable, b1, b2;

ampTable  = Signal.hanningWindow(1024).squared;

freqTable = Signal.newClear(1024).waveFill({ arg i; 0.5 ** i * 20000 }, 0, 10);
//freqTable.plot;

b1 = Buffer.loadCollection(s, freqTable);

b2 = Buffer.loadCollection(s, ampTable);

Ndef(\arcade2, {

	|
amp=0.1

	|

	var sigL, sigR,freqs, amps, phasor, ratescale, rate, phases, sig, env, phshiftxxx,phend;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;


	ratescale = 1024 / 44100 / 10;
	rate = 0.4;	// once per 10 sec


	phasor = Phasor.ar(0, rate * ratescale, 0, 1024);

	lfo1 = EnvGen.kr(Env([1,1.04,1],[1.4,0.8]), Impulse.kr([1,1/4]));
	//phases = (0..19) * phasesx + phasor;
	phases = ( (0..9) * [[0,3,7,11].midiratio] ).flat + [ [LFNoise1.kr(1/2).range(0.0,17).round.midiratio, LFNoise1.kr(1/2.1).range(0.0,7).round.midiratio] ] * lfo1 * 0.1  * 1024 + phasor;
	freqs = BufRd.ar(1, b1.bufnum, phases);
	amps = BufRd.ar(1, b2.bufnum, phases);
	sig = SinOsc.ar(freqs ) * amps;
	sig = sig.sum;
	//sig = HPF.ar(sig, 10);
	//sig = LPF.ar(sig, 19010);
	sig = sig * 0.5 * amp;
	sig.debug("sig");


}).play;
)

(
	// modulate amp with sin


var ampTable, freqTable, b1, b2;

ampTable  = Signal.hanningWindow(1024).squared;

freqTable = Signal.newClear(1024).waveFill({ arg i; 0.5 ** i * 20000 }, 0, 10);
//freqTable.plot;

b1 = Buffer.loadCollection(s, freqTable);

b2 = Buffer.loadCollection(s, ampTable);

Ndef(\arcade2, {

	|
amp=0.1

	|

	var sigL, sigR,freqs, amps, phasor, ratescale, rate, phases, sig, env, phshiftxxx,phend;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;


	ratescale = 1024 / 44100 / 10;
	rate = 0.4;	// once per 10 sec


	phasor = Phasor.ar(0, rate * ratescale, 0, 1024);

	lfo1 = EnvGen.kr(Env([1,1.004,1],[1.4,0.8]), Impulse.kr(1/8));
	//phases = (0..19) * phasesx + phasor;
	phases = (0..90) * 1.1 * 0.1 * 1024 + phasor;
	//phases = ( (0..9) * [[0,4,7].midiratio] ).flat * 0.1 * 1024 + phasor;
	freqs = BufRd.ar(1, b1.bufnum, phases);
	amps = BufRd.ar(1, b2.bufnum, phases);
	sig = SinOsc.ar(freqs ) * amps;
	sig = sig * SinOsc.ar(1/2 + ( (0..90)/90/2 )).range(0,1).cubed;
	sig = sig.sum;
	//sig = HPF.ar(sig, 10);
	//sig = LPF.ar(sig, 19010);
	sig = sig * 0.5 * amp;


}).play;
)

(


var ampTable, freqTable, b1, b2;

ampTable  = Signal.hanningWindow(1024).squared;

freqTable = Signal.newClear(1024).waveFill({ arg i; 0.5 ** i * 20000 }, 0, 10);
//freqTable.plot;

b1 = Buffer.loadCollection(s, freqTable);

b2 = Buffer.loadCollection(s, ampTable);

Ndef(\arcade2, {

	|
amp=0.1

	|

	var sigL, sigR,freqs, amps, phasor, ratescale, rate, phases, sig, env, phshiftxxx,phend;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;


	ratescale = 1024 / 44100 / 10;
	rate = 0.4;	// once per 10 sec
	rate = SinOsc.ar(1)+1; 
	rate = EnvGen.kr(Env([0,1,1,-1,0,0.4],[0.1,4,2,1,0.8]).circle(0.01), 1, timeScale: SinOsc.ar(1/14.1).range(0.001, SinOsc.ar(1/9).range(0,10)) ) + SinOsc.ar(1/2.1 * SinOsc.ar(1/8.1) ).range(0,2.2) ;

	lfo2 = EnvGen.kr(Env([0,1,1,-1,0,0.4],[0.1,4,2,1,0.8]).circle(0.01), 1, timeScale: SinOsc.ar(1/14.2).range(0.001, SinOsc.ar(1/9).range(0,10)) ) + SinOsc.ar(1/2.1 * SinOsc.ar(1/8.1) ).range(0,2.2) ;


	phasor = Phasor.ar(0, rate * ratescale, 0, 1024);

	lfo1 = EnvGen.kr(Env([1,1.004,1],[1.4,0.8]), Impulse.kr(1/8));
	//phases = (0..19) * phasesx + phasor;
	phases = (0..90) * SinOsc.ar(1.01,0,0.001,1) * ( lfo2/500+1 ) * 0.1 * 1024 + phasor;
	//phases = ( (0..9) * [[0,4,7].midiratio] ).flat * 0.1 * 1024 + phasor;
	freqs = BufRd.ar(1, b1.bufnum, phases);
	amps = BufRd.ar(1, b2.bufnum, phases);
	sig = SinOsc.ar(freqs ) * amps;
	sig = sig * SinOsc.ar(freqs).range(0,1).cubed;
	sig = Splay.ar(sig, \spread.kr(0.8), 16, 0);
	//sig = sig.sum;
	//sig = HPF.ar(sig, 10);
	//sig = LPF.ar(sig, 19010);
	sig = sig * 0.5 * amp;
	sig.debug("sig");


}).play;
)

(
	// modulate amp with sin: crazy lfo phasing


var ampTable, freqTable, b1, b2;

ampTable  = Signal.hanningWindow(1024).squared;

freqTable = Signal.newClear(1024).waveFill({ arg i; 0.5 ** i * 20000 }, 0, 10);
//freqTable.plot;

b1 = Buffer.loadCollection(s, freqTable);

b2 = Buffer.loadCollection(s, ampTable);

Ndef(\arcade2, {

	|
amp=0.1

	|

	var sigL, sigR,freqs, amps, phasor, ratescale, rate, phases, sig, env, phshiftxxx,phend;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;


	ratescale = 1024 / 44100 / 10;
	rate = 0.4;	// once per 10 sec


	phasor = Phasor.ar(0, rate * ratescale, 0, 1024);

	lfo1 = EnvGen.kr(Env([1,1.004,1],[1.4,0.8]), Impulse.kr(1/8));
	//phases = (0..19) * phasesx + phasor;
	phases = (0..90) * SinOsc.ar(1/42.05).exprange(1,1.1) * 0.1 * 1024 + phasor;
	//phases = ( (0..9) * [[0,4,7].midiratio] ).flat * 0.1 * 1024 + phasor;
	freqs = BufRd.ar(1, b1.bufnum, phases);
	amps = BufRd.ar(1, b2.bufnum, phases);
	sig = SinOsc.ar(freqs * [ [1,1.0001] ] ) * amps;
	sig = sig * SinOsc.ar(1/22 + ( (0..90)/90/ SinOsc.ar(1/42.1).exprange(0.1,2) )).range(0,1).cubed;
	sig = sig.sum;
	//sig = HPF.ar(sig, 10);
	//sig = LPF.ar(sig, 19010);
	sig = sig * 0.5 * amp;
	sig.debug("sig");


}).play;
)

(


var ampTable, freqTable, b1, b2;

ampTable  = Signal.hanningWindow(1024).squared;

freqTable = Signal.newClear(1024).waveFill({ arg i; 0.5 ** i * 20000 }, 0, 10);
//freqTable.plot;

b1 = Buffer.loadCollection(s, freqTable);

b2 = Buffer.loadCollection(s, ampTable);

Ndef(\arcade2, {

	|
amp=0.1

	|

	var sigL, sigR,freqs, amps, phasor, ratescale, rate, phases, sig, env, phshiftxxx,phend;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;


	ratescale = 1024 / 44100 / 10;
	rate = 0.4;	// once per 10 sec


	phasor = Phasor.ar(0, rate * ratescale, 0, 1024);

	phases = (0..9) * 0.1 * 1024 + phasor;
	freqs = BufRd.ar(1, b1.bufnum, phases);
	amps = BufRd.ar(1, b2.bufnum, phases);
	sig = WhiteNoise.ar(1);
	lfo3 = SinOsc.ar(ExpRand(0.01,2!phases.size)).range(1,1.04) * amps;
	sig = RHPF.ar(sig, ( freqs/lfo3 ).clip(20,20000),0.1);
	sig = RLPF.ar(sig, ( freqs*lfo3 ).clip(20,20000),0.1);
	sig = Pan2.ar(sig, LFNoise1.kr(0.1).range(-1,1), amp).sum;
	//sig = sig.sum;
	//sig = HPF.ar(sig, 10);
	//sig = LPF.ar(sig, 19010);
	sig = sig * 0.5 * amp * 13;
	sig.debug("sig");


}).play;
)



(


var ampTable, freqTable, b1, b2;

ampTable  = Signal.hanningWindow(1024).squared;

freqTable = Signal.newClear(1024).waveFill({ arg i; 0.5 ** i * 20000 }, 0, 10);
//freqTable.plot;

b1 = Buffer.loadCollection(s, freqTable);

b2 = Buffer.loadCollection(s, ampTable);

Ndef(\arcade2, {

	|
amp=0.1

	|

	var sigL, sigR,freqs, amps, phasor, ratescale, rate, phases, sig, env, phshiftxxx,phend;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;

	var num=9;

	ratescale = 1024 / 44100 / 10;
	rate = 0.4;	// once per 10 sec
	rate = Duty.kr(( ( (1..num-1)/8 )+0 ), 0, Dseq([
		1,0,0,
	],inf));


	phasor = Phasor.ar(0, rate * ratescale, 0, 1024);

	lfo1 = EnvGen.kr(Env([1,1.08,1],[1.4,1.8]), Impulse.kr(Rand(1/8,1/2!num)));
	//phases = (0..19) * phasesx + phasor;
	phases = (0..num)/lfo1 * 0.1 * 1024 + phasor;
	//phases = ( (0..9) * [[0,4,7].midiratio] ).flat * 0.1 * 1024 + phasor;
	freqs = BufRd.ar(1, b1.bufnum, phases);
	amps = BufRd.ar(1, b2.bufnum, phases);
	sig = SinOsc.ar(freqs * ( SinOsc.ar(freqs + [ [0.11, 0.1 ]*1 ]) * amps* SinOsc.ar(Rand(0.1/8,1/8!freqs.size)).range(0,5) + 1 ) ) * amps;
	//sig = SinOsc.ar(freqs * [ [1,1.0001] ] ) * amps;
	sig = sig.sum;
	//sig = HPF.ar(sig, 10);
	//sig = LPF.ar(sig, 19010);
	sig = sig * 0.5 * amp;
	sig.debug("sig");


}).play;
)

(


var ampTable, freqTable, b1, b2;

ampTable  = Signal.hanningWindow(1024).squared;

freqTable = Signal.newClear(1024).waveFill({ arg i; 0.5 ** i * 20000 }, 0, 10);
//freqTable.plot;

b1 = Buffer.loadCollection(s, freqTable);

b2 = Buffer.loadCollection(s, ampTable);

Ndef(\arcade2, {

	|
amp=0.1

	|

	var sigL, sigR,freqs, amps, phasor, ratescale, rate, phases, sig, env, phshiftxxx,phend;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;

	var num = 90;
	var gater = SinOsc.kr(1/4 * SinOsc.kr(1/41,3pi/2).range(1/4,1)).range(0.1, SinOsc.kr(1/81,3pi/2).exprange(0.2,2));

	ratescale = 1024 / 44100 / 10;
	rate = 0.4;	// once per 10 sec


	phasor = Phasor.ar(0, rate * ratescale, 0, 1024);

	lfo1 = SinOsc.kr(1/90).range(1, SinOsc.kr(1/180).exprange(1,1.2));
	phases = (0..num) *lfo1 * 0.1 * 1024 + phasor;
	freqs = BufRd.ar(1, b1.bufnum, phases);
	amps = BufRd.ar(1, b2.bufnum, phases);
	sig = SinOsc.ar(freqs ) * amps;
	sig = sig * (gater/(1..num+1) > ( 1/num )).lag(0.1);
	sig = sig.sum;
	//sig = HPF.ar(sig, 10);
	//sig = LPF.ar(sig, 19010);
	sig = sig * 0.5 * amp;
	sig.debug("sig");


}).play;
)

(


var ampTable, freqTable, b1, b2;

ampTable  = Signal.hanningWindow(1024).squared;

freqTable = Signal.newClear(1024).waveFill({ arg i; 0.5 ** i * 20000 }, 0, 10);
//freqTable.plot;

b1 = Buffer.loadCollection(s, freqTable);

b2 = Buffer.loadCollection(s, ampTable);

Ndef(\arcade2, {

	|
amp=0.1

	|

	var sigL, sigR,freqs, amps, phasor, ratescale, rate, phases, sig, env, phshiftxxx,phend;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;

	var num = 90;
	var gater = SinOsc.kr(1/100,3pi/2).range(0.2,1.51);

	ratescale = 1024 / 44100 / 10;
	rate = 0.4;	// once per 10 sec


	phasor = Phasor.ar(0, rate * ratescale, 0, 1024);

	lfo1 = SinOsc.kr(1/210).exprange(1, SinOsc.kr(1/180).exprange(1,1.2));
	phases = (0..num) *lfo1 * 0.1 * 1024 + phasor;
	freqs = BufRd.ar(1, b1.bufnum, phases);
	amps = BufRd.ar(1, b2.bufnum, phases);
	sig = SinOsc.ar(freqs, SinOsc.ar(freqs * [ [1,1.01] ])*0.1 ) * amps;
	sig.debug("sig1");
	sig = sig * (gater/(1..num+1) > ( 1/num )).lag(0.1);
	sig = sig.sum;
	//sig = HPF.ar(sig, 10);
	//sig = LPF.ar(sig, 19010);
	sig = sig * 0.5 * amp;
	sig.debug("sig");


}).play;
)

(
	// modulate amp with sin: crazy lfo phasing


var ampTable, freqTable, b1, b2;

ampTable  = Signal.hanningWindow(1024).squared;

freqTable = Signal.newClear(1024).waveFill({ arg i; 0.5 ** i * 20000 }, 0, 10);
//freqTable.plot;

b1 = Buffer.loadCollection(s, freqTable);

b2 = Buffer.loadCollection(s, ampTable);

Ndef(\arcade2, {

	|
amp=0.1

	|

	var sigL, sigR,freqs, amps, phasor, ratescale, rate, phases, sig, env, phshiftxxx,phend;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;


	var num = 90;
	var gater = LFNoise1.kr(1/4).range(0.5,1).poll;
	ratescale = 1024 / 44100 / 10;
	rate = 0.4 * LFNoise1.kr(1/101).range( LFNoise1.kr(1/10).range(-1,2),1);	// once per 10 sec


	phasor = Phasor.ar(0, rate * ratescale, 0, 1024);

	lfo1 = LFNoise1.kr(1/210).exprange(1, SinOsc.kr(1/180).exprange(1,1.2));
	phases = (0..num) * lfo1 * 0.1 * 1024 + phasor;
	freqs = BufRd.ar(1, b1.bufnum, phases);
	amps = BufRd.ar(1, b2.bufnum, phases);
	sig = SinOsc.ar(freqs * [ [1,1.0001] ] ) * amps;
	sig = sig * LFNoise1.ar(1/22 + ( (0..num)/90/ LFNoise1.ar(1/42.1).exprange(0.1,2) )).range(0,1).cubed;
	sig = sig * (gater/(1..num+1) > ( 1/num )).lag(0.1);
	sig = sig.sum;
	//sig = HPF.ar(sig, 10);
	//sig = LPF.ar(sig, 19010);
	sig = sig * 0.5 * amp;
	sig.debug("sig");


}).play;
)
