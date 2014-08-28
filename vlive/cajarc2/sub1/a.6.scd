
Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo1, { XLine.kr(2000,20,1) });
Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([100,80],inf).stutter(8),
	\freq, Ndef(~name+++\lfo1),
	\dur, 1/8,
	\isRest, Pseq([1],inf).coin.not,
));

// END

Veco.main.get_node_by_index(8).get_clip_by_index(3).response_on_play
Pdef(~name).play
Veco.main.get_node_by_index(8).get_clip_by_index(3).response_on_play
~spawnclip.(\a, 2)
Veco.main.get_node_by_index(8).get_clip_by_index(2).response_on_play
