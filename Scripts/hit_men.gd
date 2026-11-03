extends CharacterBody3D

@export var mesh: Array[MeshInstance3D]
@export var particles: GPUParticles3D

@export var moving: bool = false
@export var max_move_speed: float = 6.75

@export var head_scale: float = 1.0

var move_speed = 3.5
var direction = Vector3(1, 0, 0)
var spawned = false

var strafer: bool = true
var timer = 1

func _ready() -> void:
	move_speed = randf_range(max_move_speed / 2, max_move_speed)
	mesh[0].scale = Vector3(head_scale, head_scale, head_scale)


func _physics_process(delta: float) -> void:
	if moving:
		velocity = direction * move_speed
		move_and_slide()
	
	if strafer:
		if timer <= 0:
			direction = -direction
			move_speed = randf_range(max_move_speed / 2, max_move_speed)
			timer = randf_range(0.4, 1.6)
		else:
			timer -= delta

func _hit(pl):
	for i in mesh.size():
		mesh[i].visible = false
	particles.emitting = true
	if !spawned:
		if get_parent().has_method("_spawn_man"):
			get_parent()._spawn_man()
		spawned = true

func _on_gpu_particles_3d_finished() -> void:
	queue_free()
