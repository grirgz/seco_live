
// param specs

Spec.add(\inbus, XBusSpec.new);
Spec.add(\gate, XGateSpec.new);
Spec.add(\adsr, XEnvSpec.adsr);
Spec.add(\lag, ControlSpec(0, 1, 'linear', 0, 0, ""));
Spec.add(\gain, ControlSpec(0,1,\lin, 0,1));
Spec.add(\out, XBusSpec());
Spec.add(\trigger, \unipolar);
Spec.add(\speed, ControlSpec(-2,2,\lin, 0, 1));

// other

Spec.add(\cpmix, \unipolar);
Spec.add(\cpt, ControlSpec(0.001,5,\exp));
Spec.add(\verbmix, \unipolar);

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

