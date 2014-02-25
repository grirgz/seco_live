
Sdef('6', 'mypreset').set_data(0, 0, 
	(
		specs: [ 'amp', ControlSpec(0, 1, 'amp', 0, 0.10000000149012, ""), 'pan', ControlSpec(-1, 1, 'linear', 0.0, 0.0, ""), 'fratio', ControlSpec(0.1, 20000, 'exp', 0, 1.5, ""), 'rq', ControlSpec(0.001, 2, 'exp', 0, 0.5, ""), 'fratiob', ControlSpec(0.1, 20000, 'exp', 0, 2.0, ""), 'dmix', ControlSpec(0, 1, 'linear', 0, 0.5, ""), 'rqc', ControlSpec(0.001, 2, 'exp', 0, 0.5, ""), 'fratioc', ControlSpec(0.1, 20000, 'exp', 0, 2.0, ""), 'dmix2', ControlSpec(0, 1, 'linear', 0, 0.20000000298023, ""), 'pwidth', ControlSpec(0, 1, 'linear', 0, 0.5, ""), 'driveamp', ControlSpec(0.001, 5, 'linear', 0, 0.20000000298023, ""), 'distmix', ControlSpec(0, 1, 'linear', 0, 0.5, ""), 'drive', ControlSpec(0, 10, 'linear', 0, 2.0, ""), 'cliplevel', ControlSpec(0.001, 5, 'linear', 0, 1.0, ""), 'doneActiona', ControlSpec(0.1, 20000, 'exp', 0, 0.0, ""), 'doneActionb', ControlSpec(0.1, 20000, 'exp', 0, 0.0, ""), 'doneActionc', ControlSpec(0.1, 20000, 'exp', 0, 0.0, ""), 'env0', ('env' -> [ 4, ControlSpec(0.001, 8, 'exp', 0, 1, ""), nil, nil, Env([ 0.5, 1, 0.5, 0 ], [ 0.05, 0.06, 0.1 ], [ -4, -2, -4 ]) ]), 'env1', ('env' -> [ 3, ControlSpec(5, 128, 'linear', 0, 50, ""), nil, nil, Env([ 80, 19, 70 ], [ 0.05, 0.09 ], [ -4, 5 ]) ]), 'env0c', ('env' -> [ 4, ControlSpec(0.001, 8, 'exp', 0, 1, ""), nil, nil, Env([ 0.5, 1, 0.5, 0 ], [ 0.05, 0.06, 0.1 ], [ -4, -2, -4 ]) ]), 'env1c', ('env' -> [ 3, ControlSpec(5, 128, 'linear', 0, 50, ""), nil, nil, Env([ 80, 19, 70 ], [ 0.05, 0.09 ], [ -4, 5 ]) ]), 'env0b', ('env' -> [ 4, ControlSpec(0.001, 8, 'exp', 0, 1, ""), nil, nil, Env([ 0.5, 1, 0.5, 0 ], [ 0.05, 0.06, 0.1 ], [ -4, -2, -4 ]) ]), 'env1b', ('env' -> [ 3, ControlSpec(5, 128, 'linear', 0, 50, ""), nil, nil, Env([ 80, 19, 70 ], [ 0.05, 0.09 ], [ -4, 5 ]) ]) ],
		version: 1,
		data: [ 'amp', 1.0, 'pan', 0.0, 'fratio', 1.5, 'rq', 0.5, 'fratiob', 2.0, 'dmix', 0.5, 'rqc', 0.5, 'fratioc', 2.0, 'dmix2', 0.20000000298023, 'pwidth', 0.5, 'driveamp', 0.20000000298023, 'distmix', 0.5, 'drive', 2.0, 'cliplevel', 1.0, 'doneActiona', 0.0, 'doneActionb', 0.0, 'doneActionc', 0.0, 'env0', Env([ 0.5, 1, 0.5, 0 ], [ 0.05, 0.06, 0.1 ], [ -4, -2, -4 ]), 'env1', Env([ 80, 19, 18.34 ], [ 0.05, 0.09 ], [ -4, 5 ]), 'env0c', Env([ 0.5, 1, 0.5, 0 ], [ 0.05, 0.06, 0.1 ], [ -4, -2, -4 ]), 'env1c', Env([ 80, 19, 70 ], [ 0.05, 0.09 ], [ -4, 5 ]), 'env0b', Env([ 0.5, 1, 0.5, 0 ], [ 0.05, 0.06, 0.1 ], [ -4, -2, -4 ]), 'env1b', Env([ 80, 19, 30.64 ], [ 0.05, 0.09 ], [ -4, 5 ]) ],
	)
);

