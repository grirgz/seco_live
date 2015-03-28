Tdef(\func1, { loop{ 5.postln; 0.5.wait } }); // assign
Tdef(\func1).play; // play
Tdef(\func1, { loop{ 7.postln; 0.5.wait } }); // replace

with a function :

~func = {|value = 18| { loop{ value.postln; 0.5.wait } } }; // no need to fork, the Tdef handle that

Tdef(\func1, ~func.(1));
Tdef(\func1, ~func.(2));

{PinkNoise.ar(1) * Line.kr(1,0,2,doneAction:2)}.play .onFree {"done".postln};
~synth1 = Synth(\default);
~synth1.onFree { "stop!".postln };
~synth1.release;
