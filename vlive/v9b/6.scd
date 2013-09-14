~name = \6;

SynthDef(~name,{|out= 0 freq = 440 amp = 0.1 gate=1 cutoff=8000 rq=0.8 pan=(-0.1) pwidth=0.5|  
	 
	var pulse, filter, env;  
	var sig;
		   
	//2 cents detune for second oscillator	   
	pulse = Mix.new(Pulse.ar( ((freq.cpsmidi)+[-0.02,0,0.02,0.03]).midicps, pwidth))*0.5;
  
	filter =  BLowPass.ar(pulse,100+cutoff,rq);

	env = EnvGen.ar(\adsr.kr(Env.adsr(0.002,0.1,1.0,0.2)),gate,doneAction:2);  
	sig = filter * env;
	//sig = Pan2.ar(filter*env*amp,pan)
	sig = Splay.ar(sig, 0.8, amp, pan);
	Out.ar(out,sig);  
		 
}).add;  


(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, ~name,
	\degree, Pseq([0],inf),
	\isRest, Veco(~name).isrest,
	\dur, 1/4,
	\amp, 0.031
))
);
