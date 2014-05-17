(
Ndef(\bits, {
    var t = PulseCount.ar(Impulse.ar(8e3 * MouseX.kr(0.1,3)));
    var sig;

	sig = HPF.ar(
        (  
            ((t * [4,5]) & (t >> [1,MouseY.kr(1,4)]))
			//|((t * 5) & (t >> 3)) 
			//|((t * 2) & (t >> 2)) 
            //((t * 5) & (t >> [6, 4])) |
            //((t * 2) & (t >> 1)) |
            //((t * 8) & (t >> 11))
        ) % 256
        , 20
    ).distort * 0.2; 
	sig;
    //sig = Greyhole.ar(sig, sig, 0.5, sig);
}).play;
)