Sdef('6', 'mypreset').set_data(1, 0, 
	(
		specs: [ 'amp', ControlSpec(0, 1, 'amp', 0, 0.10000000149012, ""), 'pan', ControlSpec(-1, 1, 'linear', 0.0, 0.0, ""), 'fratio', ControlSpec(0.1, 20000, 'exp', 0, 1.5, ""), 'rq', ControlSpec(0.001, 2, 'exp', 0, 0.5, ""), 'fratiob', ControlSpec(0.1, 20000, 'exp', 0, 2.0, ""), 'dmix', ControlSpec(0, 1, 'linear', 0, 0.5, ""), 'rqc', ControlSpec(0.001, 2, 'exp', 0, 0.5, ""), 'fratioc', ControlSpec(0.1, 20000, 'exp', 0, 2.0, ""), 'dmix2', ControlSpec(0, 1, 'linear', 0, 0.20000000298023, ""), 'pwidth', ControlSpec(0, 1, 'linear', 0, 0.5, ""), 'driveamp', ControlSpec(0.001, 5, 'linear', 0, 0.20000000298023, ""), 'distmix', ControlSpec(0, 1, 'linear', 0, 0.5, ""), 'drive', ControlSpec(0, 10, 'linear', 0, 2.0, ""), 'cliplevel', ControlSpec(0.001, 5, 'linear', 0, 1.0, ""), 'doneActiona', ControlSpec(0.1, 20000, 'exp', 0, 0.0, ""), 'doneActionb', ControlSpec(0.1, 20000, 'exp', 0, 0.0, ""), 'doneActionc', ControlSpec(0.1, 20000, 'exp', 0, 0.0, ""), 'env0', ('env' -> [ 4, ControlSpec(0.001, 8, 'exp', 0, 1, ""), nil, nil, Env([ 0.5, 1, 0.5, 0 ], [ 0.05, 0.06, 0.1 ], [ -4, -2, -4 ]) ]), 'env1', ('env' -> [ 3, ControlSpec(5, 128, 'linear', 0, 50, ""), nil, nil, Env([ 80, 19, 70 ], [ 0.05, 0.09 ], [ -4, 5 ]) ]), 'env0c', ('env' -> [ 4, ControlSpec(0.001, 8, 'exp', 0, 1, ""), nil, nil, Env([ 0.5, 1, 0.5, 0 ], [ 0.05, 0.06, 0.1 ], [ -4, -2, -4 ]) ]), 'env1c', ('env' -> [ 3, ControlSpec(5, 128, 'linear', 0, 50, ""), nil, nil, Env([ 80, 19, 70 ], [ 0.05, 0.09 ], [ -4, 5 ]) ]), 'env0b', ('env' -> [ 4, ControlSpec(0.001, 8, 'exp', 0, 1, ""), nil, nil, Env([ 0.5, 1, 0.5, 0 ], [ 0.05, 0.06, 0.1 ], [ -4, -2, -4 ]) ]), 'env1b', ('env' -> [ 3, ControlSpec(5, 128, 'linear', 0, 50, ""), nil, nil, Env([ 80, 19, 70 ], [ 0.05, 0.09 ], [ -4, 5 ]) ]) ],
		version: 1,
		data: [ 'amp', 1.0, 'pan', 0.0, 'fratio', 1.5, 'rq', 0.5, 'fratiob', 2.0, 'dmix', 0.5, 'rqc', 0.5, 'fratioc', 2.0, 'dmix2', 0.20000000298023, 'pwidth', 0.5, 'driveamp', 1.090898255814, 'distmix', 0.5, 'drive', 2.3837209302326, 'cliplevel', 0.5241511627907, 'doneActiona', 0.0, 'doneActionb', 0.0, 'doneActionc', 0.0, 'env0', Env([ 0.50000000352667, 0.0085833792642842, 0.50000000352667, 0.001 ], [ 0.051086329227834, 0.058724113741444, 0.10000003174369 ], [ -4, -2, -4 ]), 'env1', Env([ 80.000001788139, 94.454545454545, 51.885454653339 ], [ 0.579595727589, 0.12159852428172 ], [ -4, 5 ]), 'env0c', Env([ 0.5, 1, 0.5, 0 ], [ 0.05, 0.06, 0.1 ], [ -4, -2, -4 ]), 'env1c', Env([ 80.000001788139, 51.558823924293, 69.99999666214 ], [ 0.040329520499771, 0.11158081427596 ], [ -4, 5 ]), 'env0b', Env([ 0.5, 1, 0.5, 0 ], [ 0.05, 0.06, 0.1 ], [ -4, -2, -4 ]), 'env1b', Env([ 80.000001788139, 22.727273122153, 30.639999374747 ], [ 0.085573119805074, 0.052586615364427 ], [ -4, 5 ]) ],
	)
);

