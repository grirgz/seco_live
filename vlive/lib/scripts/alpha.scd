
(
//Veco.switch_project_slot(0);
Veco.open_project("fxboard1");
Veco.switch_project_slot(1);
Veco.open_project("alpha_perc1");
Veco.switch_project_slot(2);
Veco.open_project("alpha1");
Veco.switch_project_slot(3);
Veco.open_project("alpha2");
Veco.switch_project_slot(4);
Veco.open_project("stone10");
Veco.switch_project_slot(5);
Veco.open_project("stone3");
Veco.switch_project_slot(6);
Veco.open_project("stone1");
Veco.switch_project_slot(0);
Veco.load_lib("main.scd");
~load_standard_quickpad.();
~set_project_tempo.(1);
~set_default_quant.(4);
CmdPeriod.run;
)

(
Veco.switch_project_slot(0);
Veco.open_project("fxboard1");
Veco.switch_project_slot(1);
Veco.open_project("alpha_perc1");
Veco.switch_project_slot(2);
Veco.open_project("alpha1");
)

~set_project_tempo.(1);
~set_default_quant.(4);
s.volume.volume = 0;
