extends StaticBody3D

@export var manager : Manager

func _hit(_pl):
	manager.started = !manager.started