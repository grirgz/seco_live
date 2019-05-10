//use samples to granulate
~sample1=Buffer.readChannel(s,"C:/Users/Public/EssaiSupercollider/SamplesPiecesMonnaie/sample1.wav",channels:0);
~sample2=Buffer.readChannel(s,"C:/Users/Public/EssaiSupercollider/SamplesPiecesMonnaie/sample2.wav",channels:0);
~sample3=Buffer.readChannel(s,"C:/Users/Public/EssaiSupercollider/SamplesPiecesMonnaie/sample3.wav",channels:0);
~sample2.play(loop:true)

(
SynthDef(\essai,{
	arg gate=1,amp=0.1,pan=0,freq=440,out;
	var sig,env,trig;
	trig=Impulse.ar(freq);
	sig=PlayBuf.ar(1,~sample2,freq,trig,loop:0);
	env=Env.adsr.ar(doneAction:2,gate:gate);
	Out.ar(out,Pan2.ar(sig*env*amp,pan));
}).add;
)

(
SynthDef(\essai,{
	arg gate=1,amp=1,pan=0,freq=440,out,dur;
	var sig,env,trig;
	trig=Impulse.ar(freq);
	//sig=TGrains.ar(2,trig,~sample1,freq,dur:1/freq,amp:1);
	sig=GrainBuf.ar(2,trig,BufDur.kr(~sample1)/freq,~sample1,freq,pos:0,pan:0);
	env=Env.adsr.ar(doneAction:2,gate:gate);
	Out.ar(out,Pan2.ar(sig*env*amp,pan));
}).add;
)


(
SynthDef(\micromelody,{
	arg rate=1,gate=1,durGrain=1, attackTime=0.01, decayTime=0.3, sustainLevel=0.5,fadeTime=1,rangeChorus=1.02,rangeChorusBis=1.02,out=0,amp=1;
	var env,chorus,chorusbis,filtermod,source,snd,sig,trigGrain,pitchGrain,freq,impulse;
	impulse=Impulse.ar(rate);
	freq=Demand.ar(impulse,0,Dseq(([[0,2,4],[2,4,6],[2,4,7],[4,6,8],[-1,0,2],[2,4,5]].degreeToKey([0,2,4,5,7,9,11])+60).midicps,inf));

	chorus = freq.lag(2)*LFNoise1.kr([0.4, 0.5, 0.7, 1, 2, 5, 10]).range(1,rangeChorus);
	chorusbis = freq.lag(2)*LFNoise1.kr([0.4, 0.5, 0.7, 1, 2, 5, 10]).range(1,rangeChorusBis);
	env=Env.adsr(attackTime:attackTime,decayTime:decayTime,sustainLevel:sustainLevel,releaseTime:fadeTime).ar(doneAction:2,gate:gate);
	source=AY.ar(tonea: AY.freqtotone(chorus),toneb: AY.freqtotone(chorusbis),mul:0.5);
	filtermod = SinOsc.kr(1/16).range(1, 10);
	snd = LPF.ar(in: source, freq: freq*filtermod);
	snd = Resonz.ar(in: snd,freq: freq,bwr: Rand(2.0,10.0));
	trigGrain=impulse;
	sig=GrainIn.ar(2,trigGrain,durGrain,snd);
	Out.ar(out,Pan2.ar(sig,0));

}).add;
)


a=Synth(\essai)
TempoClock.tempo=1
Pdef(\essai,Pbind(\instrument,\essai,\degree,Pseq([[0,2,4],[2,4,6],[2,4,7],[4,6,8],[-1,0,2],[2,4,5]],inf),\dur,1,\amp,10,\octave,3))
Pdef(\essai,Pmono(\essai,\degree,Pseq([[0,2,4],[2,4,6],[2,4,7],[4,6,8],[-1,0,2],[2,4,5]],inf),\dur,0.1,\amp,1,\octave,5))

