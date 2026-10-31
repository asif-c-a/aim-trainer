extends CanvasLayer

@export var ammo_text : RichTextLabel

func _process(_delta: float) -> void:
	pass

func _ammo(ammo : int):
	ammo_text.text = str(ammo)

	if ammo == 0:
		ammo_text.modulate.r = 255
		ammo_text.modulate.g = 0
		ammo_text.modulate.b = 0
	else:
		ammo_text.modulate.r = 255
		ammo_text.modulate.g = 255
		ammo_text.modulate.b = 255
