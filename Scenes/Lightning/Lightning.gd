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
	var up_vector = Vector3(0,1,0)
	if pos1.x < pos2.x:
		up_vector = -up_vector
	look_at(pos2, up_vector)
	mesh_instance.mesh.size = Vector2(pos1.distance_to(pos2), 1.0)

func set_edge_obj1(obj):
	edge_obj1 = obj

func set_edge_obj2(obj):
	edge_obj2 = obj
