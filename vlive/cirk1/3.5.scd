~tracks = [~twobble+++\mixer, ~tfx2+++\fx];
~fade_to_maps.(~tracks, \map1);

// END
~save_maps.(~tracks, \map1);

(
~save_object.(\mapmixer1, Ndef(~twobble+++\mixer).nodeMap);
~save_object.(\mapfx1, Ndef(~tfx2+++\fx).nodeMap);
);

Ndef(~tfx2+++\fx).fadeTime = Pdef.defaultQuant;
Ndef(~twobble+++'mixer').fadeTime = Pdef.defaultQuant;
//Ndef(~tfx2+++\fx).setNodeMap( ~load_object.(\mapfx1) );
//Ndef(~twobble+++'mixer').setNodeMap( ~load_object.(\mapmixer1) );
Ndef(~tfx2+++\fx).fadeToMap(~load_object.(\mapfx2));
Ndef(~twobble+++\mixer).fadeToMap(~load_object.(\mapmixer2));
