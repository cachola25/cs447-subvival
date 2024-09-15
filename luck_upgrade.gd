extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$tooltip_text.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_tooltip_button_mouse_entered() -> void:
	$tooltip_text.visible = true


func _on_tooltip_button_mouse_exited() -> void:
	$tooltip_text.visible = false
