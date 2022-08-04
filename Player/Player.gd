extends KinematicBody2D
class_name Player

var bullet := preload("res://Projectiles/Bullet.tscn")

export var health: int = 5
export var current_energy: int = 0
export var max_speed : int = 140
export var horizontal_speed_multiplier: float = 1.6

var velocity : Vector2 = Vector2.ZERO
var score: int = 0
var is_stopped: bool = false
var stopped_left: bool = false
var last_movement_direction :int = -1

onready var camera = get_parent().get_node("Camera2D")
onready var tilemaps = get_parent().get_node("Tilemaps")
onready var guns = $Guns
onready var shootDelay = $ShootDelay
onready var invincibilityTimer = $InvincibilityTimer
onready var invincibilityAnimation = $InvincibilityAnimation
onready var spriteAnimation = $SpriteAnimation
onready var shootDelayProgress = $Sprite/ShootDelayProgress
onready var shootDelayTween = $ShootDelayTween
onready var movementTween = $MovementTween

var original_scroll_speed : float = 0

func _ready():
	add_to_group("damageable")
	get_parent().get_node("HUD").set_max_health(health)

func _process(delta):
	if velocity.x > 0:
		if is_stopped:
			rotation_degrees = 5
		else:
			rotation_degrees = 10
	elif velocity.x < 0:
		if is_stopped:
			rotation_degrees = -5
		else:
			rotation_degrees = -10
	else:
		rotation_degrees = 0
		
		
	if Input.is_action_pressed("shoot") and shootDelay.is_stopped():
		shoot_delay()
		$LaserSound.play()
		for child in guns.get_children():
			var this_bullet := bullet.instance()
			get_parent().add_child(this_bullet)
			this_bullet.position = child.global_position
			this_bullet.direction = child.shoot_direction
			if is_stopped:
				if stopped_left:
					this_bullet.direction = child.stopped_left_shoot_direction
				else:
					this_bullet.direction = child.stopped_right_shoot_direction
			
func _physics_process(delta):
	
	var direction : Vector2 = Vector2.ZERO
	direction.x = Input.get_axis("move_left","move_right")
	if Input.is_action_pressed("move_up"):
		direction.y = -.5
	
	
	if not direction.x == 0:
		last_movement_direction = direction.x
	
	if Input.is_action_just_pressed("move_down") and not is_stopped:
		tilemaps.decrease_scroll_speed(0)
		movementTween.interpolate_property(self, "position", position, position - Vector2(0, -20), .3, Tween.TRANS_LINEAR)
		movementTween.start()
		is_stopped = true
		if last_movement_direction < 0:
			spriteAnimation.play("stop_left")
			stopped_left = true
		else:
			spriteAnimation.play("stop_right")
			stopped_left = false
	if Input.is_action_pressed("move_down") and is_stopped:
		movementTween.interpolate_property(self, "position", position, position - Vector2(0, -1.5), .05, Tween.TRANS_LINEAR)
		movementTween.start()
		
	if Input.is_action_just_pressed("move_up") and is_stopped:
		tilemaps.increase_scroll_speed()
		is_stopped = false
		if stopped_left:
			spriteAnimation.play("start_left")
		else:
			spriteAnimation.play("start_right")
	else:
		if tilemaps.scroll_speed <= 0:
			pass
		else:
			#tilemaps.decrease_scroll_speed(original_scroll_speed)
			tilemaps.scroll_speed = original_scroll_speed
		
	print(tilemaps.scroll_speed)
	if direction.length() > 1:
		direction = direction.normalized()
	
	velocity = direction * max_speed
	velocity.x = velocity.x * horizontal_speed_multiplier
	if not is_stopped:
		move_and_slide(velocity)
	
	position.x = clamp(position.x, camera.position.x - 290, camera.position.x + 290) 
	
	if position.y > 620:
		print("died!")
		queue_free()
	

func damage(amount: int):
	if not invincibilityTimer.is_stopped():
		return
	invincibilityTimer.start()
	invincibilityAnimation.play("Flash")
	health -= amount
	get_parent().get_node("HUD").update_health(health)
	if health <= 0:
		queue_free()

func increase_score(score: int):
	var current_score = get_parent().get_node("HUD/Label").text.to_int()
	current_score += score
	get_parent().get_node("HUD/Label").text = str(current_score)
	get_parent().get_node("HUD/Label/AnimationPlayer").play("Increase Score")
	

func increase_energy(energy: int):
	get_parent().get_node("HUD").update_previous_energy(current_energy)
	if current_energy < 100:
		current_energy += energy
	if current_energy > 100:
		current_energy = 100
	get_parent().get_node("HUD").update_energy(current_energy)

func shoot_delay():
	shootDelayProgress.value = 0
	shootDelay.start()
	shootDelayTween.interpolate_property(shootDelayProgress, "value", 0, 100, shootDelay.wait_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	shootDelayTween.start()
	

func _on_VisibilityNotifier2D_screen_exited():
	print("died!")
	queue_free()
