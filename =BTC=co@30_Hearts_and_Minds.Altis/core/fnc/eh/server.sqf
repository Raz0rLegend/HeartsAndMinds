
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

["Land_Cargo20_IDAP_F","InitPost",{
	params ["_obj"];
	[_obj,20] call ace_cargo_fnc_setSize;
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
        [_obj, 6] call ace_cargo_fnc_setSpace;
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
			"BWA3_Puma_Tropen",
			"BWA3_Leopard2_Tropen"];
			
["Redd_Tank_Fuchs_1A4_San_Tropentarn","InitPost",{
	params ["_obj"];
	[_obj,12] call ace_cargo_fnc_setSpace;
}, true, [], true] call CBA_fnc_addClassEventHandler;

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

SOF_Magazines = []; 
private _CfgMagazines = configFile >> "CfgMagazines"; 
{
    private _magsFilter = format ["(configName _x find '%1' == 0) && (getNumber (_x >> 'scope') == 2)", _x];
    private _magsList = _magsFilter configClasses _CfgMagazines apply { configName _x };
    SOF_Magazines append _magsList;
} forEach [ 
    "BWA3_" ,
	"rhsusf" ,
	"ACE",
	"rhs_mag_"
];

{ 
    [_x, "InitPost", { 
		params ["_obj"];
        [_obj, SOF_Magazines, true, true] call ace_arsenal_fnc_initbox; 
    }, true, [], true] call CBA_fnc_addClassEventHandler; 
} forEach [
            "rhsusf_M977A4_AMMO_BKIT_usarmy_d",
            "rhsusf_M977A4_AMMO_BKIT_M2_usarmy_d",
            "rhsusf_M977A4_AMMO_usarmy_d",
            "rnt_lkw_7t_mil_gl_kat_i_mun_trope"];
