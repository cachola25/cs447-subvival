extends Node2D

######################################
# Currently only used to initialize 
# the oxygen bar 
######################################
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$oxygen_bar.value = 100


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
