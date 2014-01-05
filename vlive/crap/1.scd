
//create buffer. I want the equation z = 2*(((x/100)**2) + ((abs(sin(10*y))/50)**(1/3)))-1
//over a 100 by 50 area

//2d to 1d conversion follows index= y*rowlength+ x
(
var width= 100; //= num cols
var height=50; //=num rows, though indexing bottom to top; i.e., standard Cartesian co-ordinates

a=Array.fill(width*height,{arg i; 
var xnow, ynow, x, y; 

xnow= i%width;
ynow= (i-xnow).div(width);

x=xnow/width;
y=ynow/height;

2*(((x)**2) + ((abs(sin(10*y)))**(1/3)))-1

});


b.sendCollection(a, 1);
)
b=Buffer.sendCollection(s, a, 1);


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
	sig = WaveTerrain.ar(b.bufnum, mod, SinOsc.ar(mod.range(0,10)),100,50);
	sig = RLPF.ar(sig, MouseX.kr(10,10000, \exponential), 0.3);

	    chain = FFT(LocalBuf(2048), sig);
	    chain = PV_MagFreeze(chain, MouseY.kr > 0.5 );
		//chain = PV_BinScramble(chain, MouseX.kr , 0.1, MouseY.kr > 0.5 );

		sig = 0.8 * IFFT(chain);


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


s.quit

{ Formlet.ar(Impulse.ar(20, 0.5), 1000, 0.01, 0.1) }.play;

{ Formlet.ar(Blip.ar(XLine.kr(10,400,8), 1000, 0.1), 1000, 0.01, 0.1) ! 2 }.play;

(
// modulating formant frequency
{
    var in;
    in = Blip.ar(SinOsc.kr(5,0,20,300), 1000, 0.1);
    Formlet.ar(in, XLine.kr(1500,700,8), 0.005, 0.04) ! 2;
}.play;
)

(
// mouse control of frequency and decay time.
{
    var in;
    in = Blip.ar(SinOsc.kr(5,0,20,300), 1000, 0.1) ! 2;
    Formlet.ar(in,
        MouseY.kr(700,2000,1),
        0.005, MouseX.kr(0.01,0.2,1));
}.play;
)

(
// mouse control of frequency and decay time.
{
    var freq;
    freq = Formlet.kr(
        Dust.kr(10 ! 2),
        MouseY.kr(7,200,1),
        0.005, MouseX.kr(0.1,2,1)
    );
    SinOsc.ar(freq * 200 + [500, 600] - 100) * 0.2 ! 2
}.play;
)

(
SynthDef(\fatsaw,
	{
		arg freq=440, amp=0.3, fat=0.0033, ffreq=2000, atk=0.001, dec=0.3, sus=0.5, rls=0.1,gate=1;

		var f1,f2,f3,f4,synth;

		f1=freq-(freq*fat);
		f2=freq-(freq*fat/2);
		f3=freq+(freq*fat/2);
		f4=freq+(freq*fat);

		synth = LFSaw.ar([f1,f2,f3,f4],[0,0.001,0.002,0.004,0.008]);
		synth = synth * EnvGen.kr(Env([0,1,sus,0],[atk,dec,rls],'lin',2),gate,doneAction:0);
		synth=Splay.ar(synth,0.7);
		synth=RLPF.ar(synth,ffreq*Linen.kr(gate,0.1,0.4,0.2,0),0.4);
		Out.ar(0,synth*amp);
},[0.1,0.3,4,2]).add;
)
(
TempoClock.default = TempoClock.new(2);
fork{

	z = Synth(\fatsaw,[\gate,0,\ffreq,500,\fat,0.5]);

	a=Pseq([0,7,12,5],inf).asStream; // musical degrees
	c = Pseq([40,38,45,47],inf).asStream; // root midi notes
	e = Pseq([0.825,0.375,0.25,0.25],inf).asStream; // note durations
	f = Pseq([1000,1500,2000,2500],inf).asStream; // filter freq value

	0.1.wait;
	z.set(\gate,1);

	//set first root note
	d = c.next;

	8.do{

		// move filter freq once every 4 notes
		z.set(\ffreq, f.next);
		4.do {
			z.set(\gate,1);
			z.set(\freq,(a.next + d).midicps);
			x=[0.451,0.45,0.449].choose;
			x.wait;
			z.set(\gate,0);

			e.next.wait;
		};

		d = c.next;
	};
	2.wait;
	z.free;
};
)



/* 140103_1504 (pluck piece)



by Nathan Thomas

http://www.afternoondust.co.uk



This piece uses code from Bruno Ruviaro (pluck pattern), published on SCCode.org: 

http://sccode.org/1-4Vn



Don't forget to update the path to the audio sample on line 26.



Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License:

http://creativecommons.org/licenses/by-nc-sa/3.0/



*/



(

Server.default = s = Server.internal;

s.options.memSize = 655360;

s.options.sampleRate = 96000.000;

s.options.blockSize = 128;

)



s.boot;



