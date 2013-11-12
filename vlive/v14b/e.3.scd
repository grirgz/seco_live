
Ndef('38fx').fadeTime = Pdef.defaultQuant;
Ndef('amixer').fadeTime = Pdef.defaultQuant;
//Ndef('38fx').setNodeMap( ~load_object.(\mapfx1) );
Ndef(\amixer).setNodeMap( ~load_object.(\mapmixer3), true );

// END

~save_object.(\mapmixer3, Ndef(\amixer).nodeMap)
Pdef.defaultQuant
