
/// chaotic synthdef


(
SynthDef(\kao, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var numosc = 10;
	var sigin;
	var kaotab, kaotab2;
	sigin = LocalIn.ar(numosc) * \fb.kr(1);
	kaotab = \kaotab.kr(1!numosc);
	kaotab2 = \kaotab2.kr(1!numosc);
	sig = numosc.collect{ arg idx; 
		var input;
		input = sigin.collect({ arg isigin, inidx;
			isigin * HenonN.ar(1, a:kaotab[inidx], b:kaotab2[idx], mul:1/5).lag(1).softclip.clip(0,1)
	  	});
		SinOsc.ar(freq * ( input.mean * 1 + 1 )); 
	};
	LocalOut.ar(sig);
	sig = sig.mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Ndef(\kao, \kao).play;
);
WindowDef(\NdefEditor).front(\kao)



{ HenonN.ar(MouseX.kr(20, SampleRate.ir)) * 0.2  }.play(s);

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq * ( HenonN.ar(1, a:0.5).lag(1).poll * 1 + 1 ));
	sig = Pan2.ar(sig, pan, amp);
}).play;
);





(
SynthDef(\kao, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, hfreq=1;
	var sig;
	var numosc = 10;
	var sigin;
	var kaotab, kaotab2;
	sigin = LocalIn.ar(numosc) * \fb.kr(1);
	kaotab = \kaotab.kr(1!numosc);
	kaotab2 = \kaotab2.kr(1!numosc);
	sig = numosc.collect{ arg idx; 
		var input;
		input = sigin.collect({ arg isigin, inidx;
			isigin * HenonN.ar(hfreq, a:kaotab[inidx], b:kaotab2[idx], mul:1/5).lag(1).softclip.clip(0,1)
	  	});
		//HenonN.ar(freq * ( Ramp.ar(input.mean,1) * 1 + 1 )); 
		SinOsc.ar(freq * ( Ramp.ar(input.mean,1) * 1 + 1 )); 
	};
	LocalOut.ar(sig);
	sig = sig.mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Ndef(\kao, \kao).play;
);
WindowDef(\NdefEditor).front(\kao)
Ndef(\kao).clear


// default initial params
{ HenonN.ar(MouseX.kr(20, SampleRate.ir)) * 0.2 }.play(s);

// mouse-control of params
{ HenonN.ar(84, MouseX.kr(1,1.4), MouseY.kr(0,0.3)) * 0.2 }.play(s);

// randomly modulate params
(
{ HenonN.ar(
    188,
    LFNoise2.kr(1, 0.2, 1.2),
    LFNoise2.kr(1, 0.15, 0.15)
) * 0.2 }.play(s);
)

// as a frequency control
{ SinOsc.ar(HenonN.ar(40, MouseX.kr(1,1.4), MouseY.kr(0,0.3))*800+900)*0.4 }.play(s);



(
SynthDef(\kao, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, hfreq=1;
	var sig;
	var numosc = 10;
	var sigin;
	var kaotab, kaotab2;
	var kaosel;
	sigin = LocalIn.ar(numosc) * \fb.kr(1);
	kaotab = \kaotab.kr(1!numosc);
	kaotab2 = \kaotab2.kr(1!numosc);
	kaosel = \kaosel.kr(0);
	sig = numosc.collect{ arg idx; 
		var input;
		input = sigin.collect({ arg isigin, inidx;
			isigin * HenonN.ar(hfreq, a:kaotab[inidx], b:kaotab2[idx], mul:1/5).lag(1).softclip.clip(0,1)
	  	});
		input = SelectX.ar(SinOsc.ar(\kaoselfreq.kr(1)+( kaosel*idx )).range(0,input.size-1), input);
		//HenonN.ar(freq * ( Ramp.ar(input.mean,1) * 1 + 1 )); 
		SinOsc.ar(freq * ( input * \fma.kr(1) + 1 )); 
	};
	LocalOut.ar(sig);
	sig = sig.mean * 2;
	sig = HPF.ar(sig, \locut.kr(50));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Ndef(\kao, \kao).play;
);

Ndef(\kao).play(BusDef(\sendbus5, \audio, 2).index, 2)
WindowDef(\NdefEditor).front(\kao)



(
MIDIdef.noteOn(\track1, { arg velocity, noteNum, channel, deviceId;
	[ velocity, noteNum, channel, deviceId ].debug;
	
	Ndef(\kao).set(\freq, noteNum.midicps);
	Ndef(\kao).set(\kaoselfreq, noteNum.midicps);
});
)
