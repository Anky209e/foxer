extends Node


const SAVE_PATH = "res://savegame.json"

func saveGame():
	var file = FileAccess.open(SAVE_PATH,FileAccess.WRITE)
	var data:Dictionary = {
		"PLAYER_HP":Game.PLAYER_HP,
		"GOLD":Game.GOLD,
	}
	var json_load = JSON.stringify(data)
	file.store_line(json_load)

func loadGame():
	var file = FileAccess.open(SAVE_PATH,FileAccess.READ)
	if FileAccess.file_exists(SAVE_PATH) == true:
		if not file.eof_reached():
			var data = JSON.parse_string(file.get_line())
			if data:
				Game.PLAYER_HP = data["PLAYER_HP"]
				Game.GOLD = data["GOLD"]
