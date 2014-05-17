
(
Ndef(~name+++\fx,{|length = 1, fb = 0.8, sep = 0.012, mix=0.5, hpfreq=400, lpfreq=5000, noisefreq=12, delayfac=0,
		offset=0, rotate=0, shift=0|
	var input = InFeedback.ar(BusDef(~name+++\fx), 2);
	var output;
	//input.poll(label:"dubin");
	//length = length.lag(0.01);
	//length = LPF.kr(length, 10);
	fb = LPF.kr(fb, 1);
	sep = LPF.kr(fb, 1);
	delayfac = LPF.kr(fb, 1);
	output = input + Fb({

		arg feedback; // this will contain the delayed output from the Fb unit

		var left,right;
		var magic;
		feedback = Limiter.ar(feedback, 1);
		magic = LeakDC.ar(feedback*fb + input);
		magic = HPF.ar(magic, hpfreq); // filter's on the feedback path
		magic = LPF.ar(magic, lpfreq);
		magic = magic.tanh; // and some more non-linearity in the form of distortion
		//#left, right = magic; // let's have named variables for the left and right channels
		magic = FreqShift.ar(magic, [0-shift,shift]);
		#left, right = magic; 
		//#left, right = Rotate2.ar(left, right, rotate); 
		magic = [
			DelayC.ar(left, 1, 
				(LFNoise2.ar(noisefreq).range(delayfac*sep,sep)+offset).clip(0,1)
			), 
			DelayC.ar(right, 1, 
				(LFNoise2.ar(noisefreq).range(sep,sep*delayfac)-offset).clip(0,1)
			)
		]; // In addition to the main delay handled by the feedback quark, this adds separately modulated delays to the left and right channels, which with a small "sep" value creates a bit of spatialization

	},length);
	output = SelectX.ar(mix,[input, output]);
	output = Rotate2.ar(output[0], output[1], rotate); 
	//output.poll;
	output
	//Out.ar(out, output);
});
)

// END

Ndef(~name+++\mixer).edit
Ndef(~name+++\mixer).play
N

~fxgroup = Group.after
