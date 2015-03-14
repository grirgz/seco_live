(
~clip_preset_manager = ~class_clip_preset_manager.new;
~clip_preset_manager.edit;
)

Veco.project_slots[1].use({  ~veco.get_node_by_uname('1').play_node })
Veco.project_slots[0].use({  ~veco.get_node_by_uname('1').stop_node })

Veco.project_slots[1][\veco].get_node_by_uname('1').play_node
Veco.project_slots[0][\veco].get_node_by_uname('1').play_node
Veco.project_slots[1][\veco].get_node_by_uname('1').uname
Veco.project_slots[1][\veco].get_node_by_uname('1').bare_uname

Veco.project_slots[0][\veco].get_node_by_uname('1').get_clip_by_index(0).uname
Veco.project_slots[0][\veco].get_node_by_uname('1').get_clip_by_index(64).uname

// preset (others channels)
(
Veco.main.pane_rect = Rect(0,4,8,4);
Veco.main.pane_offset = Point(64,0);
Veco.main.pane_target_project = Veco.project_slots[1]; 
Veco.main.clip.update_display;
)
Veco.main.pane_rect = Rect(0,4,8,4); Veco.main.clip.update_display;
Veco.main.pane_offset = Point(64,0); Veco.main.clip.update_display;
Veco.main.pane_offset = { Point(64+Veco.main.clip_offset.x,Veco.main.clip_offset.y) }; Veco.main.clip.update_display;
Veco.main.pane_target_project = Veco.project_slots[1]; Veco.main.clip.update_display;
Veco.main.clip.update_display;

// load external project
~trigpadboard = Veco.open_side_project( Veco.main.project_name +/+ "trigpad1");
(
~set_launcher.(4, { arg self; self.offset = Point(4,0)*8 });
~set_launcher.(5, { arg self; self.offset = Point(5,0)*8 });
~set_launcher.(6, { arg self;
	self.mid_pane;
	Veco.main.pane_offset = Point(0,64);
	Veco.main.pane_target_project = ~trigpadboard;
});
~set_launcher.(7, { arg self;
	self.no_pane;
});
);

// moder (act on same channel)
(
Veco.main.pane_rect = Rect(0,4,8,4);
Veco.main.pane_offset = Point(0,64);
Veco.main.pane_target_project = Veco.project_slots[1]; 
Veco.main.clip.update_display;
)
Veco.main.pane_rect = Rect(0,4,8,4); Veco.main.clip.update_display;
Veco.main.pane_offset = Point(0,64); Veco.main.clip.update_display;
Veco.main.pane_target_project = Veco.project_slots[1]; Veco.main.clip.update_display;
Veco.main.clip.update_display;
Veco.project_slots[1]

PathName(Veco.project_slots[1][\veco].project_path).asRelativePath( ( Veco.user_path+/+"" ).drop(-1))

Veco.open_project("stone1")
Veco.gui

Veco.open_project("testme2")

Veco.main.clipboard_mode
Veco.main.clipboard_clip

 (
 ~target_project_path = "/home/ggz/code/sc/seco/vlive/stone1";
 32.do { arg x;
	 32.do { arg y;
		 var node = Veco.main.get_node_by_index(x);
		 node.clips[64+y] = ~class_shortcut_clip.new(
			 Veco.main, node.uname ++ "." ++ (y+64+1).asString, node, ~target_project_path, node.bare_uname ++ "." ++ (y+1).asString
		 );
	 }
 
 }
 )


 Veco.load_lib("preset_manager.scd")
~clip_preset_manager = ~class_clip_preset_manager.new;
~clip_preset_manager.edit;
//~clip_preset_manager.scan_project( "~/code/sc/seco/vlive/stone8" );
//~clip_preset_manager.scan_tree( "~/code/sc/seco/vlive/" );
//~clip_preset_manager.open_holder_project;
//~clip_preset_manager.scan_file( "~/code/sc/seco/vlive/crap/51.scd".standardizePath ).debug("tags");
//~clip_preset_manager.clip_library.debug("clips");
"hié".debug;

)
~clip_preset_manager.save_data
~clip_preset_manager.data_path.load

(
~phpath ="~/code/sc/seco/vlive/preset_holder".standardizePath;
Veco.projects[~phpath].use{
	~debugclip.postln;
	~debugclip.execute;
	~debugclip.response_on_play;
	//Pdef(~debugclip.parent_buffer.uname).play;
}
)

(
~phpath ="~/code/sc/seco/vlive/preset_holder".standardizePath;
Veco.open_side_project(~phpath)
)
(

	~target_path ="~/code/sc/seco/vlive/stone8/".standardizePath; 
Veco.projects[~phpath].use {
	var main;
	var uname;
	var node;
	var clip;
	//Veco.main.get_node_by_index(0).clips.debug("nn")
	//main.get_node_by_index(0).get_clip_by_index(0).debug("nn")
	//main.get_node_by_index(0).clips[0]
	main = Veco.main;
	uname = main.index_to_uname(0);
	node = ~class_shortcut_node.new(main, uname, ~target_path, "1");
	main.nodes[uname] = node;
	node.path.debug("path");
	node.execute;
	clip = ~class_shortcut_clip.new(main, uname++".1", node, ~target_path, "1.1");
	node.clips[0] = clip;

	[clip.uname,clip.path].debug("path");
	//clip.execute;
	~buf.debug("buf");
	//clip.play_node;

}
)

Veco.projects[~phpath].use { ~veco.activate }
Veco.projects[~phpath].use { ~veco.get_nodeclip_by_uname("1.1").uname.debug("uname") }
Veco.projects[~phpath].use { Pdef(Veco("1").uname.debug("kkj")).source.asCompileString.debug("uname") }
Veco.projects[~phpath].use { Veco("1.1")[\stop_node].debug("hwjh") }
Veco.projects[~phpath].use { Veco("1.1")[\play_node].debug("hwjh") }
Veco.projects[~phpath].use { Veco("1.1").play_node.debug("hwjh") }
Veco.projects[~phpath].use { Veco("1.1").execute.debug("hwjh") }
Veco.projects[~phpath].use { Veco("1.1").execute.debug("hwjh") }
Veco.projects[~phpath].use { Veco("1.1").response_on_stop }
Veco.projects[~phpath].use { Veco("1").execute }
Veco.projects[~phpath]
