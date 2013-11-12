
Ndef(~tfx2+++\fx).fadeTime = Pdef.defaultQuant;
Ndef(~twobble+++\mixer).fadeTime = Pdef.defaultQuant;
Ndef(~tfx2+++\fx).setNodeMap( ~load_object.(\mapfx4) );
Ndef(~twobble+++\mixer).setNodeMap( ~load_object.(\mapmixer4), true );

// END

~save_object.(\mapmixer4, Ndef(~twobble+++\mixer).nodeMap)
Pdef.defaultQuant
~save_object.(\mapfx4, Ndef(~tfx2+++\fx).nodeMap)
