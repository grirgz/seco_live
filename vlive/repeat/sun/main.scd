
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

Quarks.checkForUpdates({Quarks.install("SuperDirt", "v1.7.3"); thisProcess.recompile()})


Synth(\default)

[1] ++ [2,3]
[1] ++ 2

~scalesBuffers = [];

~mothra = { | mode 0 offset 36 |
    var modes = [
        Tuning.new(#[ 0, 2.31, 4.64, 6.98, 9.29, 11.68 ]),
        Tuning.new(#[ 0, 2.31, 4.64, 6.98, 9.29, 9.68 ]),
        Tuning.new(#[ 0, 2.31, 4.64, 6.98, 7.35, 9.68 ]),
        Tuning.new(#[ 0, 2.31, 4.64, 5.03, 7.35, 9.68  ]),
        Tuning.new(#[ 0, 2.31, 7.21, 5.03, 7.35, 9.68 ]),
        Tuning.new(#[ 0, 0.39, 7.21, 5.03, 7.35, 9.68 ]),
    ];
    modes.do { |mothra|
        var scale = Scale([0,1,2,3,4,5], 6, mothra).cents / 100;

        ~scalesBuffers = ~scalesBuffers ++ Buffer.loadCollection(s, [0,1,2,3]);
    };
    ~scalesBuffers;
};

~mothra.value()[0].postln;
~scalesBuffers


// in the style of Autechre - Mirrage
// https://www.youtube.com/watch?v=rXQ9sNRcHYE

(
{
	var note, snd, delaytime, damp, size, diff, feedback, localout;
	note = Demand.kr(Impulse.kr(0) + Dust.kr(0.1), 0, Diwhite(60, 80, inf));
	delaytime = Demand.kr(Impulse.kr(0) + Dust.kr(0.3), 0, Dwhite(0.1, 0.3, inf));
	damp = Demand.kr(Impulse.kr(0) + Dust.kr(0.4), 0, Dwhite(0.2, 0.6, inf));
	size = Demand.kr(Impulse.kr(0) + Dust.kr(0.3), 0, Dwhite(2, 10, inf));
	diff = Demand.kr(Impulse.kr(0) + Dust.kr(0.2), 0, Dwhite(0.5, 1.0, inf));
	feedback = Demand.kr(Impulse.kr(0) + Dust.kr(0.4), 0, Dwhite(0.8, 1.0, inf));
	snd = SinOsc.ar(freq: [note, note+LFNoise1.kr(freq: 0.1).range(-0.25, 0.25)].midicps);
	localout = Mix.ar(5.collect({ |i|
		Pan2.ar(
			in: Greyhole.ar(in: PitchShift.ar(in: snd, pitchRatio: i), delayTime: delaytime, damp: damp, size: size, diff: diff, feedback: feedback, modDepth: 0.1, modFreq: 5),
			pos: LFNoise1.ar(freq: TRand.ar(10.reciprocal, 1, Impulse.kr(8.reciprocal))).range(-1,1),
			level: (i+1).reciprocal
		) * -20.dbamp;
	}));
	localout = Compander.ar(in: localout, control: localout, thresh: -6.dbamp, slopeAbove: 3.reciprocal);
	LocalOut.ar(localout);
	snd = LocalIn.ar(2);
	snd.tanh;
}.play;
)



Quarks.install("https://github.com/madskjeldgaard/plugins.quark")
Plugins.gui

AnalogBassDrum


(
Ndef(\stormofkicks, { 
    var trig = Impulse.kr(1);
    var sig = AnalogBassDrum.ar(
        trig, 
        infsustain: 0.002, 
        accent: 0.05, 
        freq: Duty.kr(1/~t, 0, Dseq([
        	30,32,25,28
        ].midicps,inf)),
        //tone: TRand.kr(0.05,0.2,trig), 
        tone: 0.01,//TRand.kr(0.5,1.0,trig), 
        decay: 20.05, 
		attackfm: 0.0001,//TRand.kr(0.1,1.0,trig),
        //attackfm: TRand.kr(0.001,0.1,trig),
        //selffm:TRand.kr(0.0,3.1,trig) 
    ) * 13;

    Pan2.ar(sig, TRand.kr(-1.0,1.0,trig));
}).play;
)
NonlinearFilter


// Lowpass with ahypsin saturation
(
{
    var freq=550, q=0.5, gain=1, shape=5, saturation=4;
    var sig = PinkNoise.ar();
    NonlinearFilter.ar(sig, freq.poll, q, gain, shape, saturation)!2 * 0.5;
}.play
)

// Highpass with hard saturation
(
{
    var freq=1000, q=0.5, gain=1, shape=4, saturation=1;
    var sig = PinkNoise.ar();
    NonlinearFilter.ar(sig, freq.poll, q, gain, shape, saturation)!2 * 0.5;
}.play
)

// Fucked up EQ:
// Bell shape filter with hyptan saturation
(
{
    var q=0.95, gain=7, shape=0, saturation=3;
    var sig = PinkNoise.ar();
    var freq = SinOsc.kr(0.1).exprange(100.0,5500.0).poll;
    NonlinearFilter.ar(sig, freq.poll, q, gain, shape, saturation)!2 * 0.5;
}.play
)

// Notch shape filter with ahypsin saturation
(
{
    var q=0.95, gain=7, shape=1, saturation=4;
    var sig = PinkNoise.ar();
    var freq = SinOsc.kr(0.1).exprange(100.0,5500.0).poll;
    NonlinearFilter.ar(sig, freq.poll, q, gain, shape, saturation)!2 * 0.5;
}.play
)
PhasorModal
(
	Ndef(\phasormodal, { |pitchstretch=(-0.1), f0=80|
		var amountVoices = 32;

		var sig = Splay.ar(
			Array.fill(amountVoices, {|i|
				PhasorModal.ar(
					LPF.ar(Dust2.ar(i+1 / 3.0), 1500), 
					freq: (i+1)*(pitchstretch+1)*f0, 
					decay: rrand(0.225,0.35), 
					damp: 1.0, 
					amp: LFNoise2.kr(1).range(0.25,0.45), 
					phase: 0

				);
			}).scramble, 
			spread: LFNoise2.kr(0.1).unipolar,
			center: 0
		);

		sig
	}).mold(2).play

)

Rongs

(
Ndef(\c, {|pan=0.0, trigfreq=4|
    var trig = Dust2.kr(trigfreq);

    var sig = Rongs.ar(
        trig,
        sustain: trig,
        f0: TExpRand.kr(50.0,500.0, trig),
        structure: TRand.kr(0.0,0.99,trig),
        brightness: TRand.kr(0.6,0.99,trig),
        stretch: TRand.kr(0.1,0.99,trig),
        damping: 0.5,
        //damping: TRand.kr(0.5,0.85, trig),
        accent: 0.99,
        loss: 0.1
    );

    Splay.ar(LeakDC.ar(sig), spread: 0.25, center: pan);
}).play;
)

// Want more mayhem?
(

Ndef(\c).copy(\c2).set(\pan, 0.285).play;
Ndef(\c).copy(\c3).set(\pan, (-0.2855285)).play;
)

// A synth def
(
SynthDef.new(\rongsinator, {|out, amp=0.25, pan=0, sustainTime=0.01, f0=100.05, structure=0.5, brightness=0.5, damping=0.75, accent=0.9, harmonicstretch=0.5, position=0.15, loss=0.15|
    var trig = Trig.kr(1, dur: sustainTime);

    var modeNum=2, cosFreq=0.025;
    var sig = Rongs.ar(
        trigger:trig,
        sustain:trig,
        f0:f0,
        structure:structure,
        brightness:brightness,
        damping:damping,
        accent:accent,
        stretch:harmonicstretch,
        position:position,
        loss:loss,
        modeNum:modeNum,
        cosFreq:cosFreq
    );

    DetectSilence.ar(in: sig, amp: 0.0001, time: 0.1, doneAction: 2);
    sig = Pan2.ar(sig, pan);
    Out.ar(out, sig);
}).add;
)

// Trig it once
Synth(\rongsinator, [\damping, 0.5])

// Play pattern
(
Pdef('🌻',
    Pbind(
        \instrument, \rongsinator,
        \amp, 0.20,
        \pan, Pwhite(-1.0,1.0),
        \f0, Pwhite(100,500),
        \dur, 0.125,
        \structure, Pseg([0.1,1.0], 5, \lin, inf),
        \brightness, 0.5,
        \damping, Pseg([0.65,0.30], 13, \lin, inf),
        \accent, 0.69,
        \harmonicstretch, 0.0151,
        \position, Pseg([0.6,0.0], 8, \lin, inf),
        \loss, 0.15,
        \modeNum, 3,
        \cosFreq, 0.15,
    )
).play
)

VosimOs


~s = Pseq((1..10),inf).asStream;
~s.value
~s

Pchain

~e = (bla: Pseq((1..10),inf).asStream).asStream
~e = (bla: Pseq((1..10),inf)).asStream
~e.next((bla:1))

p = Pseq([
 (note: 0, dur: 0.5),
 //(note: 2, dur: 0.75),
 //(note: 3, dur: 0.25),
], inf);
x = (p <> (ctranspose: Pseq([-12, 0, 12], inf).asStream)).trace.play;


~x = (freq: 1000)
~x.play
~x.next
~x

~x = (freq: Prand([200,1000]))
~x = (freq: Prand([200,1000],inf).asStream)
~x = (freq: Prand([200,1000],inf).asStream).asStream

~x = Pseq([ (freq: Prand([200,1000],inf).asStream) ],inf);
~x = Pseq([ (freq: Pseq([200,1000],inf)) ],inf);


p = Pbind(\note, 0);
x = (p <> (ctranspose: Pseq([-12, 0, 12], inf).asStream)).trace.play;
~s = (p <> (ctranspose: Pseq([-12, 0, 12], inf).asStream))
~s = (p <> (ctranspose: Pseq([-12, 0, 12], inf).asStream)).asStream
~s.next.play


(
	var freq1 = rrand(200,400);
	var freq2 = freq1 * 1.5;
	var freq3 = freq2 * 2.25;
	{LFPulse.ar(100)}.play;
	{LFPulse.ar(100)}.play;
	{LFPulse.ar(100)}.play;
)

(
var freq1 = rrand(200,400);
var freq2 = freq1 * 1.5;
var freq3 = freq2 * 2.25;
{LFPulse.ar([freq1,freq1],0,MouseX.kr(0.5,0.125),MouseY.kr(0,0.33))}.play;
{LFPulse.ar(100,0,MouseX.kr(0.5,0.125),MouseY.kr(0,0.33))}.play;
{LFPulse.ar(100)}.play;
)

"\033[2J]".postln
27.asAscii
"%[2J".format(27.asAscii).postln
0x33

(
	var freq1 = rrand(200,400);
	var freq2 = freq1 * 1.5;
	var freq3 = freq2 * 2.25;
	{LFPulse.ar([freq1,freq1],0,MouseX.kr(0.5,0.125),MouseY.kr(0,0.33))}.play;
	{LFPulse.ar([freq2,freq2],0,MouseX.kr(0.5,0.125),MouseY.kr(0,0.33))}.play;
	{LFPulse.ar([freq3,freq3],0,MouseX.kr(0.5,0.125),MouseY.kr(0,0.33))}.play;
)
// 310


(
var freq1 = rrand(200,400);
var freq2 = freq1 * 1.5;
var freq3 = freq2 * 2.25;
{LFPulse.ar(freq:[freq1,freq1],width:MouseX.kr(0.5,0.125),mul:MouseY.kr(0,0.33))}.play;
{LFPulse.ar(freq:[freq2,freq2],width:MouseX.kr(0.5,0.125),mul:MouseY.kr(0,0.33))}.play;
)
// 255

(
	"hello this is long line to test char limit, why oh why it doesn't work, please tell me why this error".postln;
	"hello this is long line to test char limit, why oh why it doesn't work, please tell me why this error".postln;
	"hello this is long line to test char limit, why oh why it doesn't work, please tell me why this error".postln;
)



(
{
    var volume, input;
    
    volume = Select.kr(MouseX.kr < 0.2, [0, (MouseX.kr - 0.2) / 0.8]);
    
    input = ((PinkNoise.ar * (1 - volume)) + (BrownNoise.ar * volume))*0.3;

    (Pan2.ar(input));

}.play
)


(
SynthDef.new(\singat2,
    {
        arg freq=440, amp=0.5, pos=0,
        
        num=2, wid=0.4;
        var snd;

        snd = SinOsc.ar(463, pi/2);


		snd = snd * LFPulse.kr(444, 0.3).poll;
		snd = snd * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), \gate.kr(1), doneAction:2);
        snd = Pan2.ar(snd, pos, amp);
        Out.ar(0, snd);
}).add;
)
~s = Synth.new(\singat2);
~s.release
~s.stop
~s.free
~s.release
Synth.new(\singat2);
1/0
sqrt(-2)


(
SynthDef.new(\singat,
    {
        arg freq=440, c=24, r=0.5, amp=1;
        var snd;

        snd = SinOsc.ar(463, pi/2);


        snd = Compander.ar(snd, snd, Pulse.kr(12, 0.3).abs+0.1, 10, 2, c, r);

        Out.ar(0, snd);
}).add;
)

Synth.new(\singat, [\c, rrand(1, 44), \r, rrand(0.1, 1.7)]);


// https://audio-video.gnu.org/video/stallman_free_software_song_320x240.ogv

(

// Free(hack).share(us.join[now]);
SynthDef(\iGNUcius, {
    var 
        freq, amp, 
                  gate, osc, 
                                lfo, out, 
                                            aenv, filterEnv, 
                                                       bus, resoFilter, 
                                                                      bowNoise;
    
   // [hackers]:free.be(ll), you!help(software).share;
    freq = \freq.kr(440);
    amp = \amp.kr(0.5);
    gate = \gate.kr(1);
    bus = \bus.kr(0);
    
    // piles.of(can.get)hoarders.money,is[true];
    osc = Pulse.ar([freq, freq*2], LFNoise1.kr(0.5!2).range(0.1, 0.9)) +
          Pulse.ar([freq*3, freq], LFNoise1.kr(0.5!2).range(0.1, 0.9));

    // neighbors.their(help).but!cannot; true.is[that];
    lfo = SinOsc.kr(\lfoFreq.kr(0.5)).range(-0.05, 0.05) * \lfoDepth.kr(1);
    bowNoise = WhiteNoise.ar(0.15) * EnvGen.kr(Env.perc(0.01, 0.1), gate); 

    // enough(when).software.free.have[we], call.our[at];
    out = (osc + bowNoise) * (1 + lfo);
    aenv = EnvGen.ar(Env.adsr(0.05, 0.2, 0.9, 0.5), gate, doneAction: Done.freeSelf) * amp;
    filterEnv = EnvGen.kr(Env.adsr(0.01, 0.3, 0.7, 0.5), gate);

    // dirty.those(licenses).kick[we'll] out.ever.more;
    resoFilter = RLPF.ar(out, freq * \filterMul.kr(4) * filterEnv, \resonance.kr(0.4));
    out = RHPF.ar(resoFilter, 100) * aenv;

    // be.free, hackers.you'll.join(us).now[and];
	Out.ar(bus, DFM1.ar(out));
    //Out.ar(bus, out);
}).add;

)

(
// software.free.and.share(us.join[now]);
p = Pbind(
    \instrument, \iGNUcius,
    \octave, Prand([2, 3], inf),
    
    // call.at[hackers].our, have(we).free;
    \degree, Pseq([2, 1, 0, -1, 0, 1, 0, -1, -2, -2, -1, 0, 1, 0, 2, -1, -1, 2, 1, 0, 2, 1, 0, -1, 0, 1, 0, -1, -2, -2, -1, 0, 1, 0, 2, -1, -1, -1], inf),
    \dur, Pseq([0.5, 0.25, 0.5, 0.5, 0.5, 0.25, 0.25, 0.25, 0.5, 0.75, 0.75, 0.25, 0.75, 0.5, 0.5, 0.75, 1.5, 0.5, 0.25, 1, 0.5, 0.25, 0.5, 0.5, 0.5, 0.25, 0.25, 0.25, 0.5, 0.75, 0.75, 0.25, 0.75, 0.5, 0.5, 0.75, 1.25, 1.5], inf)
);

// be.free[hackers].you'll.share(software).join;
p.play;
)
1/0.75
1/1.5


(
{

	2.do{
		{BPF.ar (WhiteNoise.ar, [73,81].midicps, 1e-4, Env.sine(10,50).kr(2)).sum!2}.play; gauss (7,0.2).wait;
		{BPF.ar (WhiteNoise.ar, [71,80].midicps, 1e-4, Env.sine(10).kr(2)).sum!2*50}.play; gauss (7,0.2).wait;
		{BPF.ar (WhiteNoise.ar, [69,78].midicps, 1e-4, Env.sine(10).kr(2)).sum!2*50}.play; gauss (7,0.2).wait;
		{BPF.ar (WhiteNoise.ar, [68,80].midicps, 1e-4, Env.sine(10).kr(2)).sum!2*50}.play; gauss (7,0.2).wait;
}
}.fork
)




(
Pdef(
		\mySound,
		Pbind(
					\dur, Pn(Plazy({ ~myRhythmValues  }))
						
		)

).play
)

~myRhythmValues = Pseq( [0.1,0.1,0.1], 1);
~myRhythmValues = Pseq( [1,1,1,1], 1);
~myRhythmValues = 1
  

(
Pdef(
		\mySound,
		Pbind(
					\degree, Pn(Plazy({ ~myRhythmValues  }))
						
		)

).play
)


(
SynthDef(\zed, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var input;
	input = MouseX.kr(50,200) * MouseButton.kr(0,lag:0);
	//input = Gate.kr(DelayL.kr(input,0.2,0.01), input > 10.1);
	input = Gate.kr(input, input > 0);
	input.poll;
	sig = SinOsc.ar(input);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\zed).reset;
);

(
Pdef(\zed, 
	Pmono(
		 \zed,
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);


{ MouseButton.kr }.plot(2)


(
~infSeries = {
   |n|
   // Return the nth value in Noergaard's infinity series.
   // More info: https://oeis.org/A004718
   if(n <= 0){
      0
   }{
      if(n.asInteger.even){
         ~infSeries.value(n / 2) + -1
      }{
         ~infSeries.value(n - 1 / 2) + 1
      }
   }
};
)

~infSeries.(1024)
~infSeries.dup(1024)
.set


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\count, Pseries(0,1,1000),
			\degree, Pfunc({ arg ev;  ~infSeries.(ev[\count])}),
			\octave, 4,
			\dur, 1/4,
			\amp, 0.1,
		),
		
	])
)).play;
);

