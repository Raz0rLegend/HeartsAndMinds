btc_custom_loc = [
/*
    DESCRIPTION: [POS(Array),TYPE(String),NAME(String),RADIUS (Number),IS OCCUPIED(Bool)]
    Possible types: "NameVillage","NameCity","NameCityCapital","NameLocal","Hill","Airport","NameMarine", "StrongpointArea", "BorderCrossing", "VegetationFir"
    EXAMPLE: [[13132.8,3315.07,0.00128174],"NameVillage","Mountain 1",800,true]
*/

//Big City

[[8031,1645,0],"NameVillage","Al Buhrjä",500,true],
[[2412,8002,0],"NameCity","Ben Rihkar",700,true],
[[7115,3555,0],"NameVillage","Sidy Bhool",800,true],
[[2539,6420,0],"NameCity","Al MarsHaïl",700,true],
[[8882,2382,0],"NameCity","Babel Hoèd",800,true],
[[2686,5763,0],"NameCity","Al Djoni",700,true],
[[8544,3838,0],"NameVillage","Thunis",800,true],
[[2392,5033,0],"NameCity","Pol Nhareff",650,true],
[[8162,4346,0],"NameVillage","Al BurghKamiy",700,true],
[[1065,5451,0],"NameCity","Khranty",800,true],
[[6337,3138,0],"NameVillage","Fra Hank",650,true],
[[1755,7740,0],"NameCity","Al Djozal",700,true],
[[2265,971,0],"NameCity","Kahi Vhine",650,true],
[[778,6764,0],"NameVillage","Bonh Djour",750,true],
[[1711,3496,0],"NameCityCapital","Jawhad",950,true],
[[1595,5273,0],"NameVillage","Chihanti",700,true],
[[3964,10007,0],"NameCity","Balhadur",550,true],

//Small Cities

[[5065,10074,0],"NameLocal","Roh Farry",550,true],
[[906,6278,0],"NameLocal","Landhary",600,true],
[[3806,8888,0],"NameLocal","Bouhdaly",400,true],
[[1654,9602,0],"NameLocal","Dhouza",550,true],
[[1654,9602,0],"NameLocal","Djamhiz",600,true],
[[1397,9922,0],"NameLocal","Frazhi",450,true],

// Strong Point

[[9024,3805,0],"StrongpointArea","Checkpoint Boulhra",300,true],
[[7905,9261,0],"StrongpointArea","Checkpoint Khandry",400,true],
[[8710,2567,0],"StrongpointArea","Checkpoint Kourha",300,true],
[[4681,2604,0],"StrongpointArea","Checkpoint Bouldy",250,true],
[[7108,9157,0],"StrongpointArea","Checkpoint Strady ",300,true],
[[4187,1120,0],"StrongpointArea","Checkpoint Larhby",250,true],
[[3230,9852,0],"StrongpointArea","Checkpoint Stramby",250,true],
[[3921,9482,0],"StrongpointArea","Checkpoint Probhï",250,true],
[[5474,6310,0],"StrongpointArea","Checkpoint Trah",250,true],
[[9174,6140,0],"StrongpointArea","Checkpoint Rhola",250,true],
[[3570,2021,0],"NameCityCapital","Checkpoint Bardha",700,true],

//Hill

[[4840,2163,0],"Hill","Hill Fhouldary",500,true],
[[5829,9021,0],"Hill","Hill Plohary", 500,true],

//FOB
[[4758,1820,0],"NameCityCapital","FOB Kharym",700,true],
[[3570,2021,0],"NameCityCapital","Checkpoint Bardha",700,true],
[[8279,8816,0],"NameCityCapital","FOB Muhzet",700,true]
];

/*
    Here you can tweak spectator view during respawn screen.
*/
BIS_respSpecAi = false;                  // Allow spectating of AI
BIS_respSpecAllowFreeCamera = false;     // Allow moving the camera independent from units (players)
BIS_respSpecAllow3PPCamera = false;      // Allow 3rd person camera
BIS_respSpecShowFocus = false;           // Show info about the selected unit (dissapears behind the respawn UI)
BIS_respSpecShowCameraButtons = true;    // Show buttons for switching between free camera, 1st and 3rd person view (partially overlayed by respawn UI)
BIS_respSpecShowControlsHelper = true;   // Show the controls tutorial box
BIS_respSpecShowHeader = true;           // Top bar of the spectator UI including mission time
BIS_respSpecLists = true;                // Show list of available units and locations on the left hand side

