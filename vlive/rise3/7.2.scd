Spec.add(\delayTime, [0, 2]);
Spec.add(\damp, [0, 1]);
Spec.add(\size, [0.5, 3]);
Spec.add(\diff, [0, 1]);
Spec.add(\feedback, [0, 1]);
Spec.add(\modDepth, [0, 50]);
Spec.add(\modFreq, [0, 10]);

Ndef(\reverb, {
	var in = InFeedback.ar(BusDef(~masterfx+++\fx));
	Greyhole.ar(in, \delayTime.kr(2), \damp.kr(0), \size.kr(1), \diff.kr(0.707), \feedback.kr(0.9), \modDepth.kr(0.1), \modFreq.kr(0.61))
}).play

// END


Ndef(~masterfx+++\fx).edit
Ndef(\reverb).free
BoidRoids


s.options.memSize_(65536 * 2);
s.reboot;
(

Spec.add(\t60, [0.1, 60, \exp]);
Spec.add(\damp, [0, 1]);
Spec.add(\size, [0.5, 3]);
Spec.add(\earlydiff, [0, 1]);
Spec.add(\mdepth, [0, 50]);
Spec.add(\mfreq, [0, 10]);
Spec.add(\lowx, [0, 1]);
Spec.add(\midx, [0, 1]);
Spec.add(\highx, [0, 1]);
Spec.add(\lowband, [100, 6000, \exp]);
Spec.add(\highband, [1000, 10000, \exp]);
)


Ndef(\src).clear
(
Ndef(\src, {
    //SoundIn.ar([0, 1])
    Splay.ar(Impulse.ar([1, 3, 5, 7, 9]).scramble);
});
    
Ndef(\reverb, {
    var src = Ndef(\src).ar * \amp.kr(1);
    src = JPverb.ar(
        src,
        \t60.kr(1,           0.05),
        \damp.kr(0,          0.05),
        \size.kr(1,          0.05),
        \earlydiff.kr(0.707, 0.05),
        \mdepth.kr(5,        0.05),
        \mfreq.kr(2,         0.05),
        \lowx.kr(1,          0.05),
        \midx.kr(1,          0.05),
        \highx.kr(1,         0.05),
        \lowband.kr(500,     0.05),
        \highband.kr(2000,   0.05)
    );
});
)

Ndef(\reverb).fadeTime = 1;
Ndef(\reverb).play
Ndef(\src).play
Ndef(\src).stop


Ndef('reverb').set('lowx', 0.84375, 'amp', 0.66015625, 'damp', 0.671875, 'size', 0.94921875, 'highband', 4450.794062356, 't60', 16, 'mdepth', 17.96875, 'mfreq', 0.0, 'highx', 0.0, 'lowband', 2450.0822520097, 'earlydiff', 0.421875, 'midx', 0.5546875);

// Dreamverb
Ndef('reverb').set('wet', 0.9921875, 'lowx', 0.84375, 'amp', 0.66015625, 'damp', 0.31443298969072, 'size', 2.7938144329897, 'highband', 1024.0219794048, 't60', 60, 'mdepth', 4.639175257732, 'highx', 0.0, 'mfreq', 0.10309278350515, 'lowband', 2450.0822520097, 'fadeTime', 1, 'earlydiff', 0.421875, 'midx', 0.70618556701031);


Ndef('reverb').set('lowx', 0.84375, 'amp', 0.66015625, 'damp', 0.671875, 'size', 0.94921875, 'highband', 4450.794062356, 't60', 60, 'mdepth', 17.96875, 'mfreq', 0.0, 'highx', 0.0, 'lowband', 2450.0822520097, 'earlydiff', 0.421875, 'midx', 0.5546875);

Ndef('reverb').set('lowx', 0.609375, 'amp', 0.38092041015625, 'damp', 0.2890625, 'size', 0.6171875, 'highband', 7233.9416273667, 't60', 4.0375572334984, 'mdepth', 0.0, 'mfreq', 2.03125, 'highx', 0.2265625, 'lowband', 681.56675509913, 'fadeTime', 1, 'earlydiff', 0.765625, 'midx', 0.515625);