Pdef.defaultQuant


(
Ndef(\soundin, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SoundIn.ar([0,1]);
	sig = sig * \gain.kr(1);
	//sig = sig * ( LFSaw.kr( LFNoise0.kr(1).unipolar * 5600 ) * 1 + 1 );
}).play(BusDef(\soundin, \audio, 2).index, 2);
);
Ndef(\soundin).play(0,2)
Ndef(\soundin).edit;
{ SinOsc.ar(500) ! 2 * 0.1}.play;


48.90.midicps == 137.79
53.70.midicps == 181.81
56.45.midicps == 213.12

( [48,53,56]%12+10 ).midiratio * 77

(
~list = [
[ 0.0077703297138214, 48.910087585449  ],
[ 0.017483713105321, 53.690689086914  ],
[ 0.020635280758142, 61.197845458984  ],
[ 0.023812716826797, 53.585838317871  ],
[ 0.023903254419565, 61.478565216064  ],
[ 0.025951128453016, 61.263679504395  ],
[ 0.026071844622493, 57.730617523193  ],
[ 0.026369325816631, 56.46821975708  ],
[ 0.030202079564333, 48.893745422363  ],
[ 0.03471602126956, 46.843811035156  ],
[ 0.034953143447638, 45.754936218262  ],
[ 0.035043682903051, 46.526725769043  ],
[ 0.038160759955645, 56.449726104736  ],
[ 0.041251968592405, 48.911476135254  ],
[ 0.042825598269701, 45.746288299561  ],
[ 0.052508804947138, 48.907501220703  ],
];
)

