
Ndef(\midage).put(0, { arg amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var freq = 170;
	var size;
	var time;
	var env1, env2, env3;
	var env0;
	var osig;
	var chords;
	var mid, side;
	var mfreq;

	mfreq = Duty.kr(1, 0, Dseq([
		8,2,4,2,
		6,8,3,8,
	],inf));
	freq = SinOsc.kr(mfreq).range(0,1) * 47 + 50 * Duty.kr(1, 0, Dseq([
		1,0,4,0,
	],inf)).midiratio;

	//freq = freq * [1/2,1/4,1/8,1,2,3,4];
	//freq = freq * ( [0,0.001,0.0001] * SinOsc.kr( {arg x; 1 / ( x + 1 ) }! 5/10).range(0,1) +1 ) * [1,2,1];
	freq = freq * ( 1+Duty.kr(1/4, 0, Dseq([
		[0,0,0],
		[0,0.01,0],
		[0,0,0],
		[0.0001,0,0.00001],
	],inf)) );
	freq = freq;
	//freq = freq.flat;
	sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = SinOsc.ar(freq);
	sig = SelectX.ar( Duty.kr(1/2, 0, Dseq([
		1,0,2,0,
	],inf)), [sig1, sig2, sig3]);

	osig = sig;

	sig1 = sig.clip(0.1);
	sig = SelectX.ar( SinOsc.kr((1..sig.size)/18).range(0,1), [sig, sig1] );

	sig1 = LFPulse.ar(freq * 2);
	sig = SelectX.ar( Pulse.kr((1..sig.size)*5).range(0,1), [sig, sig1] );

	sig1 = RLPF.ar(sig, SinOsc.ar( (1..sig.size).normalizeSum.debug("sum")+0.1 ).range(100,14000), SinOsc.kr((1..sig.size)/100).range(0.1,1));
	sig = SelectX.ar( SinOsc.kr((1..sig.size)/68).range(0,1), [sig, sig1] );


	sig.debug("sig");
	sig = sig.clump(2);
	sig.debug("sig1");
	sig = Splay.ar(sig, 0.8 * SinOsc.kr(1/4* [1,1/2.5]/5).range(0,1), 1, [-1,1]*0.3 * SinOsc.kr([1/14.1,1/14.57]).range(0,1));
	sig.mean;
	//sig = sig / 15;
	//sig = sig.softclip;
	//sig = sig.clip(-0.5,0.5);
	sig = sig / 15;
	sig.debug("sig2");
	//sig = 

	sig;
}).play


Ndef(\midage).put(0, { arg amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var freq = 170;
	var size;
	var time;
	var env1, env2, env3;
	var env0;
	var osig;
	var chords;
	var mid, side;
	var mfreq;

	mfreq = Duty.kr(1, 0, Dseq([
		8,2,4,2,
		6,8,3,8,
	],inf));
	freq = SinOsc.kr(mfreq).range(0,1) * 47 + 50 * Duty.kr(1, 0, Dseq([
		1,0,4,0,
	],inf)).midiratio;

	//freq = freq * [1/2,1/4,1/8,1,2,3,4];
	//freq = freq * ( [0,0.001,0.0001] * SinOsc.kr( {arg x; 1 / ( x + 1 ) }! 5/10).range(0,1) +1 ) * [1,2,1];
	freq = freq * ( 1+Duty.kr(1/4, 0, Dseq([
		[0,0,0],
		[0,0.01,0],
		[0,0,0],
		[0.0001,0,0.00001],
	],inf)) );
	freq = freq;
	//freq = freq.flat;
	sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = SinOsc.ar(freq);
	sig = SelectX.ar( Duty.kr(1/2, 0, Dseq([
		1,0,2,0,
	],inf)), [sig1, sig2, sig3]);

	osig = sig;



	sig.debug("sig");
	sig = sig.clump(2);
	sig.debug("sig1");
	sig = Splay.ar(sig, 0.8 * SinOsc.kr(1/4* [1,1/2.5]/5).range(0,1), 1, [-1,1]*0.3 * SinOsc.kr([1/14.1,1/14.57]).range(0,1));
	sig.mean;
	//sig = sig / 15;
	//sig = sig.softclip;
	//sig = sig.clip(-0.5,0.5);
	sig = sig / 15;
	sig.debug("sig2");
	//sig = 

	sig;
}).play
