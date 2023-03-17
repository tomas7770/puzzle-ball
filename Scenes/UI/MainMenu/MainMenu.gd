extends Control

func _on_PlayButton_pressed():
	var status = get_tree().change_scene("res://Scenes/Levels/{lvl}/{lvl}.tscn".format({"lvl": "Level1"}))
	if status != OK:
		print(status)

func _on_QuitButton_pressed():
	get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)
