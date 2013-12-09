
(
~buf = BufDef(\moeten);
~buf = BufDef(\march);
Pdef(~name +++ \pre, 
	Pbind(
		\range, Pseg(Pseq([0.0001,0.0008,0.1],inf), Pseq([7,1,0],inf)),
		\bufnum, ~buf,
	) <>
		//Sdef(~name, \mypreset).getsub(0).pdef <>
		//( freq: 1000 ) <>
		Pseq([

			Plazy({ arg ev;

				var res;
				res = blend(

					Sdef(ev[\name], \mypreset).getsub(0).get_event,
					Sdef(ev[\name], \mypreset).getsub(1).get_event,
					//0.5
					ev[\blender].debug("BLEDER")
					//ev[\blender],
				);
				res[\amp] = res[\amp] * ev[\amp];
				res;
			}) 
		],inf) <>
		//Sdef(~name, \mypreset).pdef <>
	//Pseq([
		//blend(
		//	Pfin(1, Sdef(~name, \mypreset).getsub(0).valpbind),
		//	Pfin(1, Sdef(~name, \mypreset).getsub(1).valpbind),
		//	0.5,

		//)
	//],inf) <>
	
	Pbind(
		\name, ~name,
		\blender, Pseq([
			Pser([0],16),
			Pser([1],16),
		],inf),
		\blender, Pseg(Pseq([0,1],inf),4, 8),
		\blender, Pseq([
			Pser([0.1],14),
			Pser([1.0],2),

		],inf),
	\legato, 1.0,
	\dur, 1/4,
	\amp, 1 * Pkey(\amp),
));
)
