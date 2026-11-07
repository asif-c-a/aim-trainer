extends Node

const MAIN_MENU = "res://Scenes/Menu/main_menu.tscn"
const STATIC_SHOOT = "res://Scenes/Levels/static_clicking.tscn"
const FLICK_SHOOT = "res://Scenes/Levels/flick_shot.tscn"
const MICRO_FLICK = "res://Scenes/Levels/micro_flick.tscn"

func change_scene(scene_path: String) -> void:
    var error = get_tree().change_scene_to_file(scene_path)

    if error != OK:
        printerr("Failed to change scene: ", scene_path)