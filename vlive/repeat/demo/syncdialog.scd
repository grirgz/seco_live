
(
~dialog = { arg hook;
	defer  {
		"show dialog".debug;
		hook.("blabla")
	};
	"instant return: wrong result"
};
~save = { arg askHook;
	"save something".debug;
	"ask path".debug;
	askHook.().debug("save askHook result");
	"save another thing".debug;
};
~save.( { ~dialog.({ arg x; x }) } )
)

(
	fork  {
		~save.( { 
			var cond = Condition.new;
			var result;
			~dialog.({ arg x;
				result = x;
				cond.unhang;
			});
			cond.wait;
			result;
		} )
	}
)

//////////////

~f = { arg x; x.asString ++ " haha" };
~f = { arg x; x * 2 + 5 };
~f.([10,20])
~f.flop.([10,20])
[10,20].collect(~f)
