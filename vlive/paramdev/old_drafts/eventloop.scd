// quel est la structure de base du model sur laquelle devrait operer la vue et les controlleurs ?
// la premiere idée est une simple list d'event qui puisse etre jouée avec Pseq. Mais ces events ont un timing relatif, ce qui fait qu'on ne peut pas deplacer ou inserer un event facilement sans tout casser. Conclusion, il faut une structure avec timing absolu et recalcul du timing relatif pour jouer, c'est a dire EventList
// EventLoop permet de contenir plusieurs EventList (dans le cas d'un enregistrement c'est un historique), de definir un debut et une fin (lpRange) arbitraire qui ne detruit pas la durée reelle de l'EventList, accessoirement de jouer les notes avec .play
// EventLoop permet aussi de changer le tempo, faire un reverse, de definir un step qui permet de sauter des notes ou de jouer a l'envers
//		de faire pause, resume, stop
// Question: vu qu'EventLoop prend le timing a partir de thisThread.second on dirait qu'il prend pas le tempo en compte, comment sait il a quel tempo il enregistre pour pouvoir le rejouter ? ou bien c'est tout le temps un tempo relatif de 1 ? oui c'est tout le temps un tempo relatif de 1 car il utilise .wait qui lui utilise TempoClock si je ne m'abuse, en tout cas il utilise le clock de TaskProxy. faudrait tester si y'a pas un bug
// il faudrait rajouter un .embedInStream qui fait le meme boulot que .play dans EventLoop, peut etre l'ajouter aussi a EventList pour plus de souplesse

// EventLoop.recordEvent prend en compte le timing, mais c'est a l'user de gerer le son qui est sensé etre generé, ce qui peut etre un avantage si on utilise un autre systeme pour jouer le son que l'event enregistré (par exemple si l'enregistreur est incorporé dans un pattern qui joue deja)
// il faut cependant prevoir un systeme qui peut jouer et enregistrer si necessaire quand on click sur un bouton ou qu'on enfonce une touche MIDI
// il faut une EventListener(EventFactory ?) qui ecoute le MIDI ou la GUI, a ne pas confondre avec l'EventPlayer qui joue l'enregistrement
// l'enregistrement doit passer par une classe separée car chaque enregistrement correspond a un EventList different, et pas forcement le meme EventLoop (car on enregistre sur la piste d'un autre instrument) mais cet EventRecorder
// si on veut plusieurs EventListener car il peut avoir des parametres specifiques par exemple jouer un pattern particulier de \ffreq ou une arpegiation, il faut un MIDIMapper qui peut mapper une source midi (noteOn on channel 1 par exemple) vers un EventListener
// A essayer de simplifier un max pour pas avoir a creer 15 objets pour faire un bete truc

// note: il semble qu'aucune pause/reprise de l'enregistrement soit prevue dans EventLoop, c'est a dire rajouter des notes puis deplacer l'event de type:\end tout a la fin

//// event keys doc:
// - in EventList, time is stored as \absTime, then you should call .calcRelDurs to set \relDur and \dur, then call .setPlayDursToRelDur to set \playDur from \relDur. 
// - \playDur is used in .play task as waiting time
// - .quantizeDurs set the quantized timing in \playDur from \absTime, you can access the original timing in \absTime and \relDur

// the messages that could be signaled to a view are:
// - addEvent
// - quantizeDurs
// Superclass
// - put
// - add
// - remove

// il n'y a aucun support pour supprimer une note dans EventList, surement parce que c'est pensé pour enregistrer seulement, pas pour editer
// de meme, pas de support pour deplacer une note, ce qui implique pas de message envoyable lors de la modif a partir du code
// faudra le rajouter
// que faire du probleme que l'interface utilise ces methodes pour changer la liste et recoi donc un signal d'updater la view alors que la modif viens d'elle meme donc la view est deja updaté ? cela n'a jamais posé probleme pour les Knob car le message pour updater la GUI ne dit pas d'updater le model, donc faut faire pareil pour EventTimeline

// un des trucs partagés par toutes les timeline est bien le temps, le reste ne sont que des clés:valeurs qui ajoutent des informations sur l'event

