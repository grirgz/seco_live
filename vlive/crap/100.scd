// Rumush

// https://mycelialcordsblog.wordpress.com/

// https://fungorumush.bandcamp.com/releases



(

fork{

var pFreq = [108, 128, 132, 144, 162, 180, 192, 204,

216, 240, 264, 288, 324, 360, 384, 408,

432, 480, 528, 576, 648, 720, 768, 816,

864, 960, 1056, 1152, 1296, 1440, 1536, 1632,

1728, 1920, 2112, 2304, 2592, 2880, 3072, 3264

];

var rep = 0;

var t = 30;

var speed = 10;

var modF = 4;

var arrayI = 31;

n = 2;

loop{

// Value Checkers

if(rep >= 8,

{ t = 150 },

{ t = [20,30].choose }

);

if(arrayI < 0,

{arrayI = 0}

);

// Structure Info

//(„rep”+rep).postln;
//
//(„t”+t).postln;
//
//(„speed”+speed).postln;
//
//(„modF”+modF).postln;
//
//(„n”+n).postln;
//
//(„arrayI”+arrayI).postln;

play{

// Sine Envelope

var env1 = EnvGen.ar(Env.sine(90, 1), doneAction:2);



// Doppler Effect

var src1 = Mix.fill(8,{

var x, y, distance, velocity, pitchRatio, amplitude, azimuth, panValue, sound, index;

index = Array.series(7, 8, 1);

x = 50.rand;

y = LFSaw.kr(1/IRand(speed, speed*3), 0, 100);

distance = hypot(x, y);

velocity = Slope.kr(distance);

pitchRatio = (344 - velocity) / 344;

amplitude = 2.5 / distance.squared;

sound = if(0.6.coin,

{Saw.ar(pFreq[index.choose] * pitchRatio, 1)},

{Saw.ar(pFreq[index.choose] * pitchRatio, LFPulse.ar(IRand(1, speed)))}

);

azimuth = atan2(y, x);

panValue = (azimuth / 0.5pi).clip2(1);

Pan2.ar(sound, [panValue, panValue.neg].choose, amplitude)

});



// Noise

var src2 = Mix.fill(n,{

var index = Array.series(8, arrayI, 1);

var fm = Pan2.ar(SinOsc.ar(pFreq.choose+SinOsc.ar(pFreq[index.choose]/IRand(2, modF), 0, 100000), 0, 1/64*LFSaw.ar(1/IRand(speed/2, speed*2)).linexp(-1, 1, 0.01, 1)), 0.9*SinOsc.ar(4/IRand(speed/2, speed*2)));

var noise = Pan2.ar(BPF.ar(PinkNoise.ar(1), pFreq[index.choose]+SinOsc.ar(1.rand, 0, 108), Rand(0.05, 0.25)), 0.9*SinOsc.ar(1/IRand(speed/2, speed*2)));



fm+noise

});



// Structure Progression

rep = rep+1;

speed = speed-1;

modF = modF*2;

n = n+2;

arrayI = arrayI-4;



// Output

(((src1)+(src2*(1/2)))*(0+env1))

};t.wait

}

}

)




(
// Original – Inspiration
play{
b=LocalBuf(1e5,2).clear;
x=BufRd.ar(2,b,Phasor.ar(0,1,0,1e5))*0.6;
BufWr.ar(Blip.ar([1,1.01],10)/5+x,b,LFNoise1.ar(0.2)+1*5e4);
x
}
)

(// Glitch Pitch
play{
var env = XLine.ar(0.5, 20, 60, doneAction:2);
b=LocalBuf(1e5,2).clear;
x=BufRd.ar(2,b,Phasor.ar(0,1,0,1e5))*0.6;
BufWr.ar(Blip.ar([1,1.01]*env,10)/5+x,b,Lag.ar(LFNoise0.ar(1*env)+1*5e4, 0.25));
x
}
)

(// Simple Sine Glitch
play{
var seq = Demand.ar(Impulse.ar(0.25), 0, Dseq([[0, 1e5, 1000], [1e5, 0, 2000]], inf));
b=LocalBuf(1e5,2).clear;
x=BufRd.ar(2,b,Phasor.ar(0,1,seq[0],seq[1]))*0.6;
r=LFNoise0.ar(0.01).unipolar;
BufWr.ar(SinOsc.ar(seq[2], 0, Decay.ar(Impulse.ar(0.125), 2, 0.5))+x,b,LFNoise1.ar(0.5+LFPulse.ar([0.0125, 0.013], 0, 0.9, 0.01))+1*5e4);
(x).tanh
}
)

(// Glitch Textures
play{
var pul = XLine.ar(1, 240, 240, doneAction:2)*(LFSaw.ar([2, 2.01])+1).round(0.25);
var tr = { arg rt=2, ph=0; Impulse.ar(rt, ph) };
var blip = Blip.ar(600, 4, 0.25);
var tone = SinOsc.ar(LFNoise0.ar(1*2).range(240, 480)+(blip*LFPulse.ar(1/4, mul:150)), 0, Decay2.ar(tr.(pul/4, 0.5), 1, 0.125));
p=TChoose.ar(tr.(1/4),[LFNoise1.ar(1)+1*2e5,LFNoise1.ar(1/2)+1*2e5]);
b=LocalBuf(4e5,2).clear;
x=BufRd.ar(2,b,Phasor.ar(0,1,0,4e5))*0.125;
BufWr.ar(blip+tone+x,b,p)*0.125;
(x).tanh
}
)

