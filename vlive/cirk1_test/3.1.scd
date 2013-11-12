
Ndef(~tfx2+++\fx).fadeTime = Pdef.defaultQuant;
Ndef(~twobble+++'mixer').fadeTime = Pdef.defaultQuant;
Ndef(~tfx2+++\fx).setNodeMap( ~load_object.(\mapfx1) );
Ndef(~twobble+++'mixer').setNodeMap( ~load_object.(\mapmixer1) );

// END

(
~save_object.(\mapmixer1, Ndef(~twobble+++\mixer).nodeMap);
~save_object.(\mapfx1, Ndef(~tfx2+++\fx).nodeMap);
);
