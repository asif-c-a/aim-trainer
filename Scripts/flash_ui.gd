extends CanvasLayer

@export var flash_img: Sprite2D

func _flash(coords: Vector2):
	flash_img.position = coords
	visible = true

	await get_tree().create_timer(1.5).timeout
	visible = false