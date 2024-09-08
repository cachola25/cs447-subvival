extends PathFollow2D

const SPEED = 200.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	progress += delta * SPEED
	print(progress_ratio)
	if progress_ratio == 1:
		progress_ratio = 0
