extends Sprite


func _physics_process(delta):
	if $Timer.is_stopped():
		visible = false
