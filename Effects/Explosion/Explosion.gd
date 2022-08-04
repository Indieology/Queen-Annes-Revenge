extends Node2D

var rng = RandomNumberGenerator.new()

onready var sound = $Sound

func _ready():
	rng.randomize()
	
	$CPUParticles2D.emitting = false
	$CPUParticles2D2.emitting = false
	$CPUParticles2D3.emitting = false
	
	var random_number = rng.randi_range(1,3)
	match random_number:
		1:
			sound.stream = load("res://Sounds/Explosion/S_Fire_Throwing_Hit_1.wav")
		2:
			sound.stream = load("res://Sounds/Explosion/S_Fire_Throwing_Hit_2.wav")
		3:
			sound.stream = load("res://Sounds/Explosion/S_Fire_Throwing_Hit_3.wav")
	sound.play()
	


func _on_Timer_timeout():
	$CPUParticles2D.restart()
	$CPUParticles2D2.restart()
	$CPUParticles2D3.restart()


