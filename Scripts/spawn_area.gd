extends Area3D

@export var hit_spheres : PackedScene
@export var coll_shape : CollisionShape3D

var x : float
var y : float
var z : float

func _ready() -> void:
	var shape = coll_shape.shape as BoxShape3D
	x = shape.size.x
	y = shape.size.y
	z = shape.size.z

	for i in range(5):
		_spawn_sphere()

func _get_random_position() -> Vector3:
	var r_pos : Vector3
	r_pos.x = randf_range(-x / 2, x / 2)
	r_pos.y = randf_range(-y / 2, y / 2)
	r_pos.z = randf_range(-z / 2, z / 2)
	return r_pos

func _spawn_sphere() -> void:
	var sph = hit_spheres.instantiate()
	add_child(sph)
	sph.global_position = global_position + _get_random_position()
