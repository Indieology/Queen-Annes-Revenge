extends KinematicBody2D

export var health : int = 3
export var score : int = 75
export var energy_dropped : int = 10
export var verticalSpeed : int = 8
#export var horizontalSpeed : int = 50

onready var guns := $FiringPositions
onready var fireTimer := $FireTimer
onready var sprite := $AnimatedSprite
onready var player : = get_parent().get_parent().get_parent().get_node("Player")

onready var hurt_effect := preload("res://Effects/Hurt Effect.tscn")
onready var explosion := preload("res://Effects/Explosion/Explosion.tscn")
onready var bullet := preload("res://Projectiles/Bullet.tscn")


#reference to the airplane node above, to check if it is still in scene
onready var wr = weakref(player)

func _ready():
	#add_to_group("damageable")
	randomize()
	fireTimer.wait_time = rand_range(1,6)
	fireTimer.start()

func _process(delta):
	if health == 2:
		sprite.frame = 1
	if health <= 1:
		sprite.frame = 2

func _physics_process(delta):
	add_to_group("damageable")
	#position.y += verticalSpeed * delta
	if fireTimer.is_stopped() and global_position.y > 0:
		fire()
		randomize()
		fireTimer.wait_time = rand_range(1,6)
		fireTimer.start()

func _on_Hurtbox_area_entered(area):
	var this_hurt_effect = hurt_effect.instance()
	get_parent().add_child(this_hurt_effect)
	this_hurt_effect.position = area.global_position
	if area.get_parent() is Player:
		area.get_parent().damage(2)
		damage(health)
		#move hurt effect position to show collision between the two objects?
		
	
func damage(amount: int):
	health -= amount
	if health <= 0:
		var this_explosion := explosion.instance()
		get_parent().add_child(this_explosion)
		this_explosion.position = position
		#exit function if player no longer exists
		if (!wr.get_ref()):
			pass
		else:
			player.increase_score(score)
			player.increase_energy(energy_dropped)
		queue_free()

func fire():
	for child in guns.get_children():
			var this_bullet := bullet.instance()
			get_parent().get_parent().get_parent().add_child(this_bullet)
			this_bullet.position = child.global_position
			this_bullet.direction = child.shoot_direction

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