~x = ~list.collect({ arg x; x[1]*5 })
48.90/5
53.70/5

11.1 5.4
11.1 * x = int(y)
:wc


Event.partialEvents
Event.parentEvents.keys
Event.partialEvents[\mypartial] = (\sp: { arg self; self.debug("self"); 444 })

~de = Event.parentEvents.default
~de[\buf] = { [~sp, ~n].debug("should return a buffer"); 0 }
Event.parentEvents.default[\freq].asCompileString
Event.parentEvents.default[\sp].asCompileString

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \bla,
			\sp, 123,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
SynthDef(\bla, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, buf;
	var sig;
	sig = SinOsc.ar(buf.poll);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);


(
Tdef(\bla, { arg ev;
	loop { 0.5.wait;
		(instrument: 'default', sustain: 2, octave: [3,3.99]-1, note: [7, 3, 0, 5].choose, out:ev[\out]).play;
		0.5.wait;
		(instrument: 'default', sustain: 2, octave: [4,3.99]-1, note: [5, 12, 12+5, 12+7].choose, out:ev[\out]).play;
		1.wait;
	};
})
)
Tdef(\bla).play
Tdef(\bla).set(\out, BusDef(\bla, \audio, 2))

~mybus
(
Ndef(\foo, { InFeedback.ar(\inbus.kr(BusDef(\bla, \audio)), 2);  }).play;
);
~y[10] = \filter -> {arg in; JPverb.ar(in, size: 20)};
Ndef(\foo)[10] = \filter -> {arg in; JPverb.ar(in, size: 20)};
~y.set(\wet10, 1);

