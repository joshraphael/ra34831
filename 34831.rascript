// Call of Duty: World at War
// #ID = 34831


function MapName() => 0x006f26f0
function MissionTimer() => dword_be(0x007238d8)
function Difficulty() => word_be(0x0077032a)
function CurrentWeapon() => word_be(0x00727cbe)
function IronSights() => word_be(0x006d308e)
function FlamethrowerAmmo() => dword_be(0x00727dbc)
function FlamethrowerAmmo2() => dword_be(0x00727dc0)
function FlamethrowerTankAmmo() => word_be(0x0083c9c6)
function Checkpoint() => 0x008691a0
function CheckpointSubstring1() => 0x008691bd
function CheckpointSubstring2() => 0x008691c1
function CheckpointSubstring3() => 0x008691c5
function CheckpointSubstring4() => 0x008691ca

// Relentless - Deployable Browning M1919
// Eviction - PPSh-41
function ClipAmmo1() => word_be(0x00727de0)

// Ring of Steel - PPSh-41
function ClipAmmo2() => word_be(0x00727de2)

// Level 1 - Grenades
function ClipAmmo9() => word_be(0x00727df0)

// Level 2 - Type 100
function ClipAmmo4() => word_be(0x00727de6)

// Hard Landing Part 1 - BAR
function ClipAmmo5() => word_be(0x00727de8)

// Breaking Point - Thompson
function ClipAmmo3() => word_be(0x00727de4)

function Stance() => word_be(0x00727cee)

// Level 2 - Air Strike
function Ammo1() => word_be(0x00727dfa)

class Mission {
    title = ""
    key = ""
    next_key = ""
    regular_title = ""
    veteran_title = ""
    challenge_title = ""
    challenge_description = ""
    challenge_trigger = always_false()
    progression_badge_id = ""
    veteran_badge_id = ""
    challenge_badge_id = ""
    win_condition = false
}

difficulties = {
    0x0000: "Recruit",
    0x0001: "Regular",
    0x0002: "Hardened",
    0x0003: "Veteran"
}

leaderboard_ids = [
    152625, // start
    152684 // end
]

// missionMap = {
//     "mak": "Semper Fi",
//     "pel1": "Little Resistance",
//     "pel2a": "Hard Landing (Part 1)",
//     "pel2b": "Hard Landing (Part 2)",
//     "sniper": "Vendetta",
//     "see1": "Their Land, Their Blood",
//     "pel1a": "Burn 'em Out",
//     "pel1b": "Relentless",
//     "see2": "Blood & Iron",
//     "ber1": "Ring of Steel",
//     "ber2": "Eviction",
//     "oki2": "Blowtorch & Corkscrew",
//     "oki3": "Breaking Point",
//     "ber3": "Heart of the Reich",
//     "ber3b": "Downfall"
// }

function ChallengeTrigger(map_start_str, map_end_str, start_checkpoint_addr, start_checkpoint_str, reset_trigger) {
    return (
        ascii_string_equals(
            address = MapName(),
            string = map_start_str,
            length = 12,
            transform = a => prev(a)
        ) &&
        (
            Difficulty() == 0x0002 ||
            Difficulty() == 0x0003
        ) && 
        once(
            MissionTimer() == 0
        ) &&
        once(
            ascii_string_equals(
                address = start_checkpoint_addr,
                string = start_checkpoint_str,
                length = 12
            )
        ) &&
        trigger_when(
            ascii_string_equals(
                address = MapName(),
                string = map_end_str,
                length = 12
            )
        ) &&
        never(
            reset_trigger ||
            ascii_string_equals(
                address = MapName(),
                string = "ui",
                length = 12
            )
        )
    )
}

