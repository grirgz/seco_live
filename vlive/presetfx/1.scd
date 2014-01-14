~name = '1';

~newfxmix.(\fx);
Veco(~name).make_mixer;

~set_dels = { arg array;
	var dels;
	//array = [0,1,0,1, 0,1,1,0];
	dels = array.collect { arg x, i; i = i + 1; [\del+++i, x] };
	dels = dels.flat;
	Ndef(~name+++\fx).set(*dels);
};
