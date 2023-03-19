extends Spatial

export(String) var next_level

onready var player_camera = $PlayerCamera
onready var player_ball = $PlayerBall

func _ready():
	for child in get_children():
		_listen_to_child_signals(child)
	player_camera.set_player(player_ball)

func _listen_to_child_signals(child: Node):
	if child.has_signal("plr_entered_endportal"):
		var status = child.connect("plr_entered_endportal", self, "_finish_level")
		if status != OK:
			print("Connect plr_entered_endportal signal: Error " + str(status))

func _finish_level():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/Levels/{lvl}/{lvl}.tscn".format({"lvl": next_level}))
