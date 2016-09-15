
Quarks.install("rd_dot")
"sudo apt-get install xdot".unixCmd; // gtk dot drawer
"sudo apt-get install graphviz".unixCmd; // old drawer (dotty)

should modify rd_dot/sclang/DotViewer.sc to replace dotty by xdot


{ SinOsc.ar(300)  }.draw;
SynthDesc(\zkick).def.draw
Ndef(\bla).source.draw;
Ndef(\bla)[0].draw;

(
SynthDef(\hello, { arg out=0, freq=200;
	var sig = SinOsc.ar(freq, \phase.kr(1)) ;
	Out.ar(out, sig);
}).draw;
)

(
ProxySynthDef(\hello, { arg out=0, freq=200;
	var sig = SinOsc.ar(freq, \phase.kr(1)) ;
	Out.ar(out, sig);
}).draw;
)
ProxySynthDef(\hello)



// draw a Ndef graph with \filter
{ Ndef(\fx1).sources[1].value.value(In.ar(2)) }.draw
