
{
	var name = ~name;
	{
		ProxyChain(name+++\fx).gui(22);
	}.defer;
}.value;

// END


ProxyChain(~name).proxy.nodeMap.controlNames[0].name
ProxyChain(~name).proxy.nodeMap
NodeMap
Ndef(~name).nodeMap.controlNames[0].name
Ndef(~name).edit
Ndef(~name).stop
"kjk".startsWith("kj")
String
ProxyChain(~name).sources[\dust]
ProxyChain.all

	~midi_macro_manager.map_list(
		ProxyChain(~name).proxy.nodeMap.controlNames.collect({ arg control;
			var spec;
			if(control.name.asString.beginsWith("wet") or: {
				control.name.asString.beginsWith("mix")
			}) {
				spec = \unipolar.asSpec;
			} {
				spec = control.name.asSpec;
			};
			[Ndef(~name), control.name, spec]
		}).reject({ arg x; [\out, \i_out].includes(x[1]) });
	)
