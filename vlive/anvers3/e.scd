~name = \e;

Veco(~name).make_mixer;
~newfxmix.(\fx);
Veco(~name)[\is_playing] = { arg self; Ndef(self.get_name+++\fx).isPlaying }
