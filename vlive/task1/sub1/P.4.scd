
~timeline_do.(8, 1, nil, { arg name, namex, index;
	{
		(7-0.12).wait;
		~spawnclip.(0, \r);
		~spawnclip.(1, \r);
		~spawnclip.(2, \r);
		//~spawnclip.(3, \r);

	}.fork;

});

// END

~spawn_cliprow.(0)
