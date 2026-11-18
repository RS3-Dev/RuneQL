-- Search-field descriptions and suggested values for query editors.
return {
    fields = {
        {
            key = "armourRole",
            label = "Armour role",
            type = "text",
            multiple = true,
        },
        {
            key = "augmentable",
            label = "Augmentable",
            type = "boolean",
            multiple = false,
        },
        {
            key = "augmented",
            label = "Augmented",
            type = "boolean",
            multiple = false,
        },
        {
            key = "baseValue",
            label = "Base value",
            type = "number",
            multiple = false,
        },
        {
            key = "category",
            label = "Category",
            type = "text",
            multiple = false,
        },
        {
            key = "combatStyle",
            label = "Combat style",
            type = "text",
            multiple = true,
        },
        {
            key = "containerType",
            label = "Container type",
            type = "text",
            multiple = false,
        },
        {
            key = "degradable",
            label = "Degradable",
            type = "boolean",
            multiple = false,
        },
        {
            key = "dose",
            label = "Dose",
            type = "number",
            multiple = false,
        },
        {
            key = "equipAgility",
            label = "Equip Agility level",
            type = "number",
            multiple = false,
        },
        {
            key = "equipAttack",
            label = "Equip Attack level",
            type = "number",
            multiple = false,
        },
        {
            key = "equipConstitution",
            label = "Equip Constitution level",
            type = "number",
            multiple = false,
        },
        {
            key = "equipDefence",
            label = "Equip Defence level",
            type = "number",
            multiple = false,
        },
        {
            key = "equipDungeoneering",
            label = "Equip Dungeoneering level",
            type = "number",
            multiple = false,
        },
        {
            key = "equipMagic",
            label = "Equip Magic level",
            type = "number",
            multiple = false,
        },
        {
            key = "equipNecromancy",
            label = "Equip Necromancy level",
            type = "number",
            multiple = false,
        },
        {
            key = "equipPrayer",
            label = "Equip Prayer level",
            type = "number",
            multiple = false,
        },
        {
            key = "equipRanged",
            label = "Equip Ranged level",
            type = "number",
            multiple = false,
        },
        {
            key = "equipSmithing",
            label = "Equip Smithing level",
            type = "number",
            multiple = false,
        },
        {
            key = "equipStrength",
            label = "Equip Strength level",
            type = "number",
            multiple = false,
        },
        {
            key = "equipRequirements",
            label = "Equip requirements",
            type = "text",
            multiple = false,
        },
        {
            key = "family",
            label = "Family",
            type = "text",
            multiple = true,
        },
        {
            key = "form",
            label = "Form",
            type = "text",
            multiple = true,
        },
        {
            key = "geTradeable",
            label = "GE tradeable",
            type = "boolean",
            multiple = false,
        },
        {
            key = "members",
            label = "Members",
            type = "boolean",
            multiple = false,
        },
        {
            key = "reclaimSources",
            label = "Reclaim sources",
            type = "text",
            multiple = true,
        },
        {
            key = "reclaimable",
            label = "Reclaimable",
            type = "boolean",
            multiple = false,
        },
        {
            key = "roles",
            label = "Roles",
            type = "text",
            multiple = true,
        },
        {
            key = "set",
            label = "Set",
            type = "text",
            multiple = true,
        },
        {
            key = "skills",
            label = "Skills",
            type = "text",
            multiple = true,
        },
        {
            key = "slot",
            label = "Slot",
            type = "text",
            multiple = true,
        },
        {
            key = "storageLocations",
            label = "Storage locations",
            type = "text",
            multiple = true,
        },
        {
            key = "subtype",
            label = "Subtype",
            type = "text",
            multiple = true,
        },
        {
            key = "tier",
            label = "Tier",
            type = "number",
            multiple = false,
        },
        {
            key = "tradeable",
            label = "Tradeable",
            type = "boolean",
            multiple = false,
        },
        {
            key = "types",
            label = "Types",
            type = "text",
            multiple = true,
        },
        {
            key = "weaponType",
            label = "Weapon type",
            type = "text",
            multiple = true,
        },
    },
    values = {
        armourRole = {
            {
                value = "hybrid",
                label = "Hybrid",
            },
            {
                value = "power",
                label = "Power",
            },
            {
                value = "tank",
                label = "Tank",
            },
        },
        augmentable = {
            {
                value = true,
                label = "true",
            },
        },
        augmented = {
            {
                value = true,
                label = "true",
            },
        },
        baseValue = {
            {
                value = 152,
                label = "152",
            },
            {
                value = 251,
                label = "251",
            },
            {
                value = 300,
                label = "300",
            },
            {
                value = 4168,
                label = "4168",
            },
        },
        category = {
            {
                value = "ammunition",
                label = "Ammunition",
            },
            {
                value = "archaeology-artefacts",
                label = "Archaeology artefacts",
            },
            {
                value = "archaeology-materials",
                label = "Archaeology materials",
            },
            {
                value = "archaeology-supplies",
                label = "Archaeology supplies & relics",
            },
            {
                value = "containers",
                label = "Bags, boxes & containers",
            },
            {
                value = "bombs",
                label = "Bombs",
            },
            {
                value = "clues",
                label = "Clue scrolls & clue supplies",
            },
            {
                value = "combat-utilities",
                label = "Combat utilities",
            },
            {
                value = "construction",
                label = "Construction",
            },
            {
                value = "consumable-buffs",
                label = "Consumable buffs",
            },
            {
                value = "cooking",
                label = "Cooking",
            },
            {
                value = "cosmetics",
                label = "Cosmetics & collectibles",
            },
            {
                value = "crafting",
                label = "Crafting",
            },
            {
                value = "currency",
                label = "Currency & tokens",
            },
            {
                value = "divination",
                label = "Divination supplies",
            },
            {
                value = "farming",
                label = "Farming produce & supplies",
            },
            {
                value = "potions",
                label = "Finished potions",
            },
            {
                value = "firemaking-supplies",
                label = "Firemaking supplies",
            },
            {
                value = "fishing",
                label = "Fishing",
            },
            {
                value = "fletching-materials",
                label = "Fletching materials",
            },
            {
                value = "food",
                label = "Food & drink",
            },
            {
                value = "fortunate-components",
                label = "Fortunate Components",
            },
            {
                value = "herblore-secondaries",
                label = "Herblore secondaries",
            },
            {
                value = "herbs",
                label = "Herbs",
            },
            {
                value = "hunter",
                label = "Hunter",
            },
            {
                value = "incense-sticks",
                label = "Incense sticks",
            },
            {
                value = "invention",
                label = "Invention devices, materials & supplies",
            },
            {
                value = "utilities",
                label = "Keys & general utilities",
            },
            {
                value = "magic-equipment",
                label = "Magic equipment",
            },
            {
                value = "melee-equipment",
                label = "Melee equipment",
            },
            {
                value = "activities",
                label = "Minigame & activity-specific items",
            },
            {
                value = "mining-resources",
                label = "Mining resources",
            },
            {
                value = "necromancy-ritual-supplies",
                label = "Necromancy Ritual Supplies",
            },
            {
                value = "necromancy-equipment",
                label = "Necromancy equipment",
            },
            {
                value = "needs-review",
                label = "Needs review",
            },
            {
                value = "pof-animals",
                label = "POF animals",
            },
            {
                value = "potion-making-supplies",
                label = "Potion-making supplies",
            },
            {
                value = "prayer",
                label = "Prayer supplies",
            },
            {
                value = "quests-lore",
                label = "Quest items & lore",
            },
            {
                value = "ranged-equipment",
                label = "Ranged equipment",
            },
            {
                value = "runecrafting",
                label = "Runecrafting supplies",
            },
            {
                value = "runes",
                label = "Runes",
            },
            {
                value = "salvage",
                label = "Salvage",
            },
            {
                value = "seeds",
                label = "Seeds & saplings",
            },
            {
                value = "shared-equipment",
                label = "Shared & hybrid equipment",
            },
            {
                value = "skilling-equipment",
                label = "Skilling outfits & accessories",
            },
            {
                value = "tools",
                label = "Skilling tools",
            },
            {
                value = "smithing-materials",
                label = "Smithing materials",
            },
            {
                value = "familiars",
                label = "Summoning charms, pouches & scrolls",
            },
            {
                value = "summoning-ingredients",
                label = "Summoning ingredients",
            },
            {
                value = "travel",
                label = "Teleports & travel",
            },
            {
                value = "unfinished-potions",
                label = "Unfinished potions",
            },
            {
                value = "upgrades",
                label = "Upgrade components & unique materials",
            },
            {
                value = "woodcutting-resources",
                label = "Woodcutting resources",
            },
            {
                value = "xp-unlocks",
                label = "XP items & unlocks",
            },
        },
        combatStyle = {
            {
                value = "hybrid",
                label = "Hybrid",
            },
            {
                value = "magic",
                label = "Magic",
            },
            {
                value = "melee",
                label = "Melee",
            },
            {
                value = "necromancy",
                label = "Necromancy",
            },
            {
                value = "ranged",
                label = "Ranged",
            },
            {
                value = "typeless",
                label = "Typeless",
            },
        },
        containerType = {
            {
                value = "bag",
                label = "Bag",
            },
            {
                value = "bucket",
                label = "Bucket",
            },
            {
                value = "flask",
                label = "Flask",
            },
            {
                value = "jug",
                label = "Jug",
            },
            {
                value = "vial",
                label = "Vial",
            },
            {
                value = "waterskin",
                label = "Waterskin",
            },
        },
        degradable = {
            {
                value = true,
                label = "true",
            },
        },
        dose = {
            {
                value = 1,
                label = "1",
            },
            {
                value = 2,
                label = "2",
            },
            {
                value = 3,
                label = "3",
            },
            {
                value = 4,
                label = "4",
            },
            {
                value = 5,
                label = "5",
            },
            {
                value = 6,
                label = "6",
            },
        },
        equipAgility = {
            {
                value = 50,
                label = "50",
            },
        },
        equipAttack = {
            {
                value = 42,
                label = "42",
            },
        },
        equipConstitution = {
            {
                value = 42,
                label = "42",
            },
            {
                value = 80,
                label = "80",
            },
        },
        equipDefence = {
            {
                value = 1,
                label = "1",
            },
            {
                value = 5,
                label = "5",
            },
            {
                value = 10,
                label = "10",
            },
            {
                value = 13,
                label = "13",
            },
            {
                value = 19,
                label = "19",
            },
            {
                value = 20,
                label = "20",
            },
            {
                value = 25,
                label = "25",
            },
            {
                value = 26,
                label = "26",
            },
            {
                value = 30,
                label = "30",
            },
            {
                value = 33,
                label = "33",
            },
            {
                value = 34,
                label = "34",
            },
            {
                value = 35,
                label = "35",
            },
            {
                value = 36,
                label = "36",
            },
            {
                value = 37,
                label = "37",
            },
            {
                value = 38,
                label = "38",
            },
            {
                value = 40,
                label = "40",
            },
            {
                value = 42,
                label = "42",
            },
            {
                value = 50,
                label = "50",
            },
            {
                value = 55,
                label = "55",
            },
            {
                value = 60,
                label = "60",
            },
            {
                value = 65,
                label = "65",
            },
            {
                value = 70,
                label = "70",
            },
            {
                value = 75,
                label = "75",
            },
            {
                value = 78,
                label = "78",
            },
            {
                value = 80,
                label = "80",
            },
            {
                value = 82,
                label = "82",
            },
            {
                value = 85,
                label = "85",
            },
            {
                value = 88,
                label = "88",
            },
            {
                value = 90,
                label = "90",
            },
            {
                value = 92,
                label = "92",
            },
            {
                value = 95,
                label = "95",
            },
            {
                value = 99,
                label = "99",
            },
        },
        equipDungeoneering = {
            {
                value = 35,
                label = "35",
            },
        },
        equipMagic = {
            {
                value = 42,
                label = "42",
            },
            {
                value = 50,
                label = "50",
            },
            {
                value = 60,
                label = "60",
            },
            {
                value = 65,
                label = "65",
            },
            {
                value = 70,
                label = "70",
            },
            {
                value = 81,
                label = "81",
            },
            {
                value = 85,
                label = "85",
            },
            {
                value = 95,
                label = "95",
            },
        },
        equipNecromancy = {
            {
                value = 70,
                label = "70",
            },
            {
                value = 80,
                label = "80",
            },
            {
                value = 90,
                label = "90",
            },
            {
                value = 95,
                label = "95",
            },
        },
        equipPrayer = {
            {
                value = 10,
                label = "10",
            },
            {
                value = 20,
                label = "20",
            },
            {
                value = 22,
                label = "22",
            },
            {
                value = 25,
                label = "25",
            },
            {
                value = 40,
                label = "40",
            },
            {
                value = 60,
                label = "60",
            },
            {
                value = 70,
                label = "70",
            },
        },
        equipRanged = {
            {
                value = 25,
                label = "25",
            },
            {
                value = 30,
                label = "30",
            },
            {
                value = 40,
                label = "40",
            },
            {
                value = 42,
                label = "42",
            },
            {
                value = 50,
                label = "50",
            },
            {
                value = 60,
                label = "60",
            },
            {
                value = 65,
                label = "65",
            },
            {
                value = 85,
                label = "85",
            },
        },
        equipRequirements = {
            {
                value = "1 Defence",
                label = "1 Defence",
            },
            {
                value = "10 Defence",
                label = "10 Defence",
            },
            {
                value = "13 Defence",
                label = "13 Defence",
            },
            {
                value = "19 Defence",
                label = "19 Defence",
            },
            {
                value = "20 Defence",
                label = "20 Defence",
            },
            {
                value = "25 Defence",
                label = "25 Defence",
            },
            {
                value = "25 Defence , 10 Prayer",
                label = "25 Defence , 10 Prayer",
            },
            {
                value = "25 Defence , 25 Prayer",
                label = "25 Defence , 25 Prayer",
            },
            {
                value = "25 Defence , 25 Ranged",
                label = "25 Defence , 25 Ranged",
            },
            {
                value = "26 Defence",
                label = "26 Defence",
            },
            {
                value = "30 Defence",
                label = "30 Defence",
            },
            {
                value = "30 Defence , 20 Prayer",
                label = "30 Defence , 20 Prayer",
            },
            {
                value = "30 Defence , 30 Ranged",
                label = "30 Defence , 30 Ranged",
            },
            {
                value = "33 Defence",
                label = "33 Defence",
            },
            {
                value = "34 Defence",
                label = "34 Defence",
            },
            {
                value = "35 Defence",
                label = "35 Defence",
            },
            {
                value = "35 Smithing , 35 Dungeoneering",
                label = "35 Smithing , 35 Dungeoneering",
            },
            {
                value = "36 Defence",
                label = "36 Defence",
            },
            {
                value = "37 Defence",
                label = "37 Defence",
            },
            {
                value = "38 Defence",
                label = "38 Defence",
            },
            {
                value = "40 Defence",
                label = "40 Defence",
            },
            {
                value = "40 Defence , 40 Prayer",
                label = "40 Defence , 40 Prayer",
            },
            {
                value = "40 Defence , 60 Magic",
                label = "40 Defence , 60 Magic",
            },
            {
                value = "40 Defence , 65 Magic",
                label = "40 Defence , 65 Magic",
            },
            {
                value = "40 Defence , 65 Ranged",
                label = "40 Defence , 65 Ranged",
            },
            {
                value = "40 Defence 50 Ranged",
                label = "40 Defence 50 Ranged",
            },
            {
                value = "40 Defence 50 Strength",
                label = "40 Defence 50 Strength",
            },
            {
                value = "40 Defence 65 Strength",
                label = "40 Defence 65 Strength",
            },
            {
                value = "40 Prayer , 40 Defence",
                label = "40 Prayer , 40 Defence",
            },
            {
                value = "40 Ranged",
                label = "40 Ranged",
            },
            {
                value = "42 Defence",
                label = "42 Defence",
            },
            {
                value = "42 Defence , 42 Attack , 42 Strength , 42 Magic , 42 Ranged , 42 Constitution , 22 Prayer",
                label = "42 Defence , 42 Attack , 42 Strength , 42 Magic , 42 Ranged , 42 Constitution , 22 Prayer",
            },
            {
                value = "5 Defence",
                label = "5 Defence",
            },
            {
                value = "50 Defence",
                label = "50 Defence",
            },
            {
                value = "50 Defence , 50 Magic",
                label = "50 Defence , 50 Magic",
            },
            {
                value = "55 Defence",
                label = "55 Defence",
            },
            {
                value = "55 Defence , 50 Magic",
                label = "55 Defence , 50 Magic",
            },
            {
                value = "55 Defence , 55 Strength",
                label = "55 Defence , 55 Strength",
            },
            {
                value = "60 Defence",
                label = "60 Defence",
            },
            {
                value = "60 Defence , 60 Ranged",
                label = "60 Defence , 60 Ranged",
            },
            {
                value = "60 Magic",
                label = "60 Magic",
            },
            {
                value = "60 Prayer",
                label = "60 Prayer",
            },
            {
                value = "65 Defence",
                label = "65 Defence",
            },
            {
                value = "70 Defence",
                label = "70 Defence",
            },
            {
                value = "70 Defence , 50 Agility",
                label = "70 Defence , 50 Agility",
            },
            {
                value = "70 Defence , 70 Magic , 70 Prayer",
                label = "70 Defence , 70 Magic , 70 Prayer",
            },
            {
                value = "70 Defence , 70 Necromancy",
                label = "70 Defence , 70 Necromancy",
            },
            {
                value = "75 Defence",
                label = "75 Defence",
            },
            {
                value = "78 Defence",
                label = "78 Defence",
            },
            {
                value = "80 Defence",
                label = "80 Defence",
            },
            {
                value = "80 Defence , 50 Agility",
                label = "80 Defence , 50 Agility",
            },
            {
                value = "80 Defence , 80 Constitution",
                label = "80 Defence , 80 Constitution",
            },
            {
                value = "80 Defence , 80 Necromancy",
                label = "80 Defence , 80 Necromancy",
            },
            {
                value = "81 Magic",
                label = "81 Magic",
            },
            {
                value = "82 Defence , 40 Ranged",
                label = "82 Defence , 40 Ranged",
            },
            {
                value = "85 Defence",
                label = "85 Defence",
            },
            {
                value = "85 Magic , 85 Ranged , 85 Defence",
                label = "85 Magic , 85 Ranged , 85 Defence",
            },
            {
                value = "85 Magic , 85 Strength , 85 Defence",
                label = "85 Magic , 85 Strength , 85 Defence",
            },
            {
                value = "85 Strength , 85 Ranged , 85 Defence",
                label = "85 Strength , 85 Ranged , 85 Defence",
            },
            {
                value = "88 Defence",
                label = "88 Defence",
            },
            {
                value = "90 Defence",
                label = "90 Defence",
            },
            {
                value = "90 Defence , 90 Necromancy",
                label = "90 Defence , 90 Necromancy",
            },
            {
                value = "92 Defence",
                label = "92 Defence",
            },
            {
                value = "95 Defence",
                label = "95 Defence",
            },
            {
                value = "95 Defence , 95 Magic",
                label = "95 Defence , 95 Magic",
            },
            {
                value = "95 Defence , 95 Necromancy",
                label = "95 Defence , 95 Necromancy",
            },
            {
                value = "99 Cooking",
                label = "99 Cooking",
            },
            {
                value = "99 Defence",
                label = "99 Defence",
            },
            {
                value = "99 Ranged",
                label = "99 Ranged",
            },
            {
                value = "Recipe for Disaster",
                label = "Recipe For Disaster",
            },
        },
        equipSmithing = {
            {
                value = 35,
                label = "35",
            },
        },
        equipStrength = {
            {
                value = 42,
                label = "42",
            },
            {
                value = 50,
                label = "50",
            },
            {
                value = 55,
                label = "55",
            },
            {
                value = 65,
                label = "65",
            },
            {
                value = 85,
                label = "85",
            },
        },
        family = {
            {
                value = "2026-halloween",
                label = "2026 Halloween",
            },
            {
                value = "acne-potion",
                label = "Acne Potion",
            },
            {
                value = "adrenaline-crystal",
                label = "Adrenaline Crystal",
            },
            {
                value = "adrenaline-flask",
                label = "Adrenaline Flask",
            },
            {
                value = "adrenaline-potion",
                label = "Adrenaline Potion",
            },
            {
                value = "adrenaline-renewal-flask",
                label = "Adrenaline Renewal Flask",
            },
            {
                value = "adrenaline-renewal-potion",
                label = "Adrenaline Renewal Potion",
            },
            {
                value = "aggression-flask",
                label = "Aggression Flask",
            },
            {
                value = "aggression-potion",
                label = "Aggression Potion",
            },
            {
                value = "aggroverload",
                label = "Aggroverload",
            },
            {
                value = "agility-flask",
                label = "Agility Flask",
            },
            {
                value = "agility-mix",
                label = "Agility Mix",
            },
            {
                value = "agility-potion",
                label = "Agility Potion",
            },
            {
                value = "aloe-potion",
                label = "Aloe Potion",
            },
            {
                value = "ancient-elven-ritual-shard",
                label = "Ancient Elven Ritual Shard",
            },
            {
                value = "antifire",
                label = "Antifire",
            },
            {
                value = "antifire-flask",
                label = "Antifire Flask",
            },
            {
                value = "antifire-mix",
                label = "Antifire Mix",
            },
            {
                value = "antipoison",
                label = "Antipoison",
            },
            {
                value = "antipoison-flask",
                label = "Antipoison Flask",
            },
            {
                value = "antipoison-mix",
                label = "Antipoison Mix",
            },
            {
                value = "antisanguine",
                label = "Antisanguine",
            },
            {
                value = "antisanguine-flask",
                label = "Antisanguine Flask",
            },
            {
                value = "arbuck-potion",
                label = "Arbuck Potion",
            },
            {
                value = "archaeology-buff",
                label = "Archaeology Buff",
            },
            {
                value = "archaeology-flask",
                label = "Archaeology Flask",
            },
            {
                value = "archaeology-potion",
                label = "Archaeology Potion",
            },
            {
                value = "ardrigal-mixture",
                label = "Ardrigal Mixture",
            },
            {
                value = "argway-potion",
                label = "Argway Potion",
            },
            {
                value = "artisan-s-potion",
                label = "Artisan S Potion",
            },
            {
                value = "attack-flask",
                label = "Attack Flask",
            },
            {
                value = "attack-mix",
                label = "Attack Mix",
            },
            {
                value = "attack-potion",
                label = "Attack Potion",
            },
            {
                value = "avantoe-potion",
                label = "Avantoe Potion",
            },
            {
                value = "barrows",
                label = "Barrows",
            },
            {
                value = "batch-of-elder-overload-potion",
                label = "Batch Of Elder Overload Potion",
            },
            {
                value = "batch-of-overload",
                label = "Batch Of Overload",
            },
            {
                value = "batch-of-supreme-overload-potion",
                label = "Batch Of Supreme Overload Potion",
            },
            {
                value = "bird-nest",
                label = "Bird Nest",
            },
            {
                value = "blessed-flask",
                label = "Blessed Flask",
            },
            {
                value = "bloodweed-potion",
                label = "Bloodweed Potion",
            },
            {
                value = "bomb-vial",
                label = "Bomb Vial",
            },
            {
                value = "botanist-s-workbench",
                label = "Botanist S Workbench",
            },
            {
                value = "bravery-potion",
                label = "Bravery Potion",
            },
            {
                value = "brightfire-potion",
                label = "Brightfire Potion",
            },
            {
                value = "buckthorn-potion",
                label = "Buckthorn Potion",
            },
            {
                value = "cadantine-potion",
                label = "Cadantine Potion",
            },
            {
                value = "cadava-potion",
                label = "Cadava Potion",
            },
            {
                value = "camouflage-flask",
                label = "Camouflage Flask",
            },
            {
                value = "camouflage-potion",
                label = "Camouflage Potion",
            },
            {
                value = "cat-antipoison",
                label = "Cat Antipoison",
            },
            {
                value = "charming-potion",
                label = "Charming Potion",
            },
            {
                value = "charming-potion-flask",
                label = "Charming Potion Flask",
            },
            {
                value = "coconut-milk",
                label = "Coconut Milk",
            },
            {
                value = "combat-flask",
                label = "Combat Flask",
            },
            {
                value = "combat-mix",
                label = "Combat Mix",
            },
            {
                value = "combat-potion",
                label = "Combat Potion",
            },
            {
                value = "compost-potion",
                label = "Compost Potion",
            },
            {
                value = "cooking-flask",
                label = "Cooking Flask",
            },
            {
                value = "cooking-potion",
                label = "Cooking Potion",
            },
            {
                value = "crafting-flask",
                label = "Crafting Flask",
            },
            {
                value = "crafting-potion",
                label = "Crafting Potion",
            },
            {
                value = "cure-potion",
                label = "Cure Potion",
            },
            {
                value = "cw-super-attack-potion",
                label = "Cw Super Attack Potion",
            },
            {
                value = "cw-super-defence-potion",
                label = "Cw Super Defence Potion",
            },
            {
                value = "cw-super-energy-potion",
                label = "Cw Super Energy Potion",
            },
            {
                value = "cw-super-magic-potion",
                label = "Cw Super Magic Potion",
            },
            {
                value = "cw-super-ranging-potion",
                label = "Cw Super Ranging Potion",
            },
            {
                value = "cw-super-strength-potion",
                label = "Cw Super Strength Potion",
            },
            {
                value = "deep-sea-fishing",
                label = "Deep Sea Fishing",
            },
            {
                value = "defence-flask",
                label = "Defence Flask",
            },
            {
                value = "defence-mix",
                label = "Defence Mix",
            },
            {
                value = "defence-potion",
                label = "Defence Potion",
            },
            {
                value = "diamond-dust-potion",
                label = "Diamond Dust Potion",
            },
            {
                value = "divination-flask",
                label = "Divination Flask",
            },
            {
                value = "divination-potion",
                label = "Divination Potion",
            },
            {
                value = "druid-pouch",
                label = "Druid Pouch",
            },
            {
                value = "duckspeak-potion",
                label = "Duckspeak Potion",
            },
            {
                value = "dwarf-weed-potion",
                label = "Dwarf Weed Potion",
            },
            {
                value = "eggs",
                label = "Eggs",
            },
            {
                value = "elder-overload-potion",
                label = "Elder Overload Potion",
            },
            {
                value = "elder-overload-salve",
                label = "Elder Overload Salve",
            },
            {
                value = "elixir-of-revealment",
                label = "Elixir Of Revealment",
            },
            {
                value = "energy-flask",
                label = "Energy Flask",
            },
            {
                value = "energy-mix",
                label = "Energy Mix",
            },
            {
                value = "energy-potion",
                label = "Energy Potion",
            },
            {
                value = "enhanced-luck-potion",
                label = "Enhanced Luck Potion",
            },
            {
                value = "enhanced-replenishment-potion",
                label = "Enhanced Replenishment Potion",
            },
            {
                value = "erzille-potion",
                label = "Erzille Potion",
            },
            {
                value = "extended-super-antifire",
                label = "Extended Super Antifire",
            },
            {
                value = "extended-super-antifire-flask",
                label = "Extended Super Antifire Flask",
            },
            {
                value = "extreme-attack",
                label = "Extreme Attack",
            },
            {
                value = "extreme-attack-flask",
                label = "Extreme Attack Flask",
            },
            {
                value = "extreme-battlemage-s-potion",
                label = "Extreme Battlemage S Potion",
            },
            {
                value = "extreme-brawler-s-potion",
                label = "Extreme Brawler S Potion",
            },
            {
                value = "extreme-cooking-flask",
                label = "Extreme Cooking Flask",
            },
            {
                value = "extreme-cooking-potion",
                label = "Extreme Cooking Potion",
            },
            {
                value = "extreme-defence",
                label = "Extreme Defence",
            },
            {
                value = "extreme-defence-flask",
                label = "Extreme Defence Flask",
            },
            {
                value = "extreme-divination",
                label = "Extreme Divination",
            },
            {
                value = "extreme-divination-flask",
                label = "Extreme Divination Flask",
            },
            {
                value = "extreme-guthix-balance",
                label = "Extreme Guthix Balance",
            },
            {
                value = "extreme-hunter",
                label = "Extreme Hunter",
            },
            {
                value = "extreme-hunter-flask",
                label = "Extreme Hunter Flask",
            },
            {
                value = "extreme-invention",
                label = "Extreme Invention",
            },
            {
                value = "extreme-invention-flask",
                label = "Extreme Invention Flask",
            },
            {
                value = "extreme-magic",
                label = "Extreme Magic",
            },
            {
                value = "extreme-magic-flask",
                label = "Extreme Magic Flask",
            },
            {
                value = "extreme-necromancy",
                label = "Extreme Necromancy",
            },
            {
                value = "extreme-necromancy-flask",
                label = "Extreme Necromancy Flask",
            },
            {
                value = "extreme-prayer",
                label = "Extreme Prayer",
            },
            {
                value = "extreme-prayer-flask",
                label = "Extreme Prayer Flask",
            },
            {
                value = "extreme-prayer-potion",
                label = "Extreme Prayer Potion",
            },
            {
                value = "extreme-ranging",
                label = "Extreme Ranging",
            },
            {
                value = "extreme-ranging-flask",
                label = "Extreme Ranging Flask",
            },
            {
                value = "extreme-runecrafting",
                label = "Extreme Runecrafting",
            },
            {
                value = "extreme-runecrafting-flask",
                label = "Extreme Runecrafting Flask",
            },
            {
                value = "extreme-sharpshooter-s-potion",
                label = "Extreme Sharpshooter S Potion",
            },
            {
                value = "extreme-strength",
                label = "Extreme Strength",
            },
            {
                value = "extreme-strength-flask",
                label = "Extreme Strength Flask",
            },
            {
                value = "extreme-warmaster-s-potion",
                label = "Extreme Warmaster S Potion",
            },
            {
                value = "featherfoil-potion",
                label = "Featherfoil Potion",
            },
            {
                value = "fellstalk-potion",
                label = "Fellstalk Potion",
            },
            {
                value = "fishing-flask",
                label = "Fishing Flask",
            },
            {
                value = "fishing-mix",
                label = "Fishing Mix",
            },
            {
                value = "fishing-potion",
                label = "Fishing Potion",
            },
            {
                value = "fletching-flask",
                label = "Fletching Flask",
            },
            {
                value = "fletching-potion",
                label = "Fletching Potion",
            },
            {
                value = "gatherer-s-potion",
                label = "Gatherer S Potion",
            },
            {
                value = "goblin-potion",
                label = "Goblin Potion",
            },
            {
                value = "grand-attack-potion",
                label = "Grand Attack Potion",
            },
            {
                value = "grand-defence-potion",
                label = "Grand Defence Potion",
            },
            {
                value = "grand-magic-potion",
                label = "Grand Magic Potion",
            },
            {
                value = "grand-ranging-potion",
                label = "Grand Ranging Potion",
            },
            {
                value = "grand-strength-potion",
                label = "Grand Strength Potion",
            },
            {
                value = "grimoire",
                label = "Grimoire",
            },
            {
                value = "guam-marr-vial",
                label = "Guam Marr Vial",
            },
            {
                value = "guam-potion",
                label = "Guam Potion",
            },
            {
                value = "guam-vial",
                label = "Guam Vial",
            },
            {
                value = "guthix-balance",
                label = "Guthix Balance",
            },
            {
                value = "guthix-balance-flask",
                label = "Guthix Balance Flask",
            },
            {
                value = "guthix-rest",
                label = "Guthix Rest",
            },
            {
                value = "guthix-rest-flask",
                label = "Guthix Rest Flask",
            },
            {
                value = "guthix-s-gift",
                label = "Guthix S Gift",
            },
            {
                value = "guthix-s-gift-flask",
                label = "Guthix S Gift Flask",
            },
            {
                value = "harralander-potion",
                label = "Harralander Potion",
            },
            {
                value = "harvest-flask",
                label = "Harvest Flask",
            },
            {
                value = "harvest-potion",
                label = "Harvest Potion",
            },
            {
                value = "healing-potion",
                label = "Healing Potion",
            },
            {
                value = "heart-of-gielinor",
                label = "Heart Of Gielinor",
            },
            {
                value = "holy-aggroverload",
                label = "Holy Aggroverload",
            },
            {
                value = "holy-overload-potion",
                label = "Holy Overload Potion",
            },
            {
                value = "hunter-flask",
                label = "Hunter Flask",
            },
            {
                value = "hunter-potion",
                label = "Hunter Potion",
            },
            {
                value = "hunting-mix",
                label = "Hunting Mix",
            },
            {
                value = "invention-flask",
                label = "Invention Flask",
            },
            {
                value = "invention-potion",
                label = "Invention Potion",
            },
            {
                value = "irit-potion",
                label = "Irit Potion",
            },
            {
                value = "juju-cooking-flask",
                label = "Juju Cooking Flask",
            },
            {
                value = "juju-cooking-potion",
                label = "Juju Cooking Potion",
            },
            {
                value = "juju-farming-flask",
                label = "Juju Farming Flask",
            },
            {
                value = "juju-farming-potion",
                label = "Juju Farming Potion",
            },
            {
                value = "juju-fishing-flask",
                label = "Juju Fishing Flask",
            },
            {
                value = "juju-fishing-potion",
                label = "Juju Fishing Potion",
            },
            {
                value = "juju-hunter-flask",
                label = "Juju Hunter Flask",
            },
            {
                value = "juju-hunter-potion",
                label = "Juju Hunter Potion",
            },
            {
                value = "juju-mining-flask",
                label = "Juju Mining Flask",
            },
            {
                value = "juju-mining-potion",
                label = "Juju Mining Potion",
            },
            {
                value = "juju-vial",
                label = "Juju Vial",
            },
            {
                value = "juju-vial-of-water",
                label = "Juju Vial Of Water",
            },
            {
                value = "juju-vial-pack",
                label = "Juju Vial Pack",
            },
            {
                value = "juju-woodcutting-flask",
                label = "Juju Woodcutting Flask",
            },
            {
                value = "juju-woodcutting-potion",
                label = "Juju Woodcutting Potion",
            },
            {
                value = "kilis-knowledge",
                label = "Kilis Knowledge",
            },
            {
                value = "kwuarm-potion",
                label = "Kwuarm Potion",
            },
            {
                value = "lantadyme-potion",
                label = "Lantadyme Potion",
            },
            {
                value = "livid-farm",
                label = "Livid Farm",
            },
            {
                value = "love-potion",
                label = "Love Potion",
            },
            {
                value = "luck-potion",
                label = "Luck Potion",
            },
            {
                value = "lycopus-potion",
                label = "Lycopus Potion",
            },
            {
                value = "magebane-potion",
                label = "Magebane Potion",
            },
            {
                value = "magic-essence",
                label = "Magic Essence",
            },
            {
                value = "magic-essence-flask",
                label = "Magic Essence Flask",
            },
            {
                value = "magic-essence-mix",
                label = "Magic Essence Mix",
            },
            {
                value = "magic-flask",
                label = "Magic Flask",
            },
            {
                value = "magic-mix",
                label = "Magic Mix",
            },
            {
                value = "magic-ogre-potion",
                label = "Magic Ogre Potion",
            },
            {
                value = "magic-potion",
                label = "Magic Potion",
            },
            {
                value = "mambo-s-potion",
                label = "Mambo S Potion",
            },
            {
                value = "marr-vial",
                label = "Marr Vial",
            },
            {
                value = "marrentill-potion",
                label = "Marrentill Potion",
            },
            {
                value = "meilyr-potion",
                label = "Meilyr Potion",
            },
            {
                value = "melee-potion",
                label = "Melee Potion",
            },
            {
                value = "mining-flask",
                label = "Mining Flask",
            },
            {
                value = "mining-potion",
                label = "Mining Potion",
            },
            {
                value = "mining-smithing-rework",
                label = "Mining Smithing Rework",
            },
            {
                value = "mixture-step-1",
                label = "Mixture Step 1",
            },
            {
                value = "mixture-step-2",
                label = "Mixture Step 2",
            },
            {
                value = "motherlode-maw",
                label = "Motherlode Maw",
            },
            {
                value = "mountain-irit-potion",
                label = "Mountain Irit Potion",
            },
            {
                value = "naturalist-s-potion",
                label = "Naturalist S Potion",
            },
            {
                value = "necromancy-flask",
                label = "Necromancy Flask",
            },
            {
                value = "necromancy-potion",
                label = "Necromancy Potion",
            },
            {
                value = "ogre-flask",
                label = "Ogre Flask",
            },
            {
                value = "overload",
                label = "Overload",
            },
            {
                value = "overload-flask",
                label = "Overload Flask",
            },
            {
                value = "overload-salve",
                label = "Overload Salve",
            },
            {
                value = "perfect-juju-agility-flask",
                label = "Perfect Juju Agility Flask",
            },
            {
                value = "perfect-juju-agility-potion",
                label = "Perfect Juju Agility Potion",
            },
            {
                value = "perfect-juju-dungeoneering-flask",
                label = "Perfect Juju Dungeoneering Flask",
            },
            {
                value = "perfect-juju-dungeoneering-potion",
                label = "Perfect Juju Dungeoneering Potion",
            },
            {
                value = "perfect-juju-farming-flask",
                label = "Perfect Juju Farming Flask",
            },
            {
                value = "perfect-juju-farming-potion",
                label = "Perfect Juju Farming Potion",
            },
            {
                value = "perfect-juju-fishing-flask",
                label = "Perfect Juju Fishing Flask",
            },
            {
                value = "perfect-juju-fishing-potion",
                label = "Perfect Juju Fishing Potion",
            },
            {
                value = "perfect-juju-herblore-flask",
                label = "Perfect Juju Herblore Flask",
            },
            {
                value = "perfect-juju-herblore-potion",
                label = "Perfect Juju Herblore Potion",
            },
            {
                value = "perfect-juju-mining-flask",
                label = "Perfect Juju Mining Flask",
            },
            {
                value = "perfect-juju-mining-potion",
                label = "Perfect Juju Mining Potion",
            },
            {
                value = "perfect-juju-prayer-flask",
                label = "Perfect Juju Prayer Flask",
            },
            {
                value = "perfect-juju-prayer-potion",
                label = "Perfect Juju Prayer Potion",
            },
            {
                value = "perfect-juju-smithing-flask",
                label = "Perfect Juju Smithing Flask",
            },
            {
                value = "perfect-juju-smithing-potion",
                label = "Perfect Juju Smithing Potion",
            },
            {
                value = "perfect-juju-woodcutting-flask",
                label = "Perfect Juju Woodcutting Flask",
            },
            {
                value = "perfect-juju-woodcutting-potion",
                label = "Perfect Juju Woodcutting Potion",
            },
            {
                value = "perfect-plus-potion",
                label = "Perfect Plus Potion",
            },
            {
                value = "poison-bomb",
                label = "Poison Bomb",
            },
            {
                value = "potion",
                label = "Potion",
            },
            {
                value = "potion-of-zombification",
                label = "Potion Of Zombification",
            },
            {
                value = "powerburst-of-acceleration",
                label = "Powerburst Of Acceleration",
            },
            {
                value = "powerburst-of-feats",
                label = "Powerburst Of Feats",
            },
            {
                value = "powerburst-of-masterstroke",
                label = "Powerburst Of Masterstroke",
            },
            {
                value = "powerburst-of-opportunity",
                label = "Powerburst Of Opportunity",
            },
            {
                value = "powerburst-of-sorcery",
                label = "Powerburst Of Sorcery",
            },
            {
                value = "powerburst-of-vitality",
                label = "Powerburst Of Vitality",
            },
            {
                value = "powerburst-vial",
                label = "Powerburst Vial",
            },
            {
                value = "prayer-mix",
                label = "Prayer Mix",
            },
            {
                value = "prayer-potion",
                label = "Prayer Potion",
            },
            {
                value = "prayer-powder",
                label = "Prayer Powder",
            },
            {
                value = "prayer-renewal",
                label = "Prayer Renewal",
            },
            {
                value = "prayer-renewal-flask",
                label = "Prayer Renewal Flask",
            },
            {
                value = "primal-extract",
                label = "Primal Extract",
            },
            {
                value = "primal-fruit-pulp",
                label = "Primal Fruit Pulp",
            },
            {
                value = "ranarr-potion",
                label = "Ranarr Potion",
            },
            {
                value = "ranged-potion",
                label = "Ranged Potion",
            },
            {
                value = "ranging-flask",
                label = "Ranging Flask",
            },
            {
                value = "ranging-mix",
                label = "Ranging Mix",
            },
            {
                value = "ranging-potion",
                label = "Ranging Potion",
            },
            {
                value = "rejuvenation-potion",
                label = "Rejuvenation Potion",
            },
            {
                value = "relicym-s-balm",
                label = "Relicym S Balm",
            },
            {
                value = "relicym-s-balm-flask",
                label = "Relicym S Balm Flask",
            },
            {
                value = "relicym-s-mix",
                label = "Relicym S Mix",
            },
            {
                value = "replenishment-potion",
                label = "Replenishment Potion",
            },
            {
                value = "resonant-anima",
                label = "Resonant Anima",
            },
            {
                value = "restore-flask",
                label = "Restore Flask",
            },
            {
                value = "restore-mix",
                label = "Restore Mix",
            },
            {
                value = "restore-potion",
                label = "Restore Potion",
            },
            {
                value = "rogue-s-purse-potion",
                label = "Rogue S Purse Potion",
            },
            {
                value = "runecrafting-flask",
                label = "Runecrafting Flask",
            },
            {
                value = "runecrafting-potion",
                label = "Runecrafting Potion",
            },
            {
                value = "safecracking",
                label = "Safecracking",
            },
            {
                value = "sagewort-potion",
                label = "Sagewort Potion",
            },
            {
                value = "samaden-potion",
                label = "Samaden Potion",
            },
            {
                value = "sanfew-serum",
                label = "Sanfew Serum",
            },
            {
                value = "sanfew-serum-flask",
                label = "Sanfew Serum Flask",
            },
            {
                value = "saradomin-brew",
                label = "Saradomin Brew",
            },
            {
                value = "saradomin-brew-flask",
                label = "Saradomin Brew Flask",
            },
            {
                value = "saradomin-s-blessing",
                label = "Saradomin S Blessing",
            },
            {
                value = "saradomin-s-blessing-flask",
                label = "Saradomin S Blessing Flask",
            },
            {
                value = "scentless-flask",
                label = "Scentless Flask",
            },
            {
                value = "scentless-potion",
                label = "Scentless Potion",
            },
            {
                value = "searing-overload-potion",
                label = "Searing Overload Potion",
            },
            {
                value = "seed-bag",
                label = "Seed Bag",
            },
            {
                value = "seren-symbol",
                label = "Seren Symbol",
            },
            {
                value = "serum-207",
                label = "Serum 207",
            },
            {
                value = "serum-207-flask",
                label = "Serum 207 Flask",
            },
            {
                value = "serum-208",
                label = "Serum 208",
            },
            {
                value = "serum-208-flask",
                label = "Serum 208 Flask",
            },
            {
                value = "shengo-potion",
                label = "Shengo Potion",
            },
            {
                value = "shrink-me-quick",
                label = "Shrink Me Quick",
            },
            {
                value = "silverhawk",
                label = "Silverhawk",
            },
            {
                value = "snakeweed-mixture",
                label = "Snakeweed Mixture",
            },
            {
                value = "snapdragon-potion",
                label = "Snapdragon Potion",
            },
            {
                value = "sobriety-potion",
                label = "Sobriety Potion",
            },
            {
                value = "spicy-stew",
                label = "Spicy Stew",
            },
            {
                value = "spirit-attraction-flask",
                label = "Spirit Attraction Flask",
            },
            {
                value = "spirit-attraction-potion",
                label = "Spirit Attraction Potion",
            },
            {
                value = "spirit-weed-potion",
                label = "Spirit Weed Potion",
            },
            {
                value = "spiritual-prayer-potion",
                label = "Spiritual Prayer Potion",
            },
            {
                value = "stamina-flask",
                label = "Stamina Flask",
            },
            {
                value = "stamina-potion",
                label = "Stamina Potion",
            },
            {
                value = "stat-restore-potion",
                label = "Stat Restore Potion",
            },
            {
                value = "sticky-bomb",
                label = "Sticky Bomb",
            },
            {
                value = "stone-spirit",
                label = "Stone Spirit",
            },
            {
                value = "strange-potion",
                label = "Strange Potion",
            },
            {
                value = "strength-flask",
                label = "Strength Flask",
            },
            {
                value = "strength-mix",
                label = "Strength Mix",
            },
            {
                value = "strength-potion",
                label = "Strength Potion",
            },
            {
                value = "strong-artisan-s-potion",
                label = "Strong Artisan S Potion",
            },
            {
                value = "strong-cure-potion",
                label = "Strong Cure Potion",
            },
            {
                value = "strong-defence-potion",
                label = "Strong Defence Potion",
            },
            {
                value = "strong-gatherer-s-potion",
                label = "Strong Gatherer S Potion",
            },
            {
                value = "strong-magic-potion",
                label = "Strong Magic Potion",
            },
            {
                value = "strong-melee-potion",
                label = "Strong Melee Potion",
            },
            {
                value = "strong-naturalist-s-potion",
                label = "Strong Naturalist S Potion",
            },
            {
                value = "strong-necromancy-potion",
                label = "Strong Necromancy Potion",
            },
            {
                value = "strong-ranged-potion",
                label = "Strong Ranged Potion",
            },
            {
                value = "strong-rejuvenation-potion",
                label = "Strong Rejuvenation Potion",
            },
            {
                value = "strong-stat-restore-potion",
                label = "Strong Stat Restore Potion",
            },
            {
                value = "strong-survivalist-s-potion",
                label = "Strong Survivalist S Potion",
            },
            {
                value = "strong-weapon-poison",
                label = "Strong Weapon Poison",
            },
            {
                value = "summoning-flask",
                label = "Summoning Flask",
            },
            {
                value = "summoning-potion",
                label = "Summoning Potion",
            },
            {
                value = "summoning-renewal",
                label = "Summoning Renewal",
            },
            {
                value = "summoning-renewal-flask",
                label = "Summoning Renewal Flask",
            },
            {
                value = "super-adrenaline-flask",
                label = "Super Adrenaline Flask",
            },
            {
                value = "super-adrenaline-potion",
                label = "Super Adrenaline Potion",
            },
            {
                value = "super-antifire",
                label = "Super Antifire",
            },
            {
                value = "super-antifire-flask",
                label = "Super Antifire Flask",
            },
            {
                value = "super-antipoison",
                label = "Super Antipoison",
            },
            {
                value = "super-antipoison-flask",
                label = "Super Antipoison Flask",
            },
            {
                value = "super-antipoison-mix",
                label = "Super Antipoison Mix",
            },
            {
                value = "super-attack-mix",
                label = "Super Attack Mix",
            },
            {
                value = "super-attack-potion",
                label = "Super Attack Potion",
            },
            {
                value = "super-cooking-flask",
                label = "Super Cooking Flask",
            },
            {
                value = "super-cooking-potion",
                label = "Super Cooking Potion",
            },
            {
                value = "super-defence",
                label = "Super Defence",
            },
            {
                value = "super-defence-flask",
                label = "Super Defence Flask",
            },
            {
                value = "super-defence-mix",
                label = "Super Defence Mix",
            },
            {
                value = "super-divination",
                label = "Super Divination",
            },
            {
                value = "super-divination-flask",
                label = "Super Divination Flask",
            },
            {
                value = "super-energy",
                label = "Super Energy",
            },
            {
                value = "super-energy-flask",
                label = "Super Energy Flask",
            },
            {
                value = "super-energy-mix",
                label = "Super Energy Mix",
            },
            {
                value = "super-fishing-explosive",
                label = "Super Fishing Explosive",
            },
            {
                value = "super-fishing-flask",
                label = "Super Fishing Flask",
            },
            {
                value = "super-fishing-potion",
                label = "Super Fishing Potion",
            },
            {
                value = "super-guthix-balance",
                label = "Super Guthix Balance",
            },
            {
                value = "super-guthix-brew-flask",
                label = "Super Guthix Brew Flask",
            },
            {
                value = "super-guthix-rest",
                label = "Super Guthix Rest",
            },
            {
                value = "super-hunter",
                label = "Super Hunter",
            },
            {
                value = "super-hunter-flask",
                label = "Super Hunter Flask",
            },
            {
                value = "super-invention",
                label = "Super Invention",
            },
            {
                value = "super-invention-flask",
                label = "Super Invention Flask",
            },
            {
                value = "super-magic-flask",
                label = "Super Magic Flask",
            },
            {
                value = "super-magic-mix",
                label = "Super Magic Mix",
            },
            {
                value = "super-magic-potion",
                label = "Super Magic Potion",
            },
            {
                value = "super-melee-potion",
                label = "Super Melee Potion",
            },
            {
                value = "super-mining-flask",
                label = "Super Mining Flask",
            },
            {
                value = "super-mining-potion",
                label = "Super Mining Potion",
            },
            {
                value = "super-necromancy",
                label = "Super Necromancy",
            },
            {
                value = "super-necromancy-flask",
                label = "Super Necromancy Flask",
            },
            {
                value = "super-prayer",
                label = "Super Prayer",
            },
            {
                value = "super-prayer-flask",
                label = "Super Prayer Flask",
            },
            {
                value = "super-prayer-renewal-potion",
                label = "Super Prayer Renewal Potion",
            },
            {
                value = "super-ranging-flask",
                label = "Super Ranging Flask",
            },
            {
                value = "super-ranging-mix",
                label = "Super Ranging Mix",
            },
            {
                value = "super-ranging-potion",
                label = "Super Ranging Potion",
            },
            {
                value = "super-restore",
                label = "Super Restore",
            },
            {
                value = "super-restore-flask",
                label = "Super Restore Flask",
            },
            {
                value = "super-restore-mix",
                label = "Super Restore Mix",
            },
            {
                value = "super-runecrafting",
                label = "Super Runecrafting",
            },
            {
                value = "super-runecrafting-flask",
                label = "Super Runecrafting Flask",
            },
            {
                value = "super-saradomin-brew",
                label = "Super Saradomin Brew",
            },
            {
                value = "super-saradomin-brew-flask",
                label = "Super Saradomin Brew Flask",
            },
            {
                value = "super-strength",
                label = "Super Strength",
            },
            {
                value = "super-strength-flask",
                label = "Super Strength Flask",
            },
            {
                value = "super-strength-mix",
                label = "Super Strength Mix",
            },
            {
                value = "super-warmaster-s-potion",
                label = "Super Warmaster S Potion",
            },
            {
                value = "super-woodcutting-flask",
                label = "Super Woodcutting Flask",
            },
            {
                value = "super-woodcutting-potion",
                label = "Super Woodcutting Potion",
            },
            {
                value = "super-zamorak-brew",
                label = "Super Zamorak Brew",
            },
            {
                value = "super-zamorak-brew-flask",
                label = "Super Zamorak Brew Flask",
            },
            {
                value = "supreme-attack-potion",
                label = "Supreme Attack Potion",
            },
            {
                value = "supreme-defence-potion",
                label = "Supreme Defence Potion",
            },
            {
                value = "supreme-magic-potion",
                label = "Supreme Magic Potion",
            },
            {
                value = "supreme-overload",
                label = "Supreme Overload",
            },
            {
                value = "supreme-overload-potion",
                label = "Supreme Overload Potion",
            },
            {
                value = "supreme-overload-salve",
                label = "Supreme Overload Salve",
            },
            {
                value = "supreme-ranging-potion",
                label = "Supreme Ranging Potion",
            },
            {
                value = "supreme-strength-potion",
                label = "Supreme Strength Potion",
            },
            {
                value = "survivalist-s-potion",
                label = "Survivalist S Potion",
            },
            {
                value = "tarromin-potion",
                label = "Tarromin Potion",
            },
            {
                value = "toadflax-potion",
                label = "Toadflax Potion",
            },
            {
                value = "torstol-potion",
                label = "Torstol Potion",
            },
            {
                value = "troll-potion",
                label = "Troll Potion",
            },
            {
                value = "ugune-potion",
                label = "Ugune Potion",
            },
            {
                value = "ultra-growth-potion",
                label = "Ultra Growth Potion",
            },
            {
                value = "ushabti",
                label = "Ushabti",
            },
            {
                value = "valerian-potion",
                label = "Valerian Potion",
            },
            {
                value = "vecna-skull",
                label = "Vecna Skull",
            },
            {
                value = "vial",
                label = "Vial",
            },
            {
                value = "vial-of-mountain-water",
                label = "Vial Of Mountain Water",
            },
            {
                value = "vial-of-stench",
                label = "Vial Of Stench",
            },
            {
                value = "vial-of-water",
                label = "Vial Of Water",
            },
            {
                value = "vial-of-water-pack",
                label = "Vial Of Water Pack",
            },
            {
                value = "vial-pack",
                label = "Vial Pack",
            },
            {
                value = "vis-wax",
                label = "Vis Wax",
            },
            {
                value = "vulnerability-bomb",
                label = "Vulnerability Bomb",
            },
            {
                value = "waking-sleep-vial",
                label = "Waking Sleep Vial",
            },
            {
                value = "weak-artisan-s-potion",
                label = "Weak Artisan S Potion",
            },
            {
                value = "weak-cure-potion",
                label = "Weak Cure Potion",
            },
            {
                value = "weak-defence-potion",
                label = "Weak Defence Potion",
            },
            {
                value = "weak-gatherer-s-potion",
                label = "Weak Gatherer S Potion",
            },
            {
                value = "weak-magic-potion",
                label = "Weak Magic Potion",
            },
            {
                value = "weak-melee-potion",
                label = "Weak Melee Potion",
            },
            {
                value = "weak-naturalist-s-potion",
                label = "Weak Naturalist S Potion",
            },
            {
                value = "weak-necromancy-potion",
                label = "Weak Necromancy Potion",
            },
            {
                value = "weak-ranged-potion",
                label = "Weak Ranged Potion",
            },
            {
                value = "weak-rejuvenation-potion",
                label = "Weak Rejuvenation Potion",
            },
            {
                value = "weak-stat-restore-potion",
                label = "Weak Stat Restore Potion",
            },
            {
                value = "weak-survivalist-s-potion",
                label = "Weak Survivalist S Potion",
            },
            {
                value = "weak-weapon-poison",
                label = "Weak Weapon Poison",
            },
            {
                value = "weapon-poison",
                label = "Weapon Poison",
            },
            {
                value = "weapon-poison-flask",
                label = "Weapon Poison Flask",
            },
            {
                value = "wergali-potion",
                label = "Wergali Potion",
            },
            {
                value = "winter-s-grip-potion",
                label = "Winter S Grip Potion",
            },
            {
                value = "wood-spirit",
                label = "Wood Spirit",
            },
            {
                value = "woodcutting-flask",
                label = "Woodcutting Flask",
            },
            {
                value = "woodcutting-potion",
                label = "Woodcutting Potion",
            },
            {
                value = "wormwood-potion",
                label = "Wormwood Potion",
            },
            {
                value = "wyrmfire-potion",
                label = "Wyrmfire Potion",
            },
            {
                value = "yeti-curse-cure",
                label = "Yeti Curse Cure",
            },
            {
                value = "zamorak-brew",
                label = "Zamorak Brew",
            },
            {
                value = "zamorak-brew-flask",
                label = "Zamorak Brew Flask",
            },
            {
                value = "zamorak-mix",
                label = "Zamorak Mix",
            },
            {
                value = "zamorak-s-favour",
                label = "Zamorak S Favour",
            },
            {
                value = "zamorak-s-favour-flask",
                label = "Zamorak S Favour Flask",
            },
        },
        form = {
            {
                value = "burnt",
                label = "Burnt",
            },
            {
                value = "damaged",
                label = "Damaged",
            },
            {
                value = "grimy",
                label = "Grimy",
            },
            {
                value = "raw",
                label = "Raw",
            },
            {
                value = "unfinished",
                label = "Unfinished",
            },
        },
        geTradeable = {
            {
                value = true,
                label = "true",
            },
        },
        members = {
            {
                value = false,
                label = "false",
            },
            {
                value = true,
                label = "true",
            },
        },
        reclaimSources = {
            {
                value = "diango",
                label = "Diango",
            },
        },
        reclaimable = {
            {
                value = true,
                label = "true",
            },
        },
        roles = {
            {
                value = "activity-points",
                label = "Activity Points",
            },
            {
                value = "activity-reset",
                label = "Activity Reset",
            },
            {
                value = "alchemy",
                label = "Alchemy",
            },
            {
                value = "ammunition-production",
                label = "Ammunition Production",
            },
            {
                value = "boss-entry",
                label = "Boss Entry",
            },
            {
                value = "buff",
                label = "Buff",
            },
            {
                value = "clue-required",
                label = "Clue Required",
            },
            {
                value = "combat",
                label = "Combat",
            },
            {
                value = "compost-production",
                label = "Compost Production",
            },
            {
                value = "cooldown-reset",
                label = "Cooldown Reset",
            },
            {
                value = "damage-enhancer",
                label = "Damage Enhancer",
            },
            {
                value = "desert-protection",
                label = "Desert Protection",
            },
            {
                value = "disassembly",
                label = "Disassembly",
            },
            {
                value = "drop-enhancer",
                label = "Drop Enhancer",
            },
            {
                value = "equipment-production",
                label = "Equipment Production",
            },
            {
                value = "equipment-upgrade-task",
                label = "Equipment Upgrade Task",
            },
            {
                value = "exchange-for-coins",
                label = "Exchange For Coins",
            },
            {
                value = "familiar",
                label = "Familiar",
            },
            {
                value = "gathering-boost",
                label = "Gathering Boost",
            },
            {
                value = "ghast-protection",
                label = "Ghast Protection",
            },
            {
                value = "healing",
                label = "Healing",
            },
            {
                value = "item-noting",
                label = "Item Noting",
            },
            {
                value = "loot-reroll",
                label = "Loot Reroll",
            },
            {
                value = "lore",
                label = "Lore",
            },
            {
                value = "pet-unlock",
                label = "Pet Unlock",
            },
            {
                value = "pouch-production",
                label = "Pouch Production",
            },
            {
                value = "prayer-restoration",
                label = "Prayer Restoration",
            },
            {
                value = "processing",
                label = "Processing",
            },
            {
                value = "recharge",
                label = "Recharge",
            },
            {
                value = "reputation",
                label = "Reputation",
            },
            {
                value = "reward",
                label = "Reward",
            },
            {
                value = "reward-container",
                label = "Reward Container",
            },
            {
                value = "reward-exchange",
                label = "Reward Exchange",
            },
            {
                value = "ritual",
                label = "Ritual",
            },
            {
                value = "skilling",
                label = "Skilling",
            },
            {
                value = "skilling-outfit",
                label = "Skilling Outfit",
            },
            {
                value = "slayer-assignment",
                label = "Slayer Assignment",
            },
            {
                value = "soul-capture",
                label = "Soul Capture",
            },
            {
                value = "stat-boost",
                label = "Stat Boost",
            },
            {
                value = "teleport",
                label = "Teleport",
            },
            {
                value = "training",
                label = "Training",
            },
            {
                value = "treasure-trail-reward",
                label = "Treasure Trail Reward",
            },
            {
                value = "upgrade",
                label = "Upgrade",
            },
            {
                value = "xp-boost",
                label = "Xp Boost",
            },
        },
        set = {
            {
                value = "barrows-equipment",
                label = "Barrows Equipment",
            },
            {
                value = "dragonstone-armour",
                label = "Dragonstone Armour",
            },
            {
                value = "hunter-gear",
                label = "Hunter Gear",
            },
            {
                value = "imphide-equipment",
                label = "Imphide Equipment",
            },
            {
                value = "infinity-robes",
                label = "Infinity Robes",
            },
            {
                value = "lunar-equipment",
                label = "Lunar Equipment",
            },
            {
                value = "moonclan-outfit",
                label = "Moonclan Outfit",
            },
            {
                value = "mystic-equipment",
                label = "Mystic Equipment",
            },
            {
                value = "pirate-clothing",
                label = "Pirate Clothing",
            },
            {
                value = "robes-rometti-s-fine-fashions",
                label = "Robes Rometti S Fine Fashions",
            },
            {
                value = "spider-silk-equipment",
                label = "Spider Silk Equipment",
            },
            {
                value = "temple-knight-armour",
                label = "Temple Knight Armour",
            },
            {
                value = "villager-outfit",
                label = "Villager Outfit",
            },
            {
                value = "void-knight-equipment",
                label = "Void Knight Equipment",
            },
            {
                value = "wizard-robes",
                label = "Wizard Robes",
            },
        },
        skills = {
            {
                value = "agility",
                label = "Agility",
            },
            {
                value = "archaeology",
                label = "Archaeology",
            },
            {
                value = "construction",
                label = "Construction",
            },
            {
                value = "cooking",
                label = "Cooking",
            },
            {
                value = "crafting",
                label = "Crafting",
            },
            {
                value = "divination",
                label = "Divination",
            },
            {
                value = "dungeoneering",
                label = "Dungeoneering",
            },
            {
                value = "farming",
                label = "Farming",
            },
            {
                value = "firemaking",
                label = "Firemaking",
            },
            {
                value = "fishing",
                label = "Fishing",
            },
            {
                value = "fletching",
                label = "Fletching",
            },
            {
                value = "herblore",
                label = "Herblore",
            },
            {
                value = "hunter",
                label = "Hunter",
            },
            {
                value = "invention",
                label = "Invention",
            },
            {
                value = "magic",
                label = "Magic",
            },
            {
                value = "mining",
                label = "Mining",
            },
            {
                value = "necromancy",
                label = "Necromancy",
            },
            {
                value = "prayer",
                label = "Prayer",
            },
            {
                value = "runecrafting",
                label = "Runecrafting",
            },
            {
                value = "slayer",
                label = "Slayer",
            },
            {
                value = "smithing",
                label = "Smithing",
            },
            {
                value = "summoning",
                label = "Summoning",
            },
            {
                value = "thieving",
                label = "Thieving",
            },
            {
                value = "woodcutting",
                label = "Woodcutting",
            },
        },
        slot = {
            {
                value = "ammunition",
                label = "Ammunition",
            },
            {
                value = "back",
                label = "Back",
            },
            {
                value = "body",
                label = "Body",
            },
            {
                value = "feet",
                label = "Feet",
            },
            {
                value = "hands",
                label = "Hands",
            },
            {
                value = "head",
                label = "Head",
            },
            {
                value = "legs",
                label = "Legs",
            },
            {
                value = "main-hand",
                label = "Main Hand",
            },
            {
                value = "neck",
                label = "Neck",
            },
            {
                value = "off-hand",
                label = "Off Hand",
            },
            {
                value = "pocket",
                label = "Pocket",
            },
            {
                value = "ring",
                label = "Ring",
            },
            {
                value = "two-hand",
                label = "Two Hand",
            },
        },
        storageLocations = {
            {
                value = "armour-case",
                label = "Armour Case",
            },
            {
                value = "cape-store",
                label = "Cape Store",
            },
            {
                value = "fancy-dress-box",
                label = "Fancy Dress Box",
            },
            {
                value = "magic-wardrobe",
                label = "Magic Wardrobe",
            },
        },
        subtype = {
            {
                value = "artefact",
                label = "Artefact",
            },
            {
                value = "gem",
                label = "Gem",
            },
            {
                value = "logs",
                label = "Logs",
            },
            {
                value = "ore",
                label = "Ore",
            },
        },
        tier = {
            {
                value = 1,
                label = "1",
            },
            {
                value = 4,
                label = "4",
            },
            {
                value = 5,
                label = "5",
            },
            {
                value = 6,
                label = "6",
            },
            {
                value = 7,
                label = "7",
            },
            {
                value = 8,
                label = "8",
            },
            {
                value = 10,
                label = "10",
            },
            {
                value = 11,
                label = "11",
            },
            {
                value = 13,
                label = "13",
            },
            {
                value = 15,
                label = "15",
            },
            {
                value = 16,
                label = "16",
            },
            {
                value = 18,
                label = "18",
            },
            {
                value = 19,
                label = "19",
            },
            {
                value = 20,
                label = "20",
            },
            {
                value = 21,
                label = "21",
            },
            {
                value = 22,
                label = "22",
            },
            {
                value = 23,
                label = "23",
            },
            {
                value = 25,
                label = "25",
            },
            {
                value = 28,
                label = "28",
            },
            {
                value = 30,
                label = "30",
            },
            {
                value = 31,
                label = "31",
            },
            {
                value = 32,
                label = "32",
            },
            {
                value = 33,
                label = "33",
            },
            {
                value = 35,
                label = "35",
            },
            {
                value = 36,
                label = "36",
            },
            {
                value = 38,
                label = "38",
            },
            {
                value = 40,
                label = "40",
            },
            {
                value = 41,
                label = "41",
            },
            {
                value = 42,
                label = "42",
            },
            {
                value = 43,
                label = "43",
            },
            {
                value = 45,
                label = "45",
            },
            {
                value = 48,
                label = "48",
            },
            {
                value = 50,
                label = "50",
            },
            {
                value = 51,
                label = "51",
            },
            {
                value = 52,
                label = "52",
            },
            {
                value = 53,
                label = "53",
            },
            {
                value = 54,
                label = "54",
            },
            {
                value = 55,
                label = "55",
            },
            {
                value = 57,
                label = "57",
            },
            {
                value = 58,
                label = "58",
            },
            {
                value = 60,
                label = "60",
            },
            {
                value = 61,
                label = "61",
            },
            {
                value = 62,
                label = "62",
            },
            {
                value = 63,
                label = "63",
            },
            {
                value = 65,
                label = "65",
            },
            {
                value = 66,
                label = "66",
            },
            {
                value = 68,
                label = "68",
            },
            {
                value = 70,
                label = "70",
            },
            {
                value = 71,
                label = "71",
            },
            {
                value = 72,
                label = "72",
            },
            {
                value = 73,
                label = "73",
            },
            {
                value = 74,
                label = "74",
            },
            {
                value = 75,
                label = "75",
            },
            {
                value = 76,
                label = "76",
            },
            {
                value = 77,
                label = "77",
            },
            {
                value = 78,
                label = "78",
            },
            {
                value = 79,
                label = "79",
            },
            {
                value = 80,
                label = "80",
            },
            {
                value = 81,
                label = "81",
            },
            {
                value = 82,
                label = "82",
            },
            {
                value = 83,
                label = "83",
            },
            {
                value = 84,
                label = "84",
            },
            {
                value = 85,
                label = "85",
            },
            {
                value = 86,
                label = "86",
            },
            {
                value = 87,
                label = "87",
            },
            {
                value = 88,
                label = "88",
            },
            {
                value = 89,
                label = "89",
            },
            {
                value = 90,
                label = "90",
            },
            {
                value = 92,
                label = "92",
            },
            {
                value = 94,
                label = "94",
            },
            {
                value = 95,
                label = "95",
            },
            {
                value = 97,
                label = "97",
            },
            {
                value = 99,
                label = "99",
            },
            {
                value = 100,
                label = "100",
            },
            {
                value = 114,
                label = "114",
            },
        },
        tradeable = {
            {
                value = true,
                label = "true",
            },
        },
        types = {
            {
                value = "ammunition",
                label = "Ammunition",
            },
            {
                value = "armour",
                label = "Armour",
            },
            {
                value = "book",
                label = "Book",
            },
            {
                value = "collectible",
                label = "Collectible",
            },
            {
                value = "component",
                label = "Component",
            },
            {
                value = "consumable",
                label = "Consumable",
            },
            {
                value = "container",
                label = "Container",
            },
            {
                value = "cosmetic",
                label = "Cosmetic",
            },
            {
                value = "currency",
                label = "Currency",
            },
            {
                value = "drink",
                label = "Drink",
            },
            {
                value = "equipment",
                label = "Equipment",
            },
            {
                value = "familiar-pouch",
                label = "Familiar Pouch",
            },
            {
                value = "familiar-scroll",
                label = "Familiar Scroll",
            },
            {
                value = "food",
                label = "Food",
            },
            {
                value = "herb",
                label = "Herb",
            },
            {
                value = "incense",
                label = "Incense",
            },
            {
                value = "ingredient",
                label = "Ingredient",
            },
            {
                value = "jewellery",
                label = "Jewellery",
            },
            {
                value = "key",
                label = "Key",
            },
            {
                value = "light-source",
                label = "Light Source",
            },
            {
                value = "material",
                label = "Material",
            },
            {
                value = "pet",
                label = "Pet",
            },
            {
                value = "potion",
                label = "Potion",
            },
            {
                value = "produce",
                label = "Produce",
            },
            {
                value = "quest-item",
                label = "Quest Item",
            },
            {
                value = "resource",
                label = "Resource",
            },
            {
                value = "rune",
                label = "Rune",
            },
            {
                value = "salvage",
                label = "Salvage",
            },
            {
                value = "seed",
                label = "Seed",
            },
            {
                value = "summoning-ingredient",
                label = "Summoning Ingredient",
            },
            {
                value = "tool",
                label = "Tool",
            },
            {
                value = "toy",
                label = "Toy",
            },
            {
                value = "unlock",
                label = "Unlock",
            },
            {
                value = "weapon",
                label = "Weapon",
            },
            {
                value = "xp-item",
                label = "Xp Item",
            },
        },
        weaponType = {
            {
                value = "battleaxe",
                label = "Battleaxe",
            },
            {
                value = "bow",
                label = "Bow",
            },
            {
                value = "crossbow",
                label = "Crossbow",
            },
            {
                value = "dagger",
                label = "Dagger",
            },
            {
                value = "halberd",
                label = "Halberd",
            },
            {
                value = "longsword",
                label = "Longsword",
            },
            {
                value = "mace",
                label = "Mace",
            },
            {
                value = "maul",
                label = "Maul",
            },
            {
                value = "scimitar",
                label = "Scimitar",
            },
            {
                value = "shortsword",
                label = "Shortsword",
            },
            {
                value = "staff",
                label = "Staff",
            },
            {
                value = "two-handed-sword",
                label = "Two Handed Sword",
            },
            {
                value = "wand",
                label = "Wand",
            },
            {
                value = "warhammer",
                label = "Warhammer",
            },
        },
    },
}
