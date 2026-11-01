extends Node3D
class_name Gun

@export var fire_rate : float = 9.75
@export var anim : AnimationPlayer
@export var soun : AudioStreamPlayer3D
@export var gun_name: String
@export var sprayable: bool = false

func _shoot():
	if anim:
		anim.speed_scale = fire_rate
		anim.play("pin_back")
	soun.play()


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	anim.play("RESET")
