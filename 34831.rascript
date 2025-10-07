// Call of Duty: World at War
// #ID = 34831

function MapName() => 0x006f26f0
function MissionTimer() => dword_be(0x01691ae4)

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
    Mission("Hard Landing (Part 1)", "pel2a", "pel2b", []),
    Mission("Hard Landing (Part 2)", "pel2b", "sniper", []),
    Mission("Vendetta", "sniper", "ui", [])
]

for mission in missions {
    achievement(
        title = mission.title,
        description = "defeat mission on any difficulty",
        points = 5,
        trigger = (
            MissionTimer() > 0 &&
            ascii_string_equals(
                address = MapName(),
                string = mission.key,
                length = 4,
                transform = a => prev(a)
            ) &&
            ascii_string_equals(
                address = MapName(),
                string = mission.next_key,
                length = 4
            )
        ),
        type = "progression"
    )
}