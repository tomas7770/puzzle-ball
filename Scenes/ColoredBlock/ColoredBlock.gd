extends RigidBody

const MagnetScene = preload("res://Scenes/Magnet/Magnet.tscn")
const LATCH_FACTOR = 2
# The block height for which latch ray casts will stay on the origin position
const LATCH_BASE_HEIGHT = 0.75

onready var mesh_instance = $MeshInstance
onready var key = $ColoredKey
onready var latch_ray_casts = $LatchRayCasts
onready var door_magnet_area = $DoorMagnetArea
var collision_shape
var magnet

export(bool) var magnetized = true

func _ready():
	for child in get_children():
		if child is CollisionShape:
			collision_shape = child
			break
	# Make the mesh and material unique so that the electrifying effect can be applied to
	# a single block without affecting others of the same color
	mesh_instance.mesh = mesh_instance.mesh.duplicate()
	mesh_instance.mesh.surface_set_material(0, mesh_instance.mesh.surface_get_material(0).duplicate())
	var material = mesh_instance.mesh.surface_get_material(0)
	if material.next_pass:
		material.next_pass = material.next_pass.duplicate()
	if !(key.shape) and collision_shape:
		key.set_shape(collision_shape.shape)
	if magnetized:
		magnet = MagnetScene.instance()
		add_child(magnet)
	# Place latch ray casts near the bottom of the block
	_position_latch_ray_casts()

func _physics_process(_delta):
	var ball = _is_on_ball()
	if ball and not ball.magnet_enabled:
		add_central_force(LATCH_FACTOR*Vector3(ball.linear_velocity.x-linear_velocity.x, 0, 0))
	_apply_door_magnet_forces()

func _position_latch_ray_casts():
	if !(collision_shape) or !(collision_shape.shape is BoxShape):
		return
	for ray_cast in latch_ray_casts.get_children():
		ray_cast.translation -= Vector3(0, collision_shape.shape.extents.y-LATCH_BASE_HEIGHT, 0)

func _is_on_ball():
	for ray_cast in latch_ray_casts.get_children():
		if ray_cast.is_colliding() \
		and ray_cast.get_collider().get_meta("player", false):
			return ray_cast.get_collider()
	return false

func _apply_door_magnet_forces():
	if !(magnet) or !(magnet.is_enabled()):
		return
	for body in door_magnet_area.get_overlapping_bodies():
		if body.get_meta("door", false) and body.is_same_color(key.get_key_color_code()):
			magnet.apply_extra_magnet_forces(body.translation)

func get_magnet():
	return magnet
