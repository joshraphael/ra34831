// Call of Duty: World at War
// #ID = 34831


function MapName() => 0x006f26f0
function MissionTimer() => dword_be(0x007238d8)
function Difficulty() => word_be(0x0077032a)

class Mission {
    title = ""
    key = ""
    next_key = ""
    checkpoints = []
}

difficulties = {
    0x0000: "Easy",
    0x0001: "Medium",
    0x0002: "Hard",
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
//     "ber3": "Heart of the Riech",
//     "ber3b": "Downfall"
// }

missions = [
    Mission("Semper Fi", "mak", "pel1", [
        "makstart",
        "mak1",
        "mak2",
        "mak3",
        "mak4",
        "mak5",
        "mak6",
        "mak7",
        "mak8",
        "mak9",
        "mak10",
        "makend"
    ]),
    Mission("Little Resistance", "pel1", "pel2a", []),
    Mission("Hard Landing (Part 1)", "pel2a", "pel2b_load", []),
    Mission("Hard Landing (Part 2)", "pel2b", "sniper", []),
    Mission("Vendetta", "sniper", "see1", []),
    Mission("Their Land, Their Blood", "see1", "pel1a", []),
    Mission("Burn 'em Out", "pel1a", "pel1b", []),
    Mission("Relentless", "pel1b", "see2", []),
    Mission("Blood & Iron", "see2", "ber1", []),
    Mission("Ring of Steel", "ber1", "ber2", []),
    Mission("Eviction", "ber2", "oki2", []),
    Mission("Blowtorch & Corkscrew", "oki2", "oki3", []),
    Mission("Breaking Point", "oki3", "oki3_load", []),
    Mission("Heart of the Riech", "ber3", "ber3b", []),
    Mission("Downfall", "ber3b", "outro", []),
]

achievement_start = 575590
achievement_offset = 0

leaderboard_start = 152625
leaderboard_offset = 0

for mission in missions {
    achievement(
        id = achievement_start + achievement_offset,
        title = mission.title,
        description = format("Complete {0} on any difficulty.", mission.title),
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
        type = "progression"
    )
    achievement_offset = achievement_offset + 1

    achievement(
        id = achievement_start + achievement_offset,
        title = format("Veteran {0}", mission.title),
        description = format("Complete {0} on verteran difficulty.", mission.title),
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
        title = format("TEMP: {0}", mission.title),
        description = format("TEMP: {0}", mission.title),
        points = 1,
        trigger = always_false(),
        type = ""
    )
    achievement_offset = achievement_offset + 1

    for id in difficulties {
        leaderboard(
            id = leaderboard_start + leaderboard_offset,
            title = format("{0} Speedrun: {1}",  difficulties[id], mission.title),
            description = format("Complete {0} as fast as possible on {1} difficulty.", mission.title, difficulties[id]),
            start = always_false(),
            cancel = always_false(),
            submit = (
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
            value = MissionTimer(),
            lower_is_better = true
        )
        leaderboard_offset = leaderboard_offset + 1
    }
}

function isInTitle() {
    return ascii_string_equals(MapName(), "ui")
}

rich_presence_conditional_display(isInTitle(), "Title Screen")
rich_presence_display("Playing Mission: {0} on {1}",
    rich_presence_value("mission", MapName()),
    rich_presence_lookup("Difficulty", Difficulty(), difficulties)
)