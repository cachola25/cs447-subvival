extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_close_pressed() -> void:
	if get_parent() is pause_menu:
		get_parent().get_node("AnimationPlayer").play("blur")
		queue_free()
	else:
		get_tree().change_scene_to_file("res://menu_scenes/start_menu/start_menu.tscn")
