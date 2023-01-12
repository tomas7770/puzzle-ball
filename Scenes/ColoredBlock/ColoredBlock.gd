extends RigidBody

const MagnetScene = preload("res://Scenes/Magnet/Magnet.tscn")

onready var key = $ColoredKey
var collision_shape
var magnet

export(bool) var magnetized = true

func _ready():
	for child in get_children():
		if child is CollisionShape:
			collision_shape = child
			break
	if !(key.shape) and collision_shape:
		key.set_shape(collision_shape.shape)
	if magnetized:
		magnet = MagnetScene.instance()
		add_child(magnet)

func get_magnet():
	return magnet