Ndef('reverb').set('lowx', 0.84375, 'amp', 0.66015625, 'damp', 0.875, 'size', 0.5, 'highband', 5829.4153471361, 't60', 0.16483258382257, 'mdepth', 17.96875, 'mfreq', 0.0, 'highx', 0.0, 'lowband', 100.0, 'fadeTime', 1, 'earlydiff', 0.703125, 'midx', 0.5546875);


Ndef(\src).edit
Ndef(\reverb).edit;



Ndef(\src).fadeTime = 4;
Ndef(\src).quant = 2;

(
Ndef(\src, {
    var src = 10.collect{
        Pan2.ar([HPF, LPF, ComplexRes].choose.performKeyValuePairs(\ar,[
            \in, [Impulse, LFPulse].choose.ar(
                [4, 2, 1, 1/2, 1/3, 1/4, 1/6].choose,
                iphase: [0, 1/4, 1/8, 1/2, 1/3].choose,
                phase: [0, 1/4, 1/8, 1/2, 1/3].choose,
                width:  [0.001, 0.0001, 0.01, 0.1, 0.2].choose,
                mul:    [1, 2, 3, 4].choose.reciprocal * [1, -1].choose
            ),
            \freq, [10000, 2000, 1000, 500, 250, 125, 125/2].choose,
            \decay, [0.1, 0.2, 0.4, 1].choose,
        ]
        ), Rand(-1, 1));
    }.sum;
    HighShelf.ar(src, \shelfFreq.kr(1000), \shelfslope.kr(1));
})
)



{[0.1,0.1]*ComplexRes.ar(Pulse.ar(0.1,0.001,0.1),50+ 5000*SinOsc.ar(50),0.5)}.play;



(

Ndef(\compar, {|in = 0|

	var ctlLag = \ctlLag.kr(0.1);



	var src, dst, filterIn, mods, env, tmpIter;

	var ampEnvs;



	// number of FM neurons

	var numNodes = 3;



	// controls

	var preAmp = \preAmp.kr(0.1, ctlLag);

	var postAmp = \postAmp.kr(0.1, ctlLag);

	var dryAmp = \dryAmp.kr(1, ctlLag);

	var filterWet = \filterWet.kr(0.9, ctlLag);

	var reverbWet = \reverbWet.kr(0.9, ctlLag);



	var freqs = numNodes.collect{|i|

		("freq"++i).asSymbol.kr((500 + (i * 100)), ctlLag)

	}.flat;

	var amps = numNodes.collect{|i|

		("amp"++i).asSymbol.kr(1, ctlLag)

	}.flat;

	var fms = numNodes.collect{|i|

		("fm"++i).asSymbol.kr(1, ctlLag)

	}.flat;

	var decays = numNodes.collect{|i|

		("decay" ++i).asSymbol.kr(0.1, ctlLag)

	}.flat;

	

	

	// signal preparation

	src = LeakDC.ar(SoundIn.ar(in));

	filterIn = preAmp * src;

	

	// FM network

	dst = freqs.inject([filterIn, 0], {|in, freq, i|

		tmpIter = ComplexRes.ar( 

			filterIn,

			freq 

			+ (fms[i] * in[0]),

			decays[i]

		);

					

		[

			tmpIter * amps[i],

			in[1] + tmpIter

		]

	});

	dst = Mix.ar(dst * [1,  amps.sum * numNodes.reciprocal]);





	// dryWet

	dst = SelectX.ar(filterWet, [

		OnePole.ar(dryAmp * src, \lpCoeff.kr(0.3, 0.1)), 

		postAmp * LeakDC.ar(dst)

	]);



	// compressor

	dst = Compander.ar(dst,dst,

		thresh: \compThresh.kr(0.5,0.1),

		slopeBelow: 1 ,

		slopeAbove: \compRatio.kr(0.3, 0.1),

		clampTime: 0.0001,

		relaxTime: 0.1

	);



	// reverb + gp limiting

	Limiter.ar(

//		SelectX.ar(reverbWet, [dst, AdCVerb.ar(0.1 * dst, 10)])
dst

	);

});

)





