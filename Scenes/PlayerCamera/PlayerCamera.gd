extends Camera

var player
var offset = Vector3(0, 1, 8.5)

func set_player(new_player):
	player = new_player

func _process(_delta):
	if !player:
		return
	translation = player.translation + offset
