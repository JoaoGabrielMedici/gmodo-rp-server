ENPC = {}

ENPC.Colors = {
	bg = Color(34, 37, 41),
	s_bg = Color(45, 49, 54),
	header = Color(57, 62, 68),

	f_list = Color(200,200,200),

	icons = Color(90,90,90),
	icons_a = Color(150,150,150),

	unavailable = Color(100,100,100)
}

ENPC.EnableBlur = true -- Enable blur theme
ENPC.Lang = "en" -- Now supported en, fr, ru, es, de, no

ENPC.DisableChangeTeam = true -- Disables change team via F4(ENPC.DisableChangeUsed need to be disabled)
ENPC.DisableChangeUsed = false -- Disables change only for job used in NPC(ENPC.DisableChangeTeam need to be disabled)

ENPC.Ranks = {  -- they ignore Utime and level rules
	-- ["superadmin"] = true,
	["vip"] = true, 
}

ENPC.CanBypass = { -- change to false, to disable it
	["utime"] = true,
	["level"] = true,
	["customcheck"] = true,
	["countlimit"] = true,
	["jobcost"] = false, -- disables job required rights too
}

/*---------------------------------------------------------------------------
 Languages
---------------------------------------------------------------------------*/

ENPC.Langs = {}

ENPC.Langs["en"] = {
	["Unavailable"] 							= "Unavailable",
	["Limit reached"] 						= "Limit reached",
	["Time"] 											= "Time",
	["Lvl"] 											= "Lvl",
	["Add Job"]										= "Add Job",
	["Select Job"] 								= "Select Job",
	["Jobs"] 											= "Jobs",
	["OK"] 												= "OK",
	["Cancel"] 										= "Cancel",
	["Settings"] 									= "Settings",
	["Name of NPC"] 							= "Name of NPC",
	["Model path"]								= "Model path",
	["Jobs List"]									= "Jobs List",
	["Job Name"]									= "Job Name",
	["Remove Job"]								= "Remove Job",
	["Save"]											= "Save",
	["Required"]									= "Required",
	["Select"]										= "Select",
	["Job Cost"]									= "Job Cost",
	["You can't afford this job"] = "You can't afford this job",
	["You unlocked"] 							= "You unlocked",
	["Need to buy"]								= "Need to buy",
	["Available"]									= "Available",
	["Selected"]									=	"Selected",
}

ENPC.Langs["fr"] = {
	["Unavailable"] 							= "Indisponible",
	["Limit reached"]							= "Limite atteinte",
	["Time"] 											= "Temps",
	["Lvl"] 											= "Lvl",
	["Add Job"]										= "Ajouter",
	["Select Job"] 								= "Sélectionner",
	["Jobs"] 											= "Emplois",
	["OK"] 												= "OK",
	["Cancel"] 										= "Annuler",
	["Settings"] 									= "Paramètres",
	["Name of NPC"] 							= "Nom du NPC",
	["Model path"]								= "Chemin du modèle",
	["Jobs List"]									= "Liste des emplois",
	["Job Name"]									= "Nom du travail",
	["Remove Job"]								= "Retirer",
	["Save"]											= "sauvegarder",
	["Required"]									= "Champs obligatoires",
	["Select"]										= "Sélectionner",
	["Job Cost"]									= "Coût de l'emploi",
	["You can't afford this job"] = "Vous ne pouvez pas vous permettre ce travail",
	["You unlocked"] 							= "Vous avez déverrouillé",
	["Need to buy"]								= "Besoin d'acheter",
	["Available"]									= "Disponible",
	["Selected"]									=	"Choisi",
}

ENPC.Langs["ru"] = {
	["Unavailable"] 							= "Недоступно",
	["Limit reached"] 						= "Достигнут лимит",
	["Time"] 											= "Время",
	["Lvl"] 											= "Ур.",
	["Add Job"]										= "Добавить",
	["Select Job"] 								= "Выбрать",
	["Jobs"] 											= "Профессии",
	["OK"] 												= "OK",
	["Cancel"] 										= "Отмена",
	["Settings"] 									= "Настройки",
	["Name of NPC"] 							= "Название",
	["Model path"]								= "Модель",
	["Jobs List"]									= "Список работ",
	["Job Name"]									= "Название работ",
	["Remove Job"]								= "Удалить",
	["Save"]											= "Сохранить",
	["Required"]									= "Требуется",
	["Select"]										= "Выбрать",
	["Job Cost"]									= "Цена",
	["You can't afford this job"] = "У вас не хватает денег",
	["You unlocked"] 							= "Вы открыли",
	["Need to buy"]								= "Нужно купить",
	["Available"]									= "Доступные",
	["Selected"]									=	"Выбранные",
}

