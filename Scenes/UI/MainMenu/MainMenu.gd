extends Control

func _on_PlayButton_pressed():
	var status = LevelManager.start_level("Level1")
	if status != OK:
		print(status)

func _on_QuitButton_pressed():
	get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)
