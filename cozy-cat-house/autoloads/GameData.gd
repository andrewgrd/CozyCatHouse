extends Node

const GEM_TYPES := 6
const BOARD_COLS := 9
const BOARD_ROWS := 9

const CAT_DATA := {
	"pirate":     {"charge": 10, "ability": "explode_3x3"},
	"scientist":  {"charge": 12, "ability": "transform_5"},
	"gardener":   {"charge": 12, "ability": "remove_blocker"},
	"sleepy":     {"charge": 15, "ability": "add_moves"},
}
