SHELL := /bin/bash
SAVE_DIR := /mnt/c/Users/Joshua\ Raphael/AppData/Roaming/Dolphin\ Emulator/StateSaves
WII_ID := RVYE52
RA_GAME_ID := 34831
SAVE_SLOT := 1

load:
	if [ -z "${checkpoint}" ]; then echo "empty checkpoint selected during load"; exit 1; fi;
	if [[ ${checkpoint} != @(makstart|mak1|mak2|mak3|mak4|mak5|mak6|mak7|mak8|mak9|makend) ]]; then echo "invalid checkpoint selected to load: ${checkpoint}"; exit 1; fi;
	cp saves/${checkpoint}.sav ${SAVE_DIR}/${WII_ID}.s0${SAVE_SLOT}