~name = '34';

~newfxmix.(\fx);
Veco(~name).make_mixer;

8.do { arg x; Veco(~name).get_clip_by_index(x).response_mode = \play; };