missions = [
    Mission("Semper Fi", "mak", "pel1", "Night Attack", "No Longer M.I.A.", "Cold Potato", "Complete \"Semper Fi\" on Hardened or Veteran difficulty without using the Type 100 SMG.", (
        ascii_string_equals(
            address = MapName(),
             string = "mak",
            length = 12,
            transform = a => prev(a)
        ) &&
        (
            Difficulty() == 0x0002 ||
            Difficulty() == 0x0003
        ) && 
        once(
            MissionTimer() == 0
        ) && (
            once(
                ascii_string_equals(
                    address = Checkpoint(),
                    string = "$default",
                    length = 12
                )
            ) ||
            once(
                ascii_string_equals(
                    address = CheckpointSubstring1(),
                    string = "makstart",
                    length = 12
                )
            )
        ) &&
        trigger_when(
            ascii_string_equals(
                address = MapName(),
                string = "pel1",
                length = 12
            )
        ) &&
        never(
            CurrentWeapon() == 0x0004 && // Type 100
            prev(CurrentWeapon()) == CurrentWeapon() &&
            ClipAmmo1() < prev(ClipAmmo1()) ||
            ascii_string_equals(
                address = MapName(),
                string = "ui",
                length = 12
            )
        )
    ), "682987", "682988", "682989"),
    Mission("Little Resistance", "pel1", "pel2a", "Beach Front", "There Was in Fact Heavy Resistance", "Take Aim", "Complete \"Little Resistance\" on Hardened or Veteran difficulty without using the Type 100 SMG.", 
        ChallengeTrigger(
            "pel1",
            "pel2a",
            CheckpointSubstring1(),
            "pel1start",
            (
                CurrentWeapon() == 0x000f && // Type 100
                prev(CurrentWeapon()) == CurrentWeapon() &&
                ClipAmmo4() < prev(ClipAmmo4())
            )
        ),
        "682990",
        "682991",
        "682992"
    ),
    Mission("Hard Landing Part 1", "pel2a", "pel2b_load", "Keep Dry", "Out of the Frying Pan...", "Watch the Tree Line", "Complete \"Hard Landing Part 1\" on Hardened or Veteran difficulty without using the BAR.", 
        ChallengeTrigger(
            "pel2a",
            "pel2b_load",
            CheckpointSubstring1(),
            "pel2astart",
            (
                CurrentWeapon() == 0x0009 && // BAR
                prev(CurrentWeapon()) == CurrentWeapon() &&
                ClipAmmo5() < prev(ClipAmmo5())
            )
        ),
        "682993",
        "682994",
        "682995"
    ),
    Mission("Hard Landing Part 2", "pel2b", "sniper", "Crumble", "...Into the Fire", "Bullets Are Better", "Complete \"Hard Landing Part 2\" on Hardened or Veteran difficulty without using the M2 Flamethrower.",
        ChallengeTrigger(
            "pel2b",
            "sniper",
            CheckpointSubstring1(),
            "pel2bstart",
            (
                CurrentWeapon() == 0x0011 && // Flamethrower
                prev(CurrentWeapon()) == CurrentWeapon() &&
                FlamethrowerAmmo() != 0x00000000
            )
        ),
        "682996",
        "682997",
        "682998"
    ),
    Mission("Vendetta", "sniper", "see1", "Like a Rat", "Survivor of Stalingrad", "No Scope", "Complete \"Vendetta\" on Hardened or Veteran difficulty without aiming down sights.",
    (
        ChallengeTrigger(
            "sniper",
            "see1",
            CheckpointSubstring1(),
            "sniperstart",
            (
                IronSights() == 0x0001
            )
        )
    ),
    "682999", "683000", "683001"),
    Mission("Their Land, Their Blood", "see1", "pel1a", "Schrek'd", "Now It Is Their Land...Their People...Their Blood", "Stand Tall", "Complete \"Their Land, Their Blood\" on Hardened or Veteran difficulty without crouching or riding a tank.",
        ChallengeTrigger(
            "see1",
            "pel1a",
            CheckpointSubstring1(),
            "see1start",
            (
                Stance() == 0x0028
            )
        ),
        "683003",
        "683004",
        "683005"
    ),
    Mission("Burn 'em Out", "pel1a", "pel1b", "Trench Warfare", "As Opposed to Snuff 'em Out", "Save the Trees", "Complete \"Burn 'em Out\" on Hardened or Veteran difficulty without using the M2 Flamethrower.",
        ChallengeTrigger(
            "pel1a",
            "pel1b",
            CheckpointSubstring1(),
            "pel1astart",
            (
                CurrentWeapon() == 0x0014 && // Flamethrower
                prev(CurrentWeapon()) == CurrentWeapon() &&
                FlamethrowerAmmo() != 0x00000000
            )
        ),
        "683006",
        "683007",
        "683008"
    ),
    Mission("Relentless", "pel1b", "see2", "Not Scared of the Dark", "We Got Straight to the Point", "Too Heavy for Me", "Complete \"Relentless\" on Hardened or Veteran difficulty without using the Deployable Browning M1919.",
        ChallengeTrigger(
            "pel1b",
            "see2",
            CheckpointSubstring1(),
            "pel1bstart",
            (
                CurrentWeapon() == 0x0008 && // Deployable Browning M1919
                prev(CurrentWeapon()) == CurrentWeapon() &&
                ClipAmmo1() < prev(ClipAmmo1())
            )
        ),
        "683009",
        "683010",
        "683011"
    ),
    Mission("Blood & Iron", "see2", "ber1", "Invincible", "The Cold Steel of a T-34", "Keeping Cool", "Complete \"Blood & Iron\" on Hardened or Veteran difficulty without using the tank's flamethrower.",
        ChallengeTrigger(
            "see2",
            "ber1",
            CheckpointSubstring1(),
            "see2start",
            (
                prev(FlamethrowerTankAmmo()) == 0x0000 &&
                FlamethrowerTankAmmo() != 0x0000
            )
        ),
        "683012",
        "683013",
        "683014"
    ),
    Mission("Ring of Steel", "ber1", "ber2", "The Invasion Begins", "Deeper Into the Heart of Berlin", "Making Space", "Complete \"Ring of Steel\" on Hardened or Veteran difficulty without using the PPSh-41.",
        ChallengeTrigger(
            "ber1",
            "ber2",
            CheckpointSubstring1(),
            "ber1start",
            (
                CurrentWeapon() == 0x0008 && // PPSh-41
                prev(CurrentWeapon()) == CurrentWeapon() &&
                ClipAmmo2() < prev(ClipAmmo2())
            )
        ),
        "683015",
        "683016",
        "683017"
    ),
    Mission("Eviction", "ber2", "oki2", "Sewer Dweller", "A Flood Will Not Stop Us", "Hallow Halls", "Complete \"Eviction\" on Hardened or Veteran difficulty without using the PPSh-41.",
        ChallengeTrigger(
            "ber2",
            "oki2",
            CheckpointSubstring1(),
            "ber2start",
            (
                CurrentWeapon() == 0x0003 && // PPSh-41
                prev(CurrentWeapon()) == CurrentWeapon() &&
                ClipAmmo1() < prev(ClipAmmo1())
            )
        ),
        "683018",
        "683019",
        "683020"
    ),
    Mission("Blowtorch & Corkscrew", "oki2", "oki3", "Bunker Boom", "More Like Rain and Mud", "Storm Stormer", "Complete \"Blowtorch & Corkscrew\" on Hardened or Veteran difficulty without using the M2 Flamethrower.",
        ChallengeTrigger(
            "oki2",
            "oki3",
            CheckpointSubstring1(),
            "oki2start",
            (
                CurrentWeapon() == 0x0016 && // Flamethrower
                prev(CurrentWeapon()) == CurrentWeapon() &&
                FlamethrowerAmmo2() != 0x00000000
            )
        ),
        "683021",
        "683022",
        "683023"
    ),
    Mission("Breaking Point", "oki3", "ber3", "Stronghold Secured", "One War Finishes, Another Continues", "Stopping Tommy", "Complete \"Breaking Point\" on Hardened or Veteran difficulty without using the Thompson.",
        ChallengeTrigger(
            "oki3",
            "ber3",
            CheckpointSubstring1(),
            "oki3start",
            (
                CurrentWeapon() == 0x0006 && // Thompson
                prev(CurrentWeapon()) == CurrentWeapon() &&
                ClipAmmo3() < prev(ClipAmmo3())
            )
        ),
        "683024",
        "683025",
        "683026"
    ),
    Mission("Heart of the Reich", "ber3", "ber3b", "Deep", "I Survived the Grenade Spam of 1945", "Eye of the Storm", "Complete \"Heart of the Reich\" on Hardened or Veteran difficulty without aiming down sights.",
    (
        ChallengeTrigger(
            "ber3",
            "ber3b",
            CheckpointSubstring2(),
            "ber31",
            (
                IronSights() == 0x0001
            )
        )
    ),
    "683027", "683029", "683030"),
    Mission("Downfall", "ber3b", "outro", "Wave Your Flag", "A Hero to the Motherland", "Uprise", "Complete \"Downfall\" on Hardened or Veteran difficulty without going prone.",
        ChallengeTrigger(
            "ber3b",
            "outro",
            CheckpointSubstring1(),
            "ber3bstart",
            (
                Stance() == 0x000b
            )
        ),
        "683031",
        "683032",
        "683033",
        true
    ),
]



