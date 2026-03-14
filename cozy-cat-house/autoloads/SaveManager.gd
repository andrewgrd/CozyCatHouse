extends Node

const SAVE_PATH = "user://save.json"

var data: Dictionary = {}

func _ready() -> void:
	load_game()

func save_game() -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(data))
	file.close()

func load_game() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		data = _default_data()
		save_game()
		return
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	data = JSON.parse_string(file.get_as_text())
	file.close()

func _default_data() -> Dictionary:
	return {
		"coins": 0,
		"current_level": 1,
		"unlocked_cats": ["pirate", "scientist", "gardener", "sleepy"],
		"home_items": []
	}