(// Gitch + Bluesy chords – Goes quite crazy after a while
play{
var src1, src2, src3, buf1, buf2;
var seq = Duty.ar(Dseq([0.25, 0.5], inf), 0, Dseq([40,64,65,66,59,62,69].midicps, inf));
buf1=LocalBuf(1e5,2).clear;
buf2=LocalBuf(1e5,2).clear;
src1=BufRd.ar(2,buf1,Phasor.ar(0,0.25,LFNoise0.ar(0.5, 1e5/8),1e5))*0.75;
src2=CombC.ar(src1*Decay.ar(Impulse.ar(0.8, 0.76), LFNoise1.ar(0.2)+1), 0.25, 0.25, 5);
src3=BufRd.ar(2,buf2,LFNoise1.ar(0.25)+1*1e5)*0.75;
BufWr.ar(Blip.ar([5, 6], 10)+src3,buf2,LFNoise1.ar(0.1)+1*5e4);
BufWr.ar(Saw.ar([seq*0.25, seq*0.251]+Crackle.ar(LFNoise1.ar(5).range(1.75, 1.99), 10))+src1,buf1,LFNoise1.ar(0.2)+1*5e4);

(src1+src2+src3)*0.25
}
)

(
// Original – Inspiration
play{
b=LocalBuf(1e5,2).clear;
x=BufRd.ar(2,b,Phasor.ar(0,1,0,1e5))*0.6;
BufWr.ar(Blip.ar([1,1.01],10)/5+x,b,LFNoise1.ar(0.2)+1*5e4);
x
}
)

Veco.gui



(
f = {
	var rep = [4, 8, 16, 32];
	var n = rep.choose;
	var x = [

	      54, 60, 66, 72, 81, 90, 96, 102,
	      108, 128, 132, 144, 162, 180, 192, 204,
	      216, 240, 264, 288, 324, 360, 384, 408,
	      432, 480, 528, 576, 648, 720, 768, 816,
	      864, 960, 1056, 1152, 1296, 1440, 1536, 1632,
	      1728, 1920, 2112, 2304, 2592, 2880, 3072, 3264,
	      3456, 3840, 4224, 4608, 5184, 5760, 6144, 6528,
	      6912, 7680, 8448, 9216, 10368, 11520, 12288, 528

       ];
	var fac1 = [1,10,100,1000].choose;
	var fac2 = [1,10,100,1000].choose;
	var fac3 = [1,10,100,1000].choose;
	Mix.fill(n,
		{
			var detune = 5.rand;
			var saw;
			var sin;
			detune = XLine.kr(0.1,1+250.0.rand ,2+9.0.rand) * 2.0.rand* [1,-1].choose;
			sin = SinOsc.ar(x.choose * ( 1 + ( SinOsc.ar(x.choose/fac1) * x.choose/fac2 )) + detune, 4.rand, 0.25);
			saw = RLPF.ar(Saw.ar(x.choose*0.01+detune, 0.75), x.choose, 2.rand);
			saw = [
				saw,
				saw.fold2( SinOsc.ar(x.choose/fac3).range(0.1,1) ),
				saw.wrap2( SinOsc.ar(x.choose/fac3).range(0.1,1) ),
				saw *  SinOsc.ar(x.choose/2),
				( saw *  SinOsc.ar(x.choose/fac3).range(1,20) ).tanh/2,
			].choose;
			Pan2.ar((sin+saw) * EnvGen.kr(Env.sine(12, 1/n), 1, doneAction:2),
			1.rand2) 
		}
	);
};
)

(
// DEFINE A ROUTINE
r = Routine({

    inf.do({
		f.play;
        10.wait;
    })
});
)

r.reset.play;



[1,3,4].samples(2)

(
Ndef(\giro, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var tt = 4;
	freq = freq * [0,3,5].midiratio;
	env1 = XLine.kr(1,400,tt);
	env2 = XLine.kr(4,1/4,tt);
	env3 = XLine.kr(1,800/4,tt);
	sig = SinOsc.ar(freq * ( 1 + ( SinOsc.ar(env1 * [1.3,1.2,1]) * env3 )));
	sig = sig.fold2(0.4 * SinOsc.ar(env2 * [1,1.2,1.3]).range(0,4));
	//sig = SinOsc.ar(freq) ;
	sig = Pan2.ar(sig, pan, amp).flop;
}).play;
);

(
Ndef(\giro, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var tt = 10;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env0;
	var pos = \pos.kr(0);
	freq = freq * [0,3,5].midiratio;
	env0 = IEnvGen.kr(Env([-1,1], [1]), pos);
	env1 = env0.range(100,400);
	//env1 = XLine.kr(100,400,tt);
	env2 = env0.range(4,1/4);
	env3 = env0.range(1,800);
	env4 = env0.range(0,1);
	env5 = IEnvGen.kr(Env([-1,0.8,1], [0.9,0.1]), pos).range(0,1);
	sig = SinOsc.ar(freq * ( 1 + ( SinOsc.ar(env1 * [1.3,1.2,1]) * env3 )));
	sig1 = sig.fold2(0.4 * SinOsc.ar(env2 * [1,1.2,1.3]).range(0,4));
	sig = SelectX.ar(env5, [sig, sig1]);
	sig1 = RLPF.ar(sig, \lpf.kr(100) * SinOsc.kr(1/4 * [1,2,4]).range(8,1), \rq.kr(0.5));
	sig = SelectX.ar(env4, [sig, sig1]);
	//sig = SinOsc.ar(freq) ;
	sig = Pan2.ar(sig, pan, amp).flop;
}).play;
);

Ndef(\giro).edit
Ndef(\giro).addSpec(\pos, \unipolar.asSpec)