~myfxbus = BusDef(\bla, \audio)
Ndef(\foo, { InFeedback.ar(\inbus.kr(~myfxbus), 2);  }).play;
Ndef(\foo)[10] = \filter -> {arg in; JPverb.ar(in, size: 20)};

Ndef(\foo, { In.ar(\inbus.kr(~myfxbus), 2);  }).play;
Ndef(\foo)[10] = \filter -> {arg in; JPverb.ar(in, size: 20)};






// -- SynthDefs --
(
SynthDef(\beep, {
    arg amp;
    var sig, env;

    sig = 4.collect({ |i|
        FSinOsc.ar(i.linlin(0,3,800,1400, 80));
    });

    sig = RLPF.ar(sig, 400);

    env = EnvGen.kr(
        Env.perc(),
        \gate.kr(1),
        doneAction:2,
    );

    sig = sig * env;
    sig = RLPF.ar(sig, 400);

    sig = sig * amp;
    Out.ar(0, sig!2);
}).add;
// Synth(\beep, [\amp:1.75]);

SynthDef(\error, {
    arg amp=0.5, freq=200;
    var sig, env;

    sig = LFTri.ar(freq);
    sig = sig + LFPar.ar(freq-(7.midicps));

    env = EnvGen.kr(
        Env.perc(),
        \gate.kr(1),
        doneAction:2,
    );

    sig = RLPF.ar(sig, 900);
    sig = sig *env;
    sig = sig * amp;

    Out.ar(0, sig!2);
}).add;
// Synth(\error);

SynthDef(\inc, {
    arg amp, freq=200;
    var sig, env;

    sig = LFTri.ar(freq);

    env = EnvGen.kr(
        Env.asr(0,1,0),
        \gate.kr(1),
        doneAction:2,
    );

    sig = RLPF.ar(sig, 200);

    Out.ar(0, sig!2);
}).add;
// Synth(\inc);
)
// -- main fun --
(
// window dimensions for function calculation
var left=1400, top=500, width=500, height=500;
Window.closeAll;
w = Window.new(
    "sc-win: Function plotter",
    Rect(1400,500,500,500),
    resizable: false,
).front;

u=UserView.new(w, w.view.bounds)
.background_(Color.gray(0.1));

~count=0;
~continue=0;
~finalpoint;
~inc_synth=Synth(\inc,[freq:200]);
u.drawFunc_({

    var target = 415@85;
    var x, y;


    Pen.width_(4);

    //- draw target -
    Pen.moveTo(target);
    Pen.lineTo(target - (0@1));
    Pen.moveTo(target);
    Pen.lineTo(target + (1@(-1)));
    Pen.moveTo(target);
    Pen.lineTo(target - (1@(-1)));
    Pen.moveTo(target);

    Pen.strokeColor_(Color.new(1, 1, 1, 1));
    Pen.stroke;

    if(~continue==0) // -- step 1 -- (getting to final point)
    {
        x = ~count;
        y = top - ~count;



        //moves pen to bottom before starting line to point
        Pen.moveTo(0@top);
        Pen.width_(4);


        if( (x@y) != (target) ) //if point isnt match to x@y, update pen position
        {
            Pen.strokeColor_(Color.new(1, 1, 1, 1));
            Pen.lineTo(x@y);
            (x@y).postln;

            ~inc_synth.set(\freq, (200+~count));
        }
        { // else if point is match to x@y

            Pen.lineTo(x@y);
            "=== POINT MATCH ===".postln;

            //set continue to zero to move to step 2
            ~continue=1;

            ~finalpoint = (x@y);
            ~finalpoint.postln;

            ~inc_synth.free;
            Synth(\beep, [\amp,0.85]);
        };
        if( y < 0 ) // if line goes out of bounds
        {
            ~continue=2;

            ~finalpoint = (x@y);
            ~finalpoint.postln;

            ~inc_synth.free;
            Synth(\error, [\amp,0.85]);

            Pen.stroke;
        };

    };

    if(~continue > 0) // -- step 2 -- (permanently draw final line)
    {
        // ~finalpoint.postln;

        if(~continue == 1)
        {
            Pen.strokeColor_(Color.new(0, 1, 0, 1));
        };
        if(~continue == 2)
        {
            Pen.strokeColor_(Color.new(1, 0, 0, 1));
        };

        Pen.moveTo(0@top);
        Pen.lineTo(~finalpoint);
        Pen.stroke;
    };


    //applies transformations, updates pen position
    Pen.stroke;
    Pen.moveTo(0@top);

    // -- counter increment = plotter speed --

    //count success
    ~count = ~count+5;

    //count fail
    ~count = ~count+10;
});

u.animate_(true);
)


