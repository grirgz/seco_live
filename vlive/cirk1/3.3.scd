
Ndef(~tfx2+++\fx).fadeTime = Pdef.defaultQuant;
Ndef(~twobble+++\mixer).fadeTime = Pdef.defaultQuant;
//Ndef(~tfx2+++\fx).setNodeMap( ~load_object.(\mapfx1) );
Ndef(~twobble+++\mixer).setNodeMap( ~load_object.(\mapmixer3), true );

// END

~save_object.(\mapmixer3, Ndef(~twobble+++\mixer).nodeMap)
Pdef.defaultQuant