(

// control range specifications

Spec.add(\freq0, [1, 20000, \exp]);

Spec.add(\freq1, \freq0);

Spec.add(\freq2, \freq0);

Spec.add(\in, [0, 2, \lin, 1, 1]);

Spec.add(\amp0, [0, 1]);

Spec.add(\amp1, \amp0);

Spec.add(\amp2, \amp0);

Spec.add(\fm0, [0, 10000]);

Spec.add(\fm1, \fm0);

Spec.add(\fm2, \fm0);

Spec.add(\decay0, [0.01, 5, \exp]);

Spec.add(\decay1, \decay0);

Spec.add(\decay2, \decay0);

Spec.add(\filterWet, [0, 1]);

Spec.add(\reverbWet, [0, 1]);

Spec.add(\preAmp, [0.5, 5, \exp]);

Spec.add(\dryAmp, [0.5, 5, \exp]);

Spec.add(\postAmp, [0.5, 50, \exp]);

Spec.add(\lpCoeff, [0, 1]);

)



Ndef(\compar).play
(

// GUI

Ndef(\compar).gui;

)



(

Ndef(\compar, {|in = 0|

	var ctlLag = \ctlLag.kr(0.1);



	var src, dst, filterIn, mods, env, tmpIter;

	var ampEnvs;



	// number of FM neurons

	var numNodes = 3;



	// controls

	var preAmp = \preAmp.kr(0.1, ctlLag);

	var postAmp = \postAmp.kr(0.1, ctlLag);

	var dryAmp = \dryAmp.kr(1, ctlLag);

	var filterWet = \filterWet.kr(0.9, ctlLag);

	var reverbWet = \reverbWet.kr(0.9, ctlLag);



	var freqs = numNodes.collect{|i|

		("freq"++i).asSymbol.kr((500 + (i * 100)), ctlLag)

	}.flat;

	var amps = numNodes.collect{|i|

		("amp"++i).asSymbol.kr(1, ctlLag)

	}.flat;

	var fms = numNodes.collect{|i|

		("fm"++i).asSymbol.kr(1, ctlLag)

	}.flat;

	var decays = numNodes.collect{|i|

		("decay" ++i).asSymbol.kr(0.1, ctlLag)

	}.flat;

	

	

	// signal preparation

	src = LeakDC.ar(SoundIn.ar(in));

	filterIn = preAmp * src;

	

	// FM network

	dst = freqs.inject([filterIn, 0], {|in, freq, i|

		tmpIter = ComplexRes.ar( 

			filterIn,

			freq 

			+ (fms[i] * in[0]),

			decays[i]

		);

					

		[

			tmpIter * amps[i],

			in[1] + tmpIter

		]

	});

	dst = Mix.ar(dst * [1,  amps.sum * numNodes.reciprocal]);





	// dryWet

	dst = SelectX.ar(filterWet, [

		OnePole.ar(dryAmp * src, \lpCoeff.kr(0.3, 0.1)), 

		postAmp * LeakDC.ar(dst)

	]);



	// compressor

	dst = Compander.ar(dst,dst,

		thresh: \compThresh.kr(0.5,0.1),

		slopeBelow: 1 ,

		slopeAbove: \compRatio.kr(0.3, 0.1),

		clampTime: 0.0001,

		relaxTime: 0.1

	);



	// reverb + gp limiting

	Limiter.ar(

		SelectX.ar(reverbWet, [dst, AdCVerb.ar(0.1 * dst, 10)])

	);

});

)





