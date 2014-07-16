~name = 'rise9-7';

BufDef.mono(\ukraine, "bruit1/07_ukraine.flac");
~ndef_channel.(\fx);
Ndef(~name+++\fx).quant = Pdef.defaultQuant;
Ndef(~name+++\fx).fadeTime=4;
Ndef(~name+++\mixer).fadeTime = 4;

// END


Ndef(~name+++\fx).end(4)
Ndef(~name+++\fx).free(4)
Ndef(~name+++\fx).isPlaying
Veco(~name)[\stop_node_hook_dict].asCompileString
Veco(~name)[\val_stop_node_hook_dict].asCompileString
