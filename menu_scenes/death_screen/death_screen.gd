extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AudioStreamPlayer.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_retry_button_pressed() -> void:
	get_tree().change_scene_to_file("res://ocean/ocean_2.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()
