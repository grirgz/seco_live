MKtl.find;
MKtl.find(\midi)

MKtl('midi_2_launch', 'midi_2_launchpad_s');
MKtl('icon', "icon-icontrols");
k = MKtl('icon')
k.gui;

k.elementGroup;
k.postElements;
k[\kn].do { arg k; k.postln }
k[\knobs]
k[\kn].collect({ arg k; k })
k[\kn][0]


k = MKtl(\lp, "novation-launchpad-s");
k.elAt(\bt).action = { "blalla".postln }
k.elAt(\pad).elAt(0).elAt(0).action = { "0 on pushed".postln; }
k.elAt(\pad).elAt(0).elAt(0).value = 0xd4.linlin(0,127,0,1)
k.elAt(\pad).elAt(2).elAt(0).value = 0x1b/127
k.elAt(\pad).elAt(2).elAt(0).value = 0xb0.linlin(0,127,0,1)
k.elAt(\pad).value = 0x0b.linlin(0,127,0,1)
k.elAt(\bt).flat.do({ arg x; x.value = 0x00.linlin(0,127,0,1)})
k.elAt(\arr).flat.do({ arg x; x.value = 0x00.linlin(0,127,0,1)})
k.elAt(\pad).elAt(0).elAt(0).value = 0.05
k.elAt(\pad).elAt(0).elAt(0).value 
k.postElements
0x3c

m= MIDIOut(0)
m.sysex(Int8Array[ 0xb0,0,0 ]); // clear grid
m.sysex(Int8Array[ 0xb0,0,0x7f ]); // full test
m.sysex(Int8Array[ 0xb0,0,0x28 ]); // turn on flashing mode
m.sysex(Int8Array[ 0xb0,0,0x20 ]); // manual flash on
m.sysex(Int8Array[ 0xb0,0,0x21 ]); // manual flash off
MKtl(\lp).desc.rebuild
MKtl(\lp).sendSpecialMessage(\enableFlashMode)
MKtl(\lp).sendSpecialMessage(\clearAll)
MKtl(\lp).specialMessages


MKtl(\lp).sendSpecialMessage(\enableFlashModex)
MKtl(\lp).sendSpecialMessage(\existnot)

//=== refresh description file:
MKtlDesc.loadDescs; // first do this!
MKtl(\lp).rebuild("novation-launchpad-s"); 
//MKtl(\lp).rebuild;  // doesnt work

k.elAt(\pad).elAt(2).elAt(0).value = 0x0f/127 - 0x0c // substract 0x0c to make it flash
