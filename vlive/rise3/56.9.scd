(
	~bufsize=2;
	Ndef(~name+++\fx).put(5, \filterIn -> { arg in, choose=0, time=2, tapetime=2, stutter=4, attack=0.001, decay=0.001, tapelevel=0.7,
					offset=0;
		var sig;
		var sig1,sig2,sig3,sig4,sig5;
		var buf = LocalBuf(~bufsize * s.sampleRate, 1);
		var rate;
		var choosetrig, choosetrig2;
		var env;
		var stuttrig;
		var recordtrig;
		var timetrig;
		var graintrig;
		sig = in;
		sig1 = sig;
		//stuttrig = Impulse.ar(stutter);
		choosetrig = choose > 0;
		stuttrig = TDuty.ar(1/stutter, choosetrig + Changed.kr(stutter), 1);
		//stuttrig = Impulse.ar(stutter).poll;
		sig3 = Ringz.ar(stuttrig, 1000, 0.001);
		stuttrig = Trig1.ar(stuttrig, 0.001);
		graintrig = TDuty.ar(1/(stutter*8), choosetrig + Changed.kr(stutter), 1);
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

		sig = sig.sum;
		RecordBuf.ar(sig, buf, 0, 1,0, 1, loop:0, trigger:recordtrig); // stutter

		//rate = Sweep.kr(A2K.kr(stuttrig), 0.1) + 1;
		rate = Sweep.kr(Impulse.kr(1), 10.1) + 1;
		rate = PulseCount.kr(Impulse.kr(4), Impulse.kr(0.5))+1;
		rate = PulseCount.kr(A2K.kr(stuttrig), Impulse.kr(0.5))+1;
		rate = Demand.kr(A2K.kr(stuttrig), Trig1.kr(choosetrig), 
			Dseq([1,0.2,2,8],inf)
		);
		rate = 0-Sweep.kr(A2K.kr(stuttrig), 1.1) + 1.1;
		//rate = PulseCount.kr(A2K.kr(sig3), Impulse.kr(0.5))+1;
		//rate.poll;
		rate = 1;
		// stutter
		env = EnvGen.ar(Env([0,1,1,0],[attack, (1/stutter)-attack-decay, decay]), stuttrig);
		//sig2 = PlayBuf.ar(1, buf, rate, stuttrig, offset * BufFrames.kr(buf), loop:1) * env;
		sig2 = BufRd.ar(1, buf, LFSaw.ar(stutter).range(0,0.21)+offset * 40000, loop:1) * env;
		sig2 = sig2 !2;
		//sig2 = TGrains.ar(2, graintrig, buf, rate, offset * BufDur.kr(buf), 0.1);
		//sig2 = TGrains.ar(2, Impulse.ar(20), buf, 1, 0.101, 0.01);
		sig2.postln;

		sig = SelectX.ar(choose.lag(0.1)-1, [sig1, sig2]);

		//sig + sig3;
		CheckBadValues.ar(sig);
		sig;
		//sig3;
	});
)
// END

(
	Ndef(~name+++\fx).put(50, \filter -> { arg in, freqshift=0, freeze=0;
		var sig;
		var chain;
		var chain2;
		in.debug("FUICL");
		sig = in;
		chain = FFT({LocalBuf(2048)}!2, in);
		// moves in and out of freeze
		chain = PV_MagFreeze(chain, freeze );
		sig = IFFT(chain);

		sig;
	});
)
