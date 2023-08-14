
(
~t = ~t ?? { ~t = 1; TempoClock.default.tempo = ~t; ~t };
s.waitForBoot { FileSystemProject.load("sun/lib.scd"); };
)

// END


Document.current.path
(
[
"ddwCommon",
"wslib",
"crucial-library",
"Feedback",
"Modality-toolkit",
"Log",
"JITLibExtensions",
"WindowViewRecall",
"https://github.com/muellmusik/EQui",
].do { arg quark;
	Quarks.install(quark);
}
)
(..40)


(
Tdef(\bla, {
	SynthDef(\zed, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
		var sig;
		sig = SinOsc.ar(rrand(100,1000));
		sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
		sig = Pan2.ar(sig, pan, amp);
		Out.ar(out, sig);
	}).add;
	s.sync;
	Synth(\zed)
});
)

Tdef(\bla).play
Tdef(\bla).isPlaying

Quarks.install("https://github.com/madskjeldgaard/PolyBuf.git")


SampleTimeline(\bla).edit
{ SinOsc.ar(500) ! 2 * 0.1}.play;

b = BufFiles(s, "/tmp/sn/")

PathName("/tmp/sn").entries
PathName("/tmp/sn").entries[0].isFolder
PathName("/tmp/sn").entries[0].isFile
PathName("/tmp/sn").entries[0].pathMatch
String

(
SynthDef(\trig2, {
    arg in=0, out=0;
    var mic, amp, trig, timer, filteredTrig, tog;
    
    mic = SoundIn.ar(in);
	//mic.poll;
    trig = DetectSilence.ar(mic, 0.05, time:1);
	//trig.poll;
    filteredTrig = Changed.ar(trig);
	//filteredTrig.lagud(0,1).poll;
    SendTrig.ar(filteredTrig, 0, trig);
    //Out.ar(out, mic);
}).add;
Pdef(\part).reset;
)
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(\trig2,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);

(
o = OSCFunc({ arg msg, time;
	[time, msg].postln;
},'/tr', s.addr);
)


r = Routine({ "bla".yield }); 
r.next



(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = LFNoise1.ar(1/2).range(100,500);
	//sig2 = LFNoise1.ar(1/2).range(100,500);
	sig2 = sig.copy;
	sig = SinOsc.ar( [ sig, sig2 ]) ;
	//sig = SinOsc.ar( sig) ;
	sig = Pan2.ar(sig, [-1,1], amp).mean;
	//sig = Pan2.ar(sig, pan, amp);
}).play;
);

(\a: 1 + 2)




(
SynthDef(\duty, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod;
	mod = Duty.kr(1, 0, Dseq([
		0,3,4,7,
	].midiratio,inf))
	sig = SinOsc.ar(freq * mod);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

{ SinOsc.ar( Duty.kr(1/8, 0, Dseq([100,200,300],inf)) ) * 0.1 ! 2 }.play
{ SinOsc.ar( Duty.kr(1/8, 0, Dseq([100,200,300,1000],inf)) ) * 0.1 ! 2 }.play
{ SinOsc.ar( Duty.kr(1/2, 0, Dseq([100,200,300],inf)) ) }.play
{ SinOsc.ar(100!2) * 0.1 * EnvGen.kr(Env.perc(0.01,0.1), gate: TDuty.kr(1/8, 0, Dseq([1,0,0,1, 0,0,1,0],inf)))  }.play


(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = LFSaw.ar(freq);
	//sig = HPF.ar(sig, 1000);
	//sig = sig + LFSaw.ar(freq); 
	//sig = sig + LFSaw.ar(freq); 
	//sig = sig - SinOsc.ar(freq * [1,2],mul:[1,1/2]).mean;
	sig = Pan2.ar(sig, pan, amp);
}).play(BusDef(\sendbus1), 2);
);
Ndef(\zed).edit