(
Pdef(\melo, 
	Pbind(
		\instrument, \default,
	)
)
);
ProtoDef(\piano).startControl(Pdef(\melo))


////////


(
SynthDef(\sawbasseli, {
    var env, sig;
    env = EnvGen.kr(Env.perc(0.001, 2, [0,1,0], [-3,50]),doneAction:2);

    sig = Saw.ar(\freq.kr(123));
    sig = RLPF.ar(sig, \cutoff.kr(350));
    sig = CombC.ar(sig, 1, 0.125, \decay.kr(1));

    sig = sig * env;

     sig = Pan2.ar(sig, 0, \amp.kr(1.2));

    Out.ar(\out.kr(0), sig);
}).add;
~bus = ~bus ?? { Bus.control };
~scale = Buffer.sendCollection(s, [0,1,3,7,9]);
)
// this func wont work!
(
{
    var sig, index, pch, freq;

    index = LFDNoise0.kr(7).range(0,1);
    index = index * BufFrames.kr(~scale);
    
    // index.poll(7);
    pch = DegreeToKey.kr(~scale, index) + 48;
    freq = pch.midicps;
    
    freq.poll;
    
	Out.kr(~bus, freq);
    //sig = Synth(\sawbasseli, [note: freq]);
    // sig = LFTri.ar(freq, mul:0.2!2);
}.play;
Synth(\sawbasseli, [freq: ~bus.asMap]);
)

