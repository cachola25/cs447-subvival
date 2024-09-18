extends Fish

class_name parrot_fish

const MIN_SPEED = 600
const MAX_SPEED = 700
const VALUE = 4

var in_bubble = false
func _ready() -> void:
	fish_type = "parrot_fish"
	
func _process(delta: float) -> void:
	pass
