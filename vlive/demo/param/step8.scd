
(
SynthDef(\plop, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq * [1,1.01,1.001, 1+0.1.rand]);
	sig = RLPF.ar(sig, \lpf.kr(400), \rq.kr(0.1));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.4),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).flop;
	Out.ar(out, sig);
}).add;

Pdef(\plop1, Pbind(
	\instrument, \plop,
	\degree, Pseq([0,4,5,8],inf),
	\dur, 1/8,
	\amp, 0.1
));

Pdef(\plop2, Pbind(
	\instrument, \default,
	\degree, Pseq([0,2],inf),
	\octave, 3,
	\dur, 1/2,
	\amp, 0.1
));

Pdef(\plop3, Pbind(
	\instrument, \default,
	\degree, Pseq([0,7,7,7,7,2],inf),
	\octave, 5,
	\dur, 1/4,
	\amp, 0.1
));

~instruments = [
	Pdef(\plop1),
	Pdef(\plop2),
	Pdef(\plop3),
];

"/home/ggz/code/sc/seco/vlive/demo/param/lib/drumrack.scd".load;

)

~dl = ~class_lib_drumpad.new;
~rl = ~class_drumrack_lib.new;
~dp = ~class_drumrack.new;
~dp.lib_drumpad = ~dl;
~dp.lib_drumrack = ~rl;
~pg = ~class_presetgroup.new;
~pg2 = ~class_presetgroup.new;
~p1 = ~class_preset.new(Pbind(\degree, 1));
~p2 = ~class_preset.new(Pbind(\degree, 4));
~p3 = ~class_preset.new(Pbind(\degree, 8));

~pg.add_preset(~p1);
~pg.add_preset(~p2);
~pg2.add_preset(~p3);
~dl.lib[\note1] = ~pg;
~dl.lib[\note2] = ~pg2;

~dp.set_pad(0, ~pg.clone);
~dp.set_pad(1, ~pg2.clone);
~rl.lib[\base] = ~dp.clone;

~drp = ~class_drumrack_proxy.new(~dp);

//~pat = ~dp.as_pattern(
//	Ppar([
//		Pbind(\midinote, 1, \dur, 1/4,  \legato, 0.2, \isRest, Pseq([1,0,1,0],inf).coin.not),
//		Pbind(\midinote, 0, \dur, 1/3*2, \legato, 0.2, \isRest, Pseq([1,1,1,0],inf).coin.not),
//	]),
//);
//~pat = ~dp.as_pattern(Pdef(\score));
//~pat = ~dp.as_pattern(Pbind(\midinote, Pseq([0,\r,1,1,0,0,0,1],inf), \dur, 1));

Pdef(\main, ~drp.as_pattern(Pdef(\score)).trace);
//Pdef(\main).play;

~dpv = ~class_drumrack_view.new(~drp);



(
Pdef(\score, 
	Pbind(\midinote, Pseq([0,0,1,1,4,4,4,4],inf), \dur, 1/4)
);
)

(
"/home/ggz/code/sc/seco/vlive/demo/param/lib/stepeditor.scd".load;
)
~dpv = ~class_drumrack_view.new(~drp);
~saveme = nil;
(
~sm = ~class_score_manager.new(4);

if(~saveme.isNil) { 
	~saveme = [~sm.banks, ~sm.superbank];
} {
	~sm.banks = ~saveme[0]; ~sm.superbank = ~saveme[1];
};

~sm.make_window;

Pdef(\score, Ppar(
	~sm.as_pattern.collect({ arg pat, x;
		Pbind(
			\whatthefuck, Pfunc{ arg ev; ev.debug("EV!!!"); \non },
			\isRest, pat.coin.not,
			\midinote, x,
			\dur, 1/4,
		).loop;
	})
).loop);
)
