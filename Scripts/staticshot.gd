extends Area3D

@export var hit_spheres : PackedScene
@export var coll_shape : CollisionShape3D

@export var manager: Manager

var x : float
var y : float
var z : float

@export var count: int = 5

var init: bool = false

func _ready() -> void:
	var shape = coll_shape.shape as BoxShape3D
	x = shape.size.x
	y = shape.size.y
	z = shape.size.z

func _process(_delta: float) -> void:
	if manager.started:
		if !init:
			for i in range(count):
				_spawn_sphere(Vector3.ZERO)
			init = true

func _get_random_position() -> Vector3:
	var r_pos : Vector3
	r_pos.x = randf_range(-x / 2, x / 2)
	r_pos.y = randf_range(-y / 2, y / 2)
	r_pos.z = randf_range(-z / 2, z / 2)
	return r_pos

func _spawn_sphere(ps) -> void:
	var sph = hit_spheres.instantiate()
	add_child(sph)
	sph.global_position = global_position + _get_random_position()