/*
    Here you can specify which equipment should be added or removed from the arsenal.
    Please take care that there are different categories (weapons, magazines, items, backpacks) for different pieces of equipment into which you have to classify the classnames.
    In all cases, you need the classname of an object.

    Attention: The function of these lists depends on the setting in the mission parameter (Restrict arsenal).
        - "Full": here you have only the registered items in the arsenal available.
        - "Remove only": here all registered items are removed from the arsenal. This only works for the ACE3 arsenal!

    Example(s):
        private _weapons = [
            "arifle_MX_F",          //Classname for the rifle MX
            "arifle_MX_SW_F",       //Classname for the rifle MX LSW
            "arifle_MXC_F"          //Classname for the rifle MXC
        ];

        private _items = [
            "G_Shades_Black",
            "G_Shades_Blue",
            "G_Shades_Green"
        ];
*/
private _weapons = [];
private _magazines = [];
private _items = [];
private _backpacks = [];

btc_custom_arsenal = [_weapons, _magazines, _items, _backpacks];

/*
    Here you can specify which equipment is loaded on player connection.
*/

private _radio = ["tf_anprc152", "ACRE_PRC148"] select (isClass(configFile >> "cfgPatches" >> "acre_main"));
//Array of colored item: 0 - Desert, 1 - Tropic, 2 - Black, 3 - forest
private _uniforms = ["U_B_CombatUniform_mcam", "U_B_CTRG_Soldier_F", "U_B_CTRG_1", "U_B_CombatUniform_mcam_wdl_f"];
private _uniformsCBRN = ["U_B_CBRN_Suit_01_MTP_F", "U_B_CBRN_Suit_01_Tropic_F", "U_C_CBRN_Suit_01_Blue_F", "U_B_CBRN_Suit_01_Wdl_F"];
private _uniformsSniper = ["U_B_FullGhillie_sard", "U_B_FullGhillie_lsh", "U_B_T_FullGhillie_tna_F", "U_B_T_FullGhillie_tna_F"];
private _vests = ["V_PlateCarrierH_CTRG", "V_PlateCarrier2_rgr_noflag_F", "V_PlateCarrierH_CTRG", "V_PlateCarrier2_wdl"];
private _helmets = ["H_HelmetSpecB_paint2", "H_HelmetB_Enh_tna_F", "H_HelmetSpecB_blk", "H_HelmetSpecB_wdl"];
private _hoods = ["G_Balaclava_combat", "G_Balaclava_TI_G_tna_F", "G_Balaclava_combat", "G_Balaclava_combat"];
private _hoodCBRN = "G_AirPurifyingRespirator_01_F";
private _laserdesignators = ["Laserdesignator", "Laserdesignator_03", "Laserdesignator_01_khk_F", "Laserdesignator_01_khk_F"];
private _night_visions = ["NVGoggles", "NVGoggles_INDEP", "NVGoggles_OPFOR", "NVGoggles_INDEP"];
private _weapons = ["arifle_MXC_F", "arifle_MXC_khk_F", "arifle_MXC_Black_F", "arifle_MXC_Black_F"];
private _weapons_machineGunner = ["arifle_MX_SW_F", "arifle_MX_SW_khk_F", "arifle_MX_SW_Black_F", "arifle_MX_SW_Black_F"];
private _weapons_sniper = ["arifle_MXM_F", "arifle_MXM_khk_F", "arifle_MXM_Black_F", "arifle_MXM_Black_F"];
private _bipods = ["bipod_01_F_snd", "bipod_01_F_khk", "bipod_01_F_blk", "bipod_01_F_blk"];
private _pistols = ["hgun_P07_F", "hgun_P07_khk_F", "hgun_P07_F", "hgun_P07_khk_F"];
private _launcher_AT = ["launch_B_Titan_short_F", "launch_B_Titan_short_tna_F", "launch_O_Titan_short_F", "launch_B_Titan_short_tna_F"];
private _launcher_AA = ["launch_B_Titan_F", "launch_B_Titan_tna_F", "launch_O_Titan_F", "launch_B_Titan_tna_F"];
private _backpacks = ["B_AssaultPack_Kerry", "B_AssaultPack_eaf_F", "B_AssaultPack_blk", "B_AssaultPack_wdl_F"];
private _backpacks_big = ["B_Kitbag_mcamo", "B_Kitbag_rgr", "B_Kitbag_rgr", "B_Kitbag_rgr"];
private _backpackCBRN = "B_CombinationUnitRespirator_01_F";

btc_arsenal_loadout = [_uniforms, _uniformsCBRN, _uniformsSniper, _vests, _helmets, _hoods, [_hoodCBRN, _hoodCBRN, _hoodCBRN, _hoodCBRN], _laserdesignators, _night_visions, _weapons, _weapons_sniper, _weapons_machineGunner, _bipods, _pistols, _launcher_AT, _launcher_AA, _backpacks, _backpacks_big, [_backpackCBRN, _backpackCBRN, _backpackCBRN, _backpackCBRN], [_radio, _radio, _radio, _radio]];
