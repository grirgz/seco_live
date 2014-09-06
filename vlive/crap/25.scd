(
	x = {
		        var freq = DemandEnvGen.ar(Dseq([300, 500], inf), 1, 8.0);
				        SinOsc.ar(freq.lag(0.01) ! 2) * 0.1

	}.play;

)
Env.shapeNames


(
x = {
        var freq = EnvGen.ar(Env([300, 500, 300], [1,1], \step), 1);
        SinOsc.ar(freq.lag(0.01).poll ! 2) * 0.1
}.play;
)

(
x = {
        var freq = EnvGen.ar(Env([300, 500, 300, 600], [1,1,1], \hold), 1);
        SinOsc.ar(freq.lag(0.01).poll ! 2) * 0.1
}.play;
)
(
x = {
        var freq = EnvGen.kr(Env([300, 500, 300, 600], [1,1,1], \step), 1);
		freq;
}.plot(4);
)
(
x = {
        var freq = EnvGen.kr(Env([300, 500, 300, 600], [1,1,1], \hold), 1);
		freq;
}.plot(4);
)

(
x = {
        var freq = EnvGen.kr(Env([300, 500, 400, 600], [1,1,2]/5, \hold), TDuty.kr(1,0,1));
		freq;
}.plot(4);
)
