

(
	//ProxyChain(~name).gui(22);
	Veco.do { arg name;
	
		Veco(name).lib.map_it = {
			~midi_macro_manager.map_list(
				ProxyChain(name+++\fx).proxy.controlNames.collect({ arg control;
					var spec;
					control.debug("control!!!");
					if(control.name.asString.beginsWith("wet") or: {
						control.name.asString.beginsWith("mix")
					}) {
						spec = \unipolar.asSpec;
					} {
						spec = control.name.asSpec;
					};
					[ProxyChain(name+++\fx).proxy, control.name, spec]
				}).reject({ arg x; [\out, \i_out, \inbus].includes(x[1]) });
			)

		};
		MIDIBoard.map(\play, { Veco(name).lib.map_it.value });
		Veco(name).lib.map_it.value;
	};

);
// END


ProxyChain(~name).proxy.nodeMap.controlNames[0].name
Ndef(~name).nodeMap.controlNames[0].name
Ndef(~name).edit
Ndef(~name).stop
"kjk".startsWith("kj")
String
ProxyChain(~name).sources
VecoLib.load_lib

