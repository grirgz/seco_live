

///////////// channels playing

// select mean mode with a two dimensional array (vertical or horizontal summing)
// strange panning effet, lofreq

sig2 = sig1.flop.mean;
sig3 = sig1.mean;
sig1 = SelectX.ar( SinOsc.kr(1/18).range(0,1), [sig2, sig3]);

// rotate the channels contents

sig1 = PanAz.ar(freq.size, sig1, {LFNoise1.kr(( 1/2 ).rand).range(-1,1)} ! sig1.size).flop.mean;

// rotate the channels contents in stereo field

sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size, amp).flop;

// select direction mode (column or row) in 2d array
sig = SelectX.ar( SinOsc.kr(1/9).range(0,1), [sig, sig.flop] ); // crossfade between direction mode
sig = SelectX.ar( SinOsc.kr(1/13).range(0,1), sig ); // then select a row or column depending the direction

// in 2d array TODO
sig1 = PanAz.ar(freq.size, sig1, {LFNoise1.kr(( 1/2 ).rand).range(-1,1)} ! sig1.size).flop.mean;
// difference between: separating a channel in 4 identic copies then passing each copy in a different filter then selecting a channel
// and: panning a channel in 4 channel and pass each channel in a different filter then summing ?

////////////// multichannel expansion with matrix

[1,2,3] * [1,2] == [1*1, 2*2, 3*1]
[[1,2], [3,4]] * [5,6] == [[1*5, 2*5], [3*6,4*6]]
[[1,2], [3,4]] * [[5,6]] == [[1*5, 2*6], [3*5,4*6]]

[[1,2], [3,4]] * [5,6,7] == [[1*5, 2*5], [3*6,4*6], [1*7,2*7]]
[[1,2], [3,4]] * [[5,6,7]] == [[1*5, 2*6, 1*7], [3*5, 4*6, 3*7]]

[1,2,3] *.t [4,5] == ( [1,2,3] * [[4,5]] ) 
[4,5] *.t [1,2,3] == ( [[1,2,3]] * [4,5] ) 

////////////////////////////// base

// fm
SinOsc.ar(freq * ( 1 + ( SinOsc.kr(200) * 1 ))) 

// ring
SinOsc.ar(freq) * LFSaw.ar(freq)

/////////////////////////////// osc

SinOsc.ar(freq) 
SinOsc.ar(freq * [1,1.01]) 
SinOsc.ar(freq * Array.series(8,1,0.1)) 


/////////////////////////////// branch a multichannel signal
// we have 5 voices and want to apply a detune for each voice and add to itself


	freq = freq*[1/4,1/2,1,2,4] ; // 5 voices

	sig = LFSaw.ar(freq + [0, (\diff.kr(1)/1)].flop).flop.sum; // detune and add
	sig.debug("sig1");
	sig = SinOsc.ar(freq) + sig; 
	sig = sig * ( 1+[osclo, osclo+oscmid/2, oscmid, oscmid+oschi/2, oschi]); // 5 channel signal
	sig = sig.fold2( SinOsc.kr(1/15 * [1,1.2].flop).range(0.4,1) ).flop.sum; // apply 2 different fold to each voice
	sig.debug("sig2"); // 5 channel signal
