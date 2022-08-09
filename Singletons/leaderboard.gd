extends Node

var player_name: String = ""
var player_score : int = 0

func _ready():
	SilentWolf.configure({
		"api_key": "tqOG5uimfN1sS0ylNmW36WmxpD5VTbp5BGfb5f48",
		"game_id": "QueenAnnesRevenge",
		"game_version": "1.0",
		"log_level": 1
	})
	
	SilentWolf.configure_scores({
		"open_scene_on_close": "res://GameWorld/Main Menu.tscn"
	})

func set_player_name(name):
	player_name = name

func set_player_score(score):
	player_score = score
