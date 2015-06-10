MKtl.find;



k = MKtl('cncn2000')

k.gui;


//all elements in a dictionary
k.elements.printAll;


//all the base keys
//some are individual elements others are arrays of elements (or arrays of arrays, etc).
k.elements.keys;

//the play button
k.elementAt(\play);

//the first slider
k.elements(\sl, 0)

//all sliders in an array
k.elementAt(\sl)

//the third knob
k.elementAt(\kn, 2);

//the button on row 2 and column 5
//buttons are organized first by rows and then columns.
k.elementAt(\bt, 1, 4)

//all buttons on row 2
k.elementAt(\bt, 1)

//all buttons on column 5
k.elementAt(\bt).asArray.flop[4]

//flopping switches rows and columns
(
[
    [1,2],
    [3,4]
].flop.postln
)

//note: this does not work with the nanoKONTROL2, however, if the controller would have hardware scenes, the button on row 2 and column 5 of scene 4 would be at:  k.elements[\bt][3][1][4]



~e =  k.elementAt(\bt, 1, 1)
~e =  k.elementAt(\sl, 1)
if(~e.class.name == 'MKtlElement') { ~e.action = { arg sl; sl.value.debug("kk") } }
