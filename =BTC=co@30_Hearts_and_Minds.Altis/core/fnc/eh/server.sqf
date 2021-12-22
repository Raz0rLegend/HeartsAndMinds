
/* ----------------------------------------------------------------------------
Function: btc_eh_fnc_server

Description:
    Add event handler to server.

Parameters:

Returns:

Examples:
    (begin example)
        [] call btc_eh_fnc_server;
    (end)

Author:
    Vdauphin

---------------------------------------------------------------------------- */

addMissionEventHandler ["BuildingChanged", btc_rep_fnc_buildingchanged];
["ace_explosives_defuse", btc_rep_fnc_explosives_defuse] call CBA_fnc_addEventHandler;
["ace_killed", btc_rep_fnc_killed] call CBA_fnc_addEventHandler;
["Animal", "InitPost", {
    [_this select 0, "HandleDamage", btc_rep_fnc_hd] call CBA_fnc_addBISEventHandler;
}] call CBA_fnc_addClassEventHandler;
["Animal", "killed", {
    params ["_unit", "_killer", "_instigator"];
    [_unit, "", _killer, _instigator] call btc_rep_fnc_killed;
}] call CBA_fnc_addClassEventHandler;
{
    [_x, "InitPost", {
        [_this select 0, "Suppressed", btc_rep_fnc_suppressed] call CBA_fnc_addBISEventHandler;
        [_this select 0, "HandleDamage", btc_rep_fnc_hd] call CBA_fnc_addBISEventHandler;
    }, false] call CBA_fnc_addClassEventHandler;
} forEach btc_civ_type_units;
{
    [_x, "InitPost", {
        [_this select 0, "HandleDamage", btc_rep_fnc_hd] call CBA_fnc_addBISEventHandler;
    }, false] call CBA_fnc_addClassEventHandler;
} forEach btc_civ_type_veh;
["ace_killed", btc_mil_fnc_unit_killed] call CBA_fnc_addEventHandler;
["ace_repair_setWheelHitPointDamage", {
    _this remoteExecCall ["btc_rep_fnc_wheelChange", 2];
}] call CBA_fnc_addEventHandler;
["ace_disarming_dropItems", btc_rep_fnc_foodRemoved] call CBA_fnc_addEventHandler;
["btc_respawn_player", {
    params ["", "_player"];
    [btc_rep_malus_player_respawn, _player] call btc_rep_fnc_change;
}] call CBA_fnc_addEventHandler;

["ace_explosives_detonate", {
    params ["_player", "_explosive", "_delay"];
    [
        btc_door_fnc_broke,
        ([3, _explosive, 0.5] call btc_door_fnc_get) + [_player, 1, 2],
        _delay
    ] call CBA_fnc_waitAndExecute;
}] call CBA_fnc_addEventHandler;

addMissionEventHandler ["HandleDisconnect", {
    params ["_headless"];
    if (_headless in (entities "HeadlessClient_F")) then {
        deleteVehicle _headless;
    };
}];
if (btc_p_auto_db) then {
    addMissionEventHandler ["HandleDisconnect", {
        if ((allPlayers - entities "HeadlessClient_F") isEqualTo []) then {
            [] call btc_db_fnc_save;
        };
    }];
};
if (btc_p_chem) then {
    ["ace_cargoLoaded", btc_chem_fnc_propagate] call CBA_fnc_addEventHandler;
    ["AllVehicles", "GetIn", {[_this select 0, _this select 2] call btc_chem_fnc_propagate}] call CBA_fnc_addClassEventHandler;
    ["DeconShower_01_F", "init", {
        btc_chem_decontaminate pushBack (_this select 0);
        (_this select 0) setVariable ['bin_deconshower_disableAction', true];
    }, true, [], true] call CBA_fnc_addClassEventHandler;
    ["DeconShower_02_F", "init", {
        btc_chem_decontaminate pushBack (_this select 0);
        (_this select 0) setVariable ['bin_deconshower_disableAction', true];
    }, true, [], true] call CBA_fnc_addClassEventHandler;
};

