extends Control

const interaction_hint_scene = preload("res://Scenes/UI/InteractionHint/InteractionHint.tscn")

onready var magnet_icon = $MagnetContainer/MagnetIcon
onready var magnet_button_label = $MagnetContainer/ButtonTexture/Label
onready var level_name_label = $LevelNameLabel
onready var level_name_label_animplayer = $LevelNameLabel/AnimationPlayer
onready var pause_panel = $PausePanel
onready var transition_anim_player = $TransitionRect/AnimationPlayer

var touchscreen_mode = false

var interaction_hint_map = {}

var is_paused = false
var pause_menu_locked = true

func _ready():
	if OS.has_touchscreen_ui_hint():
		touchscreen_mode = true
		magnet_icon.visible = false
		magnet_button_label.visible = false
		$MagnetContainer/ButtonTexture.visible = false
	else:
		$TouchControls.queue_free()
	
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

func on_level_started():
	var level_name = LevelManager.get_level_name()
	if level_name:
		level_name_label.text = level_name
	_transition_in()
	$LevelTransitionTimer.start()

func on_level_ended():
	_transition_out()
	pause_menu_locked = true

func _input(event):
	if event.is_action_pressed("plr1_pause") and !pause_menu_locked:
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
	pause_panel.hide()
	pause_menu_locked = true

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

func _on_plr_entered_interaction_area(area: Area):
	var interaction_name = null
	if area.has_method("get_interaction_name"):
		interaction_name = area.get_interaction_name()
		
	var interaction_hint = interaction_hint_scene.instance()
	interaction_hint_map[area] = interaction_hint
	add_child(interaction_hint)
	move_child(interaction_hint, 0)
	interaction_hint.set_interaction_name(interaction_name)
	
	if touchscreen_mode:
		$TouchControls.show_interact_button()
		interaction_hint.hide_button()

func _on_plr_exited_interaction_area(area):
	var interaction_hint = interaction_hint_map.get(area)
	if interaction_hint:
		remove_child(interaction_hint)
		interaction_hint_map.erase(area)
	
	if touchscreen_mode:
		$TouchControls.hide_interact_button()

func _on_plr_magnet_enabled():
	if touchscreen_mode:
		$TouchControls.on_magnet_enabled()
	magnet_icon.self_modulate.v = 1.0

func _on_plr_magnet_disabled():
	if touchscreen_mode:
		$TouchControls.on_magnet_disabled()
	magnet_icon.self_modulate.v = 0.0

func _transition_in():
	transition_anim_player.play("TransitionIn")

func _transition_out():
	transition_anim_player.play_backwards("TransitionIn")

func _on_LevelTransitionTimer_timeout():
	_unpause()
	level_name_label_animplayer.play("Fade")
	pause_menu_locked = false
