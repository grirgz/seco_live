
 
     
    (
         
    SynthDef(\kickfb, { |out=0, amp=0.1, pan=0, release=0.26, fratio=1.5, freqpan=0.01, spread=0.8, timeScale=1|
        var env0, env1, env1m, son;
     
        //freqpan = [-1,0,1] * freqpan;
        freqpan = [1,0,-1] * freqpan;
        env0 = \env0.kr(Env.new([9.5, 1, 0.5, 0], [0.105, 0.16, 00.2], [-4, -2, -4]));
        env1 = \env1.kr(Env.new([100, 29, 59], [0.105, 0.29], [-4, -5]));
       
        env0 =  EnvGen.ar(env0, doneAction:2, timeScale:timeScale);
        env1 = EnvGen.ar(env1, timeScale:timeScale);
        env1m = env1.midicps;
       
        son = LFPulse.ar(env1m * freqpan, 0, 0.5, 1, -0.5);
        son = son + WhiteNoise.ar(1);
        son = LPF.ar(son, env1m*fratio, env0);
        son = son + SinOsc.ar(env1m, 0.5, env0);
       
        son = son * 1.2;
        son = son.clip2(1);
     
        son = son * amp;
        son = Splay.ar(son, spread, amp, pan);
       
        OffsetOut.ar(out, son);
    }).add;
         
    SynthDef(\kick2, { |which = 1, which2=2, out=2, amp=1, pan=0, release=0.26, fratio=1.5|
            var env0,env1,
        env1m, son;
         
        env0 = \env0.kr(Env.new([0.1, 0.3, 0.8, 0], [0.1, 0.02,0.61], [-4, -2, -4]));
        env1 = \env1.kr(Env.new([100, 34, 37], [0.1, 0.1], [-4, -5]));
         
        env0 = EnvGen.ar(env0, doneAction:2);
            env1 = EnvGen.ar(env1);
         
            env1m = env1.midicps;
            son = LFPulse.ar(env1m,0, 0.01, 1,1.4)*LFSaw.ar(100).distort;
        son = son + WhiteNoise.ar(1);
        son = LPF.ar(son, env1m*fratio, env0);
        son = son + SinOsc.ar(env1m, 0.5, env0);
        son = son * 2.2;
        //son = son.clip2(1);
         
        son = son * amp.distort;
        son = Pan2.ar(son, pan);
        OffsetOut.ar(out, son);
        },
    ).add;
         
    SynthDef(\hats, { |which = 1, which2=2, out=4, amp=1, pan=0, release=0.26, fratio=1.5, timeScale=1|
        var env0,env1,
        env1m, son;
        env0 = \env0.kr(Env.new([0.002, 0.1, 0.01, 0], [0.0001, 0.01, 0.03], [-4, -2, -4]));
        env1 = \env1.kr(Env.new([100,100], [0.5,0.5, 0.1,0.01], [-4, -5]));
     
        env0 = EnvGen.ar(env0, timeScale:timeScale, doneAction:2);
        env1 = EnvGen.ar(env1, timeScale:timeScale);
     
        env1m = env1.midicps;
        son = LFPulse.ar(env1m,0, 0.01, 0.1, -0.5)*LFSaw.ar(1000);
        son = son + WhiteNoise.ar(1);
        son = LPF.ar(son, env1m*fratio, env0);
        son = son + SinOsc.ar(env1m, 0.5, env0);
        son = son;
        son = son.clip2(0.2);
     
        son = son * amp;
        son = Pan2.ar(son, pan);
        OffsetOut.ar(out, son);
        },
    ).add;
     
    SynthDef(\padsin, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
        var sig, sig1, sig2, sig3;
        sig = {arg x; SinOsc.ar( freq/2 * x + ExpRand(freq/64,2*freq/64))}!5;
        sig = sig.scramble;
        sig = TScramble.ar(sig, Impulse.kr(4),1);
        sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(1.01,0.1,1,1.1)),gate,doneAction:doneAction);
        sig = Splay.ar(sig, spread, amp, pan);
        Out.ar(out, sig);
    }).add;
   
    SynthDef(\snare, { |out=0, amp=0.2, pan=0, release=0.026, fratio=1.5, rq=0.5, releaseb=0.06, fratiob=2, dmix=0.5, rqc=0.5, fratioc=2,
    dmix2=0.5, releasec=0.01|
    var env0, env1, env1m, son;
    var env0b, env1b, env1mb, sonb;
    var env0c, env1c, env1mc, sonc;
 
    env0 = EnvGen.ar(Env.new([0.5, 0.5, 0.5, 0], [0.5, 0.6, release], [-4, -2, -4]), doneAction:0);
    env1 = EnvGen.ar(Env.new([18, 19, 7], [0.5, 0.9], [-4, 5]));
    env1m = env1.midicps;
 
    env0c = EnvGen.ar(Env.new([0.5, 0.1, 0.5, 0], [0.05, 0.6, releasec], [-4, -2, -4]), doneAction:2);
    env1c = EnvGen.ar(Env.new([100, 50, 700], [0.05, 0.09], [-4, 5]));
    env1mc = env1c.midicps;
 
    env0b = EnvGen.ar(Env.new([0.5, 0.1, 0.5, 0], [0.5, 0.6, releaseb], [-4, -2, -4]), doneAction:0);
    env1b = EnvGen.ar(Env.new([40, 100, 41], [0.5, 0.2], [4, -5]));
    env1mb = env1b.midicps;
 
    son = Saw.ar(100);
    son = BPF.ar(son, env1m*fratio/2, rq);
    son = son * env0;
 
        sonc = Saw.ar([1,2]);
    sonc = BPF.ar(sonc, env1mc*fratioc/2, rqc);
    sonc = sonc * env0c;
    //son = son + SinOsc.ar(env1m, 0.5, env0);
 
    sonb = LFPulse.ar(env1mb, 0, 0.2, 0.1, -0.5);
    sonb = sonb + WhiteNoise.ar(0.2);
    sonb = LPF.ar(sonb, env1mb*fratiob/4);
    sonb = sonb + SinOsc.ar(env1mb, 0.5);
    sonb = sonb * env0b;
 
    son = SelectX.ar(dmix, [sonc , son]);
    son = SelectX.ar(dmix2, [son , sonb]);
    son = son/100.tanh.distort;
    son = son.clip2(1);
 
    son = son * amp/4;
    Pan2.ar(son, pan);
    DetectSilence.ar(son, doneAction:2);
 
    OffsetOut.ar(out, son);
}).add;
     
    )
     
    ~bus = Bus.audio(s,2);
    (
    Pdef(\kickfb,
        Pbind(
            \instrument, \kickfb,
            \env0, [ Env.new([0.5, 1, 0.5, 0], [0.5, 0.16, 0.01], [-4, -2, -4]) ],
            \env1, [ Env.new([110, 43, 29], [0.015, 0.29], [-4, -5]) ],
            \pan, Pseq([
                Pser([0],17),
                Pwhite(-1.0,1.0,16-1)
            ],inf).stutter(1) * 0.5,
            \spread, 0.1,
            \dur, 1/4,
            \out, ~bus,
            \amp, 0.51,
            //\amp,0.0,
            \isRest, Pseq([1,0.6],inf).coin.not,
        )
    );
     
    Pdef(\hats,
        Pbind(
            //\instrument,Pseq([\kick2,\kick],inf),
            \instrument, \hats,
            //\out,[0,1],
            \pan,Pwhite(-1,1,inf)/4,
            \pan, 0,
            \dur, 1/8,
            \timeScale, Pseq([1,1.2,0.7,3],inf) + Pseq([0,0.51,0,0.7],inf).stutter(2),
            \timeScale, Pseq([0.4,0.8,0.4,0.81],inf),
            \amp,Pseq([0.8,0.74,0.6,0.71],inf),//*v[\level1].asMap,
            \isRest, Pseq([1],inf).coin.not,
        )
    );
     
    Pdef(\kick2,
            Pbind(
                \instrument, Pseq([\kick2,\snare],inf),
                //\out,[0,1],
                //\pan,Pwhite(-1,1,inf),
                \pan, 0,
                \dur, 1,
                \amp,2,//*v[\level1].asMap,
                \isRest, Pseq([
                    1
                ],inf).coin.not,
            )
    );
     
    Pdef(\pat2, Pbind(
        \instrument, \padsin,
        \note, Pseq([
            Prand([0,2,4,7,3]),
            Prand([0,2,4,7,3])+7,
        ],inf),
        \dur, 2,
        \amp, 0.071,
        \legato, 3.5,
        \isRest, false,
    ));
     
    )
                   
    (
        Ndef(\fb, {
            var in = InFeedback.ar(~bus,2);
            var sig = in;
            var sig1;
            sig = Fb({ arg fb;
                var del;
                var freqshift;
                fb = sig + (fb * 0.97 * \fb.kr(1));
                freqshift = \freqshift.kr(1);
                freqshift = Duty.ar(1/8, 0, Dseq([10,0,-20,0]*freqshift,inf) + Dstutter(2,Dseq([0,-50,0,50],inf)));
                fb = fb + FreqShift.ar(fb, (0-[1,2,3,4,5,6,7,8,9].clump(2).scramble*freqshift)).sum/6;
                fb;
            },1/4,\delay.kr(1/4));
            sig = Normalizer.ar(sig, 0.99,0.01);
            sig = sig / 2;
     
            sig;
        });
    )
     
    (
	TempoClock.default.tempo =  1;
    Tdef( \track, {
     
        loop{
            Pdef(\kick2,
				Pbind(
					\instrument, Pseq([\kick2,\snare],inf),
					//\out,[0,1],
					//\pan,Pwhite(-1,1,inf),
					\pan, 0,
					\dur, 1,
					\amp,2,//*v[\level1].asMap,
					\isRest, Pseq([
						1
					],inf).coin.not
				);
			);
            Pdef(\pat2).play;
            16.wait;
            Pdef(\kick2).play;
            Pdef(\hats).play;
            2.wait;
            Pdef(\kickfb).play;
            Ndef(\kickfb).play;
            8.wait;
            Pdef(\pat2).play;
            4.wait;
            Pdef(\kick2).stop;
            Pdef(\hats).stop;
            Pdef(\kick2,
				Pbind(
					\instrument, Pseq([\kick2,\snare],inf),
					//\out,[0,1],
					//\pan,Pwhite(-1,1,inf),
					\pan, 0,
					\dur, 1/4,
					\amp,2,//*v[\level1].asMap,
					\isRest, Pseq([
						1
					],inf).coin.not
				);
			);
            4.wait;
            Pdef(\kick2).play;
            4.wait;

			"FIN!".debug;
			64.wait;
        }  
    }).play;
    )


