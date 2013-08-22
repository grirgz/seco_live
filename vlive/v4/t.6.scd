
Pdef(~name +++ \step, Pbind(

	\steps, Pseq([1,2,3,4],inf),
	\play, Pfunc{ arg ev;
		"bla".postln;
		ev.postln;
		~load.(ev[\steps]);
	},
	\dur, 8*2,
));

~my = Pdef(~name +++ \step);
if(~my.isPlaying) { ~my.stop } { ~my.play };
