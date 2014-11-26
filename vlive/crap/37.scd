Ndef(\oneLine).play
(
Ndef(\oneLine,{
	var t, x, y, z, exp = 11, length;
	length = 2.pow( exp );

	t = PulseCount.ar( Impulse.ar( 8000 ) );

	y = InFeedback.ar( 16, 2 );

	//x = ( t >> 6 | ( y * 2 << 3 ) );
	 x = ( t * 5 >>  12  ).bitXor( y * 3 << 6  & ( [ 16, 18 ] * t ) );

	Out.ar( 16, x);

	x % length / ( length - 1 ) * 2 -1  * 0.5;
}
)
)

(
var voices = 5;
Ndef(\oneLine).clear;
Ndef(\oneLine, {
	var t, x, y, z, exp = 11, length;
	length = 2.pow( exp );
	t = PulseCount.ar( Impulse.ar( 8000 ) );

	y = InFeedback.ar( 16, voices );

	x = ( t * 5 >>  12  )
	.bitXor( 
		y * 3 << Demand.kr(
			Impulse.kr( 0.1 ! voices ) , 
			0, 
			Drand( (3..11), inf ) 
		) & ( 
			(13..17).choose.postln * t 
		) 
	);

	Out.ar( 16, x);

	x % length / ( length - 1 ) * 2 - 1  * voices.reciprocal;
}
);

Ndef(\y, { Splay.ar( LeakDC.ar( Ndef.ar(\oneLine, voices) ) ) } ).play
)







// we use a noise ugen to generate a burst

(

{  

 var burstEnv, att = 0, dec = 0.001; //Variable declarations 

 burstEnv = EnvGen.kr(Env.perc(att, dec), gate: Impulse.kr(1)); //envelope 

 PinkNoise.ar(burstEnv); //Noise, amp controlled by burstEnv 

}.play  

)


// but then we use Comb delay to create the delay line that creates the tone



// let's create a synthdef using Karplus-Strong

SynthDef(\ks_guitar, { arg note, pan, rand, delayTime, noiseType=1;

	var x, y, env;

	env = Env.new(#[1, 1, 0],#[2, 0.001]);

	// A simple exciter x, with some randomness.

	x = Decay.ar(Impulse.ar(0, 0, rand), 0.1+rand, WhiteNoise.ar); 

	x = CombL.ar(x, 0.05, note.reciprocal, delayTime, EnvGen.ar(env, doneAction:2)); 

	x = Pan2.ar(x, pan);

	Out.ar(0, LeakDC.ar(x));

}).store;


// and play the synthdef

(

{

20.do({

Synth(\ks_guitar, [\note, 220+(400.rand), 

\pan, 1.0.rand2, 

\rand, 0.1+0.1.rand, 

\delayTime, 2+1.0.rand]);

  (1.0.rand + 0.5).wait;

});

}.fork

)


// here using patterns

a = Pdef(\kspattern, 

Pbind(\instrument, \ks_guitar, // using our sine synthdef

\note, Pseq.new([60, 61, 63, 66], inf).midicps, // freq arg

\dur, Pseq.new([0.25, 0.5, 0.25, 1], inf),  // dur arg

\rand, Prand.new([0.2, 0.15, 0.15, 0.11], inf),  // dur arg

\pan, 2.0.rand-1,

\delayTime, 2+1.0.rand;  // envdur arg


)

).play;


// compare using whitenoise and pinknoise as an exciter:


// whitenoise


(

{  

 var burstEnv, att = 0, dec = 0.001; 

 var burst, delayTime, delayDecay = 0.5; 

 var midiPitch = 69; // A 440 

 delayTime = midiPitch.midicps.reciprocal; 

 burstEnv = EnvGen.kr(Env.perc(att, dec), gate: Impulse.kr(1/delayDecay));  

 burst = WhiteNoise.ar(burstEnv);  

 CombL.ar(burst, delayTime, delayTime, delayDecay, add: burst);  

}.play  

) 


// pinknoise

(

{  

 var burstEnv, att = 0, dec = 0.001; 

 var burst, delayTime, delayDecay = 0.5; 

 var midiPitch = 69; // A 440 

 delayTime = midiPitch.midicps.reciprocal; 

 burstEnv = EnvGen.kr(Env.perc(att, dec), gate: Impulse.kr(1/delayDecay));  

 burst = PinkNoise.ar(burstEnv);  

 CombL.ar(burst, delayTime, delayTime, delayDecay, add: burst);  

}.play  

) 




// Note that delayTime is controlling the pitch here. The delay time is reciprocal to the pitch. // 1/100th of a sec is 100Hz, 1/400th of a sec is 400Hz.



(

SynthDef(\KSpluck, { arg midiPitch = 69, delayDecay = 1.0;

var burstEnv, att = 0, dec = 0.001;

var signalOut, delayTime;


delayTime = [midiPitch, midiPitch + 12].midicps.reciprocal;

burstEnv = EnvGen.kr(Env.perc(att, dec)); 

signalOut = PinkNoise.ar(burstEnv); 

signalOut = CombL.ar(signalOut, delayTime, delayTime, delayDecay, add: signalOut); 

DetectSilence.ar(signalOut, doneAction:2);

Out.ar(0, signalOut)

}

).store;

)


(

//Then run this playback task

r = Task({

{Synth(\KSpluck, 

[

\midiPitch, rrand(30, 90), //Choose a pitch

\delayDecay, rrand(0.1, 3.0) //Choose duration

]);

//Choose a wait time before next event

[0.125, 0.125, 0.25].choose.wait;

}.loop;

}).play

)




