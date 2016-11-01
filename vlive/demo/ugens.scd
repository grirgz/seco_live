
///////////// channels playing

// select mean mode with a two dimensional array (vertical or horizontal summing)
// strange panning effet, lofreq

sig2 = sig1.flop.mean;
sig3 = sig1.mean;
sig1 = SelectX.ar( SinOsc.kr(1/18).range(0,1), [sig2, sig3]);

// rotate the channels contents

sig1 = PanAz.ar(freq.size, sig1, {LFNoise1.kr(( 1/2 ).rand).range(0,2.0)} ! sig1.size).flop.mean;

// rotate the channels contents in stereo field

sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size, amp).flop;

// select "select" mode in 2d array
sig = SelectX.ar( SinOsc.kr(1/9).range(0,1), [sig, sig.flop] );
sig = SelectX.ar( SinOsc.kr(1/13).range(0,1), sig );