Pbind(\instrument,\micromelody,\rate,1).play
a=Synth(\micromelody)
a.set(\rate,100)
a.set(\durGrain,0.01)

Pmono(\micromelody,\rate,Pseq(((0..7).degreeToKey([0,2,4,5,7,9,11])+84).midicps,inf),\durGrain,1/Pkey(\rate)).trace(\durGrain).play

Pdef(\essai).play




/********************** MICRO-RYTHMES ******************************/
//use drum samples
(
~kick=Buffer.readChannel(s,"C:/Users/Public/EssaiSupercollider/Drums/SD01.WAV",channels:0);
~claps=Buffer.readChannel(s,"C:/Users/Public/EssaiSupercollider/Drums/CLAPS.WAV",channels:0);
~closeHat=Buffer.readChannel(s,"C:/Users/Public/EssaiSupercollider/Drums/CLHAT1.WAV",channels:0);
~openHat=Buffer.readChannel(s,"C:/Users/Public/EssaiSupercollider/Drums/OPHAT1.WAV",channels:0);
)
(
SynthDef(\microRythmKick,{
	arg rate=1,rateGrain=1;
	var impulse,claps,trig;
	impulse=Impulse.ar(rate);
	trig=Demand.ar(impulse,0,Dseq([1,0,0,0],inf));
	claps=GrainBuf.ar(2,trig,BufDur.kr(~claps),~claps,rateGrain);
	Out.ar(0,claps)
}).add;

SynthDef(\microRythmCloseHat,{
	arg rate=1,rateGrain=1;
	var impulse,claps,trig;
	impulse=Impulse.ar(rate);
	trig=Demand.ar(impulse,0,Dseq([0,1,0,1],inf));
	claps=GrainBuf.ar(2,trig,BufDur.kr(~closeHat),~closeHat,rateGrain);
	Out.ar(0,claps)
}).add;

SynthDef(\microRythmOpenHat,{
	arg rate=1,rateGrain=1;
	var impulse,claps,trig;
	impulse=Impulse.ar(rate);
	trig=Demand.ar(impulse,0,Dseq([0,1,0,1],inf));
	claps=GrainBuf.ar(2,trig,BufDur.kr(~openHat),~openHat,rateGrain);
	Out.ar(0,claps)
}).add;



)


a=Synth(\microRythmKick)
a.set(\rate,10)
a.set(\rateGrain,10)
(
{
	a=Synth(\microRythmKick,[\rate,10,\rateGrain,20]);
	b=Synth(\microRythmCloseHat,[\rate,10,\rateGrain,20]);
	0.01.wait;
	"part1".postln;
	c=Synth(\microRythmOpenHat,[\rate,10,\rateGrain,20]);
	10.wait;
	"part2".postln;
	a.set(\rateGrain,1);
	b.set(\rateGrain,1);
	10.wait;
	"part3".postln;
	b.set(\rate,1);
	c.set(\rateGrain,1);
	2.wait;
	"part4".postln;
	a.set(\rateGrain,10);
	b.set(\rateGrain,10);
	5.wait;
	"part5".postln;
	c.set(\rateGrain,10);
	a.set(\rate,5);
	c.set(\rate,5);
	10.wait;
	"part6".postln;
	a.set(\rateGrain,1);
	b.set(\rateGrain,1);
	c.set(\rateGrain,1);
	10.wait;
	"part7 et fin".postln;
	d=Synth(\microRythmKick,[\rate,5,\rateGrain,1]);
	e=Synth(\microRythmCloseHat,[\rate,5,\rateGrain,1]);
	f=Synth(\microRythmOpenHat,[\rate,5,\rateGrain,10]);
	a.set(\rateGrain,0.1);
	b.set(\rateGrain,0.1);
	c.set(\rateGrain,0.1);
	a.set(\rate,10);
	b.set(\rate,10);
	c.set(\rate,10);

}.fork;
)

a.free
b.free
c.free
d.free
e.free
