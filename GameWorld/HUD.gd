extends CanvasLayer

onready var HealthBar := $VBoxContainer/HealthBar
onready var EnergyBar := $VBoxContainer/EnergyBar

var previous_energy : int = 0

func _ready():
	update_health(10)
	get_parent().get_node("Music").play(1.4)


func update_health(health: int):
	HealthBar.value = health

func set_max_health(max_health: int):
	HealthBar.max_value = max_health

func update_previous_energy(energy: int):
	previous_energy = energy

func update_energy(energy: int):
	$TweenHUD.interpolate_property(EnergyBar, "value", previous_energy, energy, .1,Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
	$TweenHUD.start()


func _on_Submit_pressed():
	var name = get_parent().get_node("GameOver/WindowDialog/LineEdit").text
	Leaderboard.set_player_name(name)
	SilentWolf.Scores.persist_score(Leaderboard.player_name, Leaderboard.player_score)
	SilentWolf.Scores.get_high_scores()
	get_parent().get_node("GameOver/WindowDialog").hide()
	load_leaderboard_screen()

func load_leaderboard_screen():
	get_tree().change_scene("res://addons/silent_wolf/Scores/Leaderboard.tscn")


func _on_Button_pressed():
	get_tree().reload_current_scene()
