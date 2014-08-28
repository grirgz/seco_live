(
SynthDef("radiostatic", {arg out=0;
	var hum, sineSweep, tuning, dustNoise, staticNoise, humFreq, numHarms;
	
	numHarms = 7;
	humFreq = 100;
	hum = Array.fill(numHarms, {|i| SinOsc.ar( (i+1) * humFreq, 0, 1/numHarms)});
	hum = hum.sum;
	dustNoise = Dust.ar(LFNoise1.ar(0.5).range(1000,8000));
	staticNoise = hum * dustNoise * LFNoise1.ar(1).range(0.5, 2);
	
	sineSweep = SinOsc.ar(LFNoise2.ar(1).range(20, 11000));
	tuning = SinOsc.ar(10000).ring4(sineSweep) * LFNoise2.ar(1.1).range(0.05, 0.1);

	Out.ar(out,  Pan2.ar(staticNoise + tuning, 0));
}).add;
)
	
a = Synth("radiostatic");
