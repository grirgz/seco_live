~notesAndDurs = [
	        [0, 2, 3, 2, 3, 4, 6, 4, 3, 2, 0, -2, 0, 2, 3, 2, 3, 4, 2, 4, 0, 2, 3, 2, 0],
			[1, 1, 2, 1, 1, 1, 2, 2, 2, 1, 2, 1, 2, 1, 2, 1, 1, 2, 1, 2, 1, 1, 1, 1, 2] * 0.25/2

].flop;
(
var counter = Pseries(1, 1, inf),
counter2 = Pseq([Pseries(1, 1, 8), Pseries(8, -1, 8)],inf),
numStream = Pstutter(1, counter2).trace.asStream,
repeatStream = Pstutter(Pseq([1,2,4,2,1],inf), 1).asStream;

p = Pbind(
        #[degree, dur], Pn(
                Pn(
                        Pser(~notesAndDurs, numStream),
                        repeatStream
                ),
                inf
        ),
        \scale, #[0, 2, 3, 5, 7, 9, 11],
        \root, 5,
        \octave, 4
).play;
)



~f = { arg x; x+(x**2) }; ~f.((0..100))
100.do { arg x; ~f.(x).postln }
~f.(14)
x^x=x



( 
var w, buttons, data, synths, dims = [16,16], resolution = 4; 
w = Window("rand-n-step", Rect(50,250,dims[0]*22 + 10,dims[1]*22+10)); 

synths = Array.fill(dims[1], { |i|
	SynthDef('rstp'++i, {
		var sig = Pan2.ar(
			PMOsc.ar(80.exprand(10000), 1.exprand(200), 1.exprand(20)),
			-1.0.rand2,
			EnvGen.kr(Env(Array.rand(4, 0, 0.1.rrand(0.5)).add(0), Array.rand(3, 0.1, 0.3).add(0.1), -5.rrand(5)), doneAction: 2)
		);
		Out.ar(0, sig);
	}).add.name;
});

data = Array2D(dims[1],dims[0]);
buttons = Array.fill(dims[1], { |l|
	Array.fill(dims[0], { |i| 
		Button( w, Rect( 5 + (22*i), 5 + (22*l), 20, 20) ).states_([ ['-'], ['+'], ['%'] ]).action_({ |b| data[l,i] = b.value }); 
	})
}); 

AppClock.play({
	inf.do({|i|
		dims[1].do({ |l|
			(buttons[l] @@ i).font_(Font("sans", 20));
			(buttons[l] @@ (i-1)).font_(Font("sans", 14));
			switch( data[l,i.mod(dims[0])],
				1, { Synth(synths[l]) },
				2, { 0.5.coin.if({ Synth(synths[l]) }) }
			);  
		});
		(TempoClock.default.tempo.reciprocal / resolution).yield;
	});
}.asRoutine);
w.front; 
)
