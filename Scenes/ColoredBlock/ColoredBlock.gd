extends RigidBody

const MagnetScene = preload("res://Scenes/Magnet/Magnet.tscn")

onready var mesh_instance = $MeshInstance
onready var key = $ColoredKey
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

func get_magnet():
	return magnet
