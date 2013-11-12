// END


//~set_dels.([1,0,1,0, 0,0,0,0])
~set_dels.(Veco(~namex).stepseq);
n = ~name;
Veco(~namex).set_step_hook = { arg self, idx, val;
	[n, idx, val].debug("hoooooolkkkkkkkkkkkkkkk");
	Ndef(n+++\fx).set(\del+++(idx+1), val);
};
