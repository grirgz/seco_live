

(
SynthDef(\o3bass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var osc1detune=\osc1detune.kr(0), osc1voices=\osc1voices.kr([1,1,1]), osc1gain=1, osc1amps = \osc1amps.kr([1,1,1]);
	var osc2detune=\osc2detune.kr(0), osc2voices=\osc2voices.kr([1,1,1]), osc2gain=1, osc2amps = \osc2amps.kr([1,1,1]);
	var osc3detune=\osc3detune.kr(0), osc3voices=\osc3voices.kr([1,1,1]), osc3gain=1, osc3amps = \osc3amps.kr([1,1,1]);
	env1 = EnvGen.kr(\lpenv.kr(Env([2,1.2,1/2],[0.011,1.7])), 1);
	sig = Saw.ar(freq * osc1voices + osc1detune) * osc1amps * osc1gain;
	sig = sig + SinOsc.ar(freq * osc2voices + osc2detune) * osc2amps * osc2gain;
	sig = sig + Pulse.ar(freq * osc3voices + osc3detune) * osc3amps * osc3gain;
	sig = sig /3;
	sig = LPF.ar(sig, \lpfr.kr(2.1) * env1 * freq);
	sig = ( sig*2 ).tanh * 3;
	sig = HPF.ar(sig, 30);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.4,0.4)),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}, metadata:(specs:(
	lpenv: XEnvSpec( ControlSpec(0,8,\lin) ),
	lpfr: ControlSpec(0,8,\lin),
	osc1amps: XArraySpec(\unipolar),
	osc2amps: XArraySpec(\unipolar),
	osc3amps: XArraySpec(\unipolar),
	osc1detune: ControlSpec(-10,10,\lin),
	osc2detune: ControlSpec(-10,10,\lin),
	osc3detune: ControlSpec(-10,10,\lin),
))).add;
);

(
Pdef(\o3bass, Pbind(
	\instrument, \o3bass,
	\octave, 3,
	\dur, 1,
)).play;
);

\fenv.asSpec

WindowDef(\PdefEditor).front(Pdef(\o3bass))

(
WindowDef(\basseditor, { arg def, pat;
	var makeosc = { arg name;
		VLayout (

			StaticText.new.string_(name),
			HLayout (
				VLayout(
					Param(pat, name+++\detune).asTextField,
					Param(pat, name+++\detune).asSlider.orientation_(\horizontal),
				),
				* 3.collect{ arg idx;
					VLayout(
						Param(pat, name+++\voices).at(idx).asTextField,
						Param(pat, name+++\amps).at(idx).asSlider.orientation_(\horizontal),
					);
				}

			)
		)
	};
	HLayout (
		[VLayout(
			PlayerWrapper(pat).asView,
			makeosc.(\osc1),
			makeosc.(\osc2),
			makeosc.(\osc3),
			nil
		), stretch:1],
		[Param(pat, \lpenv).asView, stretch:4],
		[ Param(pat, \adsr).asView, stretch:4 ],
	)
});
WindowDef(\basseditor).front(Pdef(\o3bass))
)

ProtoDef(\piano).startControl(Pdef(\o3bass));
