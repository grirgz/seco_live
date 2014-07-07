~name = 'rise7-56';

~newfxchannel.(\fx);

~set_dels = { arg array;
	var dels;
	//array = [0,1,0,1, 0,1,1,0];
	dels = array.collect { arg x, i; i = i + 1; [\del+++i, x] };
	dels = dels.flat;
	Ndef(~name+++\fx).set(*dels);
};
