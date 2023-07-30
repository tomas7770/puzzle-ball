extends Spatial

export(String) var next_level

onready var player_camera = $PlayerCamera
onready var player_ball = $PlayerBall

func _ready():
	for child in get_children():
		_listen_to_child_signals(child)
	player_camera.set_player(player_ball)

func get_player():
	return player_ball

func _listen_to_child_signals(child: Node):
	if child.has_signal("plr_entered_endportal"):
		_connect_child_signal(child, "plr_entered_endportal", self, "_on_plr_entered_endportal")

func _connect_child_signal(child, signal_name, target, method, binds = [], flags = 0):
	var status = child.connect(signal_name, target, method, binds, flags)
	if status != OK:
		print("Connect " + signal_name + " signal: Error " + str(status))

func _on_plr_entered_endportal():
	if next_level == null or next_level.empty():
		LevelManager.end_game()
	else:
		_finish_level()

func _finish_level():
	# warning-ignore:return_value_discarded
	LevelManager.start_level(next_level)
