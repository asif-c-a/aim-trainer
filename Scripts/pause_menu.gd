extends CanvasLayer

@export var manager: Manager

func _process(_delta: float) -> void:
    if manager.paused:
        visible = true
    else:
        visible = false

func _on_resume_pressed() -> void:
    manager.paused = false

func _on_quit_to_menu_pressed() -> void:
    SceneChanger.change_scene(SceneChanger.MAIN_MENU)

func _on_quit_to_desktop_pressed() -> void:
    get_tree().quit()