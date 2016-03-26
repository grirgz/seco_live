
RandDelayNetwork(\default).make(~name+++\fx, "5--")

// END

Ndef(~name+++\fx).edit
RandDelayNetwork(\default).define_specs

				Ndef(~name+++\fx).addSpec(\shift, ControlSpec(-5,5,\lin));
				Ndef(~name+++\fx).addSpec(\shift2, ControlSpec(-5,5,\lin));