~scale


//////////

// synth
(
SynthDef(\sawbasseli, {
    var env, sig;
    env = EnvGen.kr(Env.perc(0.001, 2, [0,1,0], [-3,50]),doneAction:2);

    // sig = Saw.ar(\note.kr(23).midicps);
    
    // sig gets frequency from bus 6
    sig = Saw.ar(\freq.kr(100));

    sig = RLPF.ar(sig, \cutoff.kr(350));
    sig = CombC.ar(sig, 1, 0.125, \decay.kr(1));

    sig = sig * env;

    sig = sig * \amp.kr(1.2);

    Out.ar(\out.kr(0), sig!2);
}).add;
)

// scale synth sends freq into bus 6
(
~scale = Buffer.loadCollection(s, Scale.dorian.degrees);

SynthDef(\scales, { arg out=0;
    var sig, index, pch, freq;

    index = LFDNoise0.kr(7).range(0,1);
    index = index * BufFrames.kr(~scale);

    // index.poll(7);
    pch = DegreeToKey.kr(~scale, index) + 48;
    freq = pch.midicps;
    freq.poll;
    
    Out.kr(out, freq);
}).add;
)

// test routine
(
Ppar([
	Pmono(*[
		\scales,
		\out, ~bus,
	]),
	Pbind(*[
		\instrument: \sawbasseli,
		\freq, ~bus.asMap,
		\dur: 0.25,
		\cutoff: 550,
	])
]).play;
)


