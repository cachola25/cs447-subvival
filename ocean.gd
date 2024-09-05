extends Node2D

var bubble_scene = load("res://bubble.tscn")

func spawn_bubble(sub_position):
	var bubble = bubble_scene.instantiate()
	bubble.position = sub_position
	bubble.visible = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
