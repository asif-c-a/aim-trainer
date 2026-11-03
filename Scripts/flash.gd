extends Node3D

var flash_float_direction: Vector3 = Vector3.UP
var float_time: float = 1.5

var player

func _ready() -> void:
	await get_tree().create_timer(float_time).timeout
	_pop()

func _physics_process(delta: float) -> void:
	position = position + flash_float_direction * delta

func _player_inst(pl):
	player = pl

func _pop():
	player._check_flash_screen_pos(self)
	queue_free()