achievement_start = 575590
achievement_offset = 0

leaderboard_start = 152625
leaderboard_offset = 0

for mission in missions {
    achievement_type = "progression"
    if mission.win_condition {
        achievement_type = "win_condition"
    }
    achievement(
        id = achievement_start + achievement_offset,
        title = mission.regular_title,
        badge = mission.progression_badge_id,
        description = format("Complete \"{0}\" on any difficulty.", mission.title),
        points = 5,
        trigger = (
            ascii_string_equals(
                address = MapName(),
                string = mission.key,
                length = 12,
                transform = a => prev(a)
            ) &&
            ascii_string_equals(
                address = MapName(),
                string = mission.next_key,
                length = 12
            )
        ),
        type = achievement_type
    )
    achievement_offset = achievement_offset + 1

    achievement(
        id = achievement_start + achievement_offset,
        title = mission.veteran_title,
        badge = mission.veteran_badge_id,
        description = format("Complete \"{0}\" on Veteran difficulty.", mission.title),
        points = 10,
        trigger = (
            Difficulty() == 0x0003 &&
            ascii_string_equals(
                address = MapName(),
                string = mission.key,
                length = 12,
                transform = a => prev(a)
            ) &&
            ascii_string_equals(
                address = MapName(),
                string = mission.next_key,
                length = 12
            )
        )
    )
    achievement_offset = achievement_offset + 1

    // temp achievments
    achievement(
        id = achievement_start + achievement_offset,
        title = mission.challenge_title,
        badge = mission.challenge_badge_id,
        description = mission.challenge_description,
        points = 10,
        trigger = mission.challenge_trigger,
        type = ""
    )
    achievement_offset = achievement_offset + 1

    for id in difficulties {
        leaderboard(
            id = leaderboard_start + leaderboard_offset,
            title = format("{0} Speedrun: {1}",  difficulties[id], mission.title),
            description = format("Complete {0} as fast as possible on {1} difficulty.", mission.title, difficulties[id]),
            start = (
                Difficulty() == id &&
                ascii_string_equals(
                    address = MapName(),
                    string = mission.key,
                    length = 12,
                    transform = a => prev(a)
                ) &&
                ascii_string_equals(
                    address = MapName(),
                    string = mission.next_key,
                    length = 12
                )
            ),
            cancel = always_false(),
            submit = always_true(),
            value = MissionTimer() * 0x06,
            format = "MILLISECS",
            lower_is_better = true
        )
        leaderboard_offset = leaderboard_offset + 1
    }
}

