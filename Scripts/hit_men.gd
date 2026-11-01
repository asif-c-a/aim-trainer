extends CharacterBody3D

@export var mesh: Array[MeshInstance3D]
@export var particles: GPUParticles3D

@export var moving: bool = false
@export var max_move_speed: float = 6.75

var move_speed = 3.5
var direction = Vector3(1, 0, 0)
var spawned = false

var timer = 1

func _physics_process(delta: float) -> void:
	timer -= delta
	if moving:
		velocity = direction * move_speed
		move_and_slide()
	
	if timer <= 0:
		direction = -direction
		move_speed = randf_range(max_move_speed / 2, max_move_speed)
		timer = randf_range(0.4, 1.6)

func _hit():
	for i in mesh.size():
		mesh[i].visible = false
	particles.emitting = true
	if !spawned:
		get_parent()._spawn_man()
		spawned = true

func _on_gpu_particles_3d_finished() -> void:
	queue_free()
