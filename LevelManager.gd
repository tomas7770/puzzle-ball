# Manages stuff like loading a level and setting up the HUD
extends Node

const game_hud_scene = preload("res://Scenes/UI/GameHUD/GameHUD.tscn")
var game_hud

func start_level(level_name: String):
	var status = get_tree().change_scene(
		"res://Scenes/Levels/{lvl}/{lvl}.tscn".format({"lvl": level_name}))
	if status != OK:
		print("Load level " + level_name + ": Error " + str(status))
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
