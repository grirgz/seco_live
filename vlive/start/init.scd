Veco.main.board_size = Point(16,64);
Veco.load_lib("main.scd");
~load_standard_quickpad.();

// END

Veco.main.fadeout_time = 16;

Veco.switch_project_slot(0)
Veco.project_slots.collect(_.class)
Veco.project_slots[0][\veco].project_name
Veco.project_slots[1] == topEnvironment
Veco.main.project_name
topEnvironment.push
Veco.main.clip.activate
