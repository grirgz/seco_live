
(
	~make_fx.();
	~bufsize=2;
	Ndef(~name+++\fx).put(50, \filter -> { arg in, choose=0, stutter=4, attack=0.001, decay=0.001, 
					offset=0;
		var sig;
		var sig1,sig2,sig3,sig4,sig5;
		var buf = LocalBuf(~bufsize * s.sampleRate, 2);
		var rate;
		var choosetrig, choosetrig2;
		var env;
		var stuttrig;
		var recordtrig;
		var timetrig;
		sig = in;
		sig1 = sig;
		//stuttrig = Impulse.ar(stutter);
		choosetrig = choose > 0;
		stuttrig = TDuty.ar(1/stutter, choosetrig + Changed.kr(stutter), 1);
		//stuttrig = Impulse.ar(stutter).poll;
		sig3 = Ringz.ar(stuttrig, 1000, 0.001);
		stuttrig = Trig1.ar(stuttrig, 0.001);
		//sig3 = stuttrig;
		//Ringz.ar(stuttrig, 1000, 0.001);
		//sig3.poll(Impulse.ar(20));

		//recordtrig = Impulse.kr(1/time);
		//timetrig = TDuty.ar(time / stutter, choosetrig + Changed.kr(time), 1);
		//recordtrig = recordtrig + Trig1.kr(choosetrig);
		//recordtrig = Trig1.kr(choosetrig, 1/stutter);
		recordtrig = Trig1.kr(choosetrig, 0.01); //+ timetrig;
		//recordtrig.poll;
		offset = Demand.ar(stuttrig, Trig1.ar(choosetrig), 
			//Dseq([0,1/4,2/4,3/4],inf)
			Dseq([0,0,2,2,0,0,6,6]/8,inf)
		);

		RecordBuf.ar(sig, buf, 0, 1,0, 1, loop:0, trigger:recordtrig); // stutter

		//rate = Sweep.kr(A2K.kr(stuttrig), 0.1) + 1;
		rate = Sweep.kr(Impulse.kr(1), 10.1) + 1;
		rate = PulseCount.kr(Impulse.kr(4), Impulse.kr(0.5))+1;
		rate = PulseCount.kr(A2K.kr(stuttrig), Impulse.kr(0.5))+1;
		rate = Demand.kr(A2K.kr(stuttrig), Trig1.kr(choosetrig), 
			Dseq([1,0.2,2,8],inf)
		);
		rate = 0-Sweep.kr(A2K.kr(stuttrig), 1.1) + 1.1;
		rate = \rate.kr(1);
		//rate = PulseCount.kr(A2K.kr(sig3), Impulse.kr(0.5))+1;
		//rate.poll;
		//rate = 1;
		// stutter
		env = EnvGen.ar(Env([0,1,1,0],[attack, ( (1/stutter)-attack-decay ).clip(0,10), decay]), stuttrig);
		sig2 = PlayBuf.ar(2, buf, rate, stuttrig, offset * BufFrames.kr(buf), loop:1) * env;


		sig = SelectX.ar(choose.lag(0.1), [sig1, sig2]);
		//sig = sig2;

		//sig + sig3;
		CheckBadValues.ar(sig);
		sig;
		//sig3;
	});
	Ndef(~name+++\fx).addSpec(\choose, ControlSpec(0,1,\lin,1))
);

// END

Ndef
Ndef(~name+++\fx).put(5, nil)
Ndef(~name+++\fx).clear
