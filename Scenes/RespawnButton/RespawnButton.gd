extends Area

const respawn_particles_scene = preload("res://Scenes/RespawnParticles/RespawnParticles.tscn")

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
	var old_pos = old_object.global_translation
	
	var object_parent = old_object.get_parent()
	old_object.queue_free()
	object_parent.add_child(_object_clone)
	var new_pos = _object_clone.global_translation
	
	object_to_respawn = _object_clone.get_path()
	_object_clone = get_node(object_to_respawn).duplicate()
	_create_particles(old_pos, new_pos, object_parent)

func _create_particles(position1, position2, parent):
	var respawn_particles = respawn_particles_scene.instance()
	var respawn_particles2 = respawn_particles_scene.instance()
	parent.add_child(respawn_particles)
	parent.add_child(respawn_particles2)
	respawn_particles.global_translation = position1
	respawn_particles2.global_translation = position2
