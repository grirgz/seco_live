
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

	chords = Duty.kr(4, 0, Dseq([
		Dseq([
			[0,4,7],
			[0,3,6],
		],1),
		[0,5,8,3+24],
		[2,5,8],


		Dseq([
			[0,4,7],
			[0,3,6],
		],2),
		[1,4,8,14],
		[0,9,6],
		[0,5,8,3+24],
		[2,5,8],
	],inf)).lag(0.4).midiratio ;
	freq = freq * [1/2,1/4,1/8,1,2,3,4];
	freq = freq *.t chords;
	sig = SinOsc.ar(freq);
	sig = sig.flat;
	//sig = Splay.ar(sig, \spread.kr(0.8)+ LFNoise1.kr(1/12,mul:0.2), amp, \pan.kr(0)+ LFNoise1.kr(1/17,mul:0.1));
	sig.debug("sig 1");
	//sig = sig * (1/((sig*( (1..sig.size).normalizeSum + 100 ).debug("kk")).tanh+1));
	//sig = sig * (1/((sig*(  100 ).debug("kk")).tanh+1));
	//sig = sig * (1/( 1/((sig*(  1003 ).debug("kk")).tanh+1) ));
	sig = (1/( 1/((sig*(  1000 ).debug("kk")).tanh+1) )) | ( 1/( sig+1 ) );
	sig = sig.softclip(-1,1) * 8;
	sig.debug("sig 2");
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size, amp).mean;
	side = HPF.ar(side,60);
	sig.debug("sig 3");

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
	var lfo1, lfo2;

	chords = Duty.kr(4, 0, Dseq([
		[0,3,7,10],
		[4,9,12,16],
		[0,3+12,7,10],
		[4,9,0,16],
	],inf)).lag(0.4).midiratio ;
	freq = freq * [1/2,1/4,1/8,1,2,3,4];
	freq = freq *.t chords;
	sig = SinOsc.ar(freq);
	//sig = sig.flat;
	sig = sig.collect({ arg isig, i;
		isig = isig * SinOsc.kr(1/(i+10)).range(0,1)
	});
	sig = sig.flop.collect({ arg isig, i;
		var isig1;
		isig1 = isig * LFSaw.ar(freq[i]);
		isig1 = RLPF.ar(isig1, 170 + (1+i*300));
		isig = SelectX.ar( SinOsc.kr(1/(i+12)).range(0,1), [isig, isig1]);
	});
	sig = sig.flat;
	sig.debug("sig");
	//sig = Splay.ar(sig, \spread.kr(0.8)+ LFNoise1.kr(1/12,mul:0.2), amp, \pan.kr(0)+ LFNoise1.kr(1/17,mul:0.1));
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size, amp).mean;

	mid = ( sig[0] + sig[1] ) * -3.dbamp;
	side = ( sig[0] - sig[1] ) * -3.dbamp;

	//side = side * (1/((side*101).tanh+1));
	//mid = mid * LFSaw.ar(side + 1 * 170);
	//side = HPF.ar(side,60);
	lfo1 = SinOsc.kr(1 / [1,2,3,4,5,6,7]).range(0,1);
	mid = lfo1 * mid;
	side = (1 - lfo1) * side;

	sig1 = [mid+side, mid-side];
	sig1.debug("sig");
	sig1 = sig1.flat;
	sig1 = Pan2.ar(sig1, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig1.size, amp).sum;
	sig = SelectX.ar( SinOsc.kr(1/7).range(0,1), [sig, sig1]);
	sig = sig * 10;

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

	chords = Duty.kr(4, 0, Dseq([
		//[0+12,4,9,13],
		//[0,3,8,15],
		[0,5,7,10],
		[0,3,6,10],
		[0,3,7,9],
	],inf)).lag(0.4).midiratio ;
	//freq = freq * [1/2,1/4,1/8,1,2,3,4];
	freq = freq * ( [0,0.001,0.0001] * SinOsc.kr( {arg x; 1 / ( x + 1 ) }! 5).range(0,1) +1 );
	freq = freq *.t chords;
	sig = LFSaw.ar(freq);
	sig = sig.flat;
	//sig = Splay.ar(sig, \spread.kr(0.8)+ LFNoise1.kr(1/12,mul:0.2), amp, \pan.kr(0)+ LFNoise1.kr(1/17,mul:0.1));
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size, amp).mean;
	mid = ( sig[0] + sig[1] ) * -3.dbamp;
	side = ( sig[0] - sig[1] ) * -3.dbamp;
	side = side * (1/((side*101).tanh+1));
	side = HPF.ar(side,160);
	sig.debug("sig");
	sig = [mid+side, mid-side];

	sig;
}).play

