// Call of Duty: World at War
// #ID = 34831

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
    ])
]

for mission in missions {
    assert(length(mission.checkpoints) == 12, "Check length is 12")
    achievement(
        title = mission.title,
        description = "defeat mission on any difficulty",
        points = 5,
        trigger = (
            (
                ascii_string_equals(
                    address = 0x008691bd,
                    string = mission.key,
                    length = 12,
                    transform = a => prev(a)
                ) ||
                ascii_string_equals(
                    address = 0x006f26f0,
                    string = mission.key,
                    length = 12,
                    transform = a => prev(a)
                )
            ) && (
                ascii_string_equals(
                    address = 0x008691bd,
                    string = mission.next_key,
                    length = 12
                ) ||
                ascii_string_equals(
                    address = 0x006f26f0,
                    string = mission.next_key,
                    length = 12
                )
            )
        ),
        type = "progression"
    )
}