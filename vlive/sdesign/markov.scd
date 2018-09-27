(

SynthDef(\acsound,{|freq=440,amp=0.1,dur= 0.2,cutoff=2000|

var sound, filter;


sound= Saw.ar(freq, amp)*EnvGen.kr(Env([0,1,1,0],[0.01,0.05,(dur.max(0.07))-0.06]),doneAction:2);  


filter= LPF.ar(sound,Line.kr(cutoff,300,dur)); 


Out.ar(0,filter.dup(2))

}).add;

)




(

	var markovmatrix; 
	var currentstate=3.rand; //start in one of three states

	markovmatrix= [
		[0.7,0.2,0.1],
		[0.0,0.5,0.5],
		[0.3,0.4,0.3]
	];

	{
		20.do{
			Synth(\acsound,[\freq, [48,60,64].at(currentstate).midicps, \dur, 2]); 
			//which probability distribution to use depends on what state we're in right now
			currentstate = [0,1,2].wchoose(markovmatrix[currentstate]); 
			0.25.wait;
		};
	}.fork;

)

(
	~r = Routine({ arg ev;
		var markovmatrix; 
		var currentstate=3.rand; //start in one of three states

		markovmatrix= [
			[0.7,0.2,0.1],
			[0.0,0.5,0.5],
			[0.3,0.4,0.3]
		];
		20.do{
			ev = [48,60,64].at(currentstate).midicps.yield(ev);
			currentstate = [0,1,2].wchoose(markovmatrix[currentstate]); 
		};
	});

	{
		~r.do { arg val;
			Synth(\acsound,[\freq, val, \dur, 2]); 
			0.25.wait;
		}
	}.fork;
	
	


)

(

	// TODO: don't work, crash sc
Pdef(\zed, 
	Pbind(
		\instrument, \acsound,
		\freq, ~r,
		\dur, 0.25,
		\amp, 0.1,
	).trace
).play;
)

(
Pdef(\zed, 
	Pbind(
		\instrument, \acsound,
		\freq, Prout({ arg ev;
			var markovmatrix; 
			var currentstate=3.rand; //start in one of three states

			markovmatrix= [
				[0.7,0.2,0.1],
				[0.0,0.5,0.5],
				[0.3,0.4,0.3]
			];
			20.do{
				ev = [48,60,64].at(currentstate).midicps.yield(ev);
				currentstate = [0,1,2].wchoose(markovmatrix[currentstate]); 
			};
		}).trace,
		\dur, 0.25/4,
		\amp, 0.1,
	)
).play;
);
