extends StaticBody3D

@export var sphere : MeshInstance3D
@export var particles : GPUParticles3D

var spawned = false

func _hit(pl):
	sphere.visible = false
	particles.emitting = true
	if !spawned:
		if get_parent().has_method("_spawn_sphere"):
			get_parent()._spawn_sphere()
		spawned = true

func _on_gpu_particles_3d_finished() -> void:
	queue_free()
