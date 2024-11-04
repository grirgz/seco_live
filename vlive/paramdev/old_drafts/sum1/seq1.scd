
(
Ndef.defaultQuant = 4;
Pdef.defaultQuant = 4;
);

(
Ndef(\popop, { arg freq=70, pan=0, amp=0.1;
	var sig;
	var imp = Impulse.kr(16 * TempoClock.default.tempo);
	sig = SinOsc.ar(freq * [1,2]);
	freq = freq * EnvGen.kr(Env([4,1,0.1],[0.1,0.018]), Impulse.kr(16));
	sig = sig + LFSaw.ar(freq * [1,1.0001,2]);
	sig = LPF.ar(sig, 700 * SinOsc.kr(1).range(2,1)) + LPF.ar(sig, 7000, mul:0.1);
	//sig = sig * SinOsc.kr(16).range(0,1);
	sig = sig * EnvGen.kr(Env([0,1,0],[0.0001,0.018]), imp);
	sig = Pan2.ar(sig, pan, amp).flop;
}).play;
);

(
Ndef(\hi, { arg freq=770, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = [235,245,520,700,1400]/235 * \freqfac.kr(1) + 1 * freq;
	sig = SinOsc.ar(freq * ( 1 + ( SinOsc.kr(8 * [1,2,4 * SinOsc.kr(1/4).range(0,1)]) * 4 ))) ;
	sig = sig * SinOsc.kr(2).range(0,1);
	sig = sig * LFPulse.kr(1/2, 0,0.8).range(0.1,1).lag(0.1);
	sig2 = LFSaw.ar(freq * ( 1 + ( SinOsc.kr(48 * [1,2,4 * SinOsc.kr(1/4).range(0,1)]) * 4 ))) ;
	sig2 = HPF.ar(sig2, 1000 * SinOsc.kr(1/8).range(0,1));
	sig2 = LPF.ar(sig2, 10000 * SinOsc.kr([1,2.5,1/4]).range(0.01,1));
	sig = sig + sig2;
	sig = sig * LFPulse.kr(8, 0,0.8).range(0.1,1).lag(0.1);
	sig = sig * LFPulse.kr(1/4 * [1,1/8], 0,0.9).range(0.1,1).lag(0.1);
	sig = HPF.ar(sig, 1000);
	sig = Pan2.ar(sig, pan, amp).flop;
}).play;
);

(
Pdef(\kick, Pbind(
	\instrument, \dr_kick,
	\degree, Pseq([0],inf),
	\dur, Pkeyd(\dur, 1),
	\amp, 0.3,
)).play;
Pdef(\kick).addHalo(\instrument, \dr_kick);
);
Pdef(\kick).envir = nil


(
EnvInit(\sl_kick2, StepList[1,1,0,1]);
~sl_kick2.addSpec(\list, \unipolar);
~sl_kick2.addHalo(\seqstyle, \button);
Pdef(\kick2, Pbind(
	\instrument, \dr_kick,
	\degree, Pseq([0],inf),
	\dur, 1/8,
	\isRest, ~sl_kick2.asPattern.loop.coin.not,
	\amp, Pkeyd(\amp,0.1),
)).play;
Pdef(\kick2).addHalo(\instrument, \dr_kick);
);


(

WindowDef(\main_editor,{
	VLayout (
		HLayout(
			* [Pdef(\kick), Pdef(\kick2), Ndef(\popop), Ndef(\hi)].collect({ arg x;
				var playerWrapper = PlayerWrapper(x);
				VLayout(
					playerWrapper.asView,
					XSimpleButton.new.label_("edit").action_({
						WindowDef(playerWrapper.label, {
							VLayout(
								VLayout (
									HLayout(
										playerWrapper.asView,
										XSimpleButton.new.label_("main").action_({
											WindowDef(\main_editor).front
										}).maxWidth_(50)
									),
									ParamGroupLayout.block(x.key, x.asParamGroup),
								),
								[nil, stretch:1],
							)
						}).front
					})
				)
			})
		),
		//ListParamLayout.button(Param(~sl_kick2, \list, \unipolar)),
		StepListView(~sl_kick2).asView,
		Param(Message(~sl_kick2), \stepCount, ControlSpec(1,128,\lin)).asNumberBox,
	)
}).front
)

/////////// tests

PlayerWrapper(Ndef(\popop)).isPlaying
PlayerWrapper(Pdef(\kick)).isPlaying

(
WindowDef(\hiyaaa, {
	XSimpleButton.new.label_("plop xx")
}).frontTop;
)
Window

WindowDef(\hiyaaa).window.bounds
WindowDef(\hiyaaa).window.bounds = Rect(174, 120, 573, 287)
WindowDef(\hiyaaa).window.alwaysOnTop
WindowDef(\hiyaaa).window.view.onMove = { "kjkj".debug }
WindowDef(\hiyaaa).window.bounds
WindowDef(\hiyaaa).window.availableBounds
Window.availableBounds
Window.screenBounds


Pdef(\kick).asParamGroup.edit
Pdef(\kick2).asParamGroup.edit
~sl_kick2.edit
Ndef(\popop).asParamGroup
Window

///////////////////////////////////////////