// lorsqu'on lance l'editeur ~el.edit il cree les notes graphiques (TimelineViewNode) a partir de l'EventList, ainsi qu'un model interne qui est un dictionnaire ou chaque clé est l'index d'une note graphique et la valeur l'event qui correspond a cette clé
// la question est: pourquoi ce n'est pas simplement la note graphique qui pointe vers l'event ?
//		et si on deplace une note dans l'EventList, comment l'interface retrouve quelle note graphique doit etre deplacée ?
//			il faudrait que chaque event puisse emetre un signal et que la note graphique le retrouve mais ca implique que la View doit avoir un controlleur pour chaque Event, c'est un peu le bordel non ?
//			mais meme avec un model interne index:event, l'event ne sait pas quel index il est dans l'interface
//			apres tout c'est pas si compliqué, TimelineViewNode peut gerer la creation du SimpleController pour gerer les changement de position ou d'autres proprietés de l'event, c'est lui aussi qui doit gerer la modification de \dur dans l'event lors d'un deplacement par l'UI
//				c'est un peu l'equivalent de .action et SimpleController pour un Knob
//			deplacer une note veut dire changer son \absTime mais aussi trier a nouveau la liste pour que ce soit dans l'ordre
// si on deplace une note, la view appel le callback nodeTrackAction qui lui va recreer les notes de l'EventList

// messages envoyés par un event:
// - refresh
//		- ce message met a jour les proprietés suivantes de la note graphique
//			- position temporelle ( a partir de \absTime, probleme: la quantization n'est pas affichée du coup, il faudrait une autre clé dans l'event )
//			- position verticale: \degree, \drum_name, \fx_name, etc
//			- la couleur a partir de la velocité par exemple
//		- ensuite la note appel un rafraichissement du parent pour prendre en compte ces modifications
// la creation d'une note implique la creation d'une note dans l'EventList ainsi qu'un message envoyé a la view pour lui dire qu'un nouvel Event existe et que la view doit rajouter une note graphique ainsi qu'un SimpleController sur l'event
// la destruction d'une note implique un message a la view pour lui dire detruit la note graphique et libere le SimpleController
// si on quantize l'EventList, il doit rafraichir la position de chaque note graphique, mais en fait la note graphique doit aller chercher sa position directement dans l'event, sinon il devrait aussi se mettre a jour (ce qui en fait n'est pas tant un probleme, on appel refresh sur chaque note graphiquea), mais finalement si la note va chercher directement sa proprieté, ca evite que le refresh fasse quoi que ce soit d'autre que de relancer drawBackground. Cela depend en fait si les calculs sont longs et doivent donc etre fait qu'au refresh ou peuvent etre fait a chaque cycle du drawBackground (qui peut etre frequent si ligne de progression par exemple, ou si enregistrement en live)

// les events ont leur position temporelle en beat, et leur sustain en seconde (gridPoint)
// le canvas a sa position en pixel (pixelPoint)
// areasize correspond a la taille totale de la zone d'affichage en beat@midinote (gridRect)
// viewport est un rectangle qui correspond a la zone visible de la zone d'affichage (entre 0 et 1) 
// pour s'afficher (via .draw), les notes graphiques doivent convertir leur position en beat@degree vers des pixels (gridRectToPixelRect)
// normPoint est une position entre 0 et 1 ou 0 est le debut de areasize et 1 la fin
// gridRectToNormRect traduit la position en beat@degree en point normalisé en divisant par areasize
// normRectToPixelRect traduit la position normalisé en pixels en multipliant par la taille du canvas et en y appliquant le viewport



12.0.gauss(2.0)

(
// create a cluster of events around beat 12
var events = Array.fill(64, { arg i;
            // an Event object
            (
                // gaussian distribution with 2.0 standard deviations around beat 12.0
                beat: 12.0.gauss(2.0),
                degree: 20.rand,

                type: \instr,
                instr: "schelp.EventListPlayer",
                env: Env.perc
            )
    });

Instr("schelp.EventListPlayer", { arg freq=440, env;
    SinOsc.ar(freq) * EnvGen.kr(env, doneAction:2)
});

e = EventListPlayer.new(events);

// e.gui

x = Mx.new;
x.add(e);
x.gui;

)



// make a new EventList
a = EventList[];

// add some time-stamped events to it
a.start;
a.addEvent((absTime: 0, deg: 0));    // events should begin with time 0;
a.addEvent((absTime: 0.3, deg: 1));
a.addEvent((absTime: 0.52, deg: 2));
a.addEvent((absTime: 0.72, deg: 3));
a.addEvent((absTime: 0.93, deg: 4));
a.finish(1.88);

// printing is quite flexible:
a.print;
a.print([\dur]);
a.print([\dur], false);
a.print([\absTime, \dur], false);