["GroundWeaponHolder", "InitPost", {btc_groundWeaponHolder append _this}] call CBA_fnc_addClassEventHandler;
["acex_fortify_objectPlaced", {[_this select 2] call btc_log_fnc_init}] call CBA_fnc_addEventHandler;
if (btc_p_set_skill) then {
    ["CAManBase", "InitPost", btc_mil_fnc_set_skill] call CBA_fnc_addClassEventHandler;
};
["btc_delay_vehicleInit", btc_patrol_fnc_addEH] call CBA_fnc_addEventHandler;
["ace_killed", {
    params ["_unit"];
    if (side group _unit isNotEqualTo civilian) exitWith {};
    private _vehicle = assignedVehicle _unit;
    if (_vehicle isNotEqualTo objNull) then {
        [[], [_vehicle]] call btc_fnc_delete;
    };
}] call CBA_fnc_addEventHandler;
{
    [_x, "InitPost", {
        [_this select 0, "HandleDamage", btc_patrol_fnc_disabled] call CBA_fnc_addBISEventHandler;
    }, false] call CBA_fnc_addClassEventHandler;
} forEach btc_civ_type_veh;
["ace_tagCreated", btc_tag_fnc_eh] call CBA_fnc_addEventHandler; 

if (btc_p_respawn_ticketsAtStart >= 0) then {
    ["btc_respawn_player", btc_respawn_fnc_player] call CBA_fnc_addEventHandler;
    ["ace_placedInBodyBag", btc_body_fnc_setBodyBag] call CBA_fnc_addEventHandler;

    if !(btc_p_respawn_ticketsShare) then {
        addMissionEventHandler ["PlayerConnected", btc_respawn_fnc_playerConnected];
    };
};

//Cargo
[btc_fob_mat, "InitPost", {
    params ["_obj"];
    [_obj, -1] call ace_cargo_fnc_setSpace;
}, true, [], true] call CBA_fnc_addClassEventHandler;

["Land_Cargo20_military_green_F","InitPost",{
	params ["_obj"];
	[_obj,40] call ace_cargo_fnc_setSpace;
}, true, [], true] call CBA_fnc_addClassEventHandler;

["Land_Cargo20_military_green_F","InitPost",{
	params ["_obj"];
	[_obj,10] call ace_cargo_fnc_setSize;
}, true, [], true] call CBA_fnc_addClassEventHandler;

["Land_Cargo40_military_green_F","InitPost",{
	params ["_obj"];
	[_obj,80] call ace_cargo_fnc_setSpace;
}, true, [], true] call CBA_fnc_addClassEventHandler;

["Land_Cargo40_military_green_F","InitPost",{
	params ["_obj"];
	[_obj,25] call ace_cargo_fnc_setSize;
}, true, [], true] call CBA_fnc_addClassEventHandler;

//BW
{
    [_x, "InitPost", {
        params ["_obj"];
        [_obj, 5] call ace_cargo_fnc_setSpace;
    }, true, [], true] call CBA_fnc_addClassEventHandler;
} forEach [  
			"BWA3_Eagle_FLW100_Tropen",
			"BWA3_Dingo2_FLW100_MG3_CG13_Tropen",
			"BWA3_Dingo2_FLW200_M2_CG13_Tropen",
			"BWA3_Dingo2_FLW200_GMW_CG13_Tropen",
			"Redd_Tank_Gepard_1A2_Tropentarn",
			"KGB_B_MRAP_03_hmg_F_DES",
			"Redd_Tank_Wiesel_1A2_TOW_Tropentarn",
			"Redd_Tank_Wiesel_1A4_MK20_Tropentarn",
			"rnt_sppz_2a2_luchs_tropentarn",
			"Redd_Tank_Fuchs_1A4_Pi_Tropentarn",
			"Redd_Tank_Fuchs_1A4_San_Tropentarn",
			"BWA3_Puma_Tropen",
			"BWA3_Leopard2_Tropen"];

//US
{
	[_x, "InitPost", {
        params ["_obj"];
        [_obj, 5] call ace_cargo_fnc_setSpace;
    }, true, [], true] call CBA_fnc_addClassEventHandler;
} forEach [  
			"rhsusf_mrzr4_d",
			"rhsusf_m966_d",
			"rhsusf_m1151_mk19_v2_usarmy_d",
			"rhsusf_m1151_m2_v2_usarmy_d",
			"rhsusf_m1151_m240_v2_usarmy_d",
			"rhsusf_m1165a1_gmv_m2_m240_socom_d",
			"RHS_M2A3_BUSKI",
			"rhsusf_stryker_m1132_m2_d"];
{
    [_x, "InitPost", {
        params ["_obj"];
        [_obj, 30] call ace_cargo_fnc_setSpace;
    }, true, [], true] call CBA_fnc_addClassEventHandler;
} forEach [
			"Truck_01_base_F",
			"rhsusf_M977A4_BKIT_usarmy_d",
			"rhsusf_M977A4_usarmy_d",
			"rnt_lkw_7t_mil_gl_kat_i_transport_trope",
			"rhsusf_M1084A1P2_B_D_fmtv_usarmy"];

