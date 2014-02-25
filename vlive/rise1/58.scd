~name = '58';


Veco(~name).lib.fxname = 'fx3';
~newfxmix.(\fx); // fx using mixer
Veco(~name).make_mixer; // mixer
BusDef(Veco(~name).lib.fxname, \audio);

