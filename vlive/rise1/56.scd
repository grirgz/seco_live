~name = \56;


Veco(~name).lib.fxname = 'fx1';
~newfxmix.(\fx); // fx using mixer
Veco(~name).make_mixer; // mixer

BusDef(Veco(~name).lib.fxname, \audio);
