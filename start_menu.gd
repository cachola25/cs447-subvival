extends Node2D

var changeState = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_texture_button_button_down() -> void:
	#get_tree().change_scene(load("res://level.tscn"))
	var game_scene = load("res://ocean.tscn").instantiate()
	get_tree().root.get_child(0).queue_free()
	get_tree().root.add_child(game_scene)

func _on_quit_texture_button_button_down() -> void:
	get_tree().quit()
