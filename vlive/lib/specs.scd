
Spec.add(\wideamp, ControlSpec(0.001,5,\lin,0,1));
Spec.add(\freqshift, ControlSpec(-1000,1000,\lin,0,0));
Spec.add(\stretch, ControlSpec(0.001,4,\exp,0,1));
Spec.add(\bistretch, ControlSpec(-4,4,\lin,0,1));
Spec.add(\preamp, \amp.asSpec);

Spec.add(\compt, ControlSpec(0,2,\lin));
Spec.add(\complo, ControlSpec(0,2,\lin));
Spec.add(\comphi, ControlSpec(0,2,\lin));
Spec.add(\mix, \unipolar.asSpec);
