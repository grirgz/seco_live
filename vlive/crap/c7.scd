(
Ndef(\addit, {
    var f0 = 36.midicps;//MouseY.kr(50, 2000);
    var n = 256;
    var freqs = (1..n) * f0;
    var amps = 0.5 / (1..n) ** 1;
            var sig = Mix.ar(DynKlang.ar(`[ freqs, amps , pi]));
    Pan2.ar(sig * 0.5, 0.0);
}).play;
)

~buffer = nil
(
~size = 256;
~buffer = ~buffer ?? { 
    Buffer.loadCollection(s, ~size.collect { |i|  1 - (i/~size) })
};

Ndef(\addit, {
    var sig;
    var freq = 36.midicps;
    
    sig = ~size.collect {
        |i|
        var amp = BufRd.kr(1, ~buffer, i, 0, 0).lag(1/20);
        SinOsc.ar(freq * (i + 1), pi, amp)
    };
    sig = sig.sum;
    Pan2.ar(sig * 0.5, 0.0) ;
}).play
)

Ndef(\addit).clear


[1 - ((0..~size-1)/~size), 0.5/(1..~size)].plot
