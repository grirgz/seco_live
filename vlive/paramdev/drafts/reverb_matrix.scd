
// TODO
// - remove \dur and \freq in PbindefEditor
// - inbus should not have mixer

(
FileSystemProject.load("libdef/PbindefEditor.scd");
FileSystemProject.load("sndlib/buflib.scd");

Spec.add(\fb, ControlSpec(0.001,0.99,\exp));
Spec.add(\size, ControlSpec(0.1,4,\lin));

Builder(\fdn, { arg def, matrix; 
	var hadamard_4x4, hadamard_8x8, householder, puckette, svd;

	hadamard_4x4 = [
		[ 1,  1,  1,  1 ],
		[ 1, -1,  1, -1 ],
		[ 1,  1, -1, -1 ],
		[ 1, -1, -1,  1 ],
	] * ( sqrt(2).reciprocal * sqrt(2).reciprocal );

	hadamard_8x8 = [
		[ 1,  1,  1,  1,  1,  1,  1,  1 ],
		[ 1, -1,  1, -1,  1, -1,  1, -1 ],
		[ 1,  1, -1, -1,  1,  1, -1, -1 ],
		[ 1, -1, -1,  1,  1, -1, -1,  1 ],
		[ 1,  1,  1,  1, -1, -1, -1, -1 ],
		[ 1, -1,  1, -1, -1,  1, -1,  1 ],
		[ 1,  1, -1, -1, -1, -1,  1,  1 ],
		[ 1, -1, -1,  1, -1,  1,  1, -1 ],
	] * ( sqrt(2).reciprocal * sqrt(2).reciprocal * sqrt(2).reciprocal );

	householder = [
		[-0.5, 0.5, 0.5, 0.5],
		[ 0.5, -0.5, 0.5, 0.5],
		[ 0.5, 0.5, -0.5, 0.5],
		[ 0.5, 0.5, 0.5, -0.5],
	];

	puckette = [
		[0, 1, 1, 0],
		[-1, 0, 0, -1],
		[1, 0, 0, -1],
		[0, 1, -1, 0]
	] * sqrt(2).reciprocal;

	svd = [
		[-0.29780638, -0.34044128,  0.89169459,  0.01708377],
		[ 0.66830151, -0.59712235,  0.00372119, -0.44362613],
		[-0.6599292,  -0.27730799, -0.31432955, -0.62353081],
		[-0.17081542, -0.67130091, -0.32567445,  0.64351638]
	];

	matrix = matrix ? hadamard_8x8;

	def.addSpec(\matrix, TagSpec([\svd->svd, \puckette->puckette, \hadamard_4x4->hadamard_4x4, \hadamard_8x8->hadamard_8x8, \householder->householder]));

	SynthDef(def.key, {
		var snd, size, dampingFreq, feedback, dry, delTimes, delTimesSec, order;

		//snd = Saw.ar(XLine.kr(100, 1000, 0.1)) * Env.perc(0.001, 0.2).ar;
		snd = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
		dry = snd;
		snd = Mix(snd); // if input signal is stereo then make it mono

		//matrix = svd;
		//matrix = puckette;
		//matrix = hadamard_8x8;
		//matrix = hadamard_4x4;
		//matrix = householder;

		order = matrix.size;

		size = \size.kr(0.1);
		feedback = \fb.kr(0.52);
		dampingFreq = \damp.kr(16e3);
		//delTimes = [8820.0, 14994.0, 15876.0, 16758.0]; // delaytimes in samples

		delTimes = \delTimes.kr([ 5813, 3547, 2797, 3613, 4003, 1657, 4007, 5711 ]) * 1.82;

		//delTimes = order.collect({|i| rrand(1000, 4599).nextPrime }) * 2.5;

		( delTimes.sum / 44100 ).debug(\delTimes_sum_);	// should be at least 1 sec

		delTimesSec = delTimes / 44100;

		snd = snd + LocalIn.ar(order);
		snd = DelayC.ar(snd, 0.5, delTimesSec * size - ControlDur.ir);
		snd = snd * feedback;
		snd = LPF.ar(snd, dampingFreq);

		snd = snd * matrix.flop;

		snd = snd.sum;
		//snd = Limiter.ar(snd);
		snd.wrap2(1);
		LocalOut.ar(snd);
		snd = SelectX.ar(\mix.kr(0.5), [dry, Splay.ar(snd)]);
		snd = snd * \gain.kr(0.3);
		snd = Limiter.ar(snd);
		Out.ar(\out.kr(0), snd);
	}).add;
}).build;

);


(
Pdef(\partfx, Pdef(\zedpartfx, 
	Ppar([
		Pmono(\fdn) <>
		Pbindef(\hey, \instrument, \fdn, \inbus, BusDef(\sendbus1, \audio))
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[801].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\out, BusDef(\sendbus1, \audio),
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[732].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\out, BusDef(\sendbus1, \audio),
			\gain, 0.11,
		),
		
	])
)).play;
);

(
WindowDef(\fdn, { arg def;
	var paramsView = WindowDef(\PbindefEditorParams).asView(Pbindef(\hey));
	Param(Builder(\fdn), \matrix).attachListener(paramsView, { Pdef(\partfx).reset; "reset".debug; });
	VLayout (
		HLayout (
			PlayerWrapper(Pdef(\partfx)),
			PlayerWrapper(Pdef(\part)),
			BasicButton.new.string_("...").maxWidth_(30).mouseUpAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
				//[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");

				paramsView.showGeneralOverlayMenu(view, x, y);
			}),
		),
		Param(Builder(\fdn), \matrix).asView,
		paramsView
	)
});
);

/////////

WindowDef(\fdn).front;

Pbindef(\hey).edit

