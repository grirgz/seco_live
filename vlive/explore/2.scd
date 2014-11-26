(
	Ndef(\verb, {	
		var input, output, delrd, sig, deltimes;
	 
		// Choose which sort of input you want by (un)commenting these lines:
		//input = Pan2.ar(PlayBuf.ar(1, b, loop: 0), -0.5); // buffer playback, panned halfway left
		input = SoundIn.ar([0,1]); // TAKE CARE of feedback - use headphones
		//input = Dust2.ar([0.1, 0.01]); // Occasional clicks
	 
		// Read our 4-channel delayed signals back from the feedback loop
		delrd = LocalIn.ar(4);
	 
		// This will be our eventual output, which will also be recirculated
		output = input + delrd[[0,1]];
	 
		// Cross-fertilise the four delay lines with each other:
		sig = [output[0]+output[1], output[0]-output[1], delrd[2]+delrd[3], delrd[2]-delrd[3]];
		sig = [sig[0]+sig[2], sig[1]+sig[3], sig[0]-sig[2], sig[1]-sig[3]];
		// Attenutate the delayed signals so they decay:
		sig = sig * [0.4, 0.37, 0.333, 0.3] * 1.2;
	 
		// Here we give delay times in milliseconds, convert to seconds,
		// then compensate with ControlDur for the one-block delay 
		// which is always introduced when using the LocalIn/Out fdbk loop
		deltimes = [101, 143, 165, 177] * 0.001 - ControlDur.ir;
	 
		// Apply the delays and send the signals into the feedback loop
		LocalOut.ar(DelayC.ar(sig, deltimes, deltimes));
	 
		// Now let's hear it:
		Out.ar(0, output);
	 
	}).play

)

(
	Ndef(\verb, {	
		var input, output, delrd, sig, deltimes;
	 
		// Choose which sort of input you want by (un)commenting these lines:
		//input = Pan2.ar(PlayBuf.ar(1, b, loop: 0), -0.5); // buffer playback, panned halfway left
		input = SoundIn.ar([0,1]); // TAKE CARE of feedback - use headphones
		input = input * \pregain.kr(1);
		input = input * (1-\mix.kr(0));
		//input = Dust2.ar([0.1, 0.01]); // Occasional clicks
	 
		// Read our 4-channel delayed signals back from the feedback loop
		delrd = LocalIn.ar(4);
		delrd = delrd * SelectX.kr(\enablemix.kr(1), [1,\mix.kr]);
	 
		// This will be our eventual output, which will also be recirculated
		output = input + delrd[[0,1]];
	 
		// Cross-fertilise the four delay lines with each other:
		sig = [output[0]+output[1], output[0]-output[1], delrd[2]+delrd[3], delrd[2]-delrd[3]];
		sig = [sig[0]+sig[2], sig[1]+sig[3], sig[0]-sig[2], sig[1]-sig[3]];
		// Attenutate the delayed signals so they decay:
		sig = sig * [0.4, 0.37, 0.333, 0.3] * \room.kr(1);
	 
		// Here we give delay times in milliseconds, convert to seconds,
		// then compensate with ControlDur for the one-block delay 
		// which is always introduced when using the LocalIn/Out fdbk loop
		deltimes = [101, 143, 165, 177] * \delayfac.kr(1) * 0.001 - ControlDur.ir - 0.001;

		sig = Limiter.ar(sig, 1, 0.001);
	 
		// Apply the delays and send the signals into the feedback loop
		LocalOut.ar(DelayC.ar(sig, deltimes, deltimes));
	 
		// Now let's hear it:
		Out.ar(0, output);
	 
	}).play

)

Ndef(\verb).addSpec(\room, ControlSpec(0.0,1.4,\lin,0,1));
Ndef(\verb).addSpec(\delayfac, ControlSpec(0.5,1.4,\exp,0,1));
Ndef(\verb).addSpec(\pregain, \unipolar);
Ndef(\verb).addSpec(\mix, \unipolar);
Ndef(\verb).addSpec(\enablemix, \unipolar);
Ndef(\verb).edit;

(
	Ndef(\echo, {	
		var input, output, delrd, sig, deltimes;
		var dryinput;
		var premix;
		premix = \premix.kr(1);
	 
		input = SoundIn.ar([0,1]); // TAKE CARE of feedback - use headphones
		//sig = SelectX.ar(premix, [input, DC.ar(0)]);
		sig = input * premix;
		dryinput = input * (1-premix);
	 
		delrd = LocalIn.ar(4);
		sig = sig + (delrd * \fb.kr(0.1));

		sig = DelayL.ar(sig, 1,1) + sig;
		sig = Limiter.ar(sig, 1, 0.001);
	 

		LocalOut.ar(sig);
		sig = dryinput + sig;
		sig = SelectX.ar(\postmix.kr(0), [input, sig]);
	 
		Out.ar(0, sig);
	 
	}).play

)

(
	Ndef(\echo, {	
		var input, output, delrd, sig, deltimes;
		var dryinput;
		var premix;
		premix = \premix.kr(1);
	 
		input = SoundIn.ar([0,1]); // TAKE CARE of feedback - use headphones
		//sig = SelectX.ar(premix, [input, DC.ar(0)]);
		sig = input * premix;
		dryinput = input * (1-premix);
	 
		delrd = LocalIn.ar(4);
		sig = sig + (delrd * \fb.kr(0.1));

		sig = DelayL.ar(sig, 1,1) + sig;
		sig = Limiter.ar(sig, 1, 0.001);
	 

		LocalOut.ar(sig);
		sig = dryinput + sig;
		sig = SelectX.ar(\postmix.kr(0), [input, sig]);
	 
		Out.ar(0, sig);
	 
	}).play

)

Ndef(\echo).addSpec(\postmix, \unipolar);
Ndef(\echo).addSpec(\premix, \unipolar);
Ndef(\echo).edit;

