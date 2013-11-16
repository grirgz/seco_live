~name = \4;

(
SynthDef(\singrain, { |freq = 440, amp = 0.2, sustain = 1|
	  var sig;
	  sig = SinOsc.ar(freq, 0, amp) * EnvGen.kr(Env.perc(0.01, sustain), doneAction: 2);
	  Out.ar(0, sig ! 2);
}).add;
)

// END

(
SynthDef(\singrain, { |freq = 440, ffreq=500, amp = 0.2, ii=1, sustain = 1, spread=0.8, pan=0|
	  var sig;
	  //sig = LFSaw.ar(freq * [1,0.5+(1/(2**(ii+1))),1.001], 0);
	  //sig = LFSaw.ar(freq * [1,1/8+(1/(2**(ii+1)))], 0);
	  //sig = LFSaw.ar(freq * [1,1/(ii*2+1)], 0);
	  sig = LFSaw.ar(freq * [log(ii+1),1/log(ii+1)] * LFSaw.ar((ii*16+1)).range(0.9,1.1), 0);
	  sig = RLPF.ar(sig, ffreq * SinOsc.kr(4+(ii*2)).range(0.5,1));
	  sig = sig * EnvGen.kr(Env.perc(0.01, sustain), doneAction: 2);
	  sig = Rotate2.ar(sig[0], sig[1], LFSaw.kr(1/(ii+1)));
	  sig = sig * amp;
	  //sig = Splay.ar(sig, spread, amp, pan);
	  Out.ar(0, sig);
}).add;
)


	

(
{
    var w, x, y, p, q, a, b, c, d;

    p = WhiteNoise.ar(0.05); // source
    q = LFSaw.ar(200,0,0.03)+LFSaw.ar(200.37,0,0.03)+LFSaw.ar(201,0,0.03);

    // B-format encode 2 signals at opposite sides of the circle
    #w, x, y = PanB2.ar(p, -0.5) + PanB2.ar(q, 0.5);

    #x, y = Rotate2.ar(x, y, MouseX.kr(-1,1));

    // B-format decode to quad
    #a, b, c, d = DecodeB2.ar(4, w, x, y);

    [a, b, d, c] // reorder to my speaker arrangement: Lf Rf Lr Rr
}.play;
)



// Rotation of stereo sound:
(
{
    // rotation via lfo
    var x, y;
    x = PinkNoise.ar(0.4);
    y = LFTri.ar(800) * LFPulse.kr(3,0,0.3,0.2);
    #x, y = Rotate2.ar(x, y, LFSaw.kr(0.1));
    [x,y]
}.play;
)

{
    // rotation via mouse
    var x, y;
    x = Mix.fill(4, { LFSaw.ar(200 + 2.0.rand2, 0, 0.1) });
    y = SinOsc.ar(900) * LFPulse.kr(3,0,0.3,0.2);
    #x, y = Rotate2.ar(x, y, MouseX.kr(0,2));
    [x,y]
}.play;


// Rotate B-format about Z axis:

wout = win;
zout = zin;
#xout, yout = Rotate2.ar(xin, yin, pos);

// Rotate B-format about Y axis:

wout = win;
yout = yin;
#xout, zout = Rotate2.ar(xin, zin, pos);

// Rotate B-format about X axis:

wout = win;
xout = xin;
#yout, zout = Rotate2.ar(yin, zin, pos);
)
