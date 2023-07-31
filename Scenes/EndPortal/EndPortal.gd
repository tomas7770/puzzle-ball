extends Spatial

signal plr_entered_endportal

func _on_Portal_body_entered(body):
	if body.get_meta(Const.PLAYER_META, false):
		emit_signal("plr_entered_endportal")
