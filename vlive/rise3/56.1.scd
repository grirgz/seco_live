
(
Veco(~name).lib.fxquant = 1/2;
Ndef(~name+++\fx).quant = Veco(~name).lib.fxquant;

~bus = BusDef(~name+++\fx, \audio);

~bufsize = 2;
);

//Ndef(~name+++\fx).play(0);
(
	Veco.do { arg name;
		Task({
			~name = name;
			Ndef(~name+++\fx).put(0, {
				var in = InFeedback.ar(~bus,2);
				in;
			});

			0.1.wait;


			Ndef(~name+++\fx).put(5, \filterIn -> { arg in, choose=0, time=2, tapetime=2, stutter=4, attack=0.001, decay=0.001, tapelevel=0.7,
							offset=0;
				var sig;
				var sig1,sig2,sig3,sig4,sig5;
				var buf = LocalBuf(~bufsize * s.sampleRate, 2);
				var buf2 = LocalBuf(~bufsize * s.sampleRate, 2);
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

				//recordtrig = Impulse.kr(1/time);
				//timetrig = TDuty.ar(time / stutter, choosetrig + Changed.kr(time), 1);
				//recordtrig = recordtrig + Trig1.kr(choosetrig);
				//recordtrig = Trig1.kr(choosetrig, 1/stutter);
				recordtrig = Trig1.kr(choosetrig, 0.01); //+ timetrig;
				//recordtrig.poll;
				//offset = TDuty.ar(Dseq([0.25],inf), Trig1.ar(choosetrig), 
				//	//Dseq([0,1/4,2/4,3/4],inf)
				//	Dseq([0,0,2,2,0,0,6,6]/8,inf)
				//);

				RecordBuf.ar(sig, buf, loop:1, run:1, trigger:choosetrig); // tape stop
				RecordBuf.ar(sig, buf2, 0, 1,0, 1, loop:1, trigger:recordtrig); // stutter

				// tape stop
				rate = EnvGen.kr(Env([1,1,tapelevel],[0,tapetime]), choosetrig);
				sig2 = PlayBuf.ar(2, buf, rate, choosetrig, loop:1);

				// stutter
				env = EnvGen.ar(Env([0,1,1,0],[attack, (1/stutter)-attack-decay, decay]), stuttrig);
				sig3 = PlayBuf.ar(2, buf2, 1, stuttrig, offset * BufFrames.kr(buf2), loop:1) * env;

				sig = SelectX.ar(choose.lag(0.1), [sig1, sig2, sig3]);
				//sig = Select.ar(choose, [sig1, sig2, sig3]);
				//sig = SelectX.ar(wet0, [in, sig]);
				sig;
			});

			0.1.wait;
			Ndef(~name+++\fx).put(1000, \filter -> { arg in, amp=1, mix=1, del=0;
				var dry = InFeedback.ar(~bus,2);
				var sig;
				var delay;
				var windowsize = 2048;
				sig = in * amp;
				delay = windowsize * SampleDur.ir * 0.5;
				delay = delay + (del*SampleDur.ir) ;
				//delay = 1;
				dry = DelayC.ar(dry, delay + (200 * SampleDur.ir), delay);
				sig = SelectX.ar(mix, [dry, sig]);
				sig;

			})
		}).play;
		nil;
	
	}
);



// END

MIDIBoard.map(\k1, Ndef(~name+++\fx), \del, ControlSpec(-200,200,\lin,1,0))

Veco(~name).val_play_node_hook_dict
Veco(~name).val_play_node_hook_dict[\mixer].value
Veco(~name).val_play_node_hook_dict[\fx].value
Ndef(~name+++\fx).play

