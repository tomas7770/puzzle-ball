# Manages stuff like loading a level and setting up the HUD
extends Node

const game_hud_scene = preload("res://Scenes/UI/GameHUD/GameHUD.tscn")

func start_level(level_name: String):
	var status = get_tree().change_scene(
		"res://Scenes/Levels/{lvl}/{lvl}.tscn".format({"lvl": level_name}))
	if status != OK:
		print("Load level " + level_name + ": Error " + str(status))
		return status
	_setup_level()
	return status

func _setup_level():
	# Wait for level scene to load
	yield(get_tree(), "idle_frame")
	var level_scene = get_tree().current_scene
	
	var game_hud = game_hud_scene.instance()
	game_hud.set_player(level_scene.get_player())
	get_tree().get_root().add_child(game_hud)

func pause_game():
	get_tree().paused = true

func unpause_game():
	get_tree().paused = false
