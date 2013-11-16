~name = \1;

(
{
	var name = ~name;

	Veco(~name).add_stop_node_hook(\ndef, {
		Ndef(name).release;
		Ndef(name).stop;
	});
	Veco(~name).is_playing = { 
		name.debug("ndef is playing ?");
		Ndef(name).monitor.isPlaying.debug("hein?");
		Ndef(name).monitor.isPlaying
	};

}.value;
)


// END

Ndef(~name).release
Ndef(~name).stop
Ndef(~name).monitor.isPlaying
Ndef(~name).isPlaying
