
(

{

	var a;

	a = Line.ar(-4, 4, 0.01);

	a.distort

}.plot
)


Pd


(
~bus = Bus.audio(s,2);
Ndef(\test, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq);
	sig = Pan2.ar(sig, pan, amp);
//}).play(~bus); // OK
//}).play(38, 2); // OK
}).play(~bus, 2); // error
);


// issue sent !!!

ERROR: binary operator '+' failed.
RECEIVER:
Instance of Bus {    (0xc936e90, gc=5C, fmt=00, flg=00, set=03)
  instance variables [5]
    rate : Symbol 'audio'
    index : Integer 38
    numChannels : Integer 2
    server : instance of Server (0xb93ea10, size=50, set=6)
    mapSymbol : nil
}
ARGS:
Instance of Array {    (0x9544450, gc=58, fmt=01, flg=00, set=03)
  indexed slots [2]
      0 : Integer 0
      1 : Integer 1
}
   nil
CALL STACK:
        DoesNotUnderstandError:reportError   0x9663410
                arg this = <instance of BinaryOpFailureError>
        Nil:handleError   0xc69e2b0
                arg this = nil
                arg error = <instance of BinaryOpFailureError>
        Thread:handleError   0xcfc3a90
                arg this = <instance of Thread>
                arg error = <instance of BinaryOpFailureError>
        Object:throw   0xcfc0610
                arg this = <instance of BinaryOpFailureError>
        Object:performBinaryOpOnSomething   0xab09d5f0
                arg this = <instance of Bus>
                arg aSelector = '+'
                arg thing = [*2]
                arg adverb = nil
        BusPlug:playToBundle   0xccf7330
                arg this = <instance of Ndef>
                arg bundle = <instance of MixedBundle>
                arg out = <instance of Bus>
                arg numChannels = 2
                arg group = nil
                arg multi = false
                arg vol = nil
                arg fadeTime = nil
                arg addAction = nil
        BusPlug:play   0xbd844d0
                arg this = <instance of Ndef>
                arg out = <instance of Bus>
                arg numChannels = 2
                arg group = nil
                arg multi = false
                arg vol = nil
                arg fadeTime = nil
                arg addAction = nil
                var bundle = <instance of MixedBundle>
        Interpreter:interpretPrintCmdLine   0xc2c5710
                arg this = <instance of Interpreter>
                var res = nil
                var func = <instance of Function>
                var code = "
(
~bus = Bus.audio(s,2);
Nd..."
                var doc = nil
                var ideClass = nil
        Process:interpretPrintCmdLine   0xcefa800
                arg this = <instance of Main>
^^ The preceding error dump is for ERROR: binary operator '+' failed.
RECEIVER: Bus(audio, 38, 2, localhost)