Sdef('6', 'mypreset').set_data(2, 0, 
	(
		specs: [ 'amp', ControlSpec(0, 1, 'amp', 0, 0.10000000149012, ""), 'pan', ControlSpec(-1, 1, 'linear', 0.0, 0.0, ""), 'fratio', ControlSpec(0.1, 20000, 'exp', 0, 1.5, ""), 'rq', ControlSpec(0.001, 2, 'exp', 0, 0.5, ""), 'fratiob', ControlSpec(0.1, 20000, 'exp', 0, 2.0, ""), 'dmix', ControlSpec(0, 1, 'linear', 0, 0.5, ""), 'rqc', ControlSpec(0.001, 2, 'exp', 0, 0.5, ""), 'fratioc', ControlSpec(0.1, 20000, 'exp', 0, 2.0, ""), 'dmix2', ControlSpec(0, 1, 'linear', 0, 0.20000000298023, ""), 'pwidth', ControlSpec(0, 1, 'linear', 0, 0.5, ""), 'driveamp', ControlSpec(0.001, 5, 'linear', 0, 0.20000000298023, ""), 'distmix', ControlSpec(0, 1, 'linear', 0, 0.5, ""), 'drive', ControlSpec(0, 10, 'linear', 0, 2.0, ""), 'cliplevel', ControlSpec(0.001, 5, 'linear', 0, 1.0, ""), 'doneActiona', ControlSpec(0.1, 20000, 'exp', 0, 0.0, ""), 'doneActionb', ControlSpec(0.1, 20000, 'exp', 0, 0.0, ""), 'doneActionc', ControlSpec(0.1, 20000, 'exp', 0, 0.0, ""), 'env0', ('env' -> [ 4, ControlSpec(0.001, 8, 'exp', 0, 1, ""), nil, nil, Env([ 0.5, 1, 0.5, 0 ], [ 0.05, 0.06, 0.1 ], [ -4, -2, -4 ]) ]), 'env1', ('env' -> [ 3, ControlSpec(5, 128, 'linear', 0, 50, ""), nil, nil, Env([ 80, 19, 70 ], [ 0.05, 0.09 ], [ -4, 5 ]) ]), 'env0c', ('env' -> [ 4, ControlSpec(0.001, 8, 'exp', 0, 1, ""), nil, nil, Env([ 0.5, 1, 0.5, 0 ], [ 0.05, 0.06, 0.1 ], [ -4, -2, -4 ]) ]), 'env1c', ('env' -> [ 3, ControlSpec(5, 128, 'linear', 0, 50, ""), nil, nil, Env([ 80, 19, 70 ], [ 0.05, 0.09 ], [ -4, 5 ]) ]), 'env0b', ('env' -> [ 4, ControlSpec(0.001, 8, 'exp', 0, 1, ""), nil, nil, Env([ 0.5, 1, 0.5, 0 ], [ 0.05, 0.06, 0.1 ], [ -4, -2, -4 ]) ]), 'env1b', ('env' -> [ 3, ControlSpec(5, 128, 'linear', 0, 50, ""), nil, nil, Env([ 80, 19, 70 ], [ 0.05, 0.09 ], [ -4, 5 ]) ]) ],
		version: 1,
		data: [ 'amp', 0.33464879664684, 'pan', 0.0, 'fratio', 1.5, 'rq', 0.5, 'fratiob', 2.0, 'dmix', 0.0, 'rqc', 0.5, 'fratioc', 2.0, 'dmix2', 0.20000000298023, 'pwidth', 0.5, 'driveamp', 0.20000000298023, 'distmix', 1.0, 'drive', 2.0, 'cliplevel', 1.0, 'doneActiona', 0.0, 'doneActionb', 0.0, 'doneActionc', 0.0, 'env0', Env([ 0.001, 0.15718920236783, 0.38386033950245, 0.001 ], [ 0.31750731084016, 0.062635500870001, 0.015085059328712 ], [ -4, -2, -4 ]), 'env1', Env([ 80, 19, 18.34 ], [ 0.05, 0.09 ], [ -4, 5 ]), 'env0c', Env([ 0.001, 0.022087354536722, 0.50000000352667, 0.001 ], [ 0.099467276587794, 0.042539859754922, 0.070899802595557 ], [ -4, -2, -4 ]), 'env1c', Env([ 80, 19, 70 ], [ 0.05, 0.09 ], [ -4, 5 ]), 'env0b', Env([ 0.001, 1.0000001392097, 0.50000000352667, 0.001 ], [ 0.049999999890814, 0.059999988295187, 0.10000003174369 ], [ -4, -2, -4 ]), 'env1b', Env([ 80, 19, 30.64 ], [ 0.05, 0.09 ], [ -4, 5 ]) ],
	)
);