a.quantizeDurs(0.25, 2).printAll;"";
a.totalDur;
a.playingDur;

// play the list by hand 
// ( usually one would use EventLoop )
(
fork { 
    a.do { |ev|
        var deg = ev[\deg];
        ev.postln;
        if (deg.notNil) { (degree: deg, sustain: 0.1).play; };
        ev[\relDur].wait;
    };
};
)



// Simplest example: use EventLoop to record a Pbind

e = EventLoop(\e);
e.startRec;

(
Pbind(
    \note, Pbrown(0, 12, 1, 40),
    \dur, 0.125,
    \rec, e
).play
)

e.stopRec;
e.listInfo;
e.play;

e.list.print;



    // more detail:

    // make a EventLoop with a name and a func 
    // the func expects numbers that work as degrees
e = EventLoop(\u, { |ev| (degree: ev[\deg], dur: 0.1).play; });

    // EventLoop expects lists of events, 
    // which have an absTime entry, and arbitrary other info.
    
    // for example: add a list of ascending notes
(    // (in typical use, the lists will be recorded in real time)
fork { 
    e.startRec;        // adds a start event
    e.recordEvent((deg: 0).postln); 1.wait;
    e.recordEvent((deg: 1).postln); 1.wait;
    e.recordEvent((deg: 2).postln); 0.45.wait;
    e.recordEvent((deg: 3).postln); 0.55.wait;
    e.recordEvent((deg: 4).postln); 0.3.wait;
    e.recordEvent((deg: 5).postln); 0.2.wait;
    e.recordEvent((deg: 6).postln); 0.22.wait;
    e.recordEvent((deg: 7).postln); 0.28.wait;
    e.stopRec;    
};
)
    // u has the recorded list as current,
    // and can play it
e.play;
e.looped_(true).play; // now loops

    // change tempo
e.tempo_(1.5);
e.tempo_(2);
e.tempo_(1);

    // quantize to a grid - not fully tested yet
e.quantize(0.25, 4);
e.quantize(0.125, 3);
e.quantize(0.1666666, 4);
e.unquantize;  

    // change direction
e.reverse;
e.flip;
e.forward;

    // change range within loop:
e.range = 0.25;        // first quarter
e.lpStart = 0.25;    // second quarter
e.lpStart = 0.5;    // center 50%
e.range = 0.5;        // second half
e.lpStart = 0.75;    // last quarter continues into first
e.resetLoop;        // reset loop params

    // jitter event order by % 
e.jitter = 0.25;
e.jitter = 0.5;
e.jitter = 0;
e.resetLoop;


    // if you record again, playback will stop
(
fork {
    e.startRec;
    10.do { |i|
        e.recordEvent((deg: i.neg + 7).postln); (1 / (i+1)).wait;
    };
    e.stopRec;    
};
)
e.play;

    // switch between the two lists 
e.setList(0); // the newest
e.setList(1); // back in time


e.collect(_.postln)


///////////////////////////////////////////////////


// make a sound to control 
(
Ndef(\form, { |freq = 50, shape = 0.9, ffreq = 200, amp = 0.1, lag = 0.1|
    var snd = VarSaw.ar(freq.lag(lag) + [0.1, -0.1], 0, shape.lag(lag));
    Formlet.ar(snd * amp.lag(lag), ffreq.lag(lag), 0.003, 0.03).softclip;
}).play(vol: 0.2);
// add specs for its unusual params:
Ndef(\form).addSpec(\shape, [0, 1]);
Ndef(\form).addSpec(\ffreq, \freq);
)

// make a KtlLoop for it
(
k = KtlLoop(\form);

// tell it which params will be recorded for control input:
k.paramsToRecord_([\lx, \ly, \rx, \ry]);

// simple usage case:
// tell it which object will be controlled 
k.object_(Ndef(\form));

// and declare which input params set which object params
k.ktlMap_((lx: \freq, ly: \shape, rx: \ffreq, ry: \amp));

)

// make 4 channel controller:
    // put params into an event, store it, 
    // and set the object from it

