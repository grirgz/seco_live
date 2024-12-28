
(
FileSystemProject.load("paramdev/drafts/arpegiator.scd");
~parp = { arg input, arp, engine;
	ProtoTemplateDef(\Arp).arper(input, arp, engine)
};
~parplive = { arg notefun, input, arp, engine;
	ProtoTemplateDef(\Arp).arperlive(notefun, input, arp, engine)
};
)
