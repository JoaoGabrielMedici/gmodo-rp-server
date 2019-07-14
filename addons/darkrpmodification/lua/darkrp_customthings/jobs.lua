--[[---------------------------------------------------------------------------
DarkRP custom jobs
---------------------------------------------------------------------------
This file contains your custom jobs.
This file should also contain jobs from DarkRP that you edited.

Note: If you want to edit a default DarkRP job, first disable it in darkrp_config/disabled_defaults.lua
      Once you've done that, copy and paste the job to this file and edit it.

The default jobs can be found here:
https://github.com/FPtje/DarkRP/blob/master/gamemode/config/jobrelated.lua

For examples and explanation please visit this wiki page:
http://wiki.darkrp.com/index.php/DarkRP:CustomJobFields

Add your custom jobs under the following line:
---------------------------------------------------------------------------]]



--[[---------------------------------------------------------------------------
Define which team joining players spawn into and what team you change to if demoted
---------------------------------------------------------------------------]]
GAMEMODE.DefaultTeam = TEAM_CITIZEN
--[[---------------------------------------------------------------------------
Define which teams belong to civil protection
Civil protection can set warrants, make people wanted and do some other police related things
---------------------------------------------------------------------------]]
GAMEMODE.CivilProtection = {
    [TEAM_POLICE] = true,
    [TEAM_CHIEF] = true,
    [TEAM_MAYOR] = true,
}
--[[---------------------------------------------------------------------------
Jobs that are hitmen (enables the hitman menu)
---------------------------------------------------------------------------]]
--DarkRP.addHitmanTeam(TEAM_MOB)

TEAM_POLICE = DarkRP.createJob("Guarda", {
    color = Color(0, 255, 255, 0),
    model = {"models/player/police_fem.mdl",
             "models/player/police.mdl"},
    description = [[você é um guarda!, seu trabalho e manter a paz e a organização da cidade. Você pode prender infratores, abordar pessoas. emfim vc pode fazer tudo que um guarda pode
]],
    weapons = {"weapon_uh_melee_baton", "weapon_uh_pist_beretta"},
    command = "gd",
    max = 5,
    salary = 1500,
    admin = 0,
    vote = true,
    hasLicense = true,
    candemote = true,
    category = "Governo"
})

TEAM_POLICE = DarkRP.createJob("Policial", {
    color = Color(0, 88, 255, 255),
    model = {"models/player/combine_super_soldier.mdl"},
    description = [[você é um policial!, seu trabalho e manter a paz e a organização da cidade. Você pode prender infratores, definir Procurações, abordar pessoas. emfim vc pode fazer tudo que um policial pode]],
    weapons = {"weapon_uh_melee_baton", "weapon_uh_pist_glock17", "weapon_uh_smg_mp5"},
    command = "pm",
    max = 5,
    salary = 2000,
    admin = 0,
    vote = true,
    hasLicense = true,
    candemote = true,
    category = "Governo"
})

TEAM_CITIZEN = DarkRP.createJob("Ladrão", {
    color = Color(199, 25, 25, 255),
    model = {
        "models/player/Group01/male_02.mdl",
        "models/player/Group01/male_01.mdl",
        "models/player/Group01/female_02.mdl",
        "models/player/Group01/female_01.mdl"
    },
    description = [[roube pessoas para sobreviver]],
    weapons = {"lockpick"},
    command = "ladrao",
    max = 5,
    salary = 5,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = true,
    category = "Criminosos"
})

TEAM_MAYOR = DarkRP.createJob("Prefeito", {
    color = Color(4, 0, 128, 255),
    model = {"models/player/breen.mdl"},
    description = [[Você manda na porra toda, vc pode fazer quase tudo que os outros podem, ex: Prender, criar procurações e etc..]],
    weapons = {},
    command = "prefeito",
    max = 1,
    salary = 5000,
    admin = 0,
    vote = true,
    hasLicense = true,
    candemote = true,
    category = "Governo"
})

TEAM_MOB = DarkRP.createJob("Assassino De Aluguel ", {
    color = Color(168, 46, 46, 255),
    model = {
        "models/player/Group01/male_02.mdl",
        "models/player/Group01/male_01.mdl",
        "models/player/Group01/female_06.mdl",
        "models/player/Group01/female_05.mdl"
    },
    description = [[mate pessoas por dinheiro]],
    weapons = {"weapon_uh_snip_scout"},
    command = "hit",
    max = 1,
    salary = 200,
    admin = 0,
    vote = true,
    hasLicense = false,
    candemote = true,
    category = "Criminosos"
})

TEAM_GUN = DarkRP.createJob("Vendedor De Armas", {
    color = Color(235, 255, 0, 255),
    model = {"models/player/odessa.mdl"},
    description = [[vende armas pra sobreviver]],
    weapons = {},
    command = "gun",
    max = 3,
    salary = 502,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = true,
    category = "Cidadãos"
})