Ndef(~name+++\fx).play(0);
(
	Ndef(~name+++\fx).put(0, {
		var in = InFeedback.ar(~bus,2);
		in;
	});



	Ndef(~name+++\fx).put(5, \filterIn -> { arg in, choose=0, time=2, tapetime=2, stutter=4, attack=0.001, decay=0.001, tapelevel=0.7,
					offset=0;
		var sig;
		var sig1,sig2,sig3,sig4,sig5;
		var buf = LocalBuf(~bufsize * s.sampleRate, 2);
		var buf2 = LocalBuf(~bufsize * s.sampleRate, 2);
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

		//recordtrig = Impulse.kr(1/time);
		timetrig = TDuty.ar(time / stutter, choosetrig + Changed.kr(time), 1);
		//recordtrig = recordtrig + Trig1.kr(choosetrig);
		//recordtrig = Trig1.kr(choosetrig, 1/stutter);
		recordtrig = Trig1.kr(choosetrig, 0.01) + timetrig;
		//recordtrig.poll;
		offset = TDuty.ar(Dseq([0.25],inf), Trig1.ar(choosetrig), 
			//Dseq([0,1/4,2/4,3/4],inf)
			Dseq([0,0,2,2,0,0,6,6]/8,inf)
		);

		RecordBuf.ar(sig, buf, loop:1, run:1, trigger:choosetrig); // tape stop
		RecordBuf.ar(sig, buf2, 0, 1,0, 1, loop:0, trigger:recordtrig); // stutter

		// tape stop
		rate = EnvGen.kr(Env([1,1,tapelevel],[0,tapetime]), choosetrig);
		sig2 = PlayBuf.ar(2, buf, rate, choosetrig, loop:1);

		// stutter
		env = EnvGen.ar(Env([0,1,1,0],[attack, (1/stutter)-attack-decay, decay]), stuttrig);
		sig3 = PlayBuf.ar(2, buf2, 1, stuttrig, offset * BufFrames.kr(buf2), loop:1) * env;

		sig = SelectX.ar(choose.lag(0.1), [sig1, sig2, sig3]);
		//sig = Select.ar(choose, [sig1, sig2, sig3]);
		//sig = SelectX.ar(wet0, [in, sig]);
		sig;
	});

	Ndef(~name+++\fx).put(1000, \filter -> { arg in, amp=1, mix=1;
		var dry = InFeedback.ar(~bus,2);
		var sig;
		sig = in * amp;
		sig = SelectX.ar(mix, [dry, sig]);
		sig;

	});
	
);
(
	Veco.do { arg name;
		Task({
			~name = name;
			Ndef(~name+++\fx).put(0, {
				var in = InFeedback.ar(~bus,2);
				in;
			});

			0.1.wait;


			Ndef(~name+++\fx).put(5, \filterIn -> { arg in, choose=0, time=2, tapetime=2, stutter=4, attack=0.001, decay=0.001, tapelevel=0.7,
							offset=0;
				var sig;
				var sig1,sig2,sig3,sig4,sig5;
				var buf = LocalBuf(~bufsize * s.sampleRate, 2);
				var buf2 = LocalBuf(~bufsize * s.sampleRate, 2);
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

				//recordtrig = Impulse.kr(1/time);
				timetrig = TDuty.ar(time / stutter, choosetrig + Changed.kr(time), 1);
				//recordtrig = recordtrig + Trig1.kr(choosetrig);
				//recordtrig = Trig1.kr(choosetrig, 1/stutter);
				recordtrig = Trig1.kr(choosetrig, 0.01) + timetrig;
				//recordtrig.poll;
				offset = TDuty.ar(Dseq([0.25],inf), Trig1.ar(choosetrig), 
					//Dseq([0,1/4,2/4,3/4],inf)
					Dseq([0,0,2,2,0,0,6,6]/8,inf)
				);

				RecordBuf.ar(sig, buf, loop:1, run:1, trigger:choosetrig); // tape stop
				RecordBuf.ar(sig, buf2, 0, 1,0, 1, loop:0, trigger:recordtrig); // stutter

				// tape stop
				rate = EnvGen.kr(Env([1,1,tapelevel],[0,tapetime]), choosetrig);
				sig2 = PlayBuf.ar(2, buf, rate, choosetrig, loop:1);

				// stutter
				env = EnvGen.ar(Env([0,1,1,0],[attack, (1/stutter)-attack-decay, decay]), stuttrig);
				sig3 = PlayBuf.ar(2, buf2, 1, stuttrig, offset * BufFrames.kr(buf2), loop:1) * env;

				sig = SelectX.ar(choose.lag(0.1), [sig1, sig2, sig3]);
				//sig = Select.ar(choose, [sig1, sig2, sig3]);
				//sig = SelectX.ar(wet0, [in, sig]);
				sig;
			});

			0.1.wait;
			Ndef(~name+++\fx).put(1000, \filter -> { arg in, amp=1, mix=1;
				var dry = InFeedback.ar(~bus,2);
				var sig;
				sig = in * amp;
				sig = SelectX.ar(mix, [dry, sig]);
				sig;

			})
		}).play;
		nil;
	
	}
);



