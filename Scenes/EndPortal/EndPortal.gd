extends Spatial

var level_scene

func set_level_scene(scene):
	level_scene = scene

func _on_Portal_body_entered(body):
	if body.get_meta("player", false):
		level_scene.finish_level()
