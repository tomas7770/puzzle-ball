# Colored sensor detects a colored key of the same color and emits a signal
extends Area

signal activated

export(Const.COLOR_CODE) var color
export(Shape) var shape

onready var collision_shape = $CollisionShape

func _ready():
	collision_shape.shape = shape

func set_shape(new_shape):
	shape = new_shape
	collision_shape.shape = shape

func _on_ColoredSensor_area_entered(area):
	if area.has_method("get_key_color_code") && area.get_key_color_code() == color:
		emit_signal("activated")

func get_sensor_color_code():
	return color
