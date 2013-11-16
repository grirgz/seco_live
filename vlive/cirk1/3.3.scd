

~tracks = [~twobble+++\mixer, ~tfx2+++\fx];
~fade_to_maps.(~tracks, \map3);

// END
~save_maps.(~tracks, \map1);

Ndef(~tfx2+++\fx).fadeTime = Pdef.defaultQuant;
Ndef(~twobble+++\mixer).fadeTime = Pdef.defaultQuant;
Ndef(~tfx2+++\fx).setNodeMap( ~load_object.(\mapfx3) );
Ndef(~twobble+++\mixer).setNodeMap( ~load_object.(\mapmixer3), true );


(
~save_object.(\mapmixer3, Ndef(~twobble+++\mixer).nodeMap);
~save_object.(\mapfx3, Ndef(~tfx2+++\fx).nodeMap);
)
Pdef.defaultQuant