/////////////////////////////


Ndef(~name+++\mixer).play(0);
Ndef(~name+++\fx).play(BusDef(~name+++\mixer).index);

Ndef(~name+++\fx).clear

Ndef(~name+++\fx).set(\time, 1/8)
Ndef(~name+++\fx).set(\choose, 2)
Ndef(~name+++\fx).set(\choose, 1)
Ndef(~name+++\fx).set(\choose, 0)
Ndef(~name+++\fx).set(\stutter, 20)
Ndef(~name+++\fx).set(\stutter, 20)
// choose
Ndef(~name+++\fx, { arg choose=0, time=2, tapetime=2, stutter=4, attack=0.001, decay=0.001, tapelevel=0.7;
	var in = InFeedback.ar(~bus,2);
	var sig;
	var sig1,sig2,sig3,sig4,sig5;
	var buf = LocalBuf(~bufsize * s.sampleRate, 2);
	var buf2 = LocalBuf(~bufsize * s.sampleRate, 2);
	var rate;
	var choosetrig, choosetrig2;
	var env;
	var stuttrig;
	var recordtrig;
	sig = in;
	sig1 = sig;
	stuttrig = Impulse.ar(stutter);
	choosetrig = choose > 0;

	//recordtrig = Impulse.kr(1/time);
	//recordtrig = recordtrig + Trig1.kr(choosetrig);
	recordtrig = Trig1.kr(choosetrig, 1/stutter);

	RecordBuf.ar(sig, buf, loop:0, run:recordtrig, trigger:choosetrig);
	RecordBuf.ar(sig, buf2, 0, 1,0, recordtrig, loop:0, trigger:recordtrig);

	// tape stop
	rate = EnvGen.kr(Env([1,1,tapelevel],[0,tapetime]), choosetrig);
	sig2 = PlayBuf.ar(2, buf, rate, choosetrig, loop:1);

	// stutter
	env = EnvGen.ar(Env([0,1,1,0],[attack, 1/stutter, decay]), stuttrig);
	sig3 = PlayBuf.ar(2, buf2, 1, stuttrig, 0, loop:1) * env;

	sig = Select.ar(choose, [sig1, sig2, sig3]);
	sig;
}).play;



(
Ndef(\plop, {
	
	SinOsc.ar(100) ! 2
}).play(Bus.audio(s,2))
)





a = NodeProxy.new;
s.plotTree;
a.nodeMap = nil
a.nodeMap = b
b = a.nodeMap 

b
(
Task({
    8.do {
        a.source = { arg bla=1; SinOsc.ar(Rand(50,500*bla))!2 * 0.5 };
        //0.1.wait;
    }
}).play;
)

a = NodeProxy.new;
a.source = { arg bla=1; SinOsc.ar(Rand(50,500*bla))!2 * 0.5 };

(
Task({
    8.do {
        a.play;
        //0.1.wait;
    }
}).play;
)


Platform.systemAppSupportDir

	Ndef(\plopx).quant = 1

(
	//Ndef(\plopx).play(BusDef(~name+++\mixer));
	Ndef(\plopx).play;
	//Ndef(~name+++\fx).play;
	//Ndef(~name+++\mixer).parentGroup = ~get_mixer_group.();
	//Ndef(~name+++\mixer).play(0);
	Ndef(\plopx).put(0, {
		var in = InFeedback.ar(~bus,2);
		in;
	});
	Ndef(\plopx).put(5, \filterIn -> { arg in;
		in * SinOsc.ar(90)
	});
	Ndef(\plopx).put(1000, \filter -> { arg in, amp=1, mix=1;
		var dry = InFeedback.ar(~bus,2);
		var sig;
		sig = in * amp;
		sig = SelectX.ar(mix, [dry, sig]);
		sig;

	});
)

(
Task({
    8.do {
		Ndef(\plop).put(0, {
			SinOsc.ar(100) ! 2
		});
		Ndef(\plop).put(10, \filter -> { arg in;
			in * SinOsc.ar(90)
		});
		Ndef(\plop).put(1000, \filter -> { arg in;
			in * SinOsc.ar(80)
		});
    }
}).play;
)


	Ndef(\fx).put(0, {
		SinOsc.ar(100) ! 2
	});

(

~bus = BusDef(~name+++\fx, \audio);

~bufsize = 2;
~name = '56'
);


(
	Ndef(~name+++\fx).play(BusDef(~name+++\mixer));
	Ndef(~name+++\mixer).play(0);

)
(

Task({
    8.do {
	Ndef(~name+++\fx).put(0, {
		var in = InFeedback.ar(~bus,2);
		in;
	});



	Ndef(~name+++\fx).put(5, \filterIn -> { arg in, choose=0, time=2, tapetime=2, stutter=4, attack=0.001, decay=0.001, tapelevel=0.7,
					offset=0;
		var sig;
		var sig1,sig2,sig3,sig4,sig5;
		var buf = LocalBuf(~bufsize * s.sampleRate, 2);
		var buf2 = LocalBuf(~bufsize * s.sampleRate, 2);
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

		//recordtrig = Impulse.kr(1/time);
		timetrig = TDuty.ar(time / stutter, choosetrig + Changed.kr(time), 1);
		//recordtrig = recordtrig + Trig1.kr(choosetrig);
		//recordtrig = Trig1.kr(choosetrig, 1/stutter);
		recordtrig = Trig1.kr(choosetrig, 0.01) + timetrig;
		//recordtrig.poll;
		offset = TDuty.ar(Dseq([0.25],inf), Trig1.ar(choosetrig), 
			//Dseq([0,1/4,2/4,3/4],inf)
			Dseq([0,0,2,2,0,0,6,6]/8,inf)
		);

		RecordBuf.ar(sig, buf, loop:1, run:1, trigger:choosetrig); // tape stop
		RecordBuf.ar(sig, buf2, 0, 1,0, 1, loop:0, trigger:recordtrig); // stutter

		// tape stop
		rate = EnvGen.kr(Env([1,1,tapelevel],[0,tapetime]), choosetrig);
		sig2 = PlayBuf.ar(2, buf, rate, choosetrig, loop:1);

		// stutter
		env = EnvGen.ar(Env([0,1,1,0],[attack, (1/stutter)-attack-decay, decay]), stuttrig);
		sig3 = PlayBuf.ar(2, buf2, 1, stuttrig, offset * BufFrames.kr(buf2), loop:1) * env;

		sig = SelectX.ar(choose.lag(0.1), [sig1, sig2, sig3]);
		//sig = Select.ar(choose, [sig1, sig2, sig3]);
		//sig = SelectX.ar(wet0, [in, sig]);
		sig;
	});

	Ndef(~name+++\fx).put(1000, \filter -> { arg in, amp=1, mix=1;
		var dry = InFeedback.ar(~bus,2);
		var sig;
		sig = in * amp;
		sig = SelectX.ar(mix, [dry, sig]);
		sig;

	});
    }
}).play;
	
);

(
Task({
    8.do {
	Ndef(\fx).put(0, {
		var in = InFeedback.ar(~bus,2);
		in;
	});



	Ndef(\fx).put(5, \filterIn -> { arg in, choose=0, time=2, tapetime=2, stutter=4, attack=0.001, decay=0.001, tapelevel=0.7,
					offset=0;
		var sig;
		var sig1,sig2,sig3,sig4,sig5;
		var buf = LocalBuf(~bufsize * s.sampleRate, 2);
		var buf2 = LocalBuf(~bufsize * s.sampleRate, 2);
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

		//recordtrig = Impulse.kr(1/time);
		timetrig = TDuty.ar(time / stutter, choosetrig + Changed.kr(time), 1);
		//recordtrig = recordtrig + Trig1.kr(choosetrig);
		//recordtrig = Trig1.kr(choosetrig, 1/stutter);
		recordtrig = Trig1.kr(choosetrig, 0.01) + timetrig;
		//recordtrig.poll;
		offset = TDuty.ar(Dseq([0.25],inf), Trig1.ar(choosetrig), 
			//Dseq([0,1/4,2/4,3/4],inf)
			Dseq([0,0,2,2,0,0,6,6]/8,inf)
		);

		RecordBuf.ar(sig, buf, loop:1, run:1, trigger:choosetrig); // tape stop
		RecordBuf.ar(sig, buf2, 0, 1,0, 1, loop:0, trigger:recordtrig); // stutter

		// tape stop
		rate = EnvGen.kr(Env([1,1,tapelevel],[0,tapetime]), choosetrig);
		sig2 = PlayBuf.ar(2, buf, rate, choosetrig, loop:1);

		// stutter
		env = EnvGen.ar(Env([0,1,1,0],[attack, (1/stutter)-attack-decay, decay]), stuttrig);
		sig3 = PlayBuf.ar(2, buf2, 1, stuttrig, offset * BufFrames.kr(buf2), loop:1) * env;

		sig = SelectX.ar(choose.lag(0.1), [sig1, sig2, sig3]);
		//sig = Select.ar(choose, [sig1, sig2, sig3]);
		//sig = SelectX.ar(wet0, [in, sig]);
		sig;
	});

	Ndef(\fx).put(1000, \filter -> { arg in, amp=1, mix=1;
		var dry = InFeedback.ar(~bus,2);
		var sig;
		sig = in * amp;
		sig = SelectX.ar(mix, [dry, sig]);
		sig;

	});
    }
}).play;
	
);


//////////////////////////////////:




(
	//Ndef(~name+++\fx).play(BusDef(~name+++\mixer));
	Ndef(~name+++\fx).play;
	//Ndef(~name+++\mixer).parentGroup = ~get_mixer_group.();
	//Ndef(~name+++\mixer).play(0);
Veco(~name).lib.fxquant = 1/2;
Ndef(~name+++\fx).quant = Veco(~name).lib.fxquant;

~bus = BusDef(~name+++\fx, \audio);

~bufsize = 2;

	Ndef(~name+++\fx).put(0, {
		var in = InFeedback.ar(~bus,2);
		in;
	});



	Ndef(~name+++\fx).put(5, \filterIn -> { arg in, choose=0, time=2, tapetime=2, stutter=4, attack=0.001, decay=0.001, tapelevel=0.7,
					offset=0;
		var sig;
		var sig1,sig2,sig3,sig4,sig5;
		var buf = LocalBuf(~bufsize * s.sampleRate, 2);
		var buf2 = LocalBuf(~bufsize * s.sampleRate, 2);
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

		//recordtrig = Impulse.kr(1/time);
		timetrig = TDuty.ar(time / stutter, choosetrig + Changed.kr(time), 1);
		//recordtrig = recordtrig + Trig1.kr(choosetrig);
		//recordtrig = Trig1.kr(choosetrig, 1/stutter);
		recordtrig = Trig1.kr(choosetrig, 0.01) + timetrig;
		//recordtrig.poll;
		offset = TDuty.ar(Dseq([0.25],inf), Trig1.ar(choosetrig), 
			//Dseq([0,1/4,2/4,3/4],inf)
			Dseq([0,0,2,2,0,0,6,6]/8,inf)
		);

		RecordBuf.ar(sig, buf, loop:1, run:1, trigger:choosetrig); // tape stop
		RecordBuf.ar(sig, buf2, 0, 1,0, 1, loop:0, trigger:recordtrig); // stutter

		// tape stop
		rate = EnvGen.kr(Env([1,1,tapelevel],[0,tapetime]), choosetrig);
		sig2 = PlayBuf.ar(2, buf, rate, choosetrig, loop:1);

		// stutter
		env = EnvGen.ar(Env([0,1,1,0],[attack, (1/stutter)-attack-decay, decay]), stuttrig);
		sig3 = PlayBuf.ar(2, buf2, 1, stuttrig, offset * BufFrames.kr(buf2), loop:1) * env;

		sig = SelectX.ar(choose.lag(0.1), [sig1, sig2, sig3]);
		//sig = Select.ar(choose, [sig1, sig2, sig3]);
		//sig = SelectX.ar(wet0, [in, sig]);
		sig;
	});

	Ndef(~name+++\fx).put(1000, \filter -> { arg in, amp=1, mix=1;
		var dry = InFeedback.ar(~bus,2);
		var sig;
		sig = in * amp;
		sig = SelectX.ar(mix, [dry, sig]);
		sig;

	});
	
);