s.options.memSize = 8192 * 8;


(
SynthDef(\grain, {|out = 0, freq = 100, attack = 0, decay = 1, sustain = 0.1, distort = 0, fTime = 0.1, fFac = 1.2, amp = 1, delay = 0|
    var startFreq, endFreq, src, aEnv, fEnv;
    
    startFreq = fFac * freq;
    endFreq = freq;
    
    aEnv = EnvGen.ar(Env.perc(attack, decay), timeScale: sustain, doneAction: 2, levelScale: amp);
    fEnv = EnvGen.ar(Env([startFreq, endFreq], [fTime]));
    src = SinOsc.ar(fEnv, 1, mul: 1 + distort).wrap2(1);
    
    Out.ar(out, DelayN.ar(src * aEnv!2, 0.1, delay) * 0.1)
}).add
)

(
Pdef(\grainer, Pbind(
    \radiation, Pseq([
        Pseq([10] ++ (0.1 ) ++ [10] ++ (0.1!6), 1),
        Pseq([ 1] ++ (0.1!6) ++ [ 1], inf)
    ]),
    \instrument, \grain,
    \freq, ([1200, 800, 600, 200]!12).flat.collect{|v| v * rrand(0.99, 1)} * Prand([4, 1, 2, 3, 4, 8], inf),
    \fTime, 0.0125,
    \fFac, 5,
    \sustain, 0.1,
    \attack, 0.0005,
    \decay, 2,
    //\distort, {Pwhite(0.1, 5.0)}!(12 * 4),
    \amp, 0.1,
    \delay, {Pwhite(0.01, 0.1)}!(12 * 4),
    \dur, Pkey(\radiation)
)).play
)


