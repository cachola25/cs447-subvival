extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$O2/O2ProgressBar.value = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_texture_button_button_down() -> void:
	$O2/O2ProgressBar.value += 1
