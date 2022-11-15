extends Spatial

export(String) var next_level

onready var player_camera = $PlayerCamera
onready var player_ball = $PlayerBall

func _ready():
	propagate_call("set_level_scene", [self])
	player_camera.set_player(player_ball)

func finish_level():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/Levels/{lvl}/{lvl}.tscn".format({"lvl": next_level}))
