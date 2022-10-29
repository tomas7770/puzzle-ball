# Colored sensor detects a colored key of the same color and emits a signal
extends Area

signal activated

export(Const.COLOR_CODE) var color
export(Shape) var shape

onready var collision_shape = $CollisionShape

func _ready():
	collision_shape.shape = shape

func _on_ColoredSensor_area_entered(area):
	if area.has_method("get_color_code") && area.get_color_code() == color:
		emit_signal("activated")
