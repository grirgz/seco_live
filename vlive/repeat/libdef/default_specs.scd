// Pbind specs

// moved to param quark
//Spec.add(\legato, ControlSpec(0.05,2,\exp,0,0.8));
//Spec.add(\dur, ControlSpec(1/32,10,\lin,0,1));
//Spec.add(\sustain, ControlSpec(0.05,4,\exp));
//Spec.add(\degree, ControlSpec(0,14,\lin,1));
//Spec.add(\mtranspose, ControlSpec(0,14,\lin,1));
//Spec.add(\root, ControlSpec(0,14,\lin,1));
//Spec.add(\note, ControlSpec(0,24,\lin,1));
//Spec.add(\ctranspose, ControlSpec(0,24,\lin,1));
//Spec.add(\midinote, ControlSpec(1,126,\lin,1,60));
//Spec.add(\octave, ControlSpec(1,7,\lin,1,4));
//Spec.add(\scale, TagSpecDef(\scale, { Scale.all.parent.asAssociations } ));

// param specs

Spec.add(\instrument, TagSpecDef(\SynthDef_keys));
Spec.add(\mix, \unipolar.asSpec);
Spec.add(\wet, \unipolar.asSpec);
Spec.add(\inbus, XBusSpec.new);
Spec.add(\gate, XGateSpec.new);
Spec.add(\adsr, XEnvSpec.adsr);
Spec.add(\env, XEnvSpec.new);
Spec.add(\lag, ControlSpec(0, 1, 'linear', 0, 0, ""));
Spec.add(\gain, ControlSpec(0,1,\lin, 0,1));
Spec.add(\out, ParamBusSpec(TagSpecDef(\BusDef)));
Spec.add(\trigger, \unipolar);
Spec.add(\speed, ControlSpec(-2,2,\lin, 0, 1));

Spec.add(\isRest, ParamBoolSpec(reverse:true));

// other

Spec.add(\cpmix, \unipolar);
Spec.add(\cpt, ControlSpec(0.001,5,\exp));
Spec.add(\verbmix, \unipolar);
Spec.add(\lpmix, \unipolar);


Spec.add(\wideamp, ControlSpec(0.001,5,\lin,0,1));
Spec.add(\freqshift, ControlSpec(-1000,1000,\lin,0,0));
Spec.add(\stretch, ControlSpec(0.001,4,\exp,0,1));
Spec.add(\bistretch, ControlSpec(-4,4,\lin,0,1));
Spec.add(\preamp, \amp.asSpec);

Spec.add(\compt, ControlSpec(0,2,\lin));
Spec.add(\complo, ControlSpec(0,2,\lin));
Spec.add(\comphi, ControlSpec(0,2,\lin));


Spec.add(\wavetable, ParamWavetableSpec());
Spec.add(\wavetable2, ParamWavetableSpec());

// rdn

Spec.add(\delay3, \delay.asSpec);
Spec.add(\shift3, \shift.asSpec);
Spec.add(\shiftmix, \unipolar.asSpec);
Spec.add(\distamp, ControlSpec(0.1,100,\exp));
Spec.add(\distamp2, \distamp.asSpec);
Spec.add(\distamp3, \distamp.asSpec);
Spec.add(\distmix, \unipolar);
Spec.add(\deltafreq, ControlSpec(0.00001,0.1,\exp));
Spec.add(\mamp, ControlSpec(0,1,\lin));
Spec.add(\indelay, ControlSpec(0,0.2,\lin));


Spec.add(\deltran1, ControlSpec(0.01,30,\exp));
Spec.add(\deltran2, ControlSpec(0.01,30,\exp));
Spec.add(\deltran3, ControlSpec(0.01,30,\exp));