c = Buffer.read(s, "insert/path/to/file/here/leaves_twigs_decode_004_edit.wav");



(

   SynthDef("playamp", { arg krBus;

       var sig, amp, trig, thresh;

       thresh = MouseX.kr((-15),(-60));

       sig = PlayBuf.ar(2,c,0.99,loop:inf);

       amp = Amplitude.kr(sig).ampdb;

       trig = amp >= thresh;

       Out.kr(krBus,trig);

    }).add;



   SynthDef("plucking", {arg amp = 1, freq = 440, decay = 5, coef = 0.1, krBus, outBus=0;

        var env, snd;

        env = EnvGen.kr(Env.linen(0, decay, 0), doneAction: 2);

        snd = Pluck.ar(

            in: Mix.new([WhiteNoise.ar(amp), SinOsc.ar(freq,0,amp)]),

            trig: Gate.ar(Impulse.ar(1),In.kr(krBus,1)),

            maxdelaytime: 0.1,

            delaytime: freq.reciprocal,

            decaytime: decay,

            coef: coef,

            mul: amp);

            Out.ar(outBus, [snd, snd]);

    }).add;



    SynthDef("playbuf", { arg outBus=0;

        var play;

        play = PlayBuf.ar(2,c,loop:inf);

        Out.ar(outBus,play);

    }).add;



    SynthDef("bass", {arg amp = 1, freq = 220, decay = 1, outBus=0;

        var env, snd, pan, env2, splay, phase;

        env = EnvGen.kr(Env.linen(1, decay, 1,1), doneAction: 2);

        phase = Array.fill(4, { do({ [0, 0.5, 0.7, 1].choose }) });

        snd = SinOsc.ar([freq, freq + phase],[0,phase],amp/4).sum * env;

        splay = Splay.ar(snd,0.4);

        Out.ar(outBus, splay);

    }).add;

)



z = Synth(\bass);



// Groups



(

    ~sources = Group.new;

    ~control = Group.after(~sources);

    ~bus1 = Bus.control(s,1);

    ~bus2 = Bus.audio(s,2);

)





x = Synth(\playamp,[\krBus,~bus1],~control); y = Synth(\playbuf);



// Pluck

(

    var dur;

    dur = Prand([0.2, 0.4, 0.8], inf);



    a = Pbind(

        \instrument, "plucking",

        \krBus, ~bus1,

        \scale, Scale.dorian,

        \degree, Prand([8, 17, 9, 7, 15, 12, 13, 1, 5, 14], inf),

        \coef, dur,

        \dur, dur,

        \amp, Pwhite(0.3, 0.6),

        \decay, 3

   ).play;

)



// bass



(

    b = Task({

    var delta, dur, note; 

    dur = Prand([10, 15], inf).asStream;

    note = Pwrand([145, 290], [0.8,0.2], inf).asStream;



    while {

            delta = dur.next;

            delta.notNil

        } {

            Synth(\bass,[freq: note.next,decay:4]);

            delta.yield;

        }

    }).play(quant:TempoClock.default.beats+1.0);

)





a.stop;

b.stop;

x.free;

y.free;

~sources.free;~effects.free;~bus1.free;



s.boot



//////////////////
// Ducking example
///////////////////

// Compander with
// low threshold (like 0.01)
// slopeBelow: leave at 1 (default)
// slopeAbove: small value (means input signal will be attenuated a LOT when control kicks in)
// clampTime and releaseTime: small (e.g., 0.1)
// but release time can be a bit more


/////////////////////////
// Kick and Low Synth Bass
/////////////////////////

(
Ndef(\plop,{
    var in, snd, control ;
    in = LPF.ar(Saw.ar(90*[0.990,1,1.0001]), 5500);
    control = Ringz.ar(
        in: LPF.ar(
            in: Impulse.ar(MouseY.kr(0,8).round(1)),
            freq: 30),
        freq: 30,
        decaytime: 0.15,
        mul: 7).tanh.sin*2;
    snd = Compander.ar(
        in: in,
        control: control,
        //thresh: 0.01,
        thresh: MouseX.kr(0.001,0.3),
        slopeBelow: 1,
        slopeAbove: 0.1,
        clampTime: 0.01,
        // longer release
        relaxTime: 0.1
    );
    Splay.ar([snd, control, snd])
}).play;
)



(

SynthDef(\aSynth, { |rel = 0, choose = 0, amp = 0|

    var klank, env;



    klank = Klank.ar(`[choose ! 12, {Rand(0.128, 0.7)} ! 12], BrownNoise.ar(0.7));

    env   = EnvGen.kr(Env.perc(0.01, rel), doneAction: 2);

    Out.ar(0, klank * env.dup * amp);

}).add;

)



(

{

    42.do{

        x = [70, 90, 120].choose;

        y = rrand(0.01, 5);

        // attack

        Synth(\aSynth, [\rel, y, \choose, x, \amp, 128e-6]);

        // resonance

        Synth(\aSynth, [\rel, 1, \choose, x, \amp, 128e-5]);

        y.wait;

    }

}.fork;

)
