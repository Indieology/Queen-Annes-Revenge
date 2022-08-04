extends CanvasLayer

onready var HealthBar := $VBoxContainer/HealthBar
onready var EnergyBar := $VBoxContainer/EnergyBar

var previous_energy : int = 0

func _ready():
	update_health(10)


func update_health(health: int):
	HealthBar.value = health

func set_max_health(max_health: int):
	HealthBar.max_value = max_health

func update_previous_energy(energy: int):
	previous_energy = energy

func update_energy(energy: int):
	$TweenHUD.interpolate_property(EnergyBar, "value", previous_energy, energy, .1,Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
	$TweenHUD.start()
