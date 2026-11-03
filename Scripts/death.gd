extends Area3D

func _on_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D and body.has_method("_hit"):
		body._hit(null)
