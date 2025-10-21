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

for mission in missions {
    achievement(
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

    achievement(
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
}