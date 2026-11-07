extends StaticBody3D

@export var manager : Manager

func _hit(pl):
	manager.started = !manager.started