(

f = { |f0=200, rate=4|

	{

		var seq = Dseq(f0*[1/2,3/4, Dstutter(4, Drand([1/2,1,2,3,4,5,6],1)), 2,3/2,3,4/3], inf);

		var trig = Impulse.ar(rate);

		var freq = Demand.ar(trig,0, seq).lag(0.001);

		var env = Decay2.ar(trig,1e-3,1);
		var sig;

		sig = SinOsc.ar(freq*[0.995, 1, 1.005]).fold(-0.995,0.995)*0.25*env;
		//sig = SinOsc.ar(freq*[0.995, 1, 1.005])*0.25*env;
		sig = Splay.ar(sig);
		sig = sig / 8;

		sig = FreeVerb.ar( sig, 0.5, 0.5 );
		sig;

	}

};



fork{ 4.do{

	fork{

		f.(100,2).play;

		(1/8).wait;

		f.(200,4).play;

		(1/4).wait;

		f.(100*4/3,8).play;

		(1/2).wait;

		f.(400,4).play;

	};

	(1/4).wait;

}}

)
