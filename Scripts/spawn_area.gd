extends Area3D

@export var hit_spheres : PackedScene
@export var hit_man : PackedScene
@export var coll_shape : CollisionShape3D

var x : float
var y : float
var z : float

@export var hit_man_spawn: bool

func _ready() -> void:
	var shape = coll_shape.shape as BoxShape3D
	x = shape.size.x
	y = shape.size.y
	z = shape.size.z

	for i in range(5):
		if hit_man_spawn:
			_spawn_man()
		else:
			_spawn_sphere()

func _get_random_position(floored: bool) -> Vector3:
	var r_pos : Vector3
	r_pos.x = randf_range(-x / 2, x / 2)
	if !floored:
		r_pos.y = randf_range(-y / 2, y / 2)
	else:
		r_pos.y = 0
	r_pos.z = randf_range(-z / 2, z / 2)
	return r_pos

func _spawn_sphere() -> void:
	var sph = hit_spheres.instantiate()
	add_child(sph)
	sph.global_position = global_position + _get_random_position(false)

func _spawn_man() -> void:
	var man = hit_man.instantiate()
	add_child(man)
	if randi_range(0, 1) == 1:
		man.direction = -man.direction
	man.move_speed = randf_range(man.max_move_speed / 2, man.max_move_speed)
	man.global_position = global_position + _get_random_position(true)
	man.moving = true
