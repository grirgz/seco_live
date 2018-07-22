
//////// sound analysis


(
{

var in, fft, dissonance;

//in = SinOsc.ar(MouseX.kr(100,1000),0,0.1);
//in = Mix(SinOsc.ar([440,MouseX.kr(440,880)],0,0.1));  
in= SoundIn.ar; 

fft = FFT(LocalBuf(2048), in);

dissonance=SensoryDissonance.kr(fft);

dissonance.poll; 

Out.ar(0,Pan2.ar(0.1*Blip.ar(100,(dissonance.sqrt)*200))); 
}.play
)



//different fftsize, max num peaks, own normalisation, avoid clamping by setting high value (more CPU cost) 
(
{

var in, fft, dissonance;

//in = SinOsc.ar(MouseX.kr(100,1000),0,0.1);
//in = Mix(SinOsc.ar([440,MouseX.kr(440,880)],0,0.1));  
in= SoundIn.ar; 

fft = FFT(LocalBuf(4096), in);

dissonance=SensoryDissonance.kr(fft,500,1.0,1.0,999999);

dissonance.poll; 

Out.ar(0,SinOsc.ar(dissonance*0.1,0,0.1)); 
}.play
)

///////////////////////


(
SynthDef(\vocoder, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var fft;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);

	fft = FFT(LocalBuf(16*2), sig);
	fft.pvcollect(16*2, { arg mag, phy, bin, idx;
		idx.postln;
	});
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);
