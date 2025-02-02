
(
FileSystemProject.loadOnce("paramdev/drafts/arpegiator.scd");
~parp = { arg input, arp, engine;
	ProtoTemplateDef(\Arpegiator).arper(input, arp, engine)
};
~parplive = { arg notefun, input, arp, engine;
	ProtoTemplateDef(\Arpegiator).arperlive(notefun, input, arp, engine)
};
)