ENPC.Langs["es"] = {
	["Unavailable"]								= "No Disponible",
	["Limit reached"]							= "Limite Alcanzado",
	["Time"]											= "Tiempo",
	["Lvl"]												= "Lvl",
	["Add Job"]										= "Agregar Job",
	["Select Job"]								= "Seleccionar Job",
	["Jobs"]											= "Jobs",
	["OK"]												= "OK",
	["Cancel"]										= "Cancelar",
	["Settings"]									= "Ajustes",
	["Name of NPC"]								= "Nombre",
	["Model path"]								= "Modelo",
	["Jobs List"]									= "Lista de Jobs",
	["Job Name"]									= "Nombre del Job",
	["Remove Job"]								= "Eliminar Job",
	["Save"]											= "Guardar",
	["Required"]									= "Requerido",
	["Select"]										= "Seleccionar",
	["Job Cost"]									= "Costo del Job",
	["You can't afford this job"] = "No tienes dinero para el Job",
	["You unlocked"]							= "Has desbloqueado",
	["Need to buy"]								= "Necesito comprar",
	["Available"]									= "Disponible",
	["Selected"]									=	"Seleccionado",
}

ENPC.Langs["de"] = {
	["Unavailable"] 							= "Nicht verfügbar",
	["Limit reached"] 						= "Limit wurde erreicht",
	["Time"] 											= "Zeit",
	["Lvl"] 											= "Lvl",
	["Add Job"]										= "Hinzufügen",
	["Select Job"] 								= "Auswählen",
	["Jobs"] 											= "Berufe",
	["OK"] 												= "OK",
	["Cancel"] 										= "Abbrechnen",
	["Settings"] 									= "Einstellungen",
	["Name of NPC"] 							= "NPC Name",
	["Model path"]								= "Model",
	["Jobs List"]									= "Berufliste",
	["Job Name"]									= "Berufsname",
	["Remove Job"]								= "Beruf löschen",
	["Save"]											= "Speichern",
	["Required"]									= "Erforderlich",
	["Select"]										= "Auswählen",
	["Job Cost"]									= "Preis",
	["You can't afford this job"] = "Sie haben nicht genügend Geld",
	["You unlocked"] 							= "Sie haben freigeschaltet",
	["Need to buy"]								= "Muss kaufen",
	["Available"]									= "Verfügbar",
	["Selected"]									=	"Ausgewählt",
}

ENPC.Langs["no"] = {
  ["Unavailable"]								= "Ikke tilgjengelig",
  ["Limit reached"]							= "Grense nådd",
  ["Time"]											= "Tid",
  ["Lvl"]												= "Level",
  ["Add Job"]										= "Legg til jobb",
  ["Select Job"]								= "Velg jobb",
  ["Jobs"]											= "Jobber",
  ["OK"]												= "OK",
  ["Cancel"]										= "Avbryt",
  ["Settings"]									= "Instillinger",
  ["Name of NPC"]								= "Navngi NPC",
  ["Model path"]								= "Model plassering",
  ["Jobs List"]									= "Jobb liste",
  ["Job Name"]									= "Jobb navn",
  ["Remove Job"]								= "Fjern Jobb",
  ["Save"]											= "Lagre",
  ["Required"]									= "Obligatorisk",
  ["Select"]										= "Velg",
  ["Job Cost"]									= "Pris på jobb",
  ["You can't afford this job"] = "Du har ikke nok til denne jobben.",
  ["You unlocked"]							= "Du låst opp",
  ["Need to buy"]								= "Trenger å kjøpe",
  ["Available"]									= "Tilgjengelig",
	["Selected"]									=	"valgt",
}

/*---------------------------------------------------------------------------
 Don't edit below
---------------------------------------------------------------------------*/
ENPC.JobsUsed = ENPC.JobsUsed or {}

local meta = FindMetaTable("Player")

function meta:IsIgnoreRules(type)
	return ENPC.Ranks[self:GetUserGroup()] and ENPC.CanBypass[type] or false
end

function meta:GetUnlockedJobs()
	return self.unlocked_jobs
end
 
function meta:IsUnlocked(job)
	return self.unlocked_jobs[job] or false
end

function ENPC.Translate(str)
	return ENPC.Langs[ENPC.Lang][str]
end 