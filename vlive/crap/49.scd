/*
The Beasties

A beastie is an array of values: age, sex, energy, horizontal en vertical position (+ possibly other experimental properties). 
All beasties are in a List. Add with list.add(beastie), remove with list.removeAt(index). Edit with list.put(index, beastie).

Food is in a 2D-aray. 

==========================================================================
Make two beasties, a boy and a girl. They have an amount of energy and search for food, until their energy surpasses a certain amount. Then they look for a playmate. At a certain age they come of age. If a grownup man plays with a grownup woman, a new beastie comes to life. Both parent give the same amount of energy. If one of the parents hasn't enough energy, the other compensates, if possible. In that way, death of a child is prevented as much as possible.

===========================================================================
The cycle:
1. is there food where you stand?? If yes, take e byte! Energy increases.
2. Age is increased by 1.
3. Determine ypur direction
	Are you hungry? Find food.
	Not hungry? Find someone to play with
4. take the step. Energy decreases by 1.
5. as 1.
6. Is there another beastie where you stand now? Meeting.
7. Is there a meeting between a grownup man and a grownup woman? 
	If yes, birth.
============================================================================
Birth
1. New beastie in the list
	age=0
	sex=random
	position:shoot away
	energy: if possible standard initial energy.
2. energy of parents decreases.
3. When shooting away: parents jump aside, child is shot away.
============================================================================
Death
If energy == 0 and at the position where you are, there is no food.
Remove from list.
============================================================================

*/

