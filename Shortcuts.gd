extends Node

func _input(event):
	if event.is_action_pressed("toggle_fullscreen"):
		OS.set_window_fullscreen(!OS.window_fullscreen)
