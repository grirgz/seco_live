(
SynthDef(\dex11algo3,//op3-->op2-->op1<--op4
	{
		|
		pitch=48,
		op1att=0.001,op1dec=0.4,op1sus=0.01,op1rel=0.1,op1amt=1,op1tune=0,gate=1,
		op2att=0.001,op2dec=3.250,op2sus=0.1,op2rel=0.1,op2amt=4,op2tune=12,
		op3att=0.001,op3dec=0.150,op3sus=0.1,op3rel=0.1,op3amt=2,op3tune=0,
		op4att=0.001,op4dec=1.250,op4sus=0.1,op4rel=0.1,op4amt=2,op4tune=0,feedbackamt=0.5,vol=0.5,out|
		var env1,env2,env3,env4,op1,op2,op3,op4,pan=(0.0),signal;

		env4=EnvGen.ar(Env.adsr(op4att,op4dec,op4sus,op4rel),doneAction:0);
		op4=SinOscFB.ar((pitch+op4tune).midicps,env4*feedbackamt);
		op4=op4*env4;
		op4=op4*op4amt;
		op4;
		env3=EnvGen.ar(Env.adsr(op3att,op3dec,op3sus,op3rel),doneAction:0);
		op3=SinOsc.ar((pitch+op3tune).midicps);
		op3=op3*env3;
		op3=op3*op3amt;
		env2=EnvGen.ar(Env.adsr(op2att,op2dec,op2sus,op2rel),doneAction:0);
		op2=SinOsc.ar((pitch+op2tune).midicps,op3);
		op2=op2*env2;
		op2=op2*op2amt;
		env1=EnvGen.ar(Env.adsr(op1att,op1dec,op1sus,op1rel),gate,doneAction:2);
		op1=SinOsc.ar((pitch+op1tune).midicps,op2+op4);
		op1=op1*env1;
		signal=op1*op1amt;
		signal=signal*vol;
		signal=Pan2.ar(signal,pos:pan);
		Out.ar(out,signal);
}).add
)

/////
q=Synth(\dex11algo3)
q.free

(
Pdef(\jj,
	Pbind(\instrument,
		\dex11algo3,
		\dur,Pseq([
			Pseq([1/4,1/8,1/4,1/8],6),
			Pxrand([1/16,1/32,1/8],8),
		],inf),
		\pitch,Pxrand([
			Pseq([48,49,53,60,67,43],8),
			Pseq([46,49,51,63,65],8),
			Pseq([50,46,60,58,41],8),
		],inf),
		\op1att,Pwhite (0,0.04,inf),
		\op1dec,0.61,
		\op1sus,0.2,
		\op1rel,Pwhite(0.1,1,inf),
		\op1amt,1,\op1tune,0,
		\op2att,0.001,\op2dec,0.150,\op2sus,0.2,\op2rel,0.1,\op2amt,1,\op2tune,Pxrand ([24,12,0,12,24,36],inf),
		\op3att,0.001,\op3dec,0.050,\op3sus,0.1,\op3rel,0.1,\op3amt,Pwhite(8,12,inf),\op3tune,12.1,
		\op4att,0,\op4dec,Pwhite(0.050,1,inf),\op4sus,0.1,\op4rel,0.1,\op4amt,Pwhite(1,4,inf),\op4tune,Pwhite(-0.3,0.3,inf),\feedbackamt,Pwhite(0.1,0.7,inf),
		\vol,Pseq([1,0,0.3,1,0,0.5,0.2,0.8,0.1,0,0.9,0.1,0.2,0.3,0.4,0.5,0.4,0.3,0.2,0.1]*0.5,inf),
		\out,0,




	)
)
)


Pdef(\jj).play
Pdef(\jj).stop
