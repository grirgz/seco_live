
~tracks = [~twobble+++\mixer, ~tfx2+++\fx];
~fade_to_maps.(~tracks, \map2);

// END
~save_maps.(~tracks, \map2);
Ndef(~tfx2+++\fx).fadeTime = Pdef.defaultQuant;
Ndef(~twobble+++\mixer).fadeTime = Pdef.defaultQuant;
Ndef(~tfx2+++\fx).setNodeMap( ~load_object.(\mapfx2) );
Ndef(~twobble+++\mixer).setNodeMap( ~load_object.(\mapmixer2) );


~save_object.(\mapmixer2, Ndef(~twobble+++\mixer).nodeMap);
~save_object.(\mapfx2, Ndef(~tfx2+++\fx).nodeMap);
