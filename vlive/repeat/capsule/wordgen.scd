(

	~words = [
		"chaleureux",
		"calme",
		"aggressif",
		"joyeux",
		"triste",
		"stressé",
		"angoissé",
		"minimaliste",
		"complexe",
		"bruyant",
		"lourd",
		"lent",
		"leger",
		"rapide",
		"petillant",
		"monte",
		"descend",
		"oscille",
		"aigu",
		"grave",
		"court",
		"long",
		"piquant",
		"rond",
		"carré",
		"doux",
		"brouhaha",
		"brouillard",
		"froid",
		"timide",
		"bavard",
		"ocean",
		"foret",
		"vent",
		"pluie",
		"mouillé",
		"acide",
		"sombre",
		"clair",
		"sautillant",
		"discordant",
		"harmonieux",
		"desequilibre",
		"explosion",
		"motivant",
		"ennuyant",
		"eblouissant",
		"beau",
		"moche",
		"varié",
		"repetitif",
		"acceleration",
		"deceleration",
		"eparpillement",
		"grincant",
		"epique",
		"faible",
		"colere",
		"nostalgie",
		"roulant",
		"envol",
		"rupture",
		"suspension",
		"silence",
		"bruit",
		"coloré",
		"terne",
		"continue",
		"discret",
		"progressif",
		"boitant",
		"surprenant",
		"melodique",
		"profond",
		"grand",
		"petit",
		"plat",
		"rugueux",
		"mou",
		"dur",
		"visceux",
		"metalique",
		"sec",
		"marcher",
		"courir",
		"respirer",
		"glissant",
		"lisse",
		"efritable",
		"elastique",
		"electrique",
		"spirale",
		"casse",
		"dechirement",
		"campagne",
		"ville",
		"detaillé",
		"au loin",
		"fragile",
		"solide",
		"clairsemé",
		"touffu",
		"ordonné",
		"bordelique",
		"irregulier",
		"regulier",
		"disparait",
		"apparait",
		"pic",
		"creux",
		"tourbillon",
		"granuleux",
		"gras",
		"soyeux",
		"boueux",
		"deborde",
	];

{~words.choose}.dup(16).clump(4)
)


(
	~structures = (
		alt: { arg a, b; [a, b, a, b] },
		mirror: { arg a, b; [a, b, a] },
		stut: { arg a, b; [[a, a], [b,b]].choose },
		seq: { arg a, b; [[a, b], [b,a]].choose },
	);
	~structures = (
		stut: [\end, \end],
		stut: [\end, \end],


	);
	~genstruct = {
		~structures.choose.()
	};

	~a = \a;
	~b = \b;
	//alt
	~c = \abab
	//stut
	~d = \aa
	//alt c d
	~e = \ababaaababaa

	[a, a'], [a, a']'
)
