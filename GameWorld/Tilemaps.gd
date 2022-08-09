extends Node2D

var orignal_position

export var map_mirror: int = 2350
export var scroll_speed: float = 1.5

onready var tween = $ScrollTween
onready var player = get_parent().get_node("Player")

var target_scroll_speed = scroll_speed

onready var wr = weakref(player)

func _ready():
	orignal_position = position
	increase_scroll_speed(scroll_speed)

func _physics_process(delta):
	position.y += scroll_speed
	
	if position.y > map_mirror:
		position = orignal_position
		target_scroll_speed += 1
		increase_scroll_speed(target_scroll_speed)
		var cannons = get_parent().get_node("Tilemaps/Cannons")
		var enemies = get_parent().get_node("Tilemaps/Enemies")
		
		for child in cannons.get_children():
			child.visible = true
			child.is_active = true
			child.set_deferred("monitorable", true) 
			if child.health <= 0:
				child.health += 1
		for child in enemies.get_children():
			child.visible = true
			child.is_active = true
			child.get_node("Hurtbox").set_deferred("monitorable", true)
			child.get_node("CollisionShape2D").set_deferred("disabled", false)
			if child.health <= 0:
				child.health += 3

func increase_scroll_speed(speed: float = target_scroll_speed):
	tween.interpolate_property(self, "scroll_speed", scroll_speed , speed, 1, Tween.TRANS_LINEAR,Tween.EASE_IN)
	tween.start()
	if (!wr.get_ref()):
		pass
	else:
		player.original_scroll_speed = speed
	

func decrease_scroll_speed(speed: float = 0):
	tween.interpolate_property(self, "scroll_speed", scroll_speed , speed, 1, Tween.TRANS_LINEAR,Tween.EASE_IN)
	tween.start()
