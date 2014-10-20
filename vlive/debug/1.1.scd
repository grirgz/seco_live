Pdef(~name +++ \pre, 
	~dPdef.(~name+++\macro) <>
	
	Pbind(
	\freq, 100,
));


// END

Pdef(~name+++\macro).set(\freq2, 200)
Pdef(~name+++\macro).asRack.edit
~set_macro.(\k1, Pdef(~name+++\macro), \freq2)
