extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_retry_button_pressed() -> void:
	var game_scene = load("res://ocean/ocean_2.tscn").instantiate()
	get_tree().root.get_child(0).queue_free()
	get_tree().root.add_child(game_scene)

func _on_quit_button_pressed() -> void:
	get_tree().quit()
