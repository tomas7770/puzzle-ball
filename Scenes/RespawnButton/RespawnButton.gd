extends Area

export(NodePath) var object_to_respawn

var _object_clone

func _ready():
	_object_clone = get_node(object_to_respawn).duplicate()

func _on_RespawnButton_body_entered(body):
	if body.has_method("entered_interaction_area"):
		body.entered_interaction_area(self)

func _on_RespawnButton_body_exited(body):
	if body.has_method("exited_interaction_area"):
		body.exited_interaction_area(self)

func interact(_interactor):
	var old_object = get_node(object_to_respawn)
	var object_parent = old_object.get_parent()
	old_object.queue_free()
	object_parent.add_child(_object_clone)
	object_to_respawn = _object_clone.get_path()
	_object_clone = get_node(object_to_respawn).duplicate()
