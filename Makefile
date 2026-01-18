SHELL := /bin/bash
SAVE_DIR := /mnt/c/Users/Joshua\ Raphael/AppData/Roaming/Dolphin\ Emulator/StateSaves
WII_ID := RVYE52
GAME_ID := 34831
SAVE_SLOT := 1
RASCRIPT_CLI := ~/Installs/rascript-cli/rascript-cli_v1.16.1_linux-x64
DOLPHIN_DIR := /mnt/c/Program\ Files/dolphin-2512-x64/Dolphin-x64

load:
	if [ -z "${checkpoint}" ]; then echo "empty checkpoint selected during load"; exit 1; fi;
	if [[ ${checkpoint} != @(makstart|mak1|mak2|mak3|mak4|mak5|mak6|mak7|mak8|mak9|mak10|makend|pel1start|pel11|pel12|pel13|pel14|pel15|pel16|pel17|pel18|pel1end|pel2astart|pel2a1|pel2a2|pel2a3|pel2a4|pel2a5|pel2a6|pel2a7|pel2a8|pel2aend|pel2bstart|pel2b1|pel2b2|pel2b3|pel2b4|pel2b5|pel2b6|pel2b7|pel2b8|pel2b9|pel2b10|pel2b11|pel2b12|pel2bend|sniperstart) ]]; then echo "invalid checkpoint selected to load: ${checkpoint}"; exit 1; fi;
	cp saves/${checkpoint}.sav ${SAVE_DIR}/${WII_ID}.s0${SAVE_SLOT}

compile:
	rm -f ${DOLPHIN_DIR}/RACache/Data/${GAME_ID}.json
	rm -f ${DOLPHIN_DIR}/RACache/Data/${GAME_ID}-User.txt
	rm -f ${DOLPHIN_DIR}/RACache/Data/${GAME_ID}-Rich.txt
	touch ${DOLPHIN_DIR}/RACache/Data/${GAME_ID}.json
	${RASCRIPT_CLI} -i ${GAME_ID}.rascript -o ${DOLPHIN_DIR}