{
    [_x, "InitPost", {
        params ["_obj"];
        [_obj, 20] call ace_cargo_fnc_setSpace;
    }, true, [], true] call CBA_fnc_addClassEventHandler;
} forEach ["rnt_lkw_5t_mil_gl_kat_i_transport_trope"];

//Ammo Truck

{
    [_x, "InitPost", {
        params ["_obj"];
        [_obj, [
		"BWA3_30Rnd_556x45_G36_Tracer_Dim",
		"BWA3_30Rnd_556x45_G36_SD",
		"BWA3_30Rnd_556x45_G36",
		"BWA3_30Rnd_556x45_G36_Tracer",
		"BWA3_30Rnd_556x45_G36_AP",
		"BWA3_120Rnd_762x51_Tracer",
		"BWA3_120Rnd_762x51",
		"BWA3_120Rnd_762x51_Tracer_soft",
		"BWA3_120Rnd_762x51_soft",
		"BWA3_10Rnd_127x99_G82",
		"BWA3_10Rnd_127x99_G82_AP_Tracer",
		"BWA3_10Rnd_127x99_G82_AP",
		"BWA3_10Rnd_127x99_G82_Tracer_Dim",
		"BWA3_10Rnd_127x99_G82_SD",
		"BWA3_10Rnd_127x99_G82_Tracer",
		"BWA3_10Rnd_127x99_G82_Raufoss_Tracer_Dim",
		"BWA3_10Rnd_127x99_G82_Raufoss_Tracer",
		"BWA3_10Rnd_127x99_G82_Raufoss",
		"BWA3_20Rnd_762x51_G28",
		"BWA3_20Rnd_762x51_G28_AP",
		"BWA3_20Rnd_762x51_G28_Tracer_Dim",
		"BWA3_20Rnd_762x51_G28_SD",
		"BWA3_20Rnd_762x51_G28_Tracer",
		"BWA3_20Rnd_762x51_G28_LR",
		"BWA3_10Rnd_86x70_G29",
		"BWA3_10Rnd_86x70_G29_Tracer",
		"BWA3_200Rnd_556x45",
		"BWA3_200Rnd_556x45_Tracer",
		"BWA3_CarlGustav_HE",
		"BWA3_CarlGustav_HEAT",
		"BWA3_CarlGustav_HEDP",
		"BWA3_CarlGustav_Illum",
		"BWA3_CarlGustav_Smoke",
		"BWA3_PzF3_DM32",
		"BWA3_1Rnd_120mm_Mo_Flare_white",
		"BWA3_1Rnd_120mm_Mo_annz_shells",
		"BWA3_1Rnd_120mm_Mo_Smoke_white",
		"BWA3_1Rnd_120mm_Mo_shells",
		"BWA3_1Rnd_120mm_Mo_dpz_shells",
		"BWA3_Fliegerfaust_Mag",
		"BWA3_40Rnd_46x30_MP7",
		"BWA3_12Rnd_45ACP_P12",
		"BWA3_1Rnd_Flare_Multistar_Green",
		"BWA3_1Rnd_Flare_Multistar_Red",
		"BWA3_1Rnd_Flare_Multistar_White",
		"BWA3_1Rnd_Flare_Singlestar_Green",
		"BWA3_1Rnd_Flare_Illum",
		"BWA3_1Rnd_Flare_Singlestar_Red",
		"BWA3_1Rnd_Flare_Singlestar_White",
		"BWA3_15Rnd_9x19_P8115",
		"BWA3_PzF3_Tandem",
		"BWA3_RGW90_HH",
		"BWA3_DM25",
		"BWA3_DM32_Blue",
		"BWA3_DM32_Green",
		"BWA3_DM32_Orange",
		"BWA3_DM32_Purple",
		"BWA3_DM32_Red",
		"BWA3_DM32_Yellow",
		"BWA3_DM51A1",
		"30Rnd_556x45_Stanag_Tracer_Red",
		"rhsusf_200Rnd_556x45_M855_mixed_soft_pouch_ucp",
		"rhsusf_200rnd_556x45_mixed_box"]] call ace_arsenal_fnc_initBox;
    }, true, [], true] call CBA_fnc_addClassEventHandler;
} forEach [
			"rhsusf_M977A4_AMMO_BKIT_usarmy_d",
			"rhsusf_M977A4_AMMO_BKIT_M2_usarmy_d",
			"rhsusf_M977A4_AMMO_usarmy_d",
			"rnt_lkw_7t_mil_gl_kat_i_mun_trope"];




