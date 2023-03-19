extends Spatial

signal request_finish_level

func _on_Portal_body_entered(body):
	if body.get_meta("player", false):
		emit_signal("request_finish_level")
