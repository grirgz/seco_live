
k = MKtl(\lp, "novation-launchpad-s");
k.elAt(\pad).elAt(0).elAt(0).action = { "0 on pushed".postln; };
k.elAt(\pad).elAt(0).elAt(1).action = { "0 off pushed".postln; };
k.postElements;
k.elAt(\pad).elAt(0).elAt(0).value = 0.05;


