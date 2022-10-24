extends RigidBody

onready var jump_ray_casts = $JumpRayCasts

var acceleration = 20
var max_speed = 10
var jump_force = 8
var max_slope_angle = 45

func _ready():
	# To prevent raycasts from being affected by ball rotation;
	# Their position will be updated manually each physics frame
	jump_ray_casts.set_as_toplevel(true)
	
	for ray_cast in jump_ray_casts.get_children():
		ray_cast.add_exception(self)

func _input(event):
	if event.is_action_pressed("plr1_jump"):
		_try_jump()

func _physics_process(delta):
	_update_raycast_positions()
	angular_damp = -1
	if Input.is_action_pressed("plr1_left"):
		_apply_movement_force(-1, delta)
	elif Input.is_action_pressed("plr1_right"):
		_apply_movement_force(1, delta)
	else:
		angular_damp = 15

func _update_raycast_positions():
	jump_ray_casts.translation = translation

func _apply_movement_force(dir, delta):
	# Hacky condition to limit velocity only for player-controlled movement
	if abs(linear_velocity.x) < max_speed:
		var real_accel = sign(dir)*min(acceleration, (max_speed - abs(linear_velocity.x))/delta)
		add_central_force(Vector3(real_accel, 0, 0))

func _is_on_floor():
	for ray_cast in jump_ray_casts.get_children():
		if ray_cast.is_colliding() \
		and ray_cast.get_collision_normal().angle_to(Vector3.UP) <= deg2rad(max_slope_angle):
			return true
	return false

func _try_jump():
	if _is_on_floor():
		apply_central_impulse(Vector3(0, jump_force, 0))
