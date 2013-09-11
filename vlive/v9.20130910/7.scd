~name = '7';

SynthDef(~name,{|out= 0 freq = 440 amp = 0.1 gate=1 attackTime= 0.2 fenvamount=0.5 cutoff= 1000 gain=2.0 pan=0.0 distmix=0.7|  
	 
	var osc, filter, env, filterenv;  
	var sig;
	
	//alternative: richer source
	osc = Mix(Pulse.ar(freq.lag(0.05)*[1.0,1.001,2.0],Rand(0.45,0.5)!3,0.33));   
	 
	filterenv = EnvGen.ar(\fadsr.kr(Env.adsr(0.2,0.0,1.0,0.2)),gate,doneAction:2);  
	filter =  MoogFF.ar(osc,cutoff*(1.0+(fenvamount*filterenv)),gain);
 
	env = EnvGen.ar(\adsr.kr(Env.adsr(0.001,0.3,0.9,0.2)),gate,doneAction:2);  
	sig = SelectX.ar(distmix, [filter, filter.distort]);
	sig = sig * env * amp;
	sig = Pan2.ar(sig,pan);

		 
	Out.ar(out,sig);  
		 
}).add;  

~newfx.(\fx);

BusDef(~name+++\set_fxlfo2, \control);

Ndef(~name+++\fx, { arg lfo=1;
	var source, output;  
	var chorus; 
	//var lfo;
	//lfo = Ndef(~name+++\fx_lfo1);
	//var lfo;
	source = InFeedback.ar(BusDef(~name+++\fx),2);  
	//lfo = SinOsc.ar(0.1).range(0.1,10);
	
	chorus= Mix.fill(7, { 
		
		var maxdelaytime= rrand(0.005,0.02); 
		
		DelayC.ar(source, maxdelaytime,LFNoise1.kr(Rand(4.5,10.5)*lfo,0.25*maxdelaytime,0.75*maxdelaytime) ) 
			 
	}); 
	output = chorus;
		 
});   


(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, ~name,
	\degree, Pseq([0],inf),
	\isRest, Veco(~name).isrest,
	\out, BusDef(~name+++\fx),
	\dur, 1/4,
	\amp, 0.08,
))
);


// END

//Ndef(~name+++\fx).set(\in, BusDef(~name+++\fx));
Ndef(~name+++\fx2, {|in=0 mgate= 1| 
	var source;  
	var env; 
	var abs, excess,output;  
	mgate = Impulse.kr(1);
	source = In.ar(BusDef(~name+++\fx),2);  
	env = Linen.kr(mgate, 0.4, 1, 0.4, 0); 
	//source = In.ar(in,2);  
 	
	abs = source.abs; 
	
	excess = (abs-0.1).max(0.0).min(0.9)/0.9; 
	
	//original plus sinusoidal perturbation of amount based on absolute amplitude
	output = source+(excess*(sin(excess*2pi*5)*0.5-0.5)); 
	  
	//output = SelectX.ar(env,[source,output*env]);  
	source;
	output;
		 
});   

Veco(~name).play_node_hook = {
	"fuck".debug;
	Ndef(~name+++\fx).play
}

Ndef(~name+++\fx).put(0, { arg lfo=1;
	var source, output;  
	var chorus; 
	//var lfo;
	//lfo = Ndef(~name+++\fx_lfo1);
	//var lfo;
	source = InFeedback.ar(BusDef(~name+++\fx),2);  
	//lfo = SinOsc.ar(0.1).range(0.1,10);
	
	chorus= Mix.fill(7, { 
		
		var maxdelaytime= rrand(0.005,0.02); 
		
		DelayC.ar(source, maxdelaytime,LFNoise1.kr(Rand(4.5,10.5)*lfo,0.25*maxdelaytime,0.75*maxdelaytime) ) 
			 
	}); 
	output = chorus;
		 
});   
