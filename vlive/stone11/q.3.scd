
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var freqtab;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var size = 8;
	var pan;
	var time = 4;
	var nffreq;
	var env1, env2;

	var mod1, mod2, mod3, modsel;
	var modarray, modsimple;
	env1 = MouseX.kr(0,1);

	mod1 = { arg low, high, converge, msize;
		var isig;
		var isig1;
		var nf;
		msize = msize ? size;
		nf = LFNoise1.kr(1/32/8 * env1.range(32*8,1) ! msize).exprange(1/16/8,1);
		nf = SelectX.kr(env1, [nf, 1/8]);
		isig = LFNoise1.kr(nf).range(low,high);
		isig1 = SelectX.kr(modsimple.(0,1, 1) * ( msize-1 ), isig);
		//isig1 = isig[0];
		isig = SelectX.kr(env1, [isig, isig1]);
		isig;
	};
	modsimple = { arg low, high, converge, msize;
		var isig;
		var nf;
		msize = msize ? size;
		nf = LFNoise1.kr(1/32).range(4,1/16);
		nf = SelectX.kr(env1, [nf, 1/8]);
		isig = LFNoise1.kr(nf).range(low,high);
		isig = SelectX.kr(env1, [isig, converge]);
		isig;
	};
	modarray = { arg low, high, converge, msize;
		var isig;
		var nf;
		msize = msize ? size;
		nf = LFNoise1.kr(1/32!msize).range(4,1/16);
		nf = SelectX.kr(env1, [nf, 1/8]);
		isig = LFNoise1.kr(nf).range(low,high);
		isig = SelectX.kr(env1, [isig, converge]);
		isig;
	};
	modsel = { arg ins, converge=0;
		var isig;
		var idx;
		idx = mod1.(0, 1, converge);
		isig = SelectX.ar( ins.size-1 * idx, ins);
		isig;
	};


	freq = mod1.(50,3000,100);
	freq.debug("freq");

	//freq = freq.cpsmidi.round(1).midicps;
	freq = freq *.t [1,1/2,1/4,1/8];

	sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = SinOsc.ar(freq);
	sig = modsel.([sig1, sig2, sig3]);

	sig = LFNoise1.ar(1/8!4) * sig;
	sig = sig.flop.mean;

	sig1 = sig + DelayL.ar(sig, 1, mod1.(0.003,1,0.1));
	sig = modsel.([ sig, sig1 ]);

	sig1 = sig + FreqShift.ar(sig, mod1.(-150.003,10.01,1/100));
	sig = modsel.([ sig, sig1 ]);

	sig1 = RLPF.ar(sig, mod1.(30,5000,500), mod1.(0.1,0.8,0.5));
	sig = modsel.([ sig, sig1 ]);

	sig1 = sig + DelayL.ar(sig, 0.1, mod1.(0.003,0.1,1/100));
	sig = modsel.([ sig, sig1 ]);

	sig1 = sig + DelayL.ar(sig, 0.1, mod1.(0.003,0.01,1/100));
	sig = modsel.([ sig, sig1 ]);



	amp = amp * \gain.kr(1);
	//sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig.debug("sig");
	pan = LFNoise1.kr(1/2 * (1..size)/8).range(-1.0,1.0);
	sig1 = DC.kr(-1);
	sig2 = DC.kr(1);
	sig3 = DC.kr(0);
	sig4 = SelectX.kr( ( LFNoise1.kr(1/1).range(0,1) ) * 2, [sig1, sig2, sig3]);
	pan = SelectX.kr( ( LFNoise1.kr(1/1).range(0,1) ) * 1, [pan, sig4]);
	pan.debug("pan");
	sig = Pan2.ar(sig, pan, amp).mean;
	sig.debug("sig");
	sig;
});


// END



(
{
    var a, n, mx, my, mwrap;
    n = 8;
    mx = MouseX.kr(0, 1, 0, 0.1);
    my = MouseY.kr;
    mwrap = { |pmin, pmax, min, max| sin(mx * ExpRand(pmin, pmax)) + 1 * 0.5 * ExpRand(min, max) };
    a = {
        var freq, fmul, phase;
        freq = mwrap.(10, 40, 200, 5000) + ExpRand(200, 3000);
        fmul = LFNoise0.kr(ExpRand(0.1, 8)).round(1/6).exprange(1, Rand(1, 1.2));
        phase = LFNoise2.ar(mwrap.(1, 20, 10, 1000), Rand(2, 5));
        SinOsc.ar(freq * fmul, phase)
    } ! n;
    a = a.add(
        SinOsc.ar(LFDNoise0.kr(11, SetResetFF.kr(*Dust.kr([1, 2] * 0.3))).range(0, 700) + 220)
    );
    SelectXFocus.ar(mx * n, a, my * n) * 0.2 + OnePole.ar(PinkNoise.ar(0.5 ! 2), 0.4)
    * Line.kr(0, 1, 3);
}.play;
)


