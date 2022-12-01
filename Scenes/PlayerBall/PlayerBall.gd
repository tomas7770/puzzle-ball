extends RigidBody

onready var jump_ray_casts = $JumpRayCasts
onready var magnet_area = $MagnetArea
onready var mesh_instance = $MeshInstance
var electricity_material = preload("res://Textures/ElectricityMaterial.tres")

var acceleration = 20
var max_speed = 10
var jump_force = 12
var max_slope_angle = 45
var magnet_safe_distance = 4

var magnet_enabled = false

func _ready():
	set_meta("player", true)
	# To prevent raycasts from being affected by ball rotation;
	# Their position will be updated manually each physics frame
	jump_ray_casts.set_as_toplevel(true)
	
	for ray_cast in jump_ray_casts.get_children():
		ray_cast.add_exception(self)

func _input(event):
	if event.is_action_pressed("plr1_jump"):
		_try_jump()
	elif event.is_action_pressed("plr1_magnet"):
		_toggle_magnet()

func _physics_process(delta):
	_update_raycast_positions(delta)
	angular_damp = -1
	if Input.is_action_pressed("plr1_left"):
		_apply_movement_force(-1, delta)
	elif Input.is_action_pressed("plr1_right"):
		_apply_movement_force(1, delta)
	else:
		angular_damp = 15
	_apply_magnet_forces()

func _update_raycast_positions(delta):
	jump_ray_casts.translation = translation + linear_velocity*delta
	for ray_cast in jump_ray_casts.get_children():
		ray_cast.force_raycast_update()

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

func _toggle_magnet():
	magnet_enabled = !magnet_enabled
	if magnet_enabled:
		mesh_instance.get_active_material(0).next_pass = electricity_material
		for body in magnet_area.get_overlapping_bodies():
			_body_entered_magnet(body)
	else:
		mesh_instance.get_active_material(0).next_pass = null
		for body in magnet_area.get_overlapping_bodies():
			_body_exited_magnet(body)

func _apply_magnet_forces():
	if !magnet_enabled:
		return
	for body in magnet_area.get_overlapping_bodies():
		if body.has_method("apply_magnet_forces"):
			body.apply_magnet_forces(translation - body.translation, magnet_safe_distance)

func _body_entered_magnet(body):
	if body.has_method("entered_magnet"):
		body.entered_magnet()

func _body_exited_magnet(body):
	if body.has_method("exited_magnet"):
		body.exited_magnet()

func _on_MagnetArea_body_entered(body):
	if magnet_enabled:
		_body_entered_magnet(body)

func _on_MagnetArea_body_exited(body):
	if magnet_enabled:
		_body_exited_magnet(body)
