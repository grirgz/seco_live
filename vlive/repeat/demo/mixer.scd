
(
SynthDef(\simpletrackmixer, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = InFeedback.ar(\inbus.kr, 2); 
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0,1,0.01)),gate,doneAction:2);
	sig = sig * \pregain.kr(1);
	Out.ar(out, DelayL.ar(sig, 0.1, \delay.kr(0)) * \postgain.kr(1));
	Out.ar(\sendbus0.kr), sig * \send0.kr(0));
	Out.ar(\sendbus1.kr), sig * \send1.kr(0));
	Out.ar(\sendbus2.kr), sig * \send2.kr(0));
	Out.ar(\sendbus3.kr), sig * \send3.kr(0));
}).add;

SynthDef(\fx_echo, { arg out=0, amp=0.1, gate=1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var in = InFeedback.ar(\inbus.kr, 2); 
	sig = in;
	sig = CombC.ar(sig, 1, \delay.kr(1),\decay.kr(1));
	sig1 = sig;
	sig1 = LPF.ar(sig1, \lpf.kr(15000));
	sig1 = HPF.ar(sig1, \hpf.kr(50));
	sig = SelectX.ar(\pfmix.kr(0.5), [sig, sig1]);
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * \gain.kr(1);
	sig = sig * EnvGen.ar(\adsr.kr( Env.adsr(0.01,0.1,0.8,0.1) ),gate,doneAction:2);
	Out.ar(out, sig);
}).add;
)
~bus = ~bus ?? { {Bus.audio(s, 2)} ! 10 };

(
Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([0,4,Rest(1),-2],inf) + Pseq([Pn(0,8),Pbrown(0,4,1,8)],inf),
			\dur, 1/4,
			\amp, 0.1,
			\sustain, 0.1,
			\octave, 3,
			//\out, ~bus[0],
		),
		Pbind(
			\instrument, \default,
			\note, Pseq([0,4,Rest(1),-2],inf) + Pseq([Pn(0,8),Pbrown(0,4,1,8)],inf),
			\dur, 1/4,
			\amp, 0.1,
			\sustain, 0.1,
			\out, ~bus[0],
		),
		Pmono(\simpletrackmixer,
			\inbus, ~bus[0],
			\addAction, \addToTail,
			\lag, 0.0005, // fx is after
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, Pseq([0,1],inf),
			\sendbus0, ~bus[1],
			\dur, 2,
		),
		Pmono(\fx_echo,
			\addAction, \addToTail,
			\lag, 0.00051, // fx is after
			\inbus, ~bus[1],
			\mix, 1,
			\delay, 0.1,
			\decay, 3,
			\dur, 1,
			\amp, 0.1,
		),
	]),
).play;
);