Sdef('6', 'mypreset').set_data(2, 1, 
	(
		specs: [ 'amp', ControlSpec(0, 1, 'amp', 0, 0.10000000149012, ""), 'pan', ControlSpec(-1, 1, 'linear', 0.0, 0.0, ""), 'fratio', ControlSpec(0.1, 20000, 'exp', 0, 1.5, ""), 'rq', ControlSpec(0.001, 2, 'exp', 0, 0.5, ""), 'fratiob', ControlSpec(0.1, 20000, 'exp', 0, 2.0, ""), 'dmix', ControlSpec(0, 1, 'linear', 0, 0.5, ""), 'rqc', ControlSpec(0.001, 2, 'exp', 0, 0.5, ""), 'fratioc', ControlSpec(0.1, 20000, 'exp', 0, 2.0, ""), 'dmix2', ControlSpec(0, 1, 'linear', 0, 0.20000000298023, ""), 'pwidth', ControlSpec(0, 1, 'linear', 0, 0.5, ""), 'driveamp', ControlSpec(0.001, 5, 'linear', 0, 0.20000000298023, ""), 'distmix', ControlSpec(0, 1, 'linear', 0, 0.5, ""), 'drive', ControlSpec(0, 10, 'linear', 0, 2.0, ""), 'cliplevel', ControlSpec(0.001, 5, 'linear', 0, 1.0, ""), 'doneActiona', ControlSpec(0.1, 20000, 'exp', 0, 0.0, ""), 'doneActionb', ControlSpec(0.1, 20000, 'exp', 0, 0.0, ""), 'doneActionc', ControlSpec(0.1, 20000, 'exp', 0, 0.0, ""), 'env0', ('env' -> [ 4, ControlSpec(0.001, 8, 'exp', 0, 1, ""), nil, nil, Env([ 0.5, 1, 0.5, 0 ], [ 0.05, 0.06, 0.1 ], [ -4, -2, -4 ]) ]), 'env1', ('env' -> [ 3, ControlSpec(5, 128, 'linear', 0, 50, ""), nil, nil, Env([ 80, 19, 70 ], [ 0.05, 0.09 ], [ -4, 5 ]) ]), 'env0c', ('env' -> [ 4, ControlSpec(0.001, 8, 'exp', 0, 1, ""), nil, nil, Env([ 0.5, 1, 0.5, 0 ], [ 0.05, 0.06, 0.1 ], [ -4, -2, -4 ]) ]), 'env1c', ('env' -> [ 3, ControlSpec(5, 128, 'linear', 0, 50, ""), nil, nil, Env([ 80, 19, 70 ], [ 0.05, 0.09 ], [ -4, 5 ]) ]), 'env0b', ('env' -> [ 4, ControlSpec(0.001, 8, 'exp', 0, 1, ""), nil, nil, Env([ 0.5, 1, 0.5, 0 ], [ 0.05, 0.06, 0.1 ], [ -4, -2, -4 ]) ]), 'env1b', ('env' -> [ 3, ControlSpec(5, 128, 'linear', 0, 50, ""), nil, nil, Env([ 80, 19, 70 ], [ 0.05, 0.09 ], [ -4, 5 ]) ]) ],
		version: 1,
		data: [ 'amp', 0.33464879664684, 'pan', 0.0, 'fratio', 1.5, 'rq', 0.5, 'fratiob', 2.0, 'dmix', 0.0, 'rqc', 0.5, 'fratioc', 2.0, 'dmix2', 0.20000000298023, 'pwidth', 0.5, 'driveamp', 0.20000000298023, 'distmix', 1.0, 'drive', 2.0, 'cliplevel', 1.0, 'doneActiona', 0.0, 'doneActionb', 0.0, 'doneActionc', 0.0, 'env0', Env([ 0.001, 0.15718920236783, 0.38386033950245, 0.001 ], [ 0.31750731084016, 0.062635500870001, 0.015085059328712 ], [ -4, -2, -4 ]), 'env1', Env([ 80, 19, 18.34 ], [ 0.05, 0.09 ], [ -4, 5 ]), 'env0c', Env([ 0.001, 0.022087354536722, 0.50000000352667, 0.001 ], [ 0.099467276587794, 0.042539859754922, 0.070899802595557 ], [ -4, -2, -4 ]), 'env1c', Env([ 80, 19, 70 ], [ 0.05, 0.09 ], [ -4, 5 ]), 'env0b', Env([ 0.001, 1.0000001392097, 0.50000000352667, 0.001 ], [ 0.049999999890814, 0.059999988295187, 0.10000003174369 ], [ -4, -2, -4 ]), 'env1b', Env([ 80, 19, 30.64 ], [ 0.05, 0.09 ], [ -4, 5 ]) ],
	)
);