function isInTitle() {
    return ascii_string_equals(
        address = MapName(),
        string = "ui",
        length = 12
    )
}

// Need to make each individual mission its own rich presence lookup. RATools cant handle keys with similar strings in a dictionary

// Semper Fi
rich_presence_conditional_display(ascii_string_equals(
        address = MapName(),
        string = "mak",
        length = 12
    ),
    "Playing Semper Fi on {0}",
    rich_presence_lookup("Difficulty", Difficulty(), difficulties)
)

// Little Resistance
rich_presence_conditional_display(ascii_string_equals(
        address = MapName(),
        string = "pel1",
        length = 12
    ),
    "Playing Little Resistance on {0}",
    rich_presence_lookup("Difficulty", Difficulty(), difficulties)
)

// Hard Landing (Part 1)
rich_presence_conditional_display(ascii_string_equals(
        address = MapName(),
        string = "pel2a",
        length = 12
    ),
    "Playing Hard Landing (Part 1) on {0}",
    rich_presence_lookup("Difficulty", Difficulty(), difficulties)
)

// Loading
rich_presence_conditional_display(ascii_string_equals(
        address = MapName(),
        string = "pel2b_load",
        length = 12
    ),
    "Loading..."
)

// Hard Landing (Part 2)
rich_presence_conditional_display(ascii_string_equals(
        address = MapName(),
        string = "pel2b",
        length = 12
    ),
    "Playing Hard Landing (Part 2) on {0}",
    rich_presence_lookup("Difficulty", Difficulty(), difficulties)
)

