SHELL := /bin/bash
GAME_ID := 34831
RASCRIPT_CLI := ~/Installs/rascript-cli/rascript-cli_v1.16.1_linux-x64
DOLPHIN_DIR := /mnt/c/Program\ Files/dolphin-2512-x64/Dolphin-x64

compile:
	rm -f ${DOLPHIN_DIR}/RACache/Data/${GAME_ID}.json
	rm -f ${DOLPHIN_DIR}/RACache/Data/${GAME_ID}-User.txt
	rm -f ${DOLPHIN_DIR}/RACache/Data/${GAME_ID}-Rich.txt
	touch ${DOLPHIN_DIR}/RACache/Data/${GAME_ID}.json
	${RASCRIPT_CLI} -i ${GAME_ID}.rascript -o ${DOLPHIN_DIR}