Sdef('6', 'mypreset').set_data(2, 2, 
	(
		specs: [ 'amp', ControlSpec(0, 1, 'amp', 0, 0.10000000149012, ""), 'pan', ControlSpec(-1, 1, 'linear', 0.0, 0.0, ""), 'fratio', ControlSpec(0.1, 20000, 'exp', 0, 1.5, ""), 'rq', ControlSpec(0.001, 2, 'exp', 0, 0.5, ""), 'fratiob', ControlSpec(0.1, 20000, 'exp', 0, 2.0, ""), 'dmix', ControlSpec(0, 1, 'linear', 0, 0.5, ""), 'rqc', ControlSpec(0.001, 2, 'exp', 0, 0.5, ""), 'fratioc', ControlSpec(0.1, 20000, 'exp', 0, 2.0, ""), 'dmix2', ControlSpec(0, 1, 'linear', 0, 0.20000000298023, ""), 'pwidth', ControlSpec(0, 1, 'linear', 0, 0.5, ""), 'driveamp', ControlSpec(0.001, 5, 'linear', 0, 0.20000000298023, ""), 'distmix', ControlSpec(0, 1, 'linear', 0, 0.5, ""), 'drive', ControlSpec(0, 10, 'linear', 0, 2.0, ""), 'cliplevel', ControlSpec(0.001, 5, 'linear', 0, 1.0, ""), 'doneActiona', ControlSpec(0.1, 20000, 'exp', 0, 0.0, ""), 'doneActionb', ControlSpec(0.1, 20000, 'exp', 0, 0.0, ""), 'doneActionc', ControlSpec(0.1, 20000, 'exp', 0, 0.0, ""), 'env0', ('env' -> [ 4, ControlSpec(0.001, 8, 'exp', 0, 1, ""), nil, nil, Env([ 0.5, 1, 0.5, 0 ], [ 0.05, 0.06, 0.1 ], [ -4, -2, -4 ]) ]), 'env1', ('env' -> [ 3, ControlSpec(5, 128, 'linear', 0, 50, ""), nil, nil, Env([ 80, 19, 70 ], [ 0.05, 0.09 ], [ -4, 5 ]) ]), 'env0c', ('env' -> [ 4, ControlSpec(0.001, 8, 'exp', 0, 1, ""), nil, nil, Env([ 0.5, 1, 0.5, 0 ], [ 0.05, 0.06, 0.1 ], [ -4, -2, -4 ]) ]), 'env1c', ('env' -> [ 3, ControlSpec(5, 128, 'linear', 0, 50, ""), nil, nil, Env([ 80, 19, 70 ], [ 0.05, 0.09 ], [ -4, 5 ]) ]), 'env0b', ('env' -> [ 4, ControlSpec(0.001, 8, 'exp', 0, 1, ""), nil, nil, Env([ 0.5, 1, 0.5, 0 ], [ 0.05, 0.06, 0.1 ], [ -4, -2, -4 ]) ]), 'env1b', ('env' -> [ 3, ControlSpec(5, 128, 'linear', 0, 50, ""), nil, nil, Env([ 80, 19, 70 ], [ 0.05, 0.09 ], [ -4, 5 ]) ]) ],
		version: 1,
		data: [ 'amp', 0.33464879664684, 'pan', 0.0, 'fratio', 1.5, 'rq', 0.5, 'fratiob', 2.0, 'dmix', 0.0, 'rqc', 0.5, 'fratioc', 2.0, 'dmix2', 0.20000000298023, 'pwidth', 0.5, 'driveamp', 0.20000000298023, 'distmix', 1.0, 'drive', 2.0, 'cliplevel', 1.0, 'doneActiona', 0.0, 'doneActionb', 0.0, 'doneActionc', 0.0, 'env0', Env([ 0.001, 0.15718920236783, 0.38386033950245, 0.001 ], [ 0.31750731084016, 0.062635500870001, 0.015085059328712 ], [ -4, -2, -4 ]), 'env1', Env([ 80, 19, 18.34 ], [ 0.05, 0.09 ], [ -4, 5 ]), 'env0c', Env([ 0.001, 0.022087354536722, 0.50000000352667, 0.001 ], [ 0.099467276587794, 0.042539859754922, 0.070899802595557 ], [ -4, -2, -4 ]), 'env1c', Env([ 80, 19, 70 ], [ 0.05, 0.09 ], [ -4, 5 ]), 'env0b', Env([ 0.001, 1.0000001392097, 0.50000000352667, 0.001 ], [ 0.049999999890814, 0.059999988295187, 0.10000003174369 ], [ -4, -2, -4 ]), 'env1b', Env([ 80, 19, 30.64 ], [ 0.05, 0.09 ], [ -4, 5 ]) ],
	)
);

