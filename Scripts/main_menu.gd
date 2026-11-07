extends Node3D

@export var main_menu: CanvasLayer
@export var play_menu: CanvasLayer
# @export var settings_menu: CanvasLayer

func _ready() -> void:
	main_menu.visible = true
	play_menu.visible = false

func _on_static_button_pressed() -> void:
	SceneChanger.change_scene(SceneChanger.STATIC_SHOOT)

func _on_flick_button_pressed() -> void:
	SceneChanger.change_scene(SceneChanger.FLICK_SHOOT)

func _on_micro_button_pressed() -> void:
	SceneChanger.change_scene(SceneChanger.MICRO_FLICK)

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_play_button_pressed() -> void:
	main_menu.visible = false
	play_menu.visible = true

func _on_back_pressed() -> void:
	main_menu.visible = true
	play_menu.visible = false