(
Ndef(\zed2, { arg freq=80, pan=0, amp=0.1;
	var sig;
	sig = LFSaw.ar(freq);
	sig = sig - BPF.ar(LFSaw.ar(freq), 1000);
	//sig = HPF.ar(sig, 1000);
	//sig = sig + LFSaw.ar(freq); 
	//sig = sig + LFSaw.ar(freq); 
	//sig = sig - SinOsc.ar(freq * [1,2],mul:[1,1/2]).mean;
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\zed2, { arg freqbass=50, freq=50, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	//RandSeed.kr(1,1);
	//thisThread.randSeed = 18;
	sig = LFSaw.ar(freq * ( SinOsc.ar(LFNoise1.ar(10) * 356) * 4 + 1 ));
	sig = LFSaw.ar(freq * ( SinOsc.ar(freq) * 14 + 1 ));
	sig = LFSaw.ar(freq);
	//sig = LFPulse.ar(freq) * ( SinOsc.ar(freq) * 1 + 1 );
	sig = LFPulse.ar(freq);
	sig1 = SinOsc.ar(1050 * ( SinOsc.ar(210) * 10 * ( SinOsc.ar(30) * 0.1 + 1 ) + 1 )) ;
	sig1 = HPF.ar(sig1, 1000) * 0.1;
	sig = sig + sig1;
	//sig = LFPulse.ar(freq * rrand(0.3,1.3!3)).mean * 1;
	20.do {
		//sig = BRF.ar(sig, 8000 * rrand(0.4,1.2), 0.1);
		sig = MidEQ.ar(sig, exprand(300.0,12000), 0.1, -20);
	};
	sig = sig * 3;
	//sig = sig + LFSaw.ar(exprand(20.0,200!10),mul:4.6).mean;
	//sig = sig + HPF.ar(LFSaw.ar(6000!1 * ( LFNoise1.ar(6) * 0.1 + 1 ),mul:4.6).mean, 12000);
	//sig = LFSaw.ar([50,1500,6000]/4).mean;
	//sig = sig.clip2(0.01) * 30;
	//sig = LFSaw.ar(freq * [1,1.12]).mean;
	//sig = LFSaw.ar(freq * ( PinkNoise.kr * 8 + 1 ));
	//sig = LFSaw.ar( rrand(50.0,100!3) ).mean *3;
	sig = HPF.ar(sig, \hpf.kr(2000));
	sig = LPF.ar(sig, \lpf.kr(11000));
	sig = sig + ( SinOsc.ar(freqbass) ); 
	//sig = sig + LFSaw.ar(freq); 
	//sig = sig + LFSaw.ar(freq); 
	//sig = sig - SinOsc.ar(freq * [1,2],mul:[1,1/2]).mean;
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\zed2, { arg freqbass=50, freq=50, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	//RandSeed.kr(1,1);
	//thisThread.randSeed = 18;
	sig = LFSaw.ar(freq * ( SinOsc.ar(LFNoise1.ar(10) * 356) * 4 + 1 ));
	sig = LFSaw.ar(freq * ( SinOsc.ar(freq) * 14 + 1 ));
	sig = LFSaw.ar(freq);
	//sig = LFPulse.ar(freq) * ( SinOsc.ar(freq) * 1 + 1 );
	sig = LFPulse.ar(freq);
	sig1 = SinOsc.ar(1050 * ( SinOsc.ar(210) * 10 * ( SinOsc.ar(30) * 0.1 + 1 ) + 1 )) ;
	sig1 = HPF.ar(sig1, 1000) * 0.1;
	sig = sig + sig1;
	//sig = LFPulse.ar(freq * rrand(0.3,1.3!3)).mean * 1;
	20.do {
		//sig = BRF.ar(sig, 8000 * rrand(0.4,1.2), 0.1);
		sig = MidEQ.ar(sig, exprand(300.0,12000), 0.1, -20);
	};
	10.do {
		//sig = BRF.ar(sig, 8000 * rrand(0.4,1.2), 0.1);
		sig = MidEQ.ar(sig, exprand(300.0,2000), 0.1, 8);
	};
	sig = sig * 3;
	//sig = sig + LFSaw.ar(exprand(20.0,200!10),mul:4.6).mean;
	//sig = sig + HPF.ar(LFSaw.ar(6000!1 * ( LFNoise1.ar(6) * 0.1 + 1 ),mul:4.6).mean, 12000);
	//sig = LFSaw.ar([50,1500,6000]/4).mean;
	//sig = sig.clip2(0.01) * 30;
	//sig = LFSaw.ar(freq * [1,1.12]).mean;
	//sig = LFSaw.ar(freq * ( PinkNoise.kr * 8 + 1 ));
	//sig = LFSaw.ar( rrand(50.0,100!3) ).mean *3;
	sig = HPF.ar(sig, \hpf.kr(2000));
	sig = LPF.ar(sig, \lpf.kr(11000));
	sig = sig + ( SinOsc.ar(freqbass) ); 
	//sig = sig + LFSaw.ar(freq); 
	//sig = sig + LFSaw.ar(freq); 
	//sig = sig - SinOsc.ar(freq * [1,2],mul:[1,1/2]).mean;
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

Ndef(\zed2).edit

(
Ndef(\zed3, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\zed4, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = LFNoise2.ar(2000);
	sig = WhiteNoise.ar;
	sig = SinOsc.ar(1050 * ( SinOsc.ar(210) * 10 * ( SinOsc.ar(30) * 0.1 + 1 ) + 1 )) ;
	sig = HPF.ar(sig, 10000);
	//sig = BPF.ar(sig, 1000, 0.1) * 1;
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

Ndef(\zed3).edit


SampleTimeline(\bla).edit

SampleTimeline('bla').buffer
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec_onechan,
			\bufnum, SampleTimeline('bla').buffer,
			\chan, 0,
			\legato, 1,
			\pos, 3.3,
			\hpf, 0,
			\dur, 1/2,
			\gain, 1,
		)
		
	])
)).play;
);

(
SynthDef(\playersec_onechan, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, speed=1, pos=0, doneAction=2, loop=0, trigger=1, velamp=1;
	// pos in seconds
	var sig;
	var sig1;
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufSampleRate.kr(bufnum)), doneAction:doneAction, loop: loop);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.001,0,1,0.01)),gate,doneAction:doneAction);
	sig = SelectX.ar(\chan.kr(0), sig);
	sig = HPF.ar(sig, \hpf.kr(350));
	sig = Pan2.ar(sig, pan, 1);
	Out.ar(out, sig * \gain.kr(1) * velamp);
}, metadata:(specs:(
	bufnum: ParamAudioBufferSpec()
		.startParamName_(\pos)
		.numChannels_(2)
		.startType_(\seconds)
		.sustainType_(\beats)
		.sustainParamName_(\sustain)
		.speedParamName_(\speed),
	pos: ControlSpec(0,20,\lin),
	\velamp: \unipolar.asSpec,
))).add;
)

(
var synth16 = {
    var freq = [48, 49];
    var freq2 = 48 * 32;
    var gate1 = LFDClipNoise.ar(11);
    var gate2 = LFDNoise0.ar(11);
    var mul1 = Env.perc.ar(0, gate1);
    var mul2 = Env.perc.ar(0, gate2);
    
    var soundA = { [SinOsc.ar(freq, mul:mul1), SinOsc.ar(freq, mul:mul2)] * 0.3 };    
    var soundB = { [Saw.ar(freq * 16, mul:mul1), Saw.ar(freq * 16, mul:mul2)] * 0.3 };    
    var soundC = { [Pulse.ar(freq2, mul:mul1), Pulse.ar(freq2, mul:mul2) ] * 0.3 };
    
    var out = soundA + soundB + soundC;
    
    out = FreeVerb.ar(out) + out;
    out = CombC.ar(out) + out;
    out = out * 0.3;
    out;
};
synth16.play;
)

(
Ndef(\hummer, { arg freqbass=50, freq=50, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	//thisThread.randSeed = 18;
	sig = LFSaw.ar(freq);
	sig = LFPulse.ar(freq);
	20.do {
		//sig = BRF.ar(sig, 8000 * rrand(0.4,1.2), 0.1);
		sig = MidEQ.ar(sig, exprand(300.0,12000), 0.1, -20);
	};
	sig = sig * 3;
	sig = HPF.ar(sig, \hpf.kr(7000));
	sig = LPF.ar(sig, \lpf.kr(11000));
	sig = sig + ( SinOsc.ar(freqbass) ); 
	sig = Pan2.ar(sig, pan, amp);
}).play;
);


s.scope

Synth(\default).plot(1)


(
SynthDef(\zed, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq).scope;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play();
);

s.freqscope


(
Ndef(\zed, { arg freq=500, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar( LFPulse.ar(1/16,1/2+0.45).range(200,1200).lag(8) * rrand(0.5,1.5!10) ).mean;
	sig = Pan2.ar(sig, pan, amp);
}).play;
);


"python3 -c \"print(%**(2**%))\"".format(5,4).unixCmdGetStdOut.drop(-1).as(Array).collect(_.digit)
"python3 -c 'print(123)'".unixCmdGetStdOut



~seq = "python3 -c \"print(%**(2**%))\"".format(5,9).unixCmdGetStdOut.drop(-1).as(Array).collect(_.digit)


Pd



//sound recipe, required

SynthDef(\testbleep,{ Out.ar(0,Pan2.ar(Line.kr(1,0,0.1,doneAction:2)*SinOsc.ar(440)*0.1,0.0))}).add;



//no use of latency, immediate, timing slightly more ragged


(

{

    inf.do {|i|    

        Synth(\testbleep); 

        [0.5,0.25,0.02,0.02].wrapAt(i).wait; 

    }    

}.fork;

)




(

{

    inf.do {|i|

        s.bind {  Synth(\testbleep); };  

        //[0.5,0.25,0.02].wrapAt(i).wait; 
        [0.5,0.25,0.02,0.02].wrapAt(i).wait; 

    }    

}.fork;

)


BufDef("/home/ggz/tmp/vin7.ogg")

(
SynthDef("mktestt", {arg freq = 440;
    var sig, env, gate;
    gate = Impulse.kr(0);
    env = Env.adsr(0.01, 0.03, 0.7, ExpRand(0.1,1.9).poll).ar(Done.freeSelf, gate);
    sig = SinOsc.ar(freq);
    sig = sig * env;
    //sig = AnalogChew.ar(sig,ExpRand(0.3,0.8),1,0.5);
    sig = FreeVerb.ar(sig,0.2,0.9);
    sig = sig.dup * 0.2;
    Out.ar(0, sig);
}).add;

)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \mktestt,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);


~synthdef_object = SynthDef(\test, { }).add;
~synthdef_object = SynthDescLib.global.at(\test).def;

