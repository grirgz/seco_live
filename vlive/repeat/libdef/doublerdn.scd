
WindowDef(\doublerdn, { arg def, rdnlist;
	HLayout(*
		rdnlist.collect({ arg rdn;
			WindowDef(\rdngui).asView(rdn);
		})
	)

})

// END

WindowDef(\doublerdn).front([ProtoDef(\rdn), ProtoDef(\rdn2)]);