// jimmy played harmonica in the pub where I was born
// (hh) (jrh) (cc 2006)
(
{
    var blas, zieh, mx, my, trig, which, amp, u, schnauf;
    var del = 9, det = 0.1;
    schnauf = 0.3;
    mx = MouseX.kr;
    my = MouseY.kr(0.1, 2, 1);

    blas = [0, 12, 24] +.x [60, 64, 67] ++ [60+36];
    zieh = [62, 67, 71,   74, 77, 81, 83,   86, 89, 93];

    trig = Dust.kr(1);
    which = ToggleFF.kr(TDelay.kr(trig, schnauf));
    amp = EnvGen.kr(Env([1, 0, 1], [schnauf, schnauf]), trig);
    blas = Select.kr(which, [blas, zieh]);
    u = SelectXFocus.ar(
        mx * blas.size,
        blas.collect {|f|
            Pulse.ar((Rand(-0.04, 0.09) + f).midicps * 0.5, 0.48 + LFNoise1.kr(0.06, 0.1), 0.2)
        },
        my
    ) * Slope.kr(mx + my).abs.lag2(2) * amp;
    u = Pan2.ar(OnePole.ar(u, -0.3), mx * 2 - 1);
    DelayL.ar(BPF.ar(u * 2, 1500, 0.3), del + det, LFNoise2.kr(0.2, det, del)) + u
}.play;
);

(
{
    var blas, zieh, mx, my, trig, which, amp, u, schnauf;
    var del = 9, det = 0.1;
	var button = MouseButton.kr(1,0,0.1);
    schnauf = 0.3;
    mx = MouseX.kr;
    my = MouseY.kr(0.1, 2, 1);

    blas = [0, 12, 24] +.x [60, 64, 67] ++ [60+36];
    zieh = [62, 67, 71,   74, 77, 81, 83,   86, 89, 93];

    trig = Dust.kr(1);
    which = ToggleFF.kr(TDelay.kr(trig, schnauf));
    amp = EnvGen.kr(Env([1, 0, 1], [schnauf, schnauf]), trig);
    blas = Select.kr(Slope.ar(button).range(0,1), [blas, zieh]);
    u = SelectXFocus.ar(
        mx * blas.size,
        blas.collect {|f|
            Pulse.ar((Rand(-0.04, 0.09) + f).midicps * 0.5, 0.48 + LFNoise1.kr(0.06, 0.1), 0.2)
        },
        my
    ) * Slope.kr(
			SelectX.kr(
				[
					mx + my,
					0
				]
			)
		).abs.lag2(2) * amp ;
    u = Pan2.ar(OnePole.ar(u, -0.3), mx * 2 - 1);
    DelayL.ar(BPF.ar(u * 2, 1500, 0.3), del + det, LFNoise2.kr(0.2, det, del)) + u
}.play;
);

(
{
    var blas, zieh, mx, my, trig, which, amp, u, schnauf;
    var del = 9, det = 0.1;
	var trig2;
	var sig;
    schnauf = 0.3;
    mx = MouseX.kr;
    my = MouseY.kr(0.1, 2, 1);

    blas = [0, 12, 24] +.x [60, 64, 67] ++ [60+36];
    zieh = [62, 67, 71,   74, 77, 81, 83,   86, 89, 93];

    trig = Dust.kr(1);
	which = MouseButton.kr(1,0,0.1);
	trig = Changed.kr(button, 0.0005);
	
    amp = EnvGen.kr(Env([1,1, 1.5, 0.8,0], [0.5, 0.5,0.5,0.5]), trig);
    blas = Select.kr(which.round(1), [blas, zieh]);
    u = SelectXFocus.ar(
        mx * blas.size,
        blas.collect {|f|
            Pulse.ar((Rand(-0.04, 0.09) + f).midicps * 0.5, 0.48 + LFNoise1.kr(0.06, 0.1), 0.2)
        },
        my
    ) * Slope.kr(mx + my).abs.lag2(2) * amp;
    u = Pan2.ar(OnePole.ar(u, -0.3), mx * 2 - 1);
    sig = DelayL.ar(BPF.ar(u * 2, 1500, 0.3), del + det, LFNoise2.kr(0.2, det, del)) + u;
}.play;
);
