// .reset is useless
// should use stop.play instead
// also check there is not quant


//1
(
Ndef(\a).play;

Ndef(\a, { |freq,mult,amp,ampmult,pan|
Pan2.ar(SinOsc.ar(freq*mult, 0, amp*ampmult),pan) });

Ndef(\a).set(\freq,100,\mult,2,\amp,0.5,\ampmult,2,\pan,1);
)

//2 
//run this

(
~k=[Pseq([1,5,2,1,5]),Pseq([0.1,0.5,0.2,0.1,0.5])];

Ndef(\a).set(\freq,100,\mult,2,\amp,0.5,\ampmult,2,\pan,1);

Tdef(\x, {
	var pattern;
	pattern = ~k.size.collect{|i|
		~k[i].loop.asStream};
	inf.do({
		Ndef(\a).set(
			\mult, pattern[0].next,
			\ampmult, pattern[1].next);
		100.8.wait;				
})};).stop.play;
)

//3
//then this
(
~k=[Pseq([1,5,2,1,5]/2),Pseq([0.1,0.5,0.2,0.1,0.5])];

Ndef(\a).set(\freq,1000,\mult,2,\amp,0.5,\ampmult,2,\pan,1);

Tdef(\x, {
	var pattern;
	pattern = ~k.size.collect{|i|
		~k[i].loop.asStream};
	inf.do({
		Ndef(\a).set(
			\mult, pattern[0].next,
			\ampmult, pattern[1].next);
		0.02.wait;			
})};).stop.play;
)

Tdef(\x).quant = 0

Thank you!

(
~k=[Pseq([1,5,2,1,5]/2),Pseq([0.1,0.5,0.2,0.1,0.5])];

Ndef(\a).set(\freq,1000,\mult,2,\amp,0.5,\ampmult,2,\pan,1);

Tdef(\x, {
	var pattern;
	pattern = ~k.size.collect{|i|
		~k[i].loop.asStream};
	inf.do({
		Ndef(\a).set(
			\mult, pattern[0].next,
			\ampmult, pattern[1].next);
		0.02.wait;			
})};).stop
)
