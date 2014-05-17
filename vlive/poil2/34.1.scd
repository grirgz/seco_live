
(
Ndef(~name+++\fx, { 
	var sigin, sig;
	sigin = InFeedback.ar(BusDef(~name+++\fx), 2);
	sigin;
});
)


// END

(
Ndef(~name+++\fx).put(10, \filter -> { arg in;
	var sigin, sig;
	sigin = in * SinOsc.ar(200);
	sigin;
});
)
Ndef(~name+++\fx).removeAt(1)
Ndef(~name+++\fx).fadeTime = 0.1
Ndef(~name+++\fx).fadeTime = 4
Ndef(~name+++\fx).removeLast

(
a = Ndef(~name+++\fx).add(\filter -> { arg in;
	var sigin, sig;
	sigin = in * SinOsc.ar(100);
	sigin;
});
)
a.objects.do { arg key, val; [key, val].debug("kv") }
a.objects.lastIndex
a.lastIndex
a.controlNames
