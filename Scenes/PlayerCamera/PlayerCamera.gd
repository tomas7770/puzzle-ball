extends Camera

var player

func set_player(new_player):
	player = new_player

func _process(_delta):
	if !player:
		return
	translation = player.translation + Vector3(0, 0, 6.5)