(
w = Window("KtlLoop.help", Rect(0,500, 400, 550)).front;
w.view.addFlowLayout;
Slider2D(w, Rect(0,0,190,190))
    .action_({ |sl|

        // put params into an event, 
    var event = (lx: sl.x, ly: sl.y);
        // store it, 
    k.recordEvent(event.put(\type, \set));
        // and set the object from it
    k.setuObj(event);
});
Slider2D(w, Rect(0,0,190,190))
    .action_({ |sl|
    var event = (rx: sl.x, ry: sl.y);
    k.recordEvent(event.put(\type, \set));
    k.setuObj(event);
});

// make an eventloopgui for KtlLoop
KtlLoopGui(k, parent: w, bounds: 260@180);

// and an NdefGui for the Ndef
NdefGui(Ndef(\form), 6, w);
)

// try recording: 
k.startRec;
// ...
// now move the two sliders
// ...
// ...

k.stopRec;

k.listInfo;

k.play;


// Rescaling Gestures - all recorded controller values 
// can be scaled, shifted, and inverted. 

k.rescaled = false;
k.rescaled = true;
// decrease range toward center
k.scaler = 0.5;
k.scaler = 0.25;
// shift up or down
k.shift = 0.1;
k.shift = -0.1;

// invert range
k.invert;
k.up;
k.flipInv;

k.dontRescale(\lx);
k.doRescale(\lx);

k.postKtlInfo;



~p = Param(Ndef(\ndef_scalar), \freq);
MIDIMap(\k1, ~p)

~er = EventRecorder
~er.paramsToRecord_([ ~p]);
~er.startRec
~er.stopRec
~er.eventlist.play;


(
	\type, \set,
	k
)
k.print
k.lists
NodeProxy


Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	
	sig = SinOsc.ar(\freq.kr(400)) ;
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
})

Pdef(~name +++ \pre, Pbind(
	\freq, 100,
));

Scale.choose(7);



(
SynthDef(\toc, {
Out.ar(0, XLine.ar(1, 0.01, 0.02, doneAction: 2)
* SinOsc.ar([600, 1300, 4500], 0, [0.3, 0.2, 0.1]).postln);
}).add;
)

(instrument: \toc).play;

    // get more info posted
e.verbosity = 2;

e.startRec;
    // run this line this multiple times, in some rhythm
e.recordEvent((instrument: \toc)); (instrument: \toc).play;

e.stopRec;

    // post info on the recorded list
e.listInfo;
e.printLists;

e.play;

e.looped_(true).play;
z.tempo = 0.5;
z.tempo = 2;
z.tempo = 1;




e.func.asCompileString



/////////////////////////////////////
///////////////////////////////////



    // Construct long example of EventList use by hand:

    // make a EventLoop with a name and a func 
    // the func expects numbers that work as degrees
e = EventLoop(\u, { |ev| (degree: ev[\deg], dur: 0.1).play; });

    // EventLoop expects lists of events, 
    // which have an absTime entry, and arbitrary other info.
    
    // for example: add a list of ascending notes
    // (in actual use, the lists will be recorded)
(
l = EventList[
	(absTime: 0, type: \start), // required start event
	(absTime: 0, deg: 0), 
	(absTime: 1, deg: 1), 
	(absTime: 2, deg: 2), 
	(absTime: 2.5, deg: 3), 
	(absTime: 3, deg: 4), 
	(absTime: 3.25, deg: 5), 
	(absTime: 3.5, deg: 6), 
	(absTime: 3.75, deg: 7), 
	(absTime: 3.875, deg: 8),
	(absTime: 4, type: \end)	// required end event
];
)

l.calcRelDurs;    // now add delta and dur times into the events
l.setPlayDursToRelDur;
l.print;        // print in readable order

    // make l the current list of EventLoop u: 
e.list = l; 
    // add the current list to the beginning of the recorded lists 
e.addList; 

    // now play the events in the list, 
    // with the task in EventLoop u calling its function:
e.play;
    // stops after first time, unless:
e.looped_(true).play; // now loops


        EXAMPLE 2 // record rhythm only, play by hand

// a sound to use        
(
SynthDef(\toc, {
Out.ar(0, XLine.ar(1, 0.01, 0.02, doneAction: 2)
* SinOsc.ar([600, 1300, 4500], 0, [0.3, 0.2, 0.1]).postln);
}).add;
)

e = EventLoop(\toc);

(instrument: \toc).play;

    // get more info posted
e.verbosity = 2;

e.startRec;
    // run this line this multiple times, in some rhythm
e.recordEvent((instrument: \toc)); (instrument: \toc).play;
e.recordEvent

e.stopRec;

    // post info on the recorded list
e.listInfo;
e.printLists;

e.play;

e.looped_(true).play;
z.tempo = 0.5;
z.tempo = 2;
z.tempo = 1;

e.reset


