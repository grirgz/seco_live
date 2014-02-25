Ndef(~name+++\fx).put(100, \filter -> { arg in;
	var freq = 400;
	var sig;
	var hasfreq;
	var f1, f2;
	var freq1, freq2, freq3, freq4;
	sig = in;
	sig = sig.sum;
	sig.postln;
	sig = BPF.ar(sig, [50,100,1000,5000,10000,15000]);
	sig.postln;
	sig = sig.collect { arg si;
		var fr = ZeroCrossing.ar(si);
		//si = WhiteNoise.ar(1);
		si = LFSaw.ar(fr);
		fr = LPF.ar(fr, 10);
		RLPF.ar(si, fr*2+100, 0.3);
	};
	sig = sig.sum;
	sig = sig * Amplitude.ar(in);
	//sig * 10;
	//in;
})

// END

Ndef(~name+++\fx).put(100, \filter -> { arg in;
	var freq = 400;
	var sig;
	var hasfreq;
	var f1, f2;
	freq = ZeroCrossing.ar(in);
	//#f1, f2 = Pitch.kr(in);
	//#freq, hasfreq = f1;
	//#freq, hasfreq = Pitch.kr(in);
	//freq.poll;
	//in * SinOsc.ar(SinOsc.ar(1)*0.1+1*freq); 
	//in * SinOsc.ar(freq); 
	freq = LPF.ar(freq, 10);
	//sig = GrainSin.ar (numChannels: 1, trigger: Impulse.ar(150), dur: 0.001, freq: freq, pan: 0, envbufnum: -1, maxGrains: 512, mul: 1, add: 0);
	//sig = sig * Amplitude.ar(in) + (in/4);
	freq.postln;
	freq.poll;
	sig = WhiteNoise.ar(1);
	//sig = LPF.ar(sig, freq.clip2(100,1000), 0.3);
	//sig = BPF.ar(sig, 1000, 0.3);
	sig.postln;
	sig.poll;
	//in;
	//sig = LFTri.ar(freq) * Amplitude.ar(in); 
	//sig = LPF.ar(sig, 500) * 2;
	//sig = sig + in;
	sig = sig * Amplitude.ar(in);
})
