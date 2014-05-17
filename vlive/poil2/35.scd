~name = '35';

~newfxmix.(\fx);
Veco(~name).make_mixer;
Veco(~name).add_stop_node_hook(\fx, { "rah".debug("rahxx") });
Veco(~name).add_stop_node_hook(\mixer, { "rah".debug("rahxx") });
Veco(~name).get_clip_by_index(0).response_mode = \play;

// END

Veco(~name).clips
