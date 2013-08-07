
(
SynthDef(\plop, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
)


(
SynthDef(\noisecomb3, { arg out, gate=1, pan=0, freq=300, amp=0.1, noiselevel=0.2,
		minfreq=100, decaytime=1, doneAction=2, ffreq=500, rq=0.3, spread=0.8,
		noisemin=0.4,noisemax=1.2, sawfreq=50, sawlevel=1;
	var sig, env;
	freq = EnvGen.ar(Env.perc(0.1,0.1),gate,doneAction:0) * 0.5 + 0.5 * freq;
	sig = WhiteNoise.ar(noiselevel);
	sig = sig + ClipNoise.ar(noiselevel);
	sig = sig + LFSaw.ar(sawfreq * \sawfreqtab.kr(1!10)* sawlevel);
	sig = sig + AllpassC.ar(sig, 1/minfreq, 1/freq, decaytime);
	sig = RLPF.ar(sig, ffreq * \ffreqtab.kr(1!10) * LFNoise1.ar(\ffreqnoise.kr([0.82,0.44,0.2,3.2,1.25])).range(noisemin,noisemax), rq);
	sig = (sig*10).tanh/5;
	env = EnvGen.kr(\adsr.kr(Env.adsr(0.6,0.1,0.8,0.1)), gate, doneAction:doneAction);
	sig = sig * env;
	sig = Splay.ar(sig, spread, 1, pan);
	sig = sig * amp;
	Out.ar(out, sig);
}).store;
)

(
Pdef(\plop, Pbind(
	\instrument, \noisecomb3,
	\freq, Pn(Pseries(Pwhite(50,50,inf).asStream,Prand([1,-1,-10,10],inf).asStream,10)) + Prand([-50,20,50,1300],inf) / 8,
	\freq, Pseq([100,50,60],inf),
	\ffreqtab, Pfunc {  [[0.1,0.1,1.1,2.3,4.2]] * rrand(0.1,2) },
	\ffreqnoise, Pfunc {  [[7.1,0.1,1.1,2.3,4.2]] * rrand(0.1,2) },
	\sawfreq, Pseq([50,70,60,Prand([200,100,50],inf)],inf),
	\sawfreq, Pkey(\freq),
	\sawfreqtab, Pfunc {  [[7.1,0.1,1.1,2.3,4.2]] * rrand(0.1,2) },
	\sawlevel, Prand([0.1,0.5,1,0.2],inf),
	\dur, Prand([0.5,0.25,1,0.125,Pseq([0.1,0.1,0.1,0.1,1])],inf),
	\dur, Pseq([Pn(0.05,8*8-1),1],inf),
	\dur, Pseq([0.4],inf),
	\legato, Pseq([0.5,1,1.5,1.1],inf),
	\amp, 0.3
)).play;
);


(
SynthDef(\hoo, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, spread=0.8, mix=0.5, ffreq=500;
	var sig, sig2;
	sig = LFSaw.ar(freq * \freqtab.kr(1!10));
	sig2 = RLPF.ar(sig, ffreq * \ffreqtab.kr(1!10), 0.5);
	sig = SelectX.ar(mix, [sig, sig2]);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
)

(
Pdef(\hoo, Pbind(
	\instrument, \hoo,
	\rh, Pseq([1,1,0,1, 1,1,0,0],inf),
	\rh, Pseq([1,1,1,1, 1,1,1,1],inf),
	\rh, Pseq([1,0,1,0, 1,0,1,1],inf),
	\freq, Pn(Pwhite(50,90,8)) * Pkey(\rh),
	\mix, Pseq([0.2,0.5,0.8],inf),
	\mix, 0.81,
	\octave, 3,
	\freqtab, Pfunc {  [[1.1,0.1,1.1,2.3, 4.2, 0.5,0.54,0.65]] * rrand(0.1,2) },
	\ffreqtab, Pfunc {  [[1.1,0.1,1.1,2.3, 4.2, 0.5,0.54,0.65]] * rrand(0.1,2) },
	\dur, 0.1,
	\legato, Pn(Prand([0.8,1.2,0.5],4)),
	\amp, 0.1
)).play;
);



Pdef(\hoo).quant=1

(
SynthDef(\rii, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, time=0.05, spread=0.9, minfreq=50, ffreq=500;
	var sig;
	freq = EnvGen.ar(Env([1,0.5,0,0.5], [time,0.1,0.01]),gate,doneAction:2).range(minfreq, freq) ;
	sig = LFSaw.ar(freq * \freqtab.kr(1!10));
	sig = RLPF.ar(sig, ffreq * \ffreqtab.kr(1!10), 0.5);
	sig = (sig*30).tanh/2;
	sig = sig * EnvGen.ar(Env.adsr(0.001,0.1,0.1,0.1),gate,doneAction:2);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
)

(
Pdef(\rii, Pbind(
	\instrument, \rii,
	\rh, Pseq([1,0,1,0, 1,0,1,1],inf),
	\freq, Pn(Pwhite(50,90,8)) * Pkey(\rh),
	\ffreq, Pseq([500,5000],inf),
	\freqtab, Pfunc {  [[0.5,0.5,1.1,0.3, 4.2, 0.5,0.54,0.65]] * rrand(0.1,1) },
	\time, Pseq([0.1,0.05,1,0.2],inf),
	\dur, 0.1,
	\dur, 0.2 * 8,
	\amp, 0.081
)).play;
);


(
SynthDef(\boo, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, spread=0.1, ffreq=500;
	var sig, env;
	env = EnvGen.ar(\env.kr(Env([1,0.2,0.6],[0.2,1])),gate,doneAction:2);
	sig = LFSaw.ar(freq * env);
	sig = RLPF.ar(sig, ffreq * \ffreqtab.kr(1!10), 0.5);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
)

(
Pdef(\boo1, Pbind(
	\instrument, \boo,
	\freq, 150,
	\freq, Pwhite(50,750,inf),
	\env, Pn(Plazy{
		Pseq([
			[
				Env([1,0.2,0.6],[0.2,0.1]),
				Env([0.1,0.2,0.6],[0.5,1]),
				Env([0.5,0.2,0.6],[0.2,1]),
			],
			[
				Env([0.1,1,0.6],[2,0.1]),
				Env([0.1,0.2,0.6],[0.5,1]),
				Env([0.5,0.2,0.6],[0.2,1]),
			],
		],inf);
	}),
	\ffreqtab, Pfunc {  [[1.1,0.1,1.1,2.3, 4.2, 0.5,0.54,0.65]] * rrand(0.1,2) },
	\dur, 1/2,
	\amp, 0.06
)).play;
);

~np = NodeProxy.control

(
~np.source = {
	LFNoise0.kr(2.2) * 200 + 50
}
)

(
	~np.source = Pbind(
		\instrument, \mylfo,
		\freq, Pseq([1,4,0.1],inf),
		\legato, 1,
		\dur, Pseq([0.1,0.5,4],inf)
		
	)
)

Pdef(\boo1).set(\ffreq, ~np)


(
SynthDef(\mylfo, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, range=1, offset=100;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig.range(-300,-50);
	sig.poll;
	//sig.poll;
	sig = sig * EnvGen.ar(Env.adsr(0.1,0.1,1,0.1),gate,doneAction:2);
	Out.kr(out, sig);
}).add;
)

(
Pdef(\plop6, Pbind(
	\instrument, \osc1,
	\degree, Pseq([0,2,4, 1,3,5, 2,1],inf),
	\scale, Scale.minor,
	\dur, 1/2,
	\amp, 0.7
)).play;
);
Pdef(\plop6).free

Pdef(\plop6).set(\ffreq, ~mod)
Pdef(\plop6).set(\ffreq, 200)
~mod = NodeProxy.control
~mod.awake= false
(

~mod.source = Pbind(
	\instrument, \mylfo,
	\freq, Pseq([8,14],inf),
	\dur, 2,
	//\out, ~bus,
	\amp, 0.1
);
)


(
SynthDef(\plop, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, ffreq=550, mffreq=5;
	var sig;
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, LFSaw.ar(mffreq).range(50,ffreq), 0.5);
	sig = Decimator.ar
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
)

(
Pdef(\plop, Pbind(
	\instrument, \plop,
	\ffreq, -44444150,
	\mffreq, -4,
	\degree, Pseq([0],inf),
	\dur, 1,
	\amp, 0.1
)).play;
);


{Perlin3.ar(Integrator.ar(K2A.ar(SinOsc.ar(12))), Integrator.ar(K2A.ar(LFNoise1.ar(02).range(0.1,2))))}.play(s)

{Perlin3.ar(*{Line.ar(0, 1000, 30)}.dup(3))}.plot(1)



//random instruction sets
(
a=Array.fill(50,{arg i; if(i.even,{7.rand},{1.0.rand})});
b=Buffer.sendCollection(s, a, 1);
)
//could be very loud! CAREFUL
{Out.ar(0,Pan2.ar(0.5*Instruction.ar(b.bufnum),0.0))}.play

(
a=Array.fill(50,{arg i; if(i.even,{7.rand},{1.0.rand})});
Post << a << nl;  //in case you like one
b.sendCollection(a);
)


(
t=Task({

inf.do {

a=Array.fill(50,{arg i; if(i.even,{7.rand},{1.0.rand})});
b.sendCollection(a);

exprand(0.05,1).wait;
}

}
).play;
)

t.stop;


//more considerate construction of instruction sets

(
a= Array.fill(40,{arg i; if(i.odd,{if(0.6.coin,{[0,exprand(0.005,0.05)]}, {[8,rrand(0.1,1.0),9,2*rrand(0,12)]})},{[rrand(1,6),[exprand(0.1,1.0),rrand(0.1,1.0),exprand(0.01,0.2)].choose]}); }).flatten;
Post << a << nl;
b=Buffer.sendCollection(s, a, 1);
)

//could be very loud! CAREFUL
{Out.ar(0,Pan2.ar(0.5*Instruction.ar(b.bufnum),0.0))}.play

(
a= Array.fill(30,{arg i; if(i.odd,{if(0.6.coin,{[0,exprand(0.005,0.05)]}, {[8,rrand(0.1,1.0),9,2*rrand(0,12)]})},{[rrand(1,6),[exprand(0.1,1.0),rrand(0.1,1.0),exprand(0.01,0.2)].choose]}); }).flatten.postln;
Post << a << nl;
b.sendCollection(a);
)


{Out.ar(0,Pan2.ar(0.5*FreeVerb.ar(Resonz.ar(Instruction.ar(b.bufnum),MouseX.kr(1000,5000,'exponential'),MouseY.kr(0.01,1.0,'exponential'))),0.0))}.play


//discovered sounds
(
a=[ 2, 0.98085289001465, 0, 0.0098705891385231, 3, 0.045249921951092, 8, 0.426873087883, 9, 12, 6, 0.042719216229536, 8, 0.38374520540237, 9, 22, 6, 0.040797999461159, 8, 0.71095678806305, 9, 8, 2, 0.18426358043098, 8, 0.96414197683334, 9, 10, 2, 0.064978396873361, 0, 0.014289879691635, 5, 0.015798983078423, 0, 0.038866613949307, 6, 0.030472403359923, 0, 0.036071279863708, 1, 0.046212260612025, 8, 0.610464823246, 9, 0, 1, 0.96948568820953, 0, 0.014026194255798, 3, 0.12740938462649, 0, 0.010742629527544, 1, 0.3477209756392, 8, 0.82419589757919, 9, 18, 6, 0.97822250127792, 0, 0.0073386436293812, 4, 0.1197158617971, 8, 0.37467901706696, 9, 20, 6, 0.023095168080617, 0, 0.0077425603088712 ];
b.sendCollection(a);
)


(
a=[ 3, 0.40293287038803, 0, 0.0099009671713598, 2, 0.1265909910202, 0, 0.013731463839874, 3, 0.23790548574176, 0, 0.0077773798350805, 3, 0.15899796225456, 8, 0.88809416294098, 9, 14, 2, 0.16874264604912, 0, 0.0054302242992324, 2, 0.065863798551897, 8, 0.31685080528259, 9, 6, 1, 0.025768143119174, 0, 0.022224710655753, 1, 0.021351216507072, 8, 0.45115448236465, 9, 24, 2, 0.91734998226166, 0, 0.0085382244719742, 1, 0.1098612352863, 0, 0.005935074104977, 5, 0.40578903363382, 8, 0.11921266317368, 9, 2, 6, 0.11252887270072, 0, 0.0066305213330409, 4, 0.51733835087186, 8, 0.78307151794434, 9, 14, 3, 0.86774248188551, 8, 0.54493169784546, 9, 4, 4, 0.46118148424678, 8, 0.21504091024399, 9, 4];
b.sendCollection(a);
)
$



//Can be very noisy, high pitched and aliases badly- ie great fun, but watch out for your ears, filter, try out odd param settings. I've turned all the amplitudes down in the following


//defaults, high pitched! WARNING
{Out.ar(0,Pan2.ar(0.1*WeaklyNonlinear2.ar(SinOsc.ar(MouseX.kr(100,400),0,0.1)),0.0))}.play


{Out.ar(0,Pan2.ar(0.1*WeaklyNonlinear2.ar(SinOsc.ar(MouseX.kr(50,1000,'exponential'),0,0.1),0,1,1,MouseY.kr(50,1000,'exponential')),0.0))}.play


//with reset
{Out.ar(0,Pan2.ar(0.1*WeaklyNonlinear2.ar(SinOsc.ar(MouseX.kr(10,1000,'exponential'),0,0.1),Impulse.kr(3),1,1,MouseY.kr(10,1000,'exponential'), LFNoise0.kr(1,0.4,0.5),LFNoise0.kr(1,10.4,10.5)),0.0))}.play


//MouseY controls input strength of forcing oscillator
{Out.ar(0,Pan2.ar(0.1*WeaklyNonlinear2.ar(Saw.ar(261.626,MouseY.kr(0.0001,1,'exponential')), freq:MouseX.kr(100,400)),0.0))}.play



//2 per second
(
{Out.ar(0,Pan2.ar(

CombN.ar(
Resonz.ar(WeaklyNonlinear2.ar(Saw.ar(MouseX.kr(50,2000,'exponential'),0.5),0,1,1,MouseY.kr(100,4000,'exponential')),1000,0.1),
0.05,0.05,1
)
,0.0))}.play
)


//with non zero nonlinear term, van der Pol equation, acts to damp, so a rest is needed to hear many sounds
{Out.ar(0,Pan2.ar(0.1*WeaklyNonlinear2.ar(SinOsc.ar(MouseX.kr(10,2000),0,0.1),Impulse.kr(MouseY.kr(0,100)),1,1,440,0,0,-0.01,2,-1,1),0.0))}.play

//Duffing equation
{Out.ar(0,Pan2.ar(0.1*WeaklyNonlinear2.ar(SinOsc.ar(MouseX.kr(1,1000,'exponential'),0,0.1),0,1,1,MouseY.kr(1,1000,'exponential'),0,0,-0.001,3,0,0),0.0))}.play


//make one up... will last for a while then be lost- needs a Trigger control in reset, very aliased
{Out.ar(0,Pan2.ar(0.1*WeaklyNonlinear2.ar(SinOsc.ar(MouseX.kr(1,100,'exponential'),0,0.1),Impulse.kr(0.5),1,1,MouseY.kr(1,1000,'exponential'),LFNoise0.kr(10,0.0),LFNoise0.kr(10,0.0),0.005,3,1,0.5),0.0))}.play


{Out.ar(0,Pan2.ar(0.1*WeaklyNonlinear2.ar(SinOsc.ar(0,0,0.1),0,1,1,MouseX.kr(110,880,'exponential'),0,0,MouseY.kr(0,1.0)),0.0))}.play


//noisy stereo wall
{Out.ar(0,CombN.ar(LPF.ar(0.1*WeaklyNonlinear2.ar(LFSaw.ar(MouseX.kr(100,[400,405]),0,0.1),freq:[330,440], alpha:MouseY.kr(0,[0.1,0.5])),10000),0.02,0.02,5))}.play



//hits fixed points too quickly
{Out.ar(0,Pan2.ar(0.1*Oregonator.ar(Impulse.kr(10),MouseX.kr(0.01,1,'exponential')),0.0))}.play


{Out.ar(0,Oregonator.ar(Impulse.kr(100),0.1, 0.1, 0.5, 0.2,initx:0.1, inity:-0.5, initz:0.7))}.plot(0.1)


{Out.ar(0,Pan2.ar(0.1*Oregonator.ar(Impulse.kr(100),0.1, 0.1, 0.5, 0.2,initx:0.1, inity:-0.5, initz:MouseX.kr)[0],0.0))}.play


{Out.ar(0,Pan2.ar(0.1*Oregonator.ar(Impulse.kr(MouseX.kr(100,1000)),0.1, 0.2, 0.5, 0.2,initx:MouseY.kr, inity:-0.5, initz:0.5)[0],0.0))}.play


{Out.ar(0,Pan2.ar(0.1*Oregonator.ar(Impulse.kr(MouseX.kr(10,1000,'exponential')),0.3, 0.1,0.1, 0.2,initx:MouseY.kr(0.1,1.0), inity:-0.5, initz:0.5)[0],0.0))}.play


{Out.ar(0,Pan2.ar(0.1*Oregonator.ar(Impulse.kr(MouseX.kr(100,1000)),0.1, 0.2, 0.5, 0.2,initx:MouseY.kr, inity:-0.5, initz:0.5)[1],0.0))}.play


{Out.ar(0,Pan2.ar(0.1*Mix(Oregonator.ar(Impulse.kr(MouseX.kr(10,1000)),0.1, 0.2, 0.5, 0.2,initx:MouseY.kr, inity:-0.5, initz:0.5)),0.0))}.play



//duration in samples

(60/183)*0.25*44100

b = Buffer.alloc(s,44100);

(
~breakfilenames= Array.fill(9,{arg i; var str;
str=("sounds/SCsamp/breaks/hiphop/hop"++(i+1).asString);

if((i==3) || (i==5),{str=str++".aif"});
str
});

~breakbeatlengths= [4,4,8,4,8,4,4,8,8];

~breaks= Array.fill(~breakbeatlengths.size,{arg i; Buffer.read(s,~breakfilenames[i])});
)

(
SynthDef("help-Breakcore",{ arg out=0, bufnum=0, target=0;
var playbuf;

playbuf=PlayBuf.ar(1,target, loop:1);

    Out.ar(out,
        Breakcore.ar(bufnum, playbuf, Impulse.kr(4),5512,0)*Line.kr(1,0,10,doneAction:2)
    )
}).play(s,[\bufnum,b.bufnum,\target,~breaks[0].bufnum]);
)


(
SynthDef("help-Breakcore",{ arg out=0, bufnum;

    Out.ar(out,
        Breakcore.ar(bufnum, In.ar(8)*0.3, Impulse.kr(4),5512,0)*Line.kr(1,0,10,doneAction:2)
    )
}).play(s,[\bufnum,b.bufnum]);
)


(
SynthDef("help-Breakcore",{ arg out=0, bufnum=0, target=0;
var playbuf;

playbuf=PlayBuf.ar(1,target,MouseX.kr(1,2), loop:1);
//AudioIn.ar(1,0.1)
    Out.ar(out,
        Breakcore.ar(bufnum,playbuf , Impulse.kr(LFNoise0.kr(4,10,12)),LFNoise0.kr(8,1900,2000),0)    )
}).play(s,[\bufnum,b.bufnum, \target, ~breaks[2].bufnum]);
)



(60/180)*44100*0.25


3614/4


{Disintegrator.ar(LFSaw.ar([400, 404], 0, 0.2), MouseX.kr(0, 1), MouseY.kr(0, 1))}.play

{Disintegrator.ar(SoundIn.ar, MouseX.kr(0, 44100), MouseY.kr(0, 1))}.play




