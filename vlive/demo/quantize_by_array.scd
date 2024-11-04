(
{
    var index, intv, lfo, buffer = [1,9/7,7/5,5/3,9/5,15/7,7/3,25/9,3].as(LocalBuf);
	lfo = LFNoise0.kr(1,1,2);
    index = IndexInBetween.kr(buffer, lfo).round;
    intv = Index.kr(buffer, index).poll;

	Splay.ar({MoogLadder.ar(Saw.ar(intv.lag(0.3)*30*LFNoise2.kr(12,0.02,1),LFNoise2.kr(4,0.4,0.6)**2),LFNoise2.kr(1,1700,2200),0.3)}!8);
}.play;
)

(
{
    var index, intv, lfo, buffer = [1,9/7,7/5,5/3,9/5,15/7,7/3,25/9,3];
	lfo = LFNoise0.kr(1,1,2);
    index = IndexInBetween.kr(buffer, lfo).round;
    intv = Index.kr(buffer, index).poll;
	intv = IEnvGen.kr( Env([1, 7/3, 3].stutter(2),[7/3-1, 0, 3-( 7/3 ), 0]), lfo );

	SinOsc.ar(intv.poll * 200)!2 * 0.1;

	//Splay.ar({MoogLadder.ar(Saw.ar(intv.lag(0.3)*30*LFNoise2.kr(12,0.02,1),LFNoise2.kr(4,0.4,0.6)**2),LFNoise2.kr(1,1700,2200),0.3)}!8);
}.play;
)

Env([1, 7/3, 3].stutter(2),[7/3-1, 0, 3-( 7/3 ), 0]).plot

(
~quant_to_env = { arg arr;
	var times = arr.collect({ arg a, idx;
		arr[idx+1] ? 0 - a / 2 + a
	});
	//times = [ times, 0!(arr.size-1) ].flop.flat.take(arr.size*2-1);
	times = [ times.differentiate.abs, 0!arr.size ].flop.flat;
	times.debug("times");
	//Env(arr.stutter(2), [ arr.differentiate.keep(arr.size.neg+1), 0!( arr.size-1 ) ].flop.flat)
	Env(arr.stutter(2), times)
};
//~quant_to_env.([1,7/3,3]).postcs.plot;
//~quant_to_env.([1,2,3,4]).postcs.plot;
~quant_to_env.([1,9/7,7/5,5/3,9/5,15/7,7/3,25/9,3]).postcs.plot;
)

[]
[7/3-1, 0, 3-( 7/3 ), 0]
[1,7/3,3].differentiate.keep(-3+1)
[1,2,3,4]

[1,2,3,4]


(
~quant_to_env = { arg arr;
	var times = arr.collect({ arg a, idx;
		arr[idx+1] ? 0 - a / 2 + a
	});
	times = [ times.differentiate.abs, 0!(arr.size-1) ].flop.flat;
	Env(arr.stutter(2), times)
};

{
    var index, intv, lfo, buffer = ~quant_to_env.([1,9/7,7/5,5/3,9/5,15/7,7/3,25/9,3]);
	lfo = LFNoise0.kr(1,1,2);
	intv = IEnvGen.kr( buffer, lfo );

	Splay.ar({MoogLadder.ar(Saw.ar(intv.lag(0.3)*30*LFNoise2.kr(12,0.02,1),LFNoise2.kr(4,0.4,0.6)**2),LFNoise2.kr(1,1700,2200),0.3)}!8);
}.play;
)