(

// control range specifications

Spec.add(\freq0, [1, 20000, \exp]);

Spec.add(\freq1, \freq0);

Spec.add(\freq2, \freq0);

Spec.add(\in, [0, 2, \lin, 1, 1]);

Spec.add(\amp0, [0, 1]);

Spec.add(\amp1, \amp0);

Spec.add(\amp2, \amp0);

Spec.add(\fm0, [0, 10000]);

Spec.add(\fm1, \fm0);

Spec.add(\fm2, \fm0);

Spec.add(\decay0, [0.01, 5, \exp]);

Spec.add(\decay1, \decay0);

Spec.add(\decay2, \decay0);

Spec.add(\filterWet, [0, 1]);

Spec.add(\reverbWet, [0, 1]);

Spec.add(\preAmp, [0.5, 5, \exp]);

Spec.add(\dryAmp, [0.5, 5, \exp]);

Spec.add(\postAmp, [0.5, 50, \exp]);

Spec.add(\lpCoeff, [0, 1]);

)



(

// GUI

Ndef(\compar).gui;

{DiodeRingMod.ar(SinOsc.ar(3700 * ([1, 1.1, 1.2] * SinOsc.ar(200).range(1, 2))), SinOsc.ar(100 * [0.75, 1, 0.5])).sum * 0.2 * LFPulse.ar(10.3 * 0.5, 0, 0.04) * 0.1}.play

{DiodeRingMod.ar(SinOsc.ar(18000 * ([1, 1.1, 1.2] * SinOsc.ar(200).range(1, 2))), SinOsc.ar(100 * [0.75, 1, 0.5])).sum * 0.2 * LFPulse.ar(10.3 * 1/6, 0, 0.02) * 0.1}.play

{DiodeRingMod.ar(SinOsc.ar(1800 * ([1, 1.1, 1.2] * SinOsc.ar(200).range(1, 2))), SinOsc.ar(100 * [0.75, 1, 0.5])).sum * 0.2 * LFPulse.ar(10.3 * LFPulse.ar(10.3).range(1/6, 1/2), 0, 0.02) * 0.1}.play

{DiodeRingMod.ar(SinOsc.ar(800 * ([1, 1.1, 1.2] * SinOsc.ar(200).range(1, 2))), SinOsc.ar(100 * [0.75, 1, 0.5])).sum * 0.2 * LFPulse.ar(10.3 * 1/32, 0, 0.2) * 0.1}.play

{DiodeRingMod.ar(SinOsc.ar(400 * ([1, 1.1, 1.2] * SinOsc.ar(200).range(1, 2))), SinOsc.ar(100 * [0.75, 1, 0.5])).sum * 0.2 * LFPulse.ar(10.3 * 1/32, 0, 0.2) * 0.1}.play

{DiodeRingMod.ar(SinOsc.ar(200 * ([1, 1.1, 1.2] * SinOsc.ar(200).range(1, 2))), SinOsc.ar(100 * [0.75, 1, 0.5])).sum * 0.2 * LFPulse.ar(10.3 * 1/32, 0, 0.2) * 0.1}.play

{DiodeRingMod.ar(SinOsc.ar(100 * ([1, 1.1, 1.2] * SinOsc.ar(200).range(1, 2))), SinOsc.ar(100 * [0.75, 1, 0.5])).sum * 0.2 * LFPulse.ar(10.3 * 1/32, 0, 0.2) * 0.1}.play

{DiodeRingMod.ar(SinOsc.ar(40 * ([1, 1.1, 1.2] * SinOsc.ar(50).range(1, 2))), SinOsc.ar(100 * [0.75, 1, 0.5])).sum * 0.2 * LFPulse.ar(10.3 * 1/32, 0, 0.4) * 0.5}.play

(
{
	var freq = (Demand.ar(Impulse.ar(10), 0, DNoiseRing(change: MouseX.kr(0, 1), chance: MouseY.kr(0, 1), numBits: 32))).linlin(0, 2**32, 40, 40+48).midicps.poll;
	    
	    SinOsc.ar(freq)!2

}.play
)

(
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(MouseX.kr(50,5000));
	sig = sig + SinOsc.ar(MouseY.kr(50,5000));
	sig = Pan2.ar(sig, pan, amp);
}).play;
);
NodeMap
