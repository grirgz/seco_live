~name = '57';


Veco(~name).lib.fxname = 'fx2';
~newfxmix.(\fx); // fx using mixer
Veco(~name).make_mixer; // mixer

BusDef(Veco(~name).lib.fxname, \audio);
