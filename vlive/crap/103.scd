
~path = Platform.resourceDir +/+ "sounds/a11wlk01.wav"
~sf = SoundFile(~path);
~sf.asArray
~buf = Buffer.new(s, ~path)
~buf.play
~buf.loadToFloatArray(action:{ arg ar; ~array = ar; "done loading".postln })
~array = FloatArray.newClear(500)
~sf.readData(~array)
~sf.openRead(~path)
~sd
~array

~path = Platform.resourceDir +/+ "sounds/a11wlk01.wav"; // path to sound file
~sf = SoundFile(~path);
~array = FloatArray.newClear(500); // allocate space for 500 samples
~sf.openRead; // open file
~sf.readData(~array); // load the sound data into array
~sf.close; // close file;
~array; // here are your samples
~array[0..29].do(_.postln); // print 30 first samples


~path = Platform.resourceDir +/+ "sounds/a11wlk01.wav";
~buf = Buffer.read(s, ~path);
{ PlayBuf.ar(1, ~buf, rate: 1) }.play; // normal rate
{ PlayBuf.ar(1, ~buf, rate: 1/~buf.sampleRate * 17430) }.play; // 30 samples per second
~buf

{ SinOsc.ar( 500 * (1+PlayBuf.ar(1, ~buf, rate: 1/~buf.sampleRate * 790)))!2 *0.1 }.play; // 30 samples per second

{ SinOsc.ar( MouseX.kr(50,500) ) }.play

(
Ndef(\bla, {
	var sig;
	sig = LFSaw.ar( 500 *.t [1,1/2,1/4,2] * [1,1.0001,1.0541] * (1+PlayBuf.ar(1, ~buf, rate: 1, loop:1))) *0.1 ;
	sig = LFSaw.ar( 500 * (1+PlayBuf.ar(1, ~buf, rate: [1,2.01], loop:1))) *0.1 ;
	sig = PlayBuf.ar(1, ~buf, rate: [1,1/2,2.01], loop:1);
	sig = RLPF.ar(sig, \lpf.kr(700), \rq.kr(0.5));
	sig = sig * 0.3;
	sig = Pan2.ar(sig, 0, 1).flop;
	sig;
}).play; // 30 samples per second
)



{GVerb.ar(Dust.ar(5), drylevel:1)}.play

{GVerb.ar(Dust.ar(5), drylevel:0)}.play
{GVerb.ar(Dust.ar(5), drylevel:1)}.play

{GVerb.ar(Dust.ar(5), drylevel:0)}.play

