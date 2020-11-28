(
SynthDef(\fExample, {
	arg freq=440, gate=1, out=0, amp=0.1, ffreq=2000;
	var snd = Saw.ar([freq, freq*1.01]);
	var env = Linen.kr(gate, doneAction:2);
	snd = LPF.ar(snd, ffreq);
	Out.ar(out, snd*env*amp);
}).add
)

~ffreqCtlBus = Bus.control(s,1);
~ffreqCtlBus.value = 3000; // works
~ffreqCtlBus.value = 300; // works

Pdef(\fx1).play
(
Pbindef(\fx1,
	\instrument, \fExample,
	\dur, 4,
	\ffreq, ~ffreqCtlBus.asMap
)
)

Ndef(\ffreqCtl0).bus = ~ffreqCtlBus
Ndef(\ffreqCtl0, { SinOsc.kr(0.5).range(50,2000)})

Pbindef(\fx1,
	\instrument, \fExample,
	\dur, 4,
	\ffreq, Ndef(\ffreqCtl0),
)

// how to use Ndef/Proxy to control values on control bus with a synth?
Ndef.control(\ffreqCtl0,1)
~ctrlg = Group.new(s, \addBefore)
Ndef(\ffreqCtl0).play(out: ~ffreq, numChannels:1, group: ~ctrlg) // special group before?
Ndef(\ffreqCtl0, { SinOsc.kr(0.5).range(50,2000)}) // does not work.
Ndef(\ffreqCtl0).bus = ~ffreqCtlBus
Ndef(\ffreqCtl0, { SinOsc.kr(0.5).range(50,2000)}).play(out: ~ffreq, numChannels:1, group: ~ctrlg)
Ndef(\ffreqCtl0).clear

