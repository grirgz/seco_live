~name = '32';


Veco(~name).make_mixer;
~newfxmix.(\fx);



(
{
	var name = ~name;
	Veco(~name).add_stop_node_hook(\main, { 
		//Ndef(name).stop 

		ProxyChain(name).end(4);
	})
}.value
);

// END

(
ProxyChain(~name+++\fx).add(	
	\ringmod, nil, \filter -> { |in, randrate=5| 
		//in.asArray[0] // force mono inputs
		in * SinOsc.ar(LFNoise0.kr([randrate, randrate]).exprange(100, 300)).sum 
	}, 
)
)
(
ProxyChain(~name+++\fx).add(	
	\ringmod, nil, \filter -> { |in, randrate=5| 
		//in.asArray[0] // force mono inputs
		in * SinOsc.ar(SinOsc.kr([randrate, randrate]).exprange(100, 300)).sum 
	}, 
)
)
(
ProxyChain(~name+++\fx).add(	
	\ringmod, nil, \filter -> { |in, randrate=5| 
		//in.asArray[0] // force mono inputs
		in * LFSaw.ar(SinOsc.kr([randrate, randrate]).exprange(100, 4300))
	}, 
)
)
(
ProxyChain(~name+++\fx).add(	
	\ringmod, nil, \filter -> { |in, randrate=5, hif=3000| 
		//in.asArray[0] // force mono inputs
		in * LFSaw.ar(LFSaw.kr([randrate, randrate]).exprange(100, hif))
	}, 
)
)

(
ProxyChain(~name+++\fx).add(	
	\ringmod, nil, \filter -> { |in, randrate=5| 
		//in.asArray[0] // force mono inputs
		in
	}, 
)
)

(
ProxyChain(~name+++\fx).add(	
	\ringmod, nil, \filter -> { |in, randrate=5, hif=3000| 
		//in.asArray[0] // force mono inputs
		in * LFSaw.ar(hif)
	}, 
)
)
ProxyChain(~name).sources.put(\ringmod, nil);// back to global dust
ProxyChain(~name).slotNames
