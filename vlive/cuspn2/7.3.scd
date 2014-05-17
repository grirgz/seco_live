
Pdef(~name +++ \pre, Pbind(
	\isRest, Veco(~namex).isrest(16),
	\freq1, Pseq([100,10,23,33],inf).stutter(8),
	\freq2, Pseq([10,23,40,30],inf),
	\freq1, Ndef(~name+++\lfo1, { SinOsc.ar(0.10).range(0,13) }),
	\freq2, Ndef(~name+++\lfo2, { SinOsc.ar(0.42).range(0,33) }),
	\legato, 2,
	\dur, 1/8,
));


// END

//test scanning; you can't move fast enough... scan controls should also be audio rate!
{WaveTerrain.ar(b.bufnum,MouseX.kr(0.0,1.0), MouseY.kr(0.0,1.0),100,50) ! 2}.play

(
Ndef(\wt, {
	WaveTerrain.ar(b.bufnum,LFSaw.ar(MouseX.kr(0.0,200.0)).abs, SinOsc.ar(MouseY.kr(0.0,100.0)).abs,100,50) ! 2
}).play

)

(
Ndef(\wt, {
	var mod;
	var sig;
	var pos1;
	pos1 = MouseY.kr(1,120);
	mod = SinOsc.ar(LFSaw.kr(2+LFNoise0.kr(10).range(0,10)).range(10,pos1)).range(0,1);
	sig = WaveTerrain.ar(b.bufnum, mod, SinOsc.ar(mod.range(0,10)),100,50) ! 2;
	sig = RLPF.ar(sig, MouseX.kr(10,10000, \exponential), 0.3);
}).play

)

(
Ndef(\wt, {
	var mod;
	var sig;
	var pos1;
	pos1 = MouseY.kr(1,120);
	mod = SinOsc.ar(LFSaw.kr(2+LFNoise0.kr(10).range(0,10)).range(10,pos1)).range(0,1);
	sig = WaveTerrain.ar(b.bufnum, mod, SinOsc.ar(mod.range(0,10)),100,50) ! 2;
	sig = RLPF.ar(sig, MouseX.kr(10,10000, \exponential), 0.3);
}).play

)


(
Ndef(\wt, {
	var mod;
	var sig;
	var pos1;
	var chain;
	pos1 = MouseY.kr(1,120);
	pos1 = 100;
	mod = SinOsc.ar(LFSaw.kr(2+LFNoise0.kr(10).range(0,10)).range(10,pos1)).range(0,1);
	sig = SinOsc.ar(100);
	sig = WaveTerrain.ar(b.bufnum, mod, SinOsc.ar(mod.range(0,10)),100,50);
	//sig = RLPF.ar(sig, MouseX.kr(10,10000, \exponential), 0.3);

	    //chain = FFT(LocalBuf(2048), sig);
	    //chain = PV_MagFreeze(chain, MouseY.kr > 0.5 );
		//chain = PV_BinScramble(chain, MouseX.kr , 0.1, MouseY.kr > 0.5 );

		//sig = 0.8 * IFFT(chain);


		sig = Squiz.ar(sig, MouseX.kr(1, 10, 1), zcperchunk: MouseY.kr(1, 10), mul:0.1);

		sig = sig ! 2;
		sig;
}).play

)


{var n= 1024; WaveletDaub.ar(Saw.ar(MouseY.kr(50,10000, 'exponential'),0.5), n, MouseX.kr(0,n)) ! 2}.play

BufDef(\moeten, "voices/02_moeten.flac");
(
	Ndef(\rah, {var n= 1024; 
		var sig;
		var chain;
		var posy = MouseX.kr(0.1,2);

		//sig = PlayBuf.ar(2, BufDef(\moeten), 1, loop:1);
		sig = PlayBuf.ar(2, BufDef(\moeten), MouseX.kr(0.01,3), loop:1);
		//sig = PlayBuf.ar(2, BufDef(\moeten),  SinOsc.kr(10*posy).range(0.1,2.7), loop:1);
		//sig = SinOsc.ar(200);
		//sig = WaveletDaub.ar(sig, n, MouseX.kr(0,n));
		chain = FFT(LocalBuf(2048), sig);
		//chain = PV_PhaseShift(chain, MouseX.kr(0,360));
	    chain = PV_MagFreeze(chain, MouseY.kr > 0.5 );
		//chain = PV_MagBelow(chain, MouseX.kr(0,60));
		//chain = PV_MagAbove(chain, MouseX.kr(0,60));
		//chain = PV_BinScramble(chain, MouseX.kr , 0.1, MouseY.kr > 0.5 );

		//chain = PV_PhaseShift(chain, LFNoise2.kr(1, 180, 180));
		sig = IFFT(chain);

		sig ! 2;
	}).play
)

(
	//trig with MouseY
	SynthDef("help-magFreeze2", { arg out=0, soundBufnum=2;
	    var in, chain;
	    in = PlayBuf.ar(1, soundBufnum, BufRateScale.kr(soundBufnum), loop: 1);
	    chain = FFT(LocalBuf(2048), in);
	    chain = PV_MagFreeze(chain, MouseY.kr > 0.5 );
	    Out.ar(out, 0.1 * IFFT(chain).dup);
	}).play(s,[\soundBufnum, b]);

)


//LFNoise adds some drift to explore the landscape more
{WaveTerrain.ar(b.bufnum,SinOsc.ar(MouseX.kr(1,200,'exponential')).abs + LFNoise2.ar(2),SinOsc.ar(MouseY.kr(1,300,'exponential'),pi*0.5).abs,100,50) ! 2}.play





//change surface equation
(
var width= 100; //= num cols
var height=50; //=num rows, though indexing bottom to top; i.e., standard Cartesian co-ordinates

a=Array.fill(width*height,{arg i; 
var xnow, ynow, x, y; 

xnow= i%width;
ynow= (i-xnow).div(width);

x=xnow/width;
y=ynow/height;

(((cos(5*x+1.7))**3) - ((abs(sin(23*y)))**(1/3)))

});

b.sendCollection(a);
)





//change surface equation
(
var width= 100; //= num cols
var height=50; //=num rows, though indexing bottom to top; i.e., standard Cartesian co-ordinates

a=Array.fill(width*height,{arg i; 
var xnow, ynow, x, y; 

xnow= i%width;
ynow= (i-xnow).div(width);

x=xnow/width;
y=ynow/height;

(((1.3*(cos(rrand(1,2)*x+1.7))**2) - ((abs(sin(rrand(1.2,4.9)*y)))**(1/2)))).max(-1.0).min(1.0)

});

b.sendCollection(a);
)

