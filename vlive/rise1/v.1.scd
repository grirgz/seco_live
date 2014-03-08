Pdef(~name +++ \pre, Pbind(
	\freq, 100,
	\ffreq, 5000,
	\isRest, false,
	//\dur, 4,
	\dur, Prout({
		8.do { arg x;
			Pseq(4.partition(x+1, 0.1),1).embedInStream;
		};
	}).loop,
	\dur, Prout({
		var list=[4];
		8.do { arg x;
			var seq = list.differentiate.postln;
			Pseq(seq,1).embedInStream;
			list.add(4.0.rand+0.05);
			list.sort;
			[list, list.differentiate, list.differentiate.sum].debug("end");
		};
	}).loop,
	\freqtab, Pfunc({ 
		//[[1000,2000,3000,4000,2000].rand+100]
		//[[100,200,5,400,5000].rand]
		[[100,200,150,400,5000]]
	}),
));

// END

4.partition(1, 0.1);

Pdef(~name+++\pre).clear
Pdef(~name).clear
Pdef(~name+++\pre,nil)
Pdef(~name,nil)