// Vendetta
rich_presence_conditional_display(ascii_string_equals(
        address = MapName(),
        string = "sniper",
        length = 12
    ),
    "Playing Vendetta on {0}",
    rich_presence_lookup("Difficulty", Difficulty(), difficulties)
)

// Their Land, Their Blood
rich_presence_conditional_display(ascii_string_equals(
        address = MapName(),
        string = "see1",
        length = 12
    ),
    "Playing Their Land, Their Blood on {0}",
    rich_presence_lookup("Difficulty", Difficulty(), difficulties)
)

// Burn 'em Out
rich_presence_conditional_display(ascii_string_equals(
        address = MapName(),
        string = "pel1a",
        length = 12
    ),
    "Playing Burn 'em Out on {0}",
    rich_presence_lookup("Difficulty", Difficulty(), difficulties)
)

// Relentless
rich_presence_conditional_display(ascii_string_equals(
        address = MapName(),
        string = "pel1b",
        length = 12
    ),
    "Playing Relentless on {0}",
    rich_presence_lookup("Difficulty", Difficulty(), difficulties)
)

// Blood & Iron
rich_presence_conditional_display(ascii_string_equals(
        address = MapName(),
        string = "see2",
        length = 12
    ),
    "Playing Blood & Iron on {0}",
    rich_presence_lookup("Difficulty", Difficulty(), difficulties)
)

// Ring of Steel
rich_presence_conditional_display(ascii_string_equals(
        address = MapName(),
        string = "ber1",
        length = 12
    ),
    "Playing Ring of Steel on {0}",
    rich_presence_lookup("Difficulty", Difficulty(), difficulties)
)

// Eviction
rich_presence_conditional_display(ascii_string_equals(
        address = MapName(),
        string = "ber2",
        length = 12
    ),
    "Playing Eviction on {0}",
    rich_presence_lookup("Difficulty", Difficulty(), difficulties)
)

// Blowtorch & Corkscrew
rich_presence_conditional_display(ascii_string_equals(
        address = MapName(),
        string = "oki2",
        length = 12
    ),
    "Playing Blowtorch & Corkscrew on {0}",
    rich_presence_lookup("Difficulty", Difficulty(), difficulties)
)

// Breaking Point
rich_presence_conditional_display(ascii_string_equals(
        address = MapName(),
        string = "oki3",
        length = 12
    ),
    "Playing Breaking Point on {0}",
    rich_presence_lookup("Difficulty", Difficulty(), difficulties)
)

// Heart of the Reich
rich_presence_conditional_display(ascii_string_equals(
        address = MapName(),
        string = "ber3",
        length = 12
    ),
    "Playing Heart of the Reich on {0}",
    rich_presence_lookup("Difficulty", Difficulty(), difficulties)
)

// Downfall
rich_presence_conditional_display(ascii_string_equals(
        address = MapName(),
        string = "ber3b",
        length = 12
    ),
    "Playing Downfall on {0}",
    rich_presence_lookup("Difficulty", Difficulty(), difficulties)
)

rich_presence_display("Title Screen")