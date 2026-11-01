extends Node3D

@export var hit_man: PackedScene
@export var target_pos: Marker3D
@export var min_time: float = 1
@export var max_time: float = 2.3

var sp_timer: float = 0

func _process(delta: float) -> void:
	if sp_timer < 0:
		match (randi_range(0, 2)):
			0:
				_spawn_single()
			1: 
				_spawn_double()
			2:
				_spawn_triple()
		sp_timer = randf_range(min_time, max_time)
	else:
		sp_timer -= delta

func _spawn_single():
	var hm = hit_man.instantiate()
	hm.head_scale = 0.4
	add_child(hm)
	hm.global_position = global_position
	hm.strafer = false
	hm.moving = true
	hm.direction = -(global_position - target_pos.global_position).normalized()
	await get_tree().create_timer(3).timeout
	if is_instance_valid(hm):
		hm._hit()

func _spawn_double():
	_spawn_single()
	await get_tree().create_timer(0.2).timeout
	_spawn_single()

func _spawn_triple():
	_spawn_single()
	await get_tree().create_timer(0.2).timeout
	_spawn_single()
	await get_tree().create_timer(0.2).timeout
	_spawn_single()
