extends Area2D

export var speed: int = 500
export var direction: Vector2 = Vector2.ZERO

onready var bulletLifetime: Timer = $Lifetime

func _ready():
	bulletLifetime.start()

func _physics_process(delta):
	position += direction * speed * delta
	if bulletLifetime.is_stopped():
		queue_free()


func _on_Bullet_area_entered(area):
	if area.get_parent().is_in_group("damageable") and bulletLifetime.time_left < 1.05:
		area.get_parent().damage(1)
		queue_free()
		
	elif area.is_in_group("damageable") and bulletLifetime.time_left < 1.05:
			area.damage(1)
			queue_free()
