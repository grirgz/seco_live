

    (
    Ndef(\stutter).clear;
    ~bufsize = 1; // in seconds
    Ndef(\stutter, { arg choose=0, time=2, tapetime=2, stutter=4, attack=0.001, decay=0.001, tapelevel=0.7, offset=0, recordloop=1,amp=1;
        var in = In.ar(0,2);
        var sig;
        var sig1,sig2,sig3,sig4,sig5;
        var buf = LocalBuf(~bufsize * s.sampleRate, 1);
        var buf2 = LocalBuf(~bufsize * s.sampleRate, 1);
        var rate;
        var choosetrig, choosetrig2;
        var env;
        var stuttrig;
        var recordtrig;
        var timetrig;
        sig = in;
        sig1 = sig;
     
        choosetrig = choose > 0;
        stuttrig = TDuty.ar(1/stutter, choosetrig + Changed.kr(stutter), 1);
     
        recordtrig = Trig1.kr(choosetrig, 0.01);
     
     
        RecordBuf.ar(sig, buf, loop:1, run:1, trigger:choosetrig); // tape stop
        RecordBuf.ar(sig, buf2, 0, 1,0, 1, loop:recordloop, trigger:recordtrig); // stutter
     
        // tape stop
        rate = EnvGen.kr(Env([1,1,tapelevel],[0,tapetime]), choosetrig);
        sig2 = PlayBuf.ar(1, buf, rate, choosetrig, loop:1);
     
        // stutter
        env = EnvGen.ar(Env([0,1,1,0],[attack, (1/stutter)-attack-decay, decay]), stuttrig);
        sig3 = PlayBuf.ar(1, buf2, 1, stuttrig, offset * BufFrames.kr(buf2), loop:1) * env;
     
        sig = SelectX.ar(choose.lag(0.1), [sig1, sig2, sig3]);
        //sig = ReplaceOut.ar(0,sig*amp);
     
    }).play(0);
    )
     
     
    (
    TempoClock.default.play({
    Ndef(\stutter).put(1, \set -> Pbind(
        \choose, Pseq([
            Pser([
                2, 0,2,2,0,
            ],16),
            Pser([2],32),
        ],inf),
        \stutter, Pseq([
            Pser([5,1,2,4,1,4],16),
            Pser([5,7,2,5,2,3],16),
        ],inf),
        \dur, Pseq([
            Pser([1/4,1/2],16),
            ],inf),
    ));},4)
    )


