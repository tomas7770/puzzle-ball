extends RigidBody

const MagnetScene = preload("res://Scenes/Magnet/Magnet.tscn")
const LATCH_FACTOR = 2

onready var mesh_instance = $MeshInstance
onready var key = $ColoredKey
onready var latch_ray_casts = $LatchRayCasts
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

func _physics_process(_delta):
	var ball = _is_on_ball()
	if ball and not ball.magnet_enabled:
		add_central_force(LATCH_FACTOR*Vector3(ball.linear_velocity.x-linear_velocity.x, 0, 0))

func _is_on_ball():
	for ray_cast in latch_ray_casts.get_children():
		if ray_cast.is_colliding() \
		and ray_cast.get_collider().get_meta("player", false):
			return ray_cast.get_collider()
	return false

func get_magnet():
	return magnet
