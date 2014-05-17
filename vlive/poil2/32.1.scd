


ProxyChain.from(Ndef(~name+++\fx), [\infx4, \ringmod, \dist, \riseComb5, \rlpf]);
(
ProxyChain(~name).add(	
	\ringmod, nil, \filter -> { |in, randrate=5| 
		//in.asArray[0] // force mono inputs
		in
	}, 
)
);
//ProxyChain(~name, [\dust, \ringmod, \dist, \riseComb5, \test]);

//ProxyChain(~name).play(BusDef(~name+++\mixer));

Ndef(~name+++\fx).set(\inbus, BusDef(~name+++\fx).index);
ProxyChain(~name+++\fx).add(\infx4, 1);
ProxyChain(~name+++\fx).add(\ringmod, 1);
ProxyChain(~name+++\fx).add(\dist, 0);
ProxyChain(~name+++\fx).add(\riseComb5, 0);
ProxyChain(~name+++\fx).add(\rlpf, 0.5);

Ndef(~name+++\fx).ar(2);
Ndef(~name+++\fx).play(BusDef(~name+++\mixer));


// END
Ndef(~name+++\fx).edit
BusDef(~tfx4)
ProxyChain(~name+++\fx).proxy.set(\inbus, 0);
~tfx4
~fx4.index
VecoLib.load_lib
Ndef(~name).stop;
ProxyChain(~name)
MIDIBoard.map(\k9, Ndef(~name), \rlpfreq, \freq.asSpec)
MIDIBoard.map(\s9, Ndef(~name), \wet50, \unipolar.asSpec)
MIDIBoard.map(\s9, Ndef(~name+++\lfo1), \freq, \lofreq.asSpec)
MIDIBoard.map(\k9, Ndef(~name+++\lfo1), \hif, \freq.asSpec)
Ndef(~name).map(\rlpfreq, Ndef(~name+++\lfo1, { arg freq=1, hif=900; SinOsc.ar(freq).range(100,hif) }))