(
SynthDef(\test, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);



~synth = Synth(\test)
Synth(\test, [\freq, Ndef(\lfo1, { XLine(51, 1000) })])
~synth.set(\freq, Ndef(\lfo1, { XLine.kr(51, 1000) }))




(
SynthDef(\modenvlag, { arg out=0, amp=0.1, gate=1;
	var sig;
	var prev = In.kr(out);
	sig = EnvGen.kr(Env([prev,prev,\target.kr],[0,\time.kr]), gate, doneAction:2);
	Out.kr(out, sig);
}).add;
)

~synth = Synth(\test); // launch synth
~cbus = ~cbus ?? { Bus.control(s,1).set(100) }; // create bus
~synth.set(\freq, ~cbus.asMap); // map bus
~cbus.set(1000); // set bus manually
Synth(\modenvlag, [\out, ~cbus, \target, 100, \time, 1]); // start ramping to 100 in 1 second
Synth(\modenvlag, [\out, ~cbus, \target, 200, \time, 1])


thisProcess.stop
thisProcess.recompile




(
SynthDef(\loopenv, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.kr( Env([0]), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);


(
SynthDef(\seqTest, {
    var snd, env, envFreq, seq, trig;
    seq = TDuty.ar(Dseq( [4.0,4.0], inf));        
	trig = 1;
    envFreq = Env([0,1.0,0.0,0.5,0.0],[0,90,30,10].normalizeSum * 2, \lin, 3, 0).ar(gate:trig, doneAction: Done.none);
    snd = SinOsc.ar( 400 + (envFreq * 1000));
    Out.ar(0, snd ! 2);
}).add
);

Synth(\seqTest);

(
SynthDef(\seqTest, { arg timeScale=1, trigRate=4;
    var snd, env, envFreq, seq, trig;
	var phase;
    seq = TDuty.ar(Dseq( [4.0,4.0], inf));        
	trig = Impulse.kr(trigRate);
	phase = Phasor.ar(trig, rate:timeScale/SampleRate.ir,start:0,end:1);
	envFreq = IEnvGen.kr(Env([0,1.0,0.0,0.5,0.0],[0,90,30,10].normalizeSum , \lin), index:phase);
    snd = SinOsc.ar( 400 + (envFreq * 1000));
	snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(0.1));
    Out.ar(0, snd);
}).add;
Ndef(\bla, \seqTest).play;
);


(
Ndef(\hoo, {
		var sin = SinOsc.ar(440, 0, MouseX.kr(0, 1));
	// use offset so negative values of SinOsc will map into the Env
	var env = Env([-1, -0.7, 0.7, 1], [ 0.8666, 0.2666, 0.8668 ], \lin, offset: -1.0);
	IEnvGen.ar(env, sin) * 0.1 
}).play;
)

(
Ndef(\zzz, { arg freq=200, pan=0, amp=0.1, timeScale=1, trigRate=2.2;
	var sig;
	var trig, phase;
	var endpos, startpos;
	var seqlvl = [3,2,3,2,0,1,0,10];
	//seqlvl = [0,0,0,10];
	trig = Impulse.kr(trigRate);
	startpos = Demand.kr(trig, 0, Dseq(seqlvl,inf));
	endpos = Demand.kr(trig, 0, Dseq(seqlvl.rotate(-1),inf));
	phase = Phasor.ar(1, rate:(endpos - startpos) * trigRate/SampleRate.ir,start:startpos,end:endpos, resetPos:startpos);
	startpos.poll(label:"startpos");
	endpos.poll(label:"endpos");
	phase.poll(label:"phase");
	//[startpos, endpos, phase].poll(label:["phase","ss"]);
	Out.kr(BusDef(\bla), phase);
	sig = SinOsc.ar(freq * ( phase + 1 ));
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

BusDef(\bla, \control, 1).plot(6)
(0..12).rotate(-1)


(
Ndef(\zzz, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var phase;
	var seqlvl = [3,2,3,2,0,1,0,10];
	var seqbuf = LocalBuf.newFrom(seqlvl);
	var mod;
	phase = Phasor.ar(1, rate:1/SampleRate.ir,start:0,end:seqlvl.size-1);
	//phase.poll(label:"phase");
	mod = IndexL.ar(seqbuf, phase );
	mod.poll(label:"mod");
	Out.kr(BusDef(\bla), mod);
	sig = SinOsc.ar(freq * ( mod + 1 ));
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\zzz, { arg freq=200, pan=0, amp=0.1, seqbuf;
	var sig;
	var phase;
	//var seqlvl = [3,2,3,2,0,1,0,10];
	//var seqbuf = LocalBuf.newFrom(seqlvl);
	var mod;
	phase = Phasor.ar(1, rate:1/SampleRate.ir,start:0,end:BufSamples.kr(seqbuf)-1);
	//phase.poll(label:"phase");
	mod = IndexL.ar(seqbuf, phase );
	mod.poll(label:"mod");
	Out.kr(BusDef(\bla), mod);
	sig = SinOsc.ar(freq * ( mod + 1 ));
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

BufDef(\seq2, 10, 1)

(
WindowDef(\win, { arg def;
	var buf = BufDef(\seq2);
	MultiSliderView.new.action_({
		buf.setn
		
	});
	Param(buf, \val).asView;
	
}).front;
);


(

SynthDef(\test, {
    var steps = \steps.kr(0.1!5);
    var rytm = TDuty.ar(Dseq(steps.normalizeSum * 0.5, inf));
    var value = Demand.ar(rytm, 0, Dseq([8, 2, 1, 8, 5], inf));

    Out.ar(0, SinOsc.ar( (60 + value).midicps));
}).add;

Synth(\test, [
    steps: [0.2,0.2,0.2,0.5,0.5], 
])

);


(

SynthDef(\test, {
    var steps = \steps.kr(0.0!16);
    var size = \size.ir(1);
    var rytm = TDuty.ar(Dseq(Dser(steps,size),inf) * 2, inf);
    var value = Demand.ar(rytm, 0, Dseq([0, 2, 4, 8, 10], inf));

    Out.ar(0, SinOsc.ar((60 + value).midicps) * -20.dbamp ! 2);
}).add;

Synth(\test, [
    size: 5,
    steps: [1,4].normalizeSum,
])

);

