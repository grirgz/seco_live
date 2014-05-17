~name = 'a';


Veco(~name).make_mixer;

(
{
	var name = ~name;
	Veco(~name).add_stop_node_hook(\main, { 
		//Ndef(name).stop 

		ProxyChain(name).end(4);
	})
}.value
);
