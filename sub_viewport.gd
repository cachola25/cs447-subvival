extends SubViewport

@onready var camera = $Camera2D
@onready var submarine = get_parent().get_parent().get_parent().get_node("submarine")

func _physics_process(delta: float) -> void:
	camera.position = submarine.position
