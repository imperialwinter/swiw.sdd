	-- [number] = "featureName",
	-- number: any unique number. Doesnt need to be in order or anything
	-- featureName: the name of the feature
	--  if the feature name is invalid, strange things happen, be warned

local features = {
		--[[
			Aircraft have no corpses, they need not be in this list.
			Factories can not be rotated via script due to yardmaps, but could have different death anims.
			Same with the commanders.
			Turrets and production facilties may be freely rotated.
			Flags do not leave corpses, they need not be in this list.
			Vehicles and infantry can have death animations.

			Each unit has five reserved slots to allow for death animations. Infantry have 10 reserved slots
			to allow for more variation.
		]]--

	[0] = "imp_b_airplant_dead",
	[5] = "imp_b_airplantadv_dead",
	[10] = "imp_b_barracks_dead",
	[15] = "imp_b_droidplant_dead",
	[20] = "imp_b_vehicleplant_dead",
	[25] = "imp_b_walkerplant_dead",
	[30] = "reb_b_airplant_dead",
	[35] = "reb_b_airplantadv_dead",
	[40] = "reb_b_barracks_dead",
	[45] = "reb_b_barracksadv_dead",
	[50] = "reb_b_heavyweaponslab_dead",
	[55] = "reb_b_repulsorliftplant_dead",

	[60] = "imp_c_condroid_dead",
	[65] = "imp_c_conwalker_dead",
	[70] = "reb_c_condroid_dead",
	[75] = "reb_c_conhover_dead",

	[80] = "imp_d_antiair_dead",
	[85] = "imp_d_antiairadv_dead",
	[90] = "imp_d_artillery_dead",
	[95] = "imp_d_ioncannon_dead",
	[100] = "imp_d_turbolaser_dead",
	[105] = "reb_d_antiair_dead",
	[110] = "reb_d_antiairadv_dead",
	[115] = "reb_d_artillery_dead",
	[120] = "reb_d_atgar_dead",
	[125] = "reb_d_golan_dead",
	[130] = "reb_d_sandbags",

	[135] = "imp_p_estore_dead",
	[140] = "imp_p_fusion_dead",
	[145] = "imp_p_fusionadv_dead",
	[160] = "imp_p_solar_dead",
	[165] = "imp_p_tibanna_dead",
	[170] = "reb_p_estore_dead",
	[185] = "reb_p_fusion_dead_seq1",
	[186] = "reb_p_fusion_dead_seq2",
	[190] = "reb_p_fusionadv_dead",
	[205] = "reb_p_varenergy_dead",
	[210] = "reb_p_tibanna_dead",

	[215] = "imp_sc_atrt_dead",
	[220] = "imp_sc_probedroid_dead",

	[225] = "imp_sp_sensor_dead",
	[230] = "imp_sp_sensoradv_dead",
	[235] = "reb_sp_sensor_dead",
	[240] = "reb_sp_sensoradv_dead",
	[245] = "reb_sp_spotter_dead",

	[250] = "imp_v_ataa_dead",
	[255] = "imp_v_atar_dead",
	[260] = "imp_v_atmd_dead",
	[265] = "imp_v_atpt_dead",
	[270] = "imp_v_atst_dead",
	[275] = "imp_v_atstas_dead",
	[280] = "imp_v_cav_dead",
	[285] = "imp_v_groundtransport_dead",
	[290] = "imp_v_hailfire_dead",
	[295] = "imp_v_mobileartillery_dead",
	[300] = "imp_v_tiecrawler_dead",
	[305] = "imp_v_tx130_dead",
	[310] = "reb_v_atpt_dead",
	[315] = "reb_v_espo_dead",
	[320] = "reb_v_freerunner_dead",
	[325] = "reb_v_groundtransport_dead",
	[330] = "reb_v_heavytracker_dead",
	[335] = "reb_v_landspeeder_dead",
	[340] = "reb_v_mptl_dead",
	[345] = "reb_v_scannerjammer_dead",
	[350] = "reb_v_stormcannon_dead",
	[355] = "reb_v_t1b_dead",
	[360] = "reb_v_t2b_dead",
	[365] = "reb_v_t4c_dead",
	[370] = "reb_v_ulav_dead",


	[375] = "imp_i_battledroid_dead",
	[385] = "imp_i_crabdroid_dead",
	[395] = "imp_i_droideka_dead",
	[405] = "imp_i_eweb_dead",
	[415] = "imp_i_flametrooper_dead_seq1",
	[416] = "imp_i_flametrooper_dead_seq2",
	[417] = "imp_i_flametrooper_dead_seq3",
	[418] = "imp_i_flametrooper_dead_seq4",
	[425] = "imp_i_reptrooper_dead_seq1",
	[426] = "imp_i_reptrooper_dead_seq2",
	[427] = "imp_i_reptrooper_dead_seq3",
	[428] = "imp_i_reptrooper_dead_seq4",
	[435] = "imp_i_rockettrooper_dead",
	[445] = "imp_i_royalguard_dead_seq1",
	[446] = "imp_i_royalguard_dead_seq2",
	[447] = "imp_i_royalguard_dead_seq3",
	[448] = "imp_i_royalguard_dead_seq4",
	[455] = "imp_i_scouttrooper_dead_seq1",
	[456] = "imp_i_scouttrooper_dead_seq2",
	[457] = "imp_i_scouttrooper_dead_seq3",
	[458] = "imp_i_scouttrooper_dead_seq4",
	[465] = "imp_i_stormtrooper_dead_seq1",
	[466] = "imp_i_stormtrooper_dead_seq2",
	[467] = "imp_i_stormtrooper_dead_seq3",
	[468] = "imp_i_stormtrooper_dead_seq4",
	[469] = "imp_i_stormtrooper_dead_seq5",
	[475] = "imp_i_superbattledroid_dead",
	[485] = "reb_i_avrocket_dead",
	[495] = "reb_i_bothan_dead",
	[505] = "reb_i_mrb_dead",
	[535] = "reb_i_rockettrooper_dead",

	[535] = "reb_i_rockettrooper_dead_seq1_head1",
	[536] = "reb_i_rockettrooper_dead_seq2_head1",

	[545] = "reb_i_rockettrooper_dead_seq1_head2",
	[546] = "reb_i_rockettrooper_dead_seq1_head3",
	[547] = "reb_i_rockettrooper_dead_seq2_head2",
	[548] = "reb_i_rockettrooper_dead_seq2_head3",


	[565] = "reb_i_sniper_dead_seq1",
	[566] = "reb_i_sniper_dead_seq2",
	[567] = "reb_i_sniper_dead_seq3",
	[568] = "reb_i_sniper_dead_seq4",


	[575] = "reb_i_trooper_dead_seq1_head1",
	[576] = "reb_i_trooper_dead_seq2_head1",
	[577] = "reb_i_trooper_dead_seq3_head1",
	[578] = "reb_i_trooper_dead_seq4_head1",
	[579] = "reb_i_trooper_dead_seq5_head1",
	[580] = "reb_i_trooper_dead_seq6_head1",
	[581] = "reb_i_trooper_dead_seq7_head1",
	[582] = "reb_i_trooper_dead_seq8_head1",
	[583] = "reb_i_trooper_dead_seq9_head1",
	[584] = "reb_i_trooper_dead_seq10_head1",

	[585] = "reb_i_trooper_dead_seq1_head2",
	[586] = "reb_i_trooper_dead_seq1_head3",
	[587] = "reb_i_trooper_dead_seq2_head2",
	[588] = "reb_i_trooper_dead_seq2_head3",
	[589] = "reb_i_trooper_dead_seq3_head2",
	[590] = "reb_i_trooper_dead_seq3_head3",
	[591] = "reb_i_trooper_dead_seq4_head2",
	[592] = "reb_i_trooper_dead_seq4_head3",
	[593] = "reb_i_trooper_dead_seq5_head2",
	[594] = "reb_i_trooper_dead_seq5_head3",
	[595] = "reb_i_trooper_dead_seq6_head2",
	[596] = "reb_i_trooper_dead_seq6_head3",
	[597] = "reb_i_trooper_dead_seq7_head2",
	[598] = "reb_i_trooper_dead_seq7_head3",
	[599] = "reb_i_trooper_dead_seq8_head2",
	[600] = "reb_i_trooper_dead_seq8_head3",
	[601] = "reb_i_trooper_dead_seq9_head2",
	[602] = "reb_i_trooper_dead_seq9_head3",
	[603] = "reb_i_trooper_dead_seq10_head2",
	[604] = "reb_i_trooper_dead_seq10_head3",


	[605] = "reb_i_veterantrooper_dead_seq1_head1",
	[606] = "reb_i_veterantrooper_dead_seq2_head1",
	[607] = "reb_i_veterantrooper_dead_seq3_head1",
	[608] = "reb_i_veterantrooper_dead_seq4_head1",

	[615] = "reb_i_veterantrooper_dead_seq1_head2",
	[616] = "reb_i_veterantrooper_dead_seq1_head3",
	[617] = "reb_i_veterantrooper_dead_seq2_head2",
	[618] = "reb_i_veterantrooper_dead_seq2_head3",
	[619] = "reb_i_veterantrooper_dead_seq3_head2",
	[620] = "reb_i_veterantrooper_dead_seq3_head3",
	[621] = "reb_i_veterantrooper_dead_seq4_head2",
	[622] = "reb_i_veterantrooper_dead_seq4_head3",


	[635] = "reb_i_wookiee_dead_seq1",
	[636] = "reb_i_wookiee_dead_seq2",
	[637] = "reb_i_wookiee_dead_seq3",
	[638] = "reb_i_wookiee_dead_seq4",

	[645] = "reb_commander_dead",
	[650] = "imp_commander_dead",
	
}

return features