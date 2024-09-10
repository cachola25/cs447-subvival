extends Node2D

var changeState = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $Quit/TextureButton.button_pressed && changeState:
		get_tree().quit()
		changeState = false;
	
	if !$Quit/TextureButton.button_pressed:
		changeState = true
