# Manages stuff like loading a level and setting up the HUD
extends Node

const game_hud_scene = preload("res://Scenes/UI/GameHUD/GameHUD.tscn")
var game_hud

var level_transition_timer = Timer.new()
var level_to_start: String

func _ready():
	level_transition_timer.connect("timeout", self, "_do_start_level")
	level_transition_timer.wait_time = 0.5
	level_transition_timer.one_shot = true
	level_transition_timer.process_mode = Timer.TIMER_PROCESS_PHYSICS
	level_transition_timer.pause_mode = PAUSE_MODE_PROCESS
	add_child(level_transition_timer)

func start_level(level_name: String):
	level_to_start = level_name
	pause_game()
	if game_hud:
		game_hud.on_level_ended()
		level_transition_timer.start()
		return OK
	else:
		return _do_start_level()

func _do_start_level():
	var status = get_tree().change_scene(
		"res://Scenes/Levels/{lvl}/{lvl}.tscn".format({"lvl": level_to_start}))
	if status != OK:
		print("Load level " + level_to_start + ": Error " + str(status))
		return status
	_setup_level()
	return status

func _setup_level():
	# Wait for previous scene to unload
	yield(get_tree().current_scene, "tree_exited")
	# Wait for level scene to load
	yield(get_tree(), "idle_frame")
	var level_scene = get_tree().current_scene
	
	if !game_hud:
		game_hud = game_hud_scene.instance()
		get_tree().get_root().add_child(game_hud)
	game_hud.set_player(level_scene.get_player())
	game_hud.on_level_started()

# Note: this function is over-simplified and may cause unintended behavior
# if the loaded scene is not a level
func restart_level():
	var status = get_tree().reload_current_scene()
	if status != OK:
		print("Restart level: Error " + str(status))
	_setup_level()

func quit_level():
	if game_hud:
		get_tree().get_root().remove_child(game_hud)
		game_hud = null
	unpause_game()
	var status = get_tree().change_scene("res://Scenes/UI/MainMenu/MainMenu.tscn")
	if status != OK:
		print("Quit level: Error " + str(status))

func pause_game():
	get_tree().paused = true

func unpause_game():
	get_tree().paused = false

func end_game():
	if game_hud:
		get_tree().get_root().remove_child(game_hud)
		game_hud = null
	unpause_game()
	var status = get_tree().change_scene("res://Scenes/UI/EndScreen/EndScreen.tscn")
	if status != OK:
		print("End game: Error " + str(status))

func get_level_name():
	return get_tree().current_scene.get("level_name")