(
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

	chords = Duty.kr(4, 0, Dseq([
		//[0+12,4,9,13],
		//[0,3,8,15],
		[0,5,7,10],
		[0,3,6,10],
		[0,3,7,9],
	],inf)).lag(0.4).midiratio ;
	//freq = freq * [1/2,1/4,1/8,1,2,3,4];
	freq = freq * ( [0,0.001,0.0001] * SinOsc.kr( {arg x; 1 / ( x + 1 ) }! 5).range(0,1) +1 );
	freq = freq *.t chords;
	sig = LFSaw.ar(freq);
	sig = sig.flat;
	//sig = Splay.ar(sig, \spread.kr(0.8)+ LFNoise1.kr(1/12,mul:0.2), amp, \pan.kr(0)+ LFNoise1.kr(1/17,mul:0.1));
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size, amp).mean;
	mid = ( sig[0] + sig[1] ) * -3.dbamp;
	side = ( sig[0] - sig[1] ) * -3.dbamp;
	//side = side * (1/((side*101).tanh+1));
	sig.debug("sig");
	sig = [mid+side, mid-side];
	sig = sig.collect({ arg isig, i;
		isig * SelectX.ar(
			SinOsc.ar(1 + ( i/2.321 )).range(0,1),
			[DC.ar(1), (1/((isig*70).tanh+1))/64],
		);
	});
	sig = HPF.ar(sig,160);
	sig = sig / 14;

	sig;
}).play
)


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

	chords = Duty.kr(4, 0, Dseq([
		//[0+12,4,9,13],
		//[0,3,8,15],
		[0,5,7,10],
		[0,3,6,10],
		[0,3,7,9],
	],inf)).lag(0.4).midiratio ;
	//freq = freq * [1/2,1/4,1/8,1,2,3,4];
	freq = freq * ( [0,0.001,0.0001] * SinOsc.kr( {arg x; 1 / ( x + 1 ) }! 5).range(0,1) +1 ) * [1,2,1];
	freq = freq *.t chords;
	freq = freq.flat;
	sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = SinOsc.ar(freq);
	sig = SelectX.ar( SinOsc.kr((1..sig.size)/74).range(0,2), [sig1, sig2, sig3]);

	osig = sig;

	sig1 = RLPF.ar(sig, SinOsc.ar( (1..sig.size).normalizeSum.debug("sum")+0.1 ).range(100,14000), SinOsc.kr((1..sig.size)/100).range(0.1,1));
	sig = SelectX.ar( SinOsc.kr((1..sig.size)/68).range(0,1), [sig, sig1] );


	sig = sig * SinOsc.kr((1..sig.size)/81).range(0,1);
	//sig = Splay.ar(sig, \spread.kr(0.8)+ LFNoise1.kr(1/12,mul:0.2), amp, \pan.kr(0)+ LFNoise1.kr(1/17,mul:0.1));
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size, amp).flop;
	sig.debug("sig");
	mid = ( sig[0] + sig[1] ) * -3.dbamp;
	side = ( sig[0] - sig[1] ) * -3.dbamp;
	//side = side * (1/((side*101).tanh+1));
	//side = HPF.ar(side,160);
	sig1 = [mid, mid-side];
	sig = SelectX.ar( LFSaw.kr(1/8 + ( (1..sig.flop.size).normalizeSum / 2 )).range(0,4) ! 2, [
		sig,
		[mid, side],
		sig.reverse,
		[side, mid],
		sig,
	] );

	sig1 = (sig*22 * SinOsc.kr((1..sig.flat.size).clump(sig.flop.size)/48).range(0,1)).tanh/8;
	sig.debug("sig x1");
	sig = SelectX.ar( SinOsc.kr(1/49 * (1..sig.flat.size)).range(0,1).clump(sig.flop.size), [sig, sig1] );
	sig = sig.flop.sum;

	sig = HPF.ar(sig, SinOsc.kr(1/72).range(40,100));
	sig1 = SelectXFocus.ar( SinOsc.kr(1/74).range(0,1)+[0,0.1]*osig.size/2, osig, 2 )/12;
	sig1 = HPF.ar(sig1, SinOsc.kr(1/42).range(40,1100));
	//sig = sig1;
	sig = SelectX.ar( SinOsc.kr(1/49 * (1..sig.size)).range(0,1), [sig, sig1] );
	sig.debug("sig 1");

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

	chords = Duty.kr(4, 0, Dseq([
		//[0+12,4,9,13],
		//[0,3,8,15],
		[0,5,7,10],
		[0,3,6,10],
		[0,3,7,9],
	],inf)).lag(0.4).midiratio ;
	//freq = freq * [1/2,1/4,1/8,1,2,3,4];
	freq = freq * ( [0,0.001,0.0001] * SinOsc.kr( {arg x; 1 / ( x + 1 ) }! 5).range(0,1) +1 ) * [1,2,1];
	freq = freq *.t chords;
	freq = freq.flat;
	sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = SinOsc.ar(freq);
	sig = SelectX.ar( SinOsc.kr((1..sig.size)/74).range(0,2), [sig1, sig2, sig3]);

	osig = sig;

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