Pdef(\grainer).stop


(
~klank = { |pan=0, amp=0.2|
	var sig, freq;
	var freqs, amps, rings, specs;

	//Rand operates much like client-side rrand, except that it generates a new number each time the Synth is
	//instanced (rrand will only produce a new value if the SynthDef itself is recompiled), and it always returns
	//floats (rrand returns integers if no decimal is given):
	freq = Rand(100, 5000);
	sig  = Impulse.ar(0.1);

	//Array.series prefills an array with an arithmetic series, in this case the first 12 partials above the
	//randomly generated fundamental:
	freqs = Array.series(13, freq, freq);

	//Array.fill prefills an array using values returned from its user-defined function. Here we're returning
	//amplitude values derived from the reciprocal of the one-indexed partial number:
	amps = Array.fill(13, { |i|
		var partial = i + 1;

		partial.reciprocal;
	});
	rings = Array.fill(13, { Rand(0.1, 2) });

	//A tick mark (`) preceding an array will set up a reference to that array, thus preventing SuperCollider
	//from automatically expanding the signal across multiple audio channels:
	specs = `[freqs, amps, rings];

	sig = Klank.ar(specs, sig);

	//As our code will spawn many Synths, we have to provide some way for the server to release them once they've
	//stopped sounding, otherwise each new Synth will continue to pile on as new running processes without any
	//of the old ones clearing, eventually leading to CPU overload and client/server crash. This can be achieved
	//through DetectSilence, with Done.freeSelf (or simply 2) placed in the doneAction argument:
	DetectSilence.ar(sig, doneAction: Done.freeSelf); //'doneAction: 2' without quotes also works
	Pan2.ar(sig * amp, pan); //Here we opt for Pan2 instead of .dup to be able to spatialize across the stereo field.
}.asDefName;
)

//Now let's test our code!
x = Synth(~klank); //Since we used .asDefName, the environmental variable is used as the Synth name.

~klank = nil
~klank

~rah = 10
{ arg bla=~rah; bla.debug("bla") }.value

~rah = (1..3)
(
SynthDef(\zed, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, bla=~rah;
	var sig;
	sig = SinOsc.ar(freq * bla).mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \zed,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);