s.boot;
(
~waittime = 0.01;
//Synthdefs for sounds
//strewing food
SynthDef (\strewSound, {
	Out.ar(0,
		Pan2.ar(
			BBandPass.ar (
				WhiteNoise.ar(0.25)	,		//input
				2000,						//center frequency
				1,							//bandwith in octaves
				EnvGen.kr(Env.perc(1, 2, 1, -4), doneAction: 2),										//mul
				0,							//add
			),
			LFNoise1.ar(0.125, 2, -1)
		)

	)
}).add;


//birth
SynthDef(\birth, { arg posX, posY;
	Out.ar(0,
		Pan2.ar(
			FreeVerb.ar(
				SinOsc.ar(Line.kr(500, 1000, 0.25, doneAction: 2), 0, 0.25),
				posY,		//mix
				0.5		//room
			),
			posX	//pos
		),
	)
}).add;

//death
SynthDef(\death, { arg posX, posY;
	Out.ar(0,
		Pan2.ar(
			FreeVerb.ar(
				SinOsc.ar(100+(SinOsc.ar(Line.kr(70, 64, 1, doneAction: 2), 0, 1000, 0)),
						mul: EnvGen.kr(Env.perc(0.01, 1, 0.5, -4), doneAction: 2)				),
				posY,		//mix
				0.5		//room
			),
			posX	//pos
		)
	)
}).add;


//death of a child
SynthDef(\childDeath, { arg posX, posY;
	Out.ar(0,
		Pan2.ar(
			FreeVerb.ar(
				SinOsc.ar(1600+(SinOsc.ar(Line.kr(1200, 1000, 1, doneAction: 2), 0, 1000, 0)),
						mul: EnvGen.kr(Env.perc(0.01, 1, 0.5, -4), doneAction: 2)				),
				posY,		//mix
				0.5		//room
			),
			posX	//pos
		)
	)
}).add;

//byte
SynthDef(\hap, {arg freq, posX, posY;
	Out.ar(0,
		Pan2.ar(
			FreeVerb.ar(
				RLPF.ar(
					Saw.ar(freq, EnvGen.kr(Env.perc(0.03, 0.01, 0.25, 4), levelScale: 0.5, doneAction: 2)),
					3*freq*EnvGen.kr(Env.asr(0.001, 1, 0.0001, 4), doneAction: 2), //cutoff=3*toonhoogte
					0.05
					
				),
				posY,		//mix
				0.5		//room
			),
			posX	//pos
		)
	)
}).add;


//coming of age
SynthDef(\coa, { arg posX, posY, num;
	Out.ar(0,
		Pan2.ar(
			FreeVerb.ar(
				Blip.ar(1000, num, EnvGen.kr(Env.perc(0.01, 1, 1, -4), doneAction: 2)),
				posY,		//mix
				0.5		//room
			),
			posX	//pos
		)
	)
}).add;
//meetings
SynthDef(\meeting, {arg freq1, freq2, posX, posY;
	Out.ar(0,
		Pan2.ar(
			FreeVerb.ar(
				Pulse.ar(freq1, 0.5, EnvGen.kr(Env.perc(0.01, 0.1, 1, 4), levelScale: 0.25)) + 
				Pulse.ar(freq2, 0.5, EnvGen.kr(Env.perc(0.2, 0.01, 1, 4), levelScale: 0.25, 					doneAction: 2)),	
				posY,		//mix
				1			//room
			),
			posX				//pos
		)
	)
}).add;

)
(
//variabels
var maxX=100, maxY=100, aoc=15, // aoc: age of maturity
//names of synths
strewsynth, birthsynth, deathsynth, childdeathsynth, bytesynth, coasynth, meetingsynth,
//names of functions and routines
strew, findFood, findPartner, eat, determinePartner, doIt,
//named indices 
age=0, sex=1, xPos=2, yPos=3, energy=4, dying=5, cngoa=6;

~beasties = List.new(2);
~thisBeastie=Array.new(7);
~thatBeastie=Array.new(7);
~newBeastie=Array.new(7);
~food=Array2D.new(maxX, maxY);
t=0.03; //default time to wait


//fill ~food with zeroes
{for(0, maxX-1, {arg h;
	for(0, maxY-1, {arg v;
		~food[h,v]=0
	});
});
}.value;

//show window
z=7;
w=Window("beasties", Rect(400, 150, z*maxX, z*maxY));
w.view.background_(Color.white);
w.front;


//strewing food, 10 bytes per cycle
strew={
	var x, y;
 for(1, 10, {
	 x=maxX.rand;
	 y=maxY.rand;
	 ~food[x,y]=~food[x,y]+1;
	 });
	 strewsynth=Synth("strewSound");
	};


//draw
w.drawFunc={
	//draw ~food 
	for(0, maxX-1, {arg v;
		for(0, maxY-1, {arg h;
			Pen.color=Color.new(1-(~food[h,v]/10), 1,1-(~food[h,v]/10)); //more food on one place -> darker green
			Pen.addRect(Rect(h*z, v*z, z, z));
			Pen.fill;
		})
	});
		
	//draw ~beasties 
	for(0, ~beasties.size-1, {arg i;
		e=~beasties[i];
		if(e[dying]==true,{
			Pen.color=Color.black;
			Pen.addRect(Rect(((e[xPos]-0.5)*z), ((e[yPos]-0.5)*z), 2*z, 2*z));			Pen.fill;
		});
		if (e[cngoa]==true,{
			Pen.color=Color.yellow;
			Pen.addRect(Rect(((e[xPos]-0.5)*z), ((e[yPos]-0.5)*z), 2*z, 2*z));			Pen.fill;
		});

		if (e[sex]==0, {
			if (e[age]<aoc, {
				r=1;
				g=0.45 - (e[age] * 0.45/aoc);
				b=0.9 - (e[age] * 0.9/aoc);
			},{
				r=1;
				g=1-pow(0.995, e[age]-aoc);	//beasties get grey when they age
				b=1-pow(0.995, e[age]-aoc);
			})
		},{
			if (e[age]<aoc, {
				r=0;
				g=0.9 - (e[age] * 0.9/aoc);
				b=1;
			},{
				r=1-pow(0.995, e[age]-aoc);
				g=1-pow(0.995, e[age]-aoc);
				b=1;
			}
			);
		}
		);
		if (e[energy]<100, {		//beasties get darker when hungry
			r=e[energy]/100*r;
			g=e[energy]/100*g;
			b=e[energy]/100*b;
		});
		Pen.color=Color(r, g, b);
		Pen.addRect(Rect((e[xPos]*z), (e[yPos]*z), z, z));		Pen.fill;		
	});
	
};


findFood={
	var minX, minY, distance;
	var curpos;
	minX=maxX;	//x-coördinate of food-particle, closest to the beastie
	minY=maxY;	//y-coördinate of food-particle, closest to the beastie
	curpos = Point(~thisBeastie[xPos], ~thisBeastie[yPos]);

	block { arg break;
		~spiral_do.(maxX, { arg point;
			point = point + curpos;
			point.debug("findFood: before: point");
			point.x = point.x.wrap(0,maxX-1);
			point.y = point.y.wrap(0,maxY-1);
			point.debug("findFood: point");
			if(~food[point.x,point.y]>0) {
				minX = point.x;
				minY = point.y;
				break.value;
			}

		})
	};
	//distance=max(maxX, maxY);
	//for(0, maxY-1, {arg v;
	//	for(0, maxX-1, {arg h;
	//		if (~food[h,v]>0, {
	//			d=max((h-~thisBeastie[xPos]).abs, (v-~thisBeastie[yPos]).abs);
	//			if(d<distance, {
	//				minX=h;
	//				minY=v;
	//				distance=d;
	//			});
	//		});
	//	});
	//});

	[minX, minY].debug("found food !!");

	if(minX<~thisBeastie[xPos], {~thisBeastie[xPos]=~thisBeastie[xPos]-1});
	if(minX>~thisBeastie[xPos], {~thisBeastie[xPos]=~thisBeastie[xPos]+1});
	if(minY<~thisBeastie[yPos], {~thisBeastie[yPos]=~thisBeastie[yPos]-1});
	if(minY>~thisBeastie[yPos], {~thisBeastie[yPos]=~thisBeastie[yPos]+1});
};

eat={if (~food[~thisBeastie[xPos], ~thisBeastie[yPos]]>0, {
	f=240-(210*~thisBeastie[sex])+((1760+(210*~thisBeastie[sex]))*pow(0.99, ~thisBeastie[age]));
	//"Men" and "women" have different voices. Voices get lower with age
	bytesynth=Synth("hap", [freq: f, posX: -1+ (2*~thisBeastie[xPos]/maxX), posY: ~thisBeastie[yPos]/maxY]);
	~food[~thisBeastie[xPos], ~thisBeastie[yPos]]= ~food[~thisBeastie[xPos], ~thisBeastie[yPos]]-1;	~thisBeastie[energy]=~thisBeastie[energy]+10; //1 byte = 10 steps
			});
};



findPartner={
	var minX, minY, distance;
	var kdminX, kdminY;
	var nearest;
	var tree;
	var curnode;
	minX=maxX;	//x-coördinate of partner, closest to the beastie
	minY=maxY;	//y-coördinate of partner, closest to the beastie
	
	debug("findPartner:start");
	tree = KDTree(~beasties.collect({ arg x; [x[xPos],x[yPos]] }).debug("beasties"));
	curnode = tree.find([~thisBeastie[xPos], ~thisBeastie[yPos]]);
	nearest = tree.nearestToNode;
	kdminX = nearest[0].location[0];
	kdminY = nearest[0].location[1];
	minX = kdminX;
	minY = kdminY;
	//distance=max(maxX, maxY);
	//for(0, ~beasties.size-1, {arg k;
	//	if (k!= ~thisIndex,{
	//		d=max((~beasties[k][xPos]-~thisBeastie[xPos]).abs, (~beasties[k][yPos]-~thisBeastie[yPos]).abs);
	//		if(d<distance, {
	//			minX=~beasties[k][xPos];
	//			minY=~beasties[k][yPos];
	//			distance=d;
	//		});
	//	});
	//});
	[minX, minY, [kdminX, kdminY]].debug("minX, minY");
	if(minX<~thisBeastie[xPos], {~thisBeastie[xPos]=~thisBeastie[xPos]-1});
	if(minX>~thisBeastie[xPos], {~thisBeastie[xPos]=~thisBeastie[xPos]+1});
	if(minY<~thisBeastie[yPos], {~thisBeastie[yPos]=~thisBeastie[yPos]-1});
	if(minY>~thisBeastie[yPos], {~thisBeastie[yPos]=~thisBeastie[yPos]+1});
	debug("findPartner:end");
};



determinePartner={arg l;
	~partnerFound=false;
	for(0, ~beasties.size-1, {arg j;
		if(((l!=j)&&(~beasties[j][xPos]==~thisBeastie[xPos])&&
			(~beasties[j][yPos]==~thisBeastie[yPos])), {
				~thatBeastie=~beasties[j];
				~thatIndex=j;
				~partnerFound=true}
			);
	});
};


doIt=Routine({
	var f1, f2;
	~beasties.add([0, 1, maxX.rand, maxY.rand, 100, false, false]);
	~beasties.add([0, 0, maxX.rand, maxY.rand, 100, false, false]);
	strew.value;
	////~beasties.postln;
	{w.refresh}.defer;

	{
		i=0;
		while ({i<= (~beasties.size-1)}, {
			~thisIndex=i;
			~thisBeastie=~beasties[i];
			~thisBeastie[age]=~thisBeastie[age]+1;

			// coaing

			if(~thisBeastie[age]==aoc, {
				var bb = ~thisBeastie;
				var n;
				0.3.coin.if {
					Task({
						if (bb[energy]<100, {
							n=bb[energy]
						},{
							n=100
						});
						0.1.rand.wait;
						coasynth=Synth("coa", [\posX, -1+ (2*bb[xPos]/maxX), \posY, bb[yPos]/maxY, \num, n]);
						bb[cngoa]=true;
						0.5.wait;
						bb[cngoa]=false;	
					}).play;
				}
			});

			// energy loss
			~thisBeastie[energy]=~thisBeastie[energy]-1;

			// eating
			eat.value;

			// death

			if ((~thisBeastie[energy]<=0), {
				var bb = ~thisBeastie;
				var idx = ~thisIndex;
				var ite = i;
				if(bb[dying] == false) {
					Task({
						bb[dying]=true;
						if(bb[age] < aoc, {
							0.1.rand.wait;
							childdeathsynth=Synth("childDeath", [posX: -1+ (2* bb[xPos]/maxX), posY: bb[yPos]/maxY]);
						},{	
							0.1.rand.wait;
							deathsynth=Synth("death", [posX: -1+ (2*bb[xPos]/maxX), posY: bb[yPos]/maxY]);
						});
						//~beasties.put(idx, bb);
						1.wait;
						~beasties.removeAt(ite);
					}).play;
				}
			},{
				if (~thisBeastie[energy]<500, //hungry?
					{findFood}.value,
					{findPartner}.value
				);
				determinePartner.value(i);

				//meeting

				if (~partnerFound, {
					//play meeting
					var p1, p2;
					f1=240-(210*~thisBeastie[sex])+((1760+(210*~thisBeastie[sex]))*pow(0.99, ~thisBeastie[age]));
					f2=240-(210*~thatBeastie[sex])+((1760+(210*~thatBeastie[sex]))*pow(0.99, ~thatBeastie[age]));
					p1 = -1+(~thisBeastie[xPos]/maxX*2);
					p2=~thisBeastie[yPos]/maxY;
					meetingsynth=Synth(\meeting, [freq1: f1, freq2: f2, posX: p, posY: p2]);

					if(( (~thisBeastie[sex]!=~thatBeastie[sex])&&(~thisBeastie[age]>aoc)&&
					(~thatBeastie[age]>aoc)), {
						//birth
						birthsynth=Synth("birth", [posX: -1+ (2*~thisBeastie[xPos]/maxX), posY: ~thisBeastie[yPos]/maxY]);

						~thisBeastie[energy]=~thisBeastie[energy]-50;
						~thatBeastie[energy]=~thatBeastie[energy]-50;
						~newBeastie=[0, 2.rand, ~thisBeastie[xPos], ~thisBeastie[yPos], 100, false, false];
						if((~thisBeastie[energy]<0),{
							~thatBeastie[energy]=~thatBeastie[energy]+~thisBeastie[energy];
							~thisBeastie[energy]=0
						});
						if((~thatBeastie[energy]<0),{
							~newBeastie[energy]=~newBeastie[energy]+~thatBeastie[energy];
							~thatBeastie[energy]=0
						});	
						~beasties.add(~newBeastie);
						~beasties.size.postln;
						g=2.rand;
						if(g==0, {		//shoot horizontally
							~thisBeastie[yPos]=~thisBeastie[yPos]+1;
							if(~thisBeastie[yPos] > (maxY-1), {~thisBeastie[yPos]=maxY-1});
							~thatBeastie[yPos]=~thatBeastie[yPos]-1;
							if(~thatBeastie[yPos] < 0, {~thatBeastie[yPos]=0});
							~beasties.put(~thisIndex, ~thisBeastie);
							~beasties.put(~thatIndex, ~thatBeastie);
							x=~newBeastie[xPos];
							if((x<(maxX/2)), {
								for(0, 10, {
									~newBeastie[xPos]=~newBeastie[xPos]+2;
									~beasties.put(~beasties.size-1, ~newBeastie);
									{w.refresh}.defer;
									t.wait;
								})
							},{
								for(0, 10, {
									~newBeastie[xPos]=~newBeastie[xPos]-2;
									~beasties.put(~beasties.size-1, ~newBeastie);
									{w.refresh}.defer;
									t.wait;
								});
							}
							)
						},	{			//shoot vertically
							~thisBeastie[xPos]=~thisBeastie[xPos]+1;
							if(~thisBeastie[xPos] > (maxX-1), {~thisBeastie[xPos]=maxX-1});
							~thatBeastie[xPos]=~thatBeastie[xPos]-1;
							if(~thatBeastie[xPos] < 0, {~thatBeastie[xPos]=0});
							~beasties.put(~thisIndex, ~thisBeastie);
							~beasties.put(~thatIndex, ~thatBeastie);
							y=~newBeastie[yPos];
							if((y<(maxY/2)), {
								for(0, 10, {
									~newBeastie[yPos]=~newBeastie[yPos]+2;
									~beasties.put(~beasties.size-1, ~newBeastie);
									{w.refresh}.defer;
									t.wait;
								})
							},{
								for(0, 10, {
									~newBeastie[yPos]=~newBeastie[yPos]-2;
									~beasties.put(~beasties.size-1, ~newBeastie);
									{w.refresh}.defer;
									t.wait;
								});
							});
						});
					});
					~partnerFound=false;
				});
				eat.value;
				~beasties.put(i,~thisBeastie);
			});

			t.wait;
			i=i+1;
		});
		~waittime.wait;
		{w.refresh}.defer;
		strew.value;
	}.loop;

	
//~beasties.postln;
});

doIt.play;
~waittime = 0.11;
t=0.003;
)

~waittime = 0.01;
~waittime = 1.11;
~waittime = 0.21;
(
~waittime = 0.11;
t=0.003
)
Volume.volume = 1
s.volume.volume = -78
s.volume.volume = 0
