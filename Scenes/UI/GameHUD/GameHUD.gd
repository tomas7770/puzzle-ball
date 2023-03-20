extends Control

const interaction_hint_scene = preload("res://Scenes/UI/InteractionHint/InteractionHint.tscn")
onready var pause_panel = $PausePanel

var interaction_hint_map = {}

var is_paused = false

func set_player(player: RigidBody):
	# warning-ignore:return_value_discarded
	player.connect("plr_entered_interaction_area", self, "_on_plr_entered_interaction_area")
	# warning-ignore:return_value_discarded
	player.connect("plr_exited_interaction_area", self, "_on_plr_exited_interaction_area")

func _input(event):
	if event.is_action_pressed("plr1_pause"):
		if is_paused:
			LevelManager.unpause_game()
			pause_panel.hide()
		else:
			LevelManager.pause_game()
			pause_panel.show()
		is_paused = !is_paused

func _process(_delta):
	var camera = get_viewport().get_camera()
	if !camera:
		return
		
	for area in interaction_hint_map.keys():
		var target_position = area.global_translation + 2*Vector3.UP
		var interaction_hint = interaction_hint_map[area]
		interaction_hint.visible = !(camera.is_position_behind(target_position))
		interaction_hint.rect_position = camera.unproject_position(target_position)

func _on_plr_entered_interaction_area(area):
	var interaction_hint = interaction_hint_scene.instance()
	interaction_hint_map[area] = interaction_hint
	add_child(interaction_hint)

func _on_plr_exited_interaction_area(area):
	var interaction_hint = interaction_hint_map.get(area)
	if interaction_hint:
		remove_child(interaction_hint)
		interaction_hint_map.erase(area)