Sdef('6', 'mypreset').set_data(4, 0, 
	(
		specs: [ 'amp', ControlSpec(0, 1, 'amp', 0, 0.10000000149012, ""), 'pan', ControlSpec(-1, 1, 'linear', 0.0, 0.0, ""), 'fratio', ControlSpec(0.1, 20000, 'exp', 0, 1.5, ""), 'rq', ControlSpec(0.001, 2, 'exp', 0, 0.5, ""), 'fratiob', ControlSpec(0.1, 20000, 'exp', 0, 2.0, ""), 'dmix', ControlSpec(0, 1, 'linear', 0, 0.5, ""), 'rqc', ControlSpec(0.001, 2, 'exp', 0, 0.5, ""), 'fratioc', ControlSpec(0.1, 20000, 'exp', 0, 2.0, ""), 'dmix2', ControlSpec(0, 1, 'linear', 0, 0.20000000298023, ""), 'pwidth', ControlSpec(0, 1, 'linear', 0, 0.5, ""), 'driveamp', ControlSpec(0.001, 5, 'linear', 0, 0.20000000298023, ""), 'distmix', ControlSpec(0, 1, 'linear', 0, 0.5, ""), 'drive', ControlSpec(0, 10, 'linear', 0, 2.0, ""), 'cliplevel', ControlSpec(0.001, 5, 'linear', 0, 1.0, ""), 'doneActiona', ControlSpec(0.1, 20000, 'exp', 0, 0.0, ""), 'doneActionb', ControlSpec(0.1, 20000, 'exp', 0, 0.0, ""), 'doneActionc', ControlSpec(0.1, 20000, 'exp', 0, 0.0, ""), 'env0', ('env' -> [ 4, ControlSpec(0.001, 8, 'exp', 0, 1, ""), nil, nil, Env([ 0.5, 1, 0.5, 0 ], [ 0.05, 0.06, 0.1 ], [ -4, -2, -4 ]) ]), 'env1', ('env' -> [ 3, ControlSpec(5, 128, 'linear', 0, 50, ""), nil, nil, Env([ 80, 19, 70 ], [ 0.05, 0.09 ], [ -4, 5 ]) ]), 'env0c', ('env' -> [ 4, ControlSpec(0.001, 8, 'exp', 0, 1, ""), nil, nil, Env([ 0.5, 1, 0.5, 0 ], [ 0.05, 0.06, 0.1 ], [ -4, -2, -4 ]) ]), 'env1c', ('env' -> [ 3, ControlSpec(5, 128, 'linear', 0, 50, ""), nil, nil, Env([ 80, 19, 70 ], [ 0.05, 0.09 ], [ -4, 5 ]) ]), 'env0b', ('env' -> [ 4, ControlSpec(0.001, 8, 'exp', 0, 1, ""), nil, nil, Env([ 0.5, 1, 0.5, 0 ], [ 0.05, 0.06, 0.1 ], [ -4, -2, -4 ]) ]), 'env1b', ('env' -> [ 3, ControlSpec(5, 128, 'linear', 0, 50, ""), nil, nil, Env([ 80, 19, 70 ], [ 0.05, 0.09 ], [ -4, 5 ]) ]) ],
		version: 1,
		data: [ 'amp', 1.0, 'pan', 0.0, 'fratio', 3.2372567860682, 'rq', 0.12633620208492, 'fratiob', 3.4753383418772, 'dmix', 0.5, 'rqc', 0.5, 'fratioc', 2.8089063911112, 'dmix2', 0.21802325581395, 'pwidth', 0.5, 'driveamp', 0.75666279069767, 'distmix', 0.93313953488372, 'drive', 2.0, 'cliplevel', 1.0, 'doneActiona', 0.0, 'doneActionb', 0.0, 'doneActionc', 0.0, 'env0', Env([ 0.5, 5.0414585130018, 0.5, 0 ], [ 0.05, 0.064147856684048, 0.1 ], [ -4, -2, -4 ]), 'env1', Env([ 80, 19, 18.34 ], [ 0.05, 0.09 ], [ -4, 5 ]), 'env0c', Env([ 0.5, 6.601595302595, 0.5, 0 ], [ 0.05, 0.06, 0.1 ], [ -4, -2, -4 ]), 'env1c', Env([ 80, 19, 70 ], [ 0.05, 0.09 ], [ -4, 5 ]), 'env0b', Env([ 0.5, 2.7209413995405, 0.5, 0 ], [ 0.05, 0.06, 0.1 ], [ -4, -2, -4 ]), 'env1b', Env([ 80, 19, 30.64 ], [ 0.05, 0.09 ], [ -4, 5 ]) ],
	)
);


Sdef('6','mypreset').set_active_subindexes(Order.newFromIndices([ 0, 0, 0, 0 ], [ 0, 1, 2, 4 ]));