

(
	SynthDef.new(\s1, { arg a = #[50,54,57];
	var x;
	x = SinOsc.ar(a.midicps, 0, 0.25).mean;
	x = Pan2.ar(x, 0, 1);
	Out.ar(0, x);
}).add;
)

z = Synth.new(\s1);
z.set(\a, [70,37,48]); 


/////

(
	SynthDef.new(\s1, {
	var x;
	x = SinOsc.ar(\a.kr([50,54,57]), 0, 0.25).mean;
	x = Pan2.ar(x, 0, 1);
	Out.ar(0, x);
}).add;
)
