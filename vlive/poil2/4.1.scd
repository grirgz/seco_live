
Ndef(~name).ar(2);
Ndef(~name).play(BusDef(~name+++\mixer));
//Ndef(~name).edit

ProxyChain.from(Ndef(~name), [\dust, \ringmod, \dist, \riseComb5, \test]);
//ProxyChain(~name, [\dust, \ringmod, \dist, \riseComb5, \test]);

//ProxyChain(~name).play(BusDef(~name+++\mixer));

ProxyChain(~name).add(\dust, 1);
ProxyChain(~name).add(\ringmod, 0);
ProxyChain(~name).add(\dist, 0);
ProxyChain(~name).add(\riseComb5, 0);


// END

VecoLib.load_lib
Ndef(~name).stop;
ProxyChain(~name)
