
(
Ndef(\fee).put(0, { arg amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;

	var freq;
	var lpspread;

	freq = 140 * [0,3,5].midiratio;
	freq = freq *.t [1,4,1.01,1/2,4.01,1.001,2];

	sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = SinOsc.ar(freq);
	sig = SelectX.ar(SinOsc.kr(0.7*(1..11)/12).unipolar*2, [sig1, sig2, sig3]);
	sig = SelectX.ar(SinOsc.kr(0.07*(1..11)/12).unipolar*6, sig.flop);

	sig = sig.fold2( SinOsc.kr(1/4/(1..11)).range(0.1,2));
	sig = sig.wrap2( SinOsc.kr(1/4/(1..11).reverse).range(0.1,2));
	lpspread = SinOsc.kr(1/5*(1..11)/9)*1.5;
	//lpspread = 0;
	sig = RLPF.ar(sig, \lpf.kr(400) * SinOsc.kr((0..11)+1/42.3).exprange(1/2,10) * ((0..11)/11 - 0.5 * lpspread + 1), \rq.kr(0.5));
	sig = HPF.ar(sig, 700);

	sig = sig / 2;
	
	amp = amp * \gain.kr(1);
	//sig = sig.flop;
	sig = Splay.ar(sig, \spread.kr(0.2), amp, \pan.kr(0));
	sig;
}).play;

)


(
	// concept doc !!!
Ndef(\fee).put(0, { arg amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;

	var freq;
	var lpspread;

	freq = 140 * [0,3,5].midiratio;
	freq = freq *.t [1,4,1.01,1/2,4.01,1.001,2];
	sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = SinOsc.ar(freq);

	sig = [sig1, sig2, sig3];

	// 3 * 7 * 3 = 63

	// here we select the dimension which we want to select
	// 0 is waveform, 1 is note, 2 is detune/octave
	// NO! this don't work like this, we lose multiple dimensions
	sig = sig.deepCollect(2,{ arg sig;
		SelectX.ar( SinOsc.kr(1/2).range(0,sig.size-1), sig );
	})
	
	amp = amp * \gain.kr(1);
	//sig = sig.flop;
	sig = Splay.ar(sig, \spread.kr(0.2), amp, \pan.kr(0));
	sig;
}).play;
)

(
Ndef(\fee).put(0, { arg amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;

	var freq;
	var lpspread;

	freq = 140 * [0,3,5,9].midiratio;
	freq = freq *.t [1,4,1.01,1/2,4.01,1.001,2];
	sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = SinOsc.ar(freq);

	sig = [sig1, sig2, sig3];

	// 3 * 7 * 4 = 63 channels
	sig.shape.debug("shape");

	// here how we select the dimension which we want to select
	// first dimension is is waveform, 2 is note, 3 is detune/octave
	sig = SelectX.ar( SinOsc.kr((1..sig.shape[1])/20).range(0,sig.size-1), sig); // here we select in the first dimension
	//sig = sig.flop;
	sig = SelectX.ar( SinOsc.kr((1..sig.shape[1])/10).range(0,sig.size-1), sig); 
	sig = SelectX.ar( SinOsc.kr((1..sig.shape[1]?1)/32).range(0,sig.size-1), sig); 

	sig.shape.debug("shape");
	
	amp = amp * \gain.kr(1);
	//sig = sig.flop;
	//sig = Splay.ar(sig, \spread.kr(0.2), amp, \pan.kr(0));
	sig = Pan2.ar(sig, 0, amp);
	sig;
}).play;
)


~a = [ [ [1,2,3,4], [5,6,7,8], [9,10,11,12] ], [ [1,2,3,4], [5,6,7,8], [9,10,11,12] ]+100 ]
~a.deepCollect(2, { arg x; x.debug("el") })

~a.flop.shape
~a.flopDeep.shape
~a.flop.flopDeep.shape
~a.rank
~a.shape
""


(
Ndef(\fee).put(0, { arg amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;

	var freq;
	var lpspread;

	freq = 140 * [0,4,7,9].midiratio;
	freq = freq *.t [1,4,1.01,1/2,4.01,1.001,2];
	sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = SinOsc.ar(freq);

	sig = [sig1, sig2, sig3];

	// 3 * 7 * 4 = 63 channels
	sig.shape.debug("shape");

	sig = sig.flat;
	sig.shape.debug("shape");
	sig = sig.clump(4).flop; // make 4 packets of 21 items
	sig.size.debug("size");
	sig.shape.debug("shape");
	sig = SelectX.ar( SinOsc.kr(( 1..sig.shape[1] )/20).range(0,sig.size-1), sig); // select between the 4 channel, 21 times -> 21 channels

	sig = sig.clump(4).flop; // make 6 packets of 4 items
	sig.size.debug("size");
	sig.shape.debug("shape");
	sig = SelectX.ar( SinOsc.kr(( 1..sig.shape[1] )/12).range(0,sig.size-1), sig); // select between the 4 channel, 6 times -> 6 channels

	sig.shape.debug("shape");
	lpspread = SinOsc.kr(1/5*(1..11)/9)*1.5;
	sig = RLPF.ar(sig, \lpf.kr(400) * SinOsc.kr((0..11)+1/42.3).exprange(1/2,10) * ((0..11)/11 - 0.5 * lpspread + 1), \rq.kr(0.5));
	//sig = HPF.ar(sig, 700);
	
	amp = amp * \gain.kr(1);
	//sig = sig.flop;
	//sig = Splay.ar(sig, \spread.kr(0.2), amp, \pan.kr(0));
	sig = Pan2.ar(sig, 0, amp).flop.mean;
	sig;
}).play;
)

// c'est un echec total, il n'y a pas d'algoritme generique de transformation des matrices mutlidiensionelles de signaux, c'est un domaine bien trop complexe ou il y a mil facon de transformer
