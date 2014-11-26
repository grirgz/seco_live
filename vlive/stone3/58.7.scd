
Ndef(~name+++\fx).put(50, \filter -> { arg in;	
		var input, output, delrd, sig, deltimes;
		var ret;
	 
		// Choose which sort of input you want by (un)commenting these lines:
		//input = Pan2.ar(PlayBuf.ar(1, b, loop: 0), -0.5); // buffer playback, panned halfway left
		//input = SoundIn.ar([0,1]); // TAKE CARE of feedback - use headphones
		input = in;
		input = input * 1;
		//input = Dust2.ar([0.1, 0.01]); // Occasional clicks
		//input = (input.abs < 0.502) * input;
	 
		// Read our 4-channel delayed signals back from the feedback loop
		delrd = LocalIn.ar(4);
		delrd = delrd * 1;
	 
		// This will be our eventual output, which will also be recirculated
		output = input + delrd[[0,1]];
	 
		// Cross-fertilise the four delay lines with each other:
		sig = [output[0]+output[1], output[0]-output[1], delrd[2]+delrd[3], delrd[2]-delrd[3]];
		sig = [sig[0]+sig[2], sig[1]+sig[3], sig[0]-sig[2], sig[1]-sig[3]];
		// Attenutate the delayed signals so they decay:
		sig = sig * [0.4, 0.37, 0.333, 0.3] * 1.4;
	 
		// Here we give delay times in milliseconds, convert to seconds,
		// then compensate with ControlDur for the one-block delay 
		// which is always introduced when using the LocalIn/Out fdbk loop
		deltimes = [101, 143, 165, 177] * 0.001 - ControlDur.ir;
		deltimes = deltimes * SinOsc.ar(148).range(1,1.005) / 8 - 0.001;
	 
		// Apply the delays and send the signals into the feedback loop
		ret = DelayC.ar(sig, deltimes, deltimes);
		//ret = Limiter.ar(ret, 1, 0.001);
		ret = ret.tanh;
		LocalOut.ar(ret);
	 
		// Now let's hear it:
		//sig.poll;
		sig = LPF.ar(sig, 4150);
		sig = Pan2.ar(sig, 0, 1).flop;
		sig.postln;
		sig;
		//output;
	 
	})
