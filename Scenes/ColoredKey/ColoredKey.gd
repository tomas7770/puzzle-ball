# Colored key activates a colored sensor of the same color
extends Area

export(Const.COLOR_CODE) var color
export(Shape) var shape

onready var collision_shape = $CollisionShape

func _ready():
	collision_shape.shape = shape

func get_key_color_code():
	return color