/////////////////////////



	//Ndef(\trapu, { SinOsc.ar(80) });
	Ndef(\chapi).quant = 1
(
	8.do {

	
	Ndef(\chapi).play;
	//Ndef(\trapu).play;
		Ndef(\chapi).put(0, {
			SinOsc.ar(100) ! 2
		});
		Ndef(\chapi).put(10, \filter -> { arg in;
			in * SinOsc.ar(90)
		});
		Ndef(\chapi).put(1000, \filter -> { arg in;
			in * SinOsc.ar(80)
		});
	}
)
Main.version

	Ndef(\chapi).quant = 1
(

	
	Ndef(\chapi).play;
	//Ndef(\trapu).play;
		Ndef(\chapi).put(0, {
			SinOsc.ar(100) ! 2
		});
		Ndef(\chapi).put(10, \filter -> { arg in;
			in * SinOsc.ar(90)
		});
		Ndef(\chapi).put(1000, \filter -> { arg in;
			in * SinOsc.ar(80)
		});
)

/////////////////////////

//Ndef(~name+++\fx).play(0);
(
	//Ndef(~name+++\fx).play(BusDef(~name+++\mixer));
	Ndef(~name+++\fx).play;
	//Ndef(~name+++\mixer).parentGroup = ~get_mixer_group.();
	Ndef(~name+++\mixer).play(0);
Veco(~name).lib.fxquant = 1/2;
Ndef(~name+++\fx).quant = Veco(~name).lib.fxquant;

~bus = BusDef(~name+++\fx, \audio);

~bufsize = 2;
	Ndef(~name+++\fx).put(0, {
		var in = InFeedback.ar(~bus,2);
		in;
	});



	Ndef(~name+++\fx).put(5, \filterIn -> { arg in, choose=0, time=2, tapetime=2, stutter=4, attack=0.001, decay=0.001, tapelevel=0.7,
					offset=0;
		var sig;
		var sig1,sig2,sig3,sig4,sig5;
		var buf = LocalBuf(~bufsize * s.sampleRate, 2);
		var buf2 = LocalBuf(~bufsize * s.sampleRate, 2);
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

		//recordtrig = Impulse.kr(1/time);
		timetrig = TDuty.ar(time / stutter, choosetrig + Changed.kr(time), 1);
		//recordtrig = recordtrig + Trig1.kr(choosetrig);
		//recordtrig = Trig1.kr(choosetrig, 1/stutter);
		recordtrig = Trig1.kr(choosetrig, 0.01) + timetrig;
		//recordtrig.poll;
		offset = TDuty.ar(Dseq([0.25],inf), Trig1.ar(choosetrig), 
			//Dseq([0,1/4,2/4,3/4],inf)
			Dseq([0,0,2,2,0,0,6,6]/8,inf)
		);

		RecordBuf.ar(sig, buf, loop:1, run:1, trigger:choosetrig); // tape stop
		RecordBuf.ar(sig, buf2, 0, 1,0, 1, loop:0, trigger:recordtrig); // stutter

		// tape stop
		rate = EnvGen.kr(Env([1,1,tapelevel],[0,tapetime]), choosetrig);
		sig2 = PlayBuf.ar(2, buf, rate, choosetrig, loop:1);

		// stutter
		env = EnvGen.ar(Env([0,1,1,0],[attack, (1/stutter)-attack-decay, decay]), stuttrig);
		sig3 = PlayBuf.ar(2, buf2, 1, stuttrig, offset * BufFrames.kr(buf2), loop:1) * env;

		sig = SelectX.ar(choose.lag(0.1), [sig1, sig2, sig3]);
		//sig = Select.ar(choose, [sig1, sig2, sig3]);
		//sig = SelectX.ar(wet0, [in, sig]);
		sig;
	});

	Ndef(~name+++\fx).put(1000, \filter -> { arg in, amp=1, mix=1;
		var dry = InFeedback.ar(~bus,2);
		var sig;
		sig = in * amp;
		sig = SelectX.ar(mix, [dry, sig]);
		sig;

	});
	
);
