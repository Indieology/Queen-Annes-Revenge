extends Area2D

export var health : int = 1
export var score : int = 25
export var energy_dropped : int = 10


onready var player = get_parent().get_parent().get_parent().get_node("Player")
onready var gun := $FiringPosition
onready var delay_timer := $DelayTimer
onready var sprite := $Sprite


onready var hurt_effect := preload("res://Effects/Hurt Effect.tscn")
onready var explosion := preload("res://Effects/Explosion/Explosion.tscn")
onready var bullet := preload("res://Projectiles/Bullet.tscn")

onready var wr = weakref(player)

func _ready():
	#add_to_group("damageable")
	randomize()
	delay_timer.wait_time = rand_range(1,3)
	delay_timer.start()

func _physics_process(delta):
	add_to_group("damageable")
	if delay_timer.is_stopped() and global_position.y > 0:
		fire()
		randomize()
		delay_timer.wait_time = rand_range(1,4)
		delay_timer.start()

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
		this_explosion.scale /= 2
		#exit function if player no longer exists
		if (!wr.get_ref()):
			pass
		else:
			player.increase_score(score)
			player.increase_energy(energy_dropped)
		queue_free()

func fire():
	var this_bullet := bullet.instance()
	get_parent().get_parent().get_parent().add_child(this_bullet)
	this_bullet.position = gun.global_position
	this_bullet.direction = gun.shoot_direction

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
