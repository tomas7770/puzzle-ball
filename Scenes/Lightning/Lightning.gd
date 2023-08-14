extends Spatial

onready var mesh_instance = $MeshInstance

var edge_obj1
var edge_obj2

func _ready():
	mesh_instance.mesh = mesh_instance.mesh.duplicate()

func _process(_delta):
	if !(edge_obj1 and edge_obj2):
		return
	var pos1 = edge_obj1.get_global_transform_interpolated().origin
	var pos2 = edge_obj2.get_global_transform_interpolated().origin
	translation = pos1.linear_interpolate(pos2, 0.5)
	look_at(pos2, (pos2-translation).cross(Vector3(0,0,1)))
	mesh_instance.mesh.size = Vector2(pos1.distance_to(pos2), 2.0)

func set_edge_obj1(obj):
	edge_obj1 = obj

func set_edge_obj2(obj):
	edge_obj2 = obj
