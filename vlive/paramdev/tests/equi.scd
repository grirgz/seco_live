
TrackMixerDef(\bla).insertFxAt(0).instrument = \equi
TrackMixerDef(\bla).edit

~equi

(
WindowDef(\win, { arg def;
	var proxy = Ndef(\bla);
	var prefix = \azer;
	var eqview = View.new;
	eqview.background = Color.blue;
	~equi = EQui(eqview,nil,proxy,nil,prefix);
	~equi.sync;
	eqview;
}).front;
)

Ndef(\bla, { LFSaw.ar(100).equi(prefix:\azer);  })
Ndef(\bla).edit

~ep = EQuiParams()
~ep.loShelfFreq
~ep.loShelfGain


TestDefVal.hello(nil)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, TrackMixerDef(\bla).inbus,
		),
		
	])
)).play;
);
