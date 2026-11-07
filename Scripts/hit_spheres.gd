extends StaticBody3D

@export var sphere : MeshInstance3D
@export var coll_shape: CollisionShape3D
@export var particles : GPUParticles3D

var hit: bool = false
var spawned = false

func _ready() -> void:
	coll_shape.disabled = false
	if particles and not particles.finished.is_connected(_on_gpu_particles_3d_finished):
		particles.finished.connect(_on_gpu_particles_3d_finished)

func _hit(_pl):
	if hit:
		return

	hit = true
	# print("hit")
	
	if sphere:
		sphere.visible = false
	else:
		print("Warning: 'sphere' export is unassigned on: ", name)
	
	if coll_shape:
		coll_shape.disabled = true
	else:
		print("Warning: 'coll_shape' export is unassigned on: ", name)
	
	if particles:
		particles.emitting = true
	else:
		print("Warning: 'particles' export is unassigned on: ", name)
		queue_free()
		return
		
	if !spawned:
		if get_parent() and get_parent().has_method("_flicked"):
			get_parent()._flicked()
		elif get_parent() and get_parent().has_method("_spawn_sphere"):
			get_parent()._spawn_sphere(global_position)
		spawned = true

func _on_gpu_particles_3d_finished() -> void:
	queue_free()
