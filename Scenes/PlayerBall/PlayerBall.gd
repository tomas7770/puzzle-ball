extends RigidBody

var acceleration = 20
var max_speed = 10

func _physics_process(delta):
	angular_damp = -1
	if Input.is_action_pressed("plr1_left"):
		_apply_movement_force(-1, delta)
	elif Input.is_action_pressed("plr1_right"):
		_apply_movement_force(1, delta)
	else:
		angular_damp = 15

func _apply_movement_force(dir, delta):
	# Hacky condition to limit velocity only for player-controlled movement
	if abs(linear_velocity.x) < max_speed:
		var real_accel = sign(dir)*min(acceleration, (max_speed - abs(linear_velocity.x))/delta)
		add_central_force(Vector3(real_accel, 0, 0))
