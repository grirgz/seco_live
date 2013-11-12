
Ndef('38fx').fadeTime = Pdef.defaultQuant;
Ndef('amixer').fadeTime = Pdef.defaultQuant;
Ndef('38fx').setNodeMap( ~load_object.(\mapfx4) );
Ndef(\amixer).setNodeMap( ~load_object.(\mapmixer4), true );

// END

~save_object.(\mapmixer4, Ndef(\amixer).nodeMap)
Pdef.defaultQuant
~save_object.(\mapfx4, Ndef('38fx').nodeMap)
