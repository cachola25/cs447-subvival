extends Node2D

var changeState = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$O2/O2ProgressBar.value = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $O2/TextureButton.button_pressed && changeState:
		$O2/O2ProgressBar.value += 1
		changeState = false;
	
	if !$O2/TextureButton.button_pressed:
		changeState = true
