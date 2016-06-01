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
