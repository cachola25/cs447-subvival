extends Fish

class_name triggerfish

const MIN_SPEED = 1250
const MAX_SPEED = 1450
const VALUE = 3

var in_bubble = false

func _ready() -> void:
	fish_type = "triggerfish"
	
func _process(delta: float) -> void:
	pass
