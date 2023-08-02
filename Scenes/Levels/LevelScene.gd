extends Spatial

export(String) var next_level
export(String) var level_name

onready var player_camera = $PlayerCamera
onready var player_ball = $PlayerBall

var respawn_preview_map = {}

func _ready():
	for child in get_children():
		_listen_to_child_signals(child)
	player_camera.set_player(player_ball)

func get_player():
	return player_ball

func _listen_to_child_signals(child: Node):
	if child.has_signal("plr_entered_endportal"):
		_connect_child_signal(child, "plr_entered_endportal", self, "_on_plr_entered_endportal")
	if child.has_signal("plr_entered_interaction_area"):
		_connect_child_signal(child, "plr_entered_interaction_area", self, "_on_plr_entered_interaction_area")
	if child.has_signal("plr_exited_interaction_area"):
		_connect_child_signal(child, "plr_exited_interaction_area", self, "_on_plr_exited_interaction_area")

func _connect_child_signal(child, signal_name, target, method, binds = [], flags = 0):
	var status = child.connect(signal_name, target, method, binds, flags)
	if status != OK:
		print("Connect " + signal_name + " signal: Error " + str(status))

func _on_plr_entered_endportal():
	if next_level == null or next_level.empty():
		LevelManager.end_game()
	else:
		_finish_level()

func _on_plr_entered_interaction_area(area):
	if area.has_method("get_object_to_respawn"):
		var object_to_respawn = area.get_object_to_respawn()
		if object_to_respawn.has_method("create_respawn_preview"):
			var respawn_preview = object_to_respawn.create_respawn_preview()
			respawn_preview_map[area] = respawn_preview
			add_child(respawn_preview)
			respawn_preview.transform = area.get_respawn_transform()

func _on_plr_exited_interaction_area(area):
	var respawn_preview = respawn_preview_map.get(area)
	if respawn_preview:
		call_deferred("remove_child", respawn_preview)
		respawn_preview_map.erase(area)

func _finish_level():
	# warning-ignore:return_value_discarded
	LevelManager.start_level(next_level)
