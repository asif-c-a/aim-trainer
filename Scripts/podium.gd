extends Node3D

enum type{
	FLASH,
	HITMAN,
	HITSPHERE
}

@export var spawn_item: type
@export var spawn_position: Marker3D

@export var hit_man: PackedScene
@export var hit_sphere: PackedScene
@export var flash: PackedScene

func _hit(pl):
	match spawn_item:
		type.HITSPHERE:
			_spawn_sphere()

		type.HITMAN:
			_spawn_hit_man()
		
		type.FLASH:
			_spawn_flash(pl)

func _spawn_hit_man():
	var man = hit_man.instantiate()
	add_child(man)
	man.global_position = spawn_position.global_position
	man.moving = false

	await get_tree().create_timer(3).timeout
	if is_instance_valid(man):
		man.queue_free()

func _spawn_sphere():
	var sph = hit_sphere.instantiate()
	add_child(sph)
	sph.global_position = spawn_position.global_position + Vector3(0, 2, 0)

	await get_tree().create_timer(3).timeout
	if is_instance_valid(sph):
		sph.queue_free()

func _spawn_flash(pl):
	var fls = flash.instantiate()
	add_child(fls)
	fls.global_position = spawn_position.global_position + Vector3(0, 1, 0)
	fls._player_inst(pl)
