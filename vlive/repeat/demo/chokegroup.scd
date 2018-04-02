
	snd = snd * ( 1-EnvGen.ar( Env([0,1], [0.1]),In.kr(\chokebus.kr(BusDef(\zero, \control)), 1) * Duty.kr(0.01, 0, Dseq([ 0,Dseq([1],inf), ],inf)), doneAction:2) ); 
	Out.kr(\chokebus.kr, Impulse.kr(0));


(
SynthDef(\bigkick, { |out = 0, pan = 0, amp = 0.3|
	var body, bodyFreq, bodyAmp;
	var pop, popFreq, popAmp;
	var click, clickAmp;
	var snd;

	// body starts midrange, quickly drops down to low freqs, and trails off
	bodyFreq = EnvGen.ar(\bodyfreqenv.kr(Env([261, 60, 51], [0.035, 0.08], curve: \exp)));
	bodyAmp = EnvGen.ar(\bodyenv.kr(Env.linen(0.005, 0.1, 0.3)), doneAction: 2);
	body = SinOsc.ar(bodyFreq) * bodyAmp;
	// pop sweeps over the midrange
	popFreq = XLine.kr(\popfstart.kr(750), \popfend.kr(261), \popfdur.kr(0.02));
	popAmp = EnvGen.ar(\popenv.kr(Env.linen(0.001, 0.02, 0.001))) * \popamp.kr(0.15);
	pop = SinOsc.ar(popFreq) * popAmp;
	// click is spectrally rich, covering the high-freq range
	// you can use Formant, FM, noise, whatever
	clickAmp = EnvGen.ar(Env.perc(\clickat.kr(0.001), \clickrel.kr(0.01))) * \clickamp.kr(0.15);
	click = LPF.ar(Formant.ar(\formfund.kr(910), \formfreq.kr(4760), \formbw.kr(2110)), \lpf.kr(3140)) * clickAmp;

	snd = body + pop + click;
	snd = snd * \distpreamp.kr(1) * EnvGen.ar( \distenv.kr(Env([1,2,1],[0.1,0.8])));
	snd = snd.tanh;
	snd = snd * \distpostamp.kr(1);

	snd = snd * ( 1-EnvGen.ar( Env([0,1], [0.1]),In.kr(\chokebus.kr(BusDef(\zero, \control)), 1) * Duty.kr(0.01, 0, Dseq([ 0,Dseq([1],inf), ],inf)), doneAction:2) ); 
	Out.kr(\chokebus.kr, Impulse.kr(0));

	Out.ar(out, Pan2.ar(snd, pan, amp));
}).add;
)
