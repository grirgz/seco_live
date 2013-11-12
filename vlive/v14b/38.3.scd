
(
Ndef(~name+++\fx,{|amp = 1, mix=0.5, inmix=1, maxdelay=0.1, delay=0.1, decay=0.5|
	var input = InFeedback.ar(BusDef(~name+++\fx), 2);
	var output;
	output = input;
	output = SelectX.ar(inmix,[Silent.ar, output]);
	output = CombL.ar(output, maxdelay, delay, decay);
	Out.ar(~fx1, output * \sendfx1.kr(0));
	output = SelectX.ar(mix,[input, output]);
	output = output * amp;
	output
});
)

// END

Ndef(~name+++\mixer).edit
Ndef(~name+++\mixer).play
Ndef(~name+++\fx).quant=2
Ndef(~name+++\fx).stop
Ndef(~name+++\fx).clear
Ndef(~name+++\fx).play(BusDef(~name+++\mixer))
~nm = Ndef(~name+++\fx).nodeMap.deepCopy
~nm2 = Ndef(~name+++\fx).nodeMap.deepCopy
~decay = Ndef(~name+++\fx).nodeMap.deepCopy
Ndef(~name+++\fx).setNodeMap( ~nm.deepCopy)
Ndef(~name+++\fx).setNodeMap( ~nm2.deepCopy, false)
Ndef(~name+++\fx).setNodeMap( ~decay.deepCopy, true)
Ndef(~name+++\fx).nodeMap = ~nm2
Ndef(~name+++\fx).fadeTime = 8

(
~save_object = { arg name, object;
	if(object.notNil) {
		object.writeArchive(Veco.main.data_path +/+ name ++ ".obj");
	};
};
~load_object = { arg name;
	Object.readArchive(Veco.main.data_path +/+ name ++ ".obj");
};
)

~save_object.(\mapfx1, Ndef(~name+++\fx).nodeMap)
~save_object.(\mapfx2, Ndef(~name+++\fx).nodeMap)

~save_object.(\mapmixer1, Ndef(\amixer).nodeMap)
~save_object.(\mapmixer2, Ndef(\amixer).nodeMap)

~load_object.(\mapfx1)
Ndef(~name+++\fx).setNodeMap( ~load_object.(\mapfx1) )
