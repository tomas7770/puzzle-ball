extends Control

const interaction_hint_scene = preload("res://Scenes/UI/InteractionHint/InteractionHint.tscn")

onready var magnet_icon = $MagnetContainer/MagnetIcon
onready var magnet_button_label = $MagnetContainer/ButtonTexture/Label
onready var pause_panel = $PausePanel

var interaction_hint_map = {}

var is_paused = false

func _ready():
	var events = InputMap.get_action_list("plr1_magnet")
	for event in events:
		if event is InputEventKey:
			magnet_button_label.text = OS.get_scancode_string(event.scancode)

func set_player(player: RigidBody):
	# warning-ignore:return_value_discarded
	player.connect("plr_entered_interaction_area", self, "_on_plr_entered_interaction_area")
	# warning-ignore:return_value_discarded
	player.connect("plr_exited_interaction_area", self, "_on_plr_exited_interaction_area")
	# warning-ignore:return_value_discarded
	player.connect("plr_magnet_enabled", self, "_on_plr_magnet_enabled")
	# warning-ignore:return_value_discarded
	player.connect("plr_magnet_disabled", self, "_on_plr_magnet_disabled")
	_on_plr_magnet_disabled()

func _input(event):
	if event.is_action_pressed("plr1_pause"):
		if is_paused:
			_unpause()
		else:
			LevelManager.pause_game()
			pause_panel.show()
			pause_panel.get_node("Buttons/ResumeButton").grab_focus()
			is_paused = true

func _unpause():
	LevelManager.unpause_game()
	pause_panel.hide()
	is_paused = false

func _on_ResumeButton_pressed():
	_unpause()

func _on_RestartButton_pressed():
	LevelManager.restart_level()
	_unpause()

func _on_QuitButton_pressed():
	LevelManager.quit_level()

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
	move_child(interaction_hint, 0)

func _on_plr_exited_interaction_area(area):
	var interaction_hint = interaction_hint_map.get(area)
	if interaction_hint:
		remove_child(interaction_hint)
		interaction_hint_map.erase(area)

func _on_plr_magnet_enabled():
	magnet_icon.self_modulate.v = 1.0

func _on_plr_magnet_disabled():
	magnet_icon.self_modulate.v = 0.0
