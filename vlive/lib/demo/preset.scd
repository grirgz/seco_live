// set the specs

Sdef(~name, \mypreset, \preset, ~name);

}, metadata:(specs:(
	env0: \env -> [4, ControlSpec(0.001,8,\exp, 0, 1), nil, nil, Env.new([9.5, 1, 0.5, 0], [0.105, 0.16, 00.2])],
	env1: \env -> [3, ControlSpec(5,128,\lin, 0, 50), nil, nil, Env.new([210, 29, 59], [0.105, 0.29], [-4, -5])],
	env2: \env -> [3, ControlSpec(5,128,\lin, 0, 50), nil, nil, Env.new([210, 29, 59], [0.105, 0.29], [-4, -5])],
	env3: \env -> [3, ControlSpec(5,128,\lin, 0, 50), nil, nil, Env.new([210, 29, 59], [0.105, 0.29], [-4, -5])],

))).add;

Sdef(~name, \mypreset).rebuild(true)

// see presets for the y.24 nodeclip
~score_storage.all[\y][\mypreset].all[0].indices
~score_storage.all[\y][\mypreset].all[27].indices
~score_storage.all[\y][\mypreset].all.indices
~score_storage.all[\y][\mypreset].all.indices
~score_storage.all[\y][\mypreset].all[25][0] == ~score_storage.all[\y][\mypreset].all[24][1]
~score_storage.all[\y][\mypreset].all[25][0].vals.keysValuesDo{ arg k,v; v.get_val.debug(k) };
~score_storage.all[\y][\mypreset].all[27][0].vals.keysValuesDo{ arg k,v; v.get_val.debug(k) };
~score_storage.all[\y][\mypreset].all[26][0].get_event
~score_storage.all[\y][\mypreset].all[25][1]

Sdef(~name, \mypreset).all.indices
Sdef(~name, \mypreset).get(0).vals.keysValuesDo{ arg k,v; v.get_val.debug(k) };
Sdef(~name, \mypreset).get(0, 0).vals.keysValuesDo{ arg k,v; v.get_val.debug(k) };
~score_storage.all[\y][\mypreset].all[0][0].vals.keysValuesDo{ arg k,v; v.get_val.debug(k) };
