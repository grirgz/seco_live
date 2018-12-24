
~t = 135/4/60; TempoClock.default.tempo = ~t;
/////// main test
(
Pdef(\part, Pdef(\main, 
	Pseq([
		Ppar([
			Pdef(\ze_snapkickx),
			Pdef(\ze_snare_ksh2b),
			//Pdef(\ze_phyhat3),
			//Pdef(\ze_kalimba),
			//Pdef(\ze_brownbass),
			//Pdef(\ze_fmbass),
			//Pdef(\ze_fmbell),
			//Pdef(\ze_vlip),
			Pdef(\ze_pluck),
			//Pdef(\ze_chordar),
			//Pdef(\ze_fmsaw_scratch),
			//Pdef(\ze_rise),
			//Pdef(\ze_amenbreak),
			//Pdef(\ze_sibass),
			//Pdef(\ze_stringsx),
			//Pdef(\ze_basicbass),
			//Pdef(\ze_snare_electro),
			Pdef(\ze_hihat_electro),
			Pdef(\ze_snaretuned2),
			//Pdef(\ze_organ_tonewheel1),
			Pdef(\ze_hech),
			//Pdef(\ze_fzion3),
			//Pdef(\ze_fzion4),
			//Pdef(\ze_fzion2),
			//Pdef(\ze_fzion),
			//Pdef(\ze_clap_bat),
			//Pdef(\ze_hat_bat_pre),
			//Pdef(\ze_clave_bat),
			//Pdef(\ze_feynman_scratch),
			//Pdef(\ze_dronebleu),
			//Pdef(\ze_dronebleuhi),
			//Pdef(\ze_iron),
			//Pdef(\ze_cracklemono),
			//Pdef(\ze_crackledec),
			//Pdef(\ze_bassgrise),
			//Pdef(\ze_dubdrone4x),
			//Pdef(\ze_dubdrone4),
			//Pdef(\ze_rim1),
			//Pdef(\ze_rim5),
			//Pdef(\ze_rim6),
			//Pdef(\ze_rim8),
			//Pdef(\ze_chovar),
			Pdef(\ze_hat_ksh2b),
			//Pdef(\ze_ridecast_speed),
			//Pdef(\ze_phyhat4),
			//Pdef(\ze_organ),
			//Pdef(\ze_wavechord),
			//Pdef(\ze_rim1_speed),
			//Pdef(\ze_grancru),
			//Pdef(\ze_smp_crush),
			//Pdef(\ze_smp_crush2),
			//Pdef(\ze_simpleacid),
			//Pdef(\ze_stepchord1),
			//Pdef(\ze_stepchord2),
			//Pdef(\ze_ridecast),
			//Pdef(\ze_chordlock2),
			//Pdef(\ze_chordlock3),
			//Pdef(\ze_basslok),
			//Pdef(\ze_tassbass),
			//Pdef(\ze_chordo),
			//Pdef(\ze_perctone),
			Pdef(\ze_aigu),
			//Pdef(\ze_conga),
			Pdef(\ze_longf),
			//Pdef(\ze_dubdrone),
			//Pdef(\ze_dubdrone3),
			Pdef(\ze_chordo2),
			//Pdef(\ze_plouc),
			//Pdef(\ze_hipass),
			//Pdef(\ze_hipasswide),
			//Pdef(\ze_chordodo),
			//Pdef(\ze_basicpadfm),
			Pdef(\ze_cymbalsimple),
			Pdef(\ze_oneone),
			//Pdef(\ze_oneone2),
		]),
	])
)).play;
);


(
~ze_list = [
				Pdef(\ze_snapkickx),
				Pdef(\ze_snare_ksh2b),
				Pdef(\ze_phyhat3),
				Pdef(\ze_kalimba),
				Pdef(\ze_brownbass),
				Pdef(\ze_fmbass),
				Pdef(\ze_fmbell),
				Pdef(\ze_vlip),
				Pdef(\ze_pluck),
				Pdef(\ze_chordar),
				Pdef(\ze_fmsaw_scratch),
				Pdef(\ze_rise),
				Pdef(\ze_amenbreak),
				Pdef(\ze_sibass),
				Pdef(\ze_stringsx),
				Pdef(\ze_basicbass),
				Pdef(\ze_snare_electro),
				Pdef(\ze_hihat_electro),
				Pdef(\ze_snaretuned2),
				Pdef(\ze_organ_tonewheel1),
				Pdef(\ze_hech),
				Pdef(\ze_fzion3),
				Pdef(\ze_fzion4),
				Pdef(\ze_fzion2),
				Pdef(\ze_fzion),
				Pdef(\ze_clap_bat),
				Pdef(\ze_hat_bat_pre),
				Pdef(\ze_clave_bat),
				Pdef(\ze_feynman_scratch),
				Pdef(\ze_dronebleu),
				Pdef(\ze_dronebleuhi),
				Pdef(\ze_iron),
				Pdef(\ze_cracklemono),
				Pdef(\ze_crackledec),
				Pdef(\ze_bassgrise),
				Pdef(\ze_dubdrone4x),
				Pdef(\ze_dubdrone4),
				Pdef(\ze_rim1),
				Pdef(\ze_rim5),
				Pdef(\ze_rim6),
				Pdef(\ze_rim8),
				Pdef(\ze_chovar),
				Pdef(\ze_hat_ksh2b),
				Pdef(\ze_ridecast_speed),
				Pdef(\ze_phyhat4),
				Pdef(\ze_organ),
				Pdef(\ze_wavechord),
				Pdef(\ze_rim1_speed),
				Pdef(\ze_grancru),
				Pdef(\ze_smp_crush),
				Pdef(\ze_smp_crush2),
				Pdef(\ze_simpleacid),
				Pdef(\ze_stepchord1),
				Pdef(\ze_stepchord2),
				Pdef(\ze_ridecast),
				Pdef(\ze_chordlock2),
				Pdef(\ze_chordlock3),
				Pdef(\ze_basslok),
			Pdef(\ze_tassbass),
			Pdef(\ze_chordo),
			Pdef(\ze_perctone),
			Pdef(\ze_aigu),
			Pdef(\ze_conga),
			Pdef(\ze_longf),
			Pdef(\ze_dubdrone),
			Pdef(\ze_dubdrone3),
			Pdef(\ze_chordo2),
			Pdef(\ze_plouc),
			Pdef(\ze_hipass),
			Pdef(\ze_hipasswide),
			Pdef(\ze_chordodo),
			Pdef(\ze_basicpadfm),
			Pdef(\ze_cymbalsimple),
			Pdef(\ze_oneone),
			Pdef(\ze_oneone2),
]
)

//// rand part
(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Prout({ arg ev;
			var tab = ~ze_list;
			100.do  {
				Ppar(
					{ tab.choose }.dup(8).collect({ arg x; Pfindur(8,x) })
				).embedInStream;
			}
		}),
	])
)).play;
);

//// two paralel rand part
(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Prout({ arg ev;
			var tab = ~ze_list;
			100.do  {
				Ppar(
					{ tab.choose }.dup(4).collect({ arg x; Pfindur(16,x) })
				).embedInStream;
			}
		}),
		Prout({ arg ev;
			var tab = ~ze_list;
			Event.silent(8).embedInStream;
			100.do  {
				Ppar(
					{ tab.choose }.dup(4).collect({ arg x; Pfindur(16,x) })
				).embedInStream;
			}
		}),
	])
)).play;
);
