extends Area3D

@export var default_item: Node3D
@export var player: Node3D
@export var spawn_time: float = 0.25

@export var hit_spheres : PackedScene
@export var coll_shape : CollisionShape3D

var x : float
var y : float
var z : float

var mouse_on_default: bool = false
var spawned_hit_sphere: bool = false

var spawn_timer: float

func _ready() -> void:
	var shape = coll_shape.shape as BoxShape3D
	x = shape.size.x
	y = shape.size.y
	z = shape.size.z

func _process(delta: float) -> void:
	mouse_on_default = player._check_track(default_item)

	if !spawned_hit_sphere and mouse_on_default:
		spawn_timer -= delta

		if spawn_timer <= 0:
			_spawn_sphere()
			spawned_hit_sphere = true

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

func _flicked():
	spawned_hit_sphere = false
	spawn_timer = spawn_time