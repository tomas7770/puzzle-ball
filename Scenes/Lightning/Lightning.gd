extends Spatial

onready var mesh_instance = $MeshInstance
var material

var edge_obj1
var edge_obj2

func _ready():
	mesh_instance.mesh = mesh_instance.mesh.duplicate()
	mesh_instance.mesh.surface_set_material(0, mesh_instance.mesh.surface_get_material(0).duplicate())
	material = mesh_instance.mesh.surface_get_material(0)

func _process(_delta):
	if !(edge_obj1 and edge_obj2):
		return
	var pos1 = edge_obj1.get_global_transform_interpolated().origin
	var pos2 = edge_obj2.get_global_transform_interpolated().origin
	translation = pos1.linear_interpolate(pos2, 0.5)
	look_at(pos2, (pos2-translation).cross(Vector3(0,0,1)))
	mesh_instance.mesh.size = Vector2(pos1.distance_to(pos2), 1.0)
	material.set_shader_param("dist", mesh_instance.mesh.size.x)

func set_edge_obj1(obj):
	edge_obj1 = obj

func set_edge_obj2(obj):
	edge_obj2 = obj
