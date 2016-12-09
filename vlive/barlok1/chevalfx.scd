
(
// nice dist
~fxpreset = ();

~fxpreset.full_cool_dist = {
RandDelayNetwork('multifbdel').make('fx1', "5-E718-7PFC");
Ndef('fx1').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.19444444444444,
	'gain', 1.659849325763,
	'fb', 0.004672712486216,
	'delay', 0.0001,
	'delay2', 0.0001,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 21.01757144013,
	'pitchlag', 0.73564225445964,
	'pitchmix', 0.81666666666667,
	'fb1', 0,
	'fb2', 0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 20000.0,
	'hpf', 20.0,
	'deltran1', -0.26666666666667,
	'deltran2', -0.26666666666667,
	'deltran3', -0.16666666666667,
	'fbdistamp', 10.176656299638,
	'fbdistmix', 0.86666666666667,
	'postlpf', 19296.21434110699,
	'posthpf', 20.0,
	'wetamp', 0.42086895357865,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

};


~fxpreset.full_nice_dist = {

	RandDelayNetwork('multifbdel').make('fx1', "5-76BF-J2LV", BusDef(\fx1, \audio));
	Ndef('fx1').put(100, \pset -> Pbind(
		'wet10', 1.0,
		'mix', 0.19444444444444,
		'gain', 1.659849325763,
		'fb', 0.004672712486216,
		'delay', 0.00014307229891938,
		'delay2', 0.00054116952654646,
		'shift', 0.0,
		'shift2', 0.0,
		'distamp', 21.01757144013,
		'pitchlag', 0.73564225445964,
		'pitchmix', 0.81666666666667,
		'fb1', 0,
		'fb2', 0,
		'prelpf', 17000,
		'prehpf', 17,
		'lpf', 20000.0,
		'hpf', 20.0,
		'deltran1', -0.26666666666667,
		'deltran2', -0.26666666666667,
		'deltran3', -0.16666666666667,
		'fbdistamp', 10.176656299638,
		'fbdistmix', 0.86666666666667,
		'postlpf', 19796.21434110699,
		'posthpf', 20.0,
		'wetamp', 0.42086895357865,
		'indelay', 0.04,
		'wet20', 1.0,
		'mamp', 1,
	).keep(1));

};
~fxpreset.nice_dist = {

	Ndef('fx1').put(100, \pset -> Pbind(
		'wet10', 1.0,
		'mix', 0.19444444444444,
		'gain', 1.659849325763,
		'fb', 0.004672712486216,
		'delay', 0.00014307229891938,
		'delay2', 0.00054116952654646,
		'shift', 0.0,
		'shift2', 0.0,
		'distamp', 21.01757144013,
		'pitchlag', 0.73564225445964,
		'pitchmix', 0.81666666666667,
		'fb1', 0,
		'fb2', 0,
		'prelpf', 17000,
		'prehpf', 17,
		'lpf', 20000.0,
		'hpf', 20.0,
		'deltran1', -0.26666666666667,
		'deltran2', -0.26666666666667,
		'deltran3', -0.16666666666667,
		'fbdistamp', 10.176656299638,
		'fbdistmix', 0.86666666666667,
		'postlpf', 19796.21434110699,
		'posthpf', 20.0,
		'wetamp', 0.42086895357865,
		'indelay', 0.04,
		'wet20', 1.0,
		'mamp', 1,
	).keep(1));

};
~fxpreset.soft_dist = {

	Ndef('fx1').put(100, \pset -> Pbind(
		'wet10', 1.0,
		'mix', 0.19444444444444,
		'gain', 1.659849325763,
		'fb', 0.000672712486216,
		'delay', 0.00014307229891938,
		'delay2', 0.00054116952654646,
		'shift', 0.0,
		'shift2', 0.0,
		'distamp', 21.01757144013,
		'pitchlag', 0.73564225445964,
		'pitchmix', 0.81666666666667,
		'fb1', 0,
		'fb2', 0,
		'prelpf', 17000,
		'prehpf', 17,
		'lpf', 20000.0,
		'hpf', 20.0,
		'deltran1', -0.26666666666667,
		'deltran2', -0.26666666666667,
		'deltran3', -0.16666666666667,
		'fbdistamp', 10.176656299638,
		'fbdistmix', 0.86666666666667,
		'postlpf', 19796.21434110699,
		'posthpf', 20.0,
		'wetamp', 0.42086895357865,
		'indelay', 0.04,
		'wet20', 1.0,
		'mamp', 1,
	).keep(1));

};
~fxpreset.no_dist = {

	Ndef('fx1').put(100, \pset -> Pbind(
		'wet10', 1.0,
		'mix', 0.19444444444444,
		'gain', 1.659849325763,
		'fb', 0.000672712486216,
		'delay', 0.00014307229891938,
		'delay2', 0.00054116952654646,
		'shift', 0.0,
		'shift2', 0.0,
		'distamp', 1.01757144013,
		'pitchlag', 0.73564225445964,
		'pitchmix', 0.81666666666667,
		'fb1', 0,
		'fb2', 0,
		'prelpf', 17000,
		'prehpf', 17,
		'lpf', 20000.0,
		'hpf', 20.0,
		'deltran1', 0.26666666666667,
		'deltran2', 0.26666666666667,
		'deltran3', 0.16666666666667,
		'fbdistamp', 1.176656299638,
		'fbdistmix', 0.86666666666667,
		'postlpf', 19796.21434110699,
		'posthpf', 20.0,
		'wetamp', 0.42086895357865,
		'indelay', 0.04,
		'wet20', 1.0,
		'mamp', 1,
	).keep(1));

};

~fxpreset.rev_dist = {

	Ndef('fx1').put(100, \pset -> Pbind(
		'wet10', 1.0,
		'mix', 0.19444444444444,
		'gain', 1.659849325763,
		'fb', 0.001672712486216,
		'delay', 0.00014307229891938,
		'delay2', 0.00054116952654646,
		'shift', 0.0,
		'shift2', 0.0,
		'distamp', 1.01757144013,
		'pitchlag', 0.73564225445964,
		'pitchmix', 0.81666666666667,
		'fb1', 0,
		'fb2', 0,
		'prelpf', 17000,
		'prehpf', 17,
		'lpf', 20000.0,
		'hpf', 20.0,
		'deltran1', 0.76666666666667,
		'deltran2', 0.26666666666667,
		'deltran3', 0.16666666666667,
		'fbdistamp', 1.176656299638,
		'fbdistmix', 0.86666666666667,
		'postlpf', 19796.21434110699,
		'posthpf', 20.0,
		'wetamp', 0.42086895357865,
		'indelay', 0.04,
		'wet20', 1.0,
		'mamp', 1,
	).keep(1));

};
);
