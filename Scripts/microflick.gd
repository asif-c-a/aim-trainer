extends Area3D

@export var hit_spheres : PackedScene
@export var coll_shape : CollisionShape3D

@export var manager: Manager

var x : float
var y : float
var z : float

@export var count: int = 5
var init: bool = false
var htimes: int = 5

func _ready() -> void:
	var shape = coll_shape.shape as BoxShape3D
	if shape:
		x = shape.size.x
		y = shape.size.y
		z = shape.size.z

func _process(_delta: float) -> void:
	if manager.started and !init:
		for i in range(count):
			_spawn_sphere(global_position)
		init = true

func _spawn_sphere(ps: Vector3) -> void:
	var sph = hit_spheres.instantiate()
	add_child(sph)
	
	if htimes == 0:
		sph.global_position = global_position + _get_random_position()
		htimes = randi_range(3, 5)
	else:
		sph.global_position = _get_valid_offset_position(ps, 0.5)
		htimes -= 1

func _get_valid_offset_position(ps: Vector3, distance: float) -> Vector3:
	var half_extents = Vector3(x, y, z) / 2.0
	
	for i in range(50):
		var random_dir := Vector3(randf_range(-1, 1), randf_range(-1, 1), randf_range(-1, 1)).normalized()
		var candidate_global = ps + (random_dir * distance)
		
		var local_pos = to_local(candidate_global)
		
		local_pos -= coll_shape.position
		
		if (abs(local_pos.x) <= half_extents.x and 
			abs(local_pos.y) <= half_extents.y and 
			abs(local_pos.z) <= half_extents.z):
			return candidate_global
	return ps

func _get_random_position() -> Vector3:
	var r_pos : Vector3
	r_pos.x = randf_range(-x / 2, x / 2)
	r_pos.y = randf_range(-y / 2, y / 2)
	r_pos.z = randf_range(-z / 2, z / 2)
	return r_pos