~name = \1;

{ SinOsc.ar(400) }.play

// END


(
SynthDef(\singrains,
	{
		arg pan=0,freq=440,mul=0.5,amp=0.1,dur=0.6,effectBus;
		var sig, env;
		sig=SinOsc.ar(freq,0,mul);
		env=EnvGen.kr(Env.perc(0.01,dur),doneAction:2);
		Out.ar(0,Pan2.ar(sig*env,pan)*amp);
		Out.ar(effectBus,sig*env*amp);
	}
).add;

SynthDef(\reverb,
	{
		arg inBus,pan;
		var input;
		input=In.ar(inBus,1);
		Out.ar(0,Pan2.ar(Mix.ar(GVerb.ar(input,100,revtime:4)),pan)*0.2);
	}
).add;
b=Bus.audio(s,1);
)

//singrains, die immer schneller werden
(
{
	x=Synth(\reverb,[\inBus,b]);
	2000.do{
		arg i;
		var val,valrand,panRand=1.0.rand2;
		val=((i%2000/2000*(-1)+1)**10*2).max(0.02);
		valrand=val+((((i%2000/2000)*(-1)+1)**10)).rand2;
		valrand=val.min(valrand);
		Synth.before(
			x,
			\singrains,
			[\freq,1800.0.rand+200,\pan,panRand,\mul,0.9.rand+0.1,\dur,valrand*1.4,\effectBus,b]
		);
		x.set(\pan,panRand);
		valrand.wait;
	}
}.fork;
)




(
var out, mod_index = 1;
n = 512;
a = Array.fill(n, { |i| i * 2pi/n });  // linear advancing phase
m = sin(a);  // modulator
p = a + (m * mod_index);  // modulated phase input
c = sin(p);  // carrier
out = [a, m, p, c];
out.lace(out.size * n).plot(numChannels: out.size);
)
