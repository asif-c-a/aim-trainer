class_name Manager
extends Node3D

@export var player: Node3D
var started: bool = false
var paused: bool = false

func _process(_delta: float) -> void:
	if paused:
		# get_tree().paused = true
		player.allow_input = false
	else:
		# get_tree().paused = false
		player.allow_input = true
	
	if Input.is_action_just_pressed("exit"):
		paused = !paused
