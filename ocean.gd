extends Node2D

const MAP_SCALE_X = 10
const MAP_SCALE_Y = 10

@onready var submarine = $submarine
var map_left_limit = 0
var map_right_limit
var map_top_limit = 0
var map_bottom_limit
var submarine_camera
var minimap_camera

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$background.z_index = 0
	map_right_limit = $background.size.x
	map_bottom_limit = $background.size.y
	map_right_limit *= MAP_SCALE_X
	map_bottom_limit *= MAP_SCALE_Y
	submarine_camera = submarine.get_node("Camera2D")
	minimap_camera = $CanvasLayer/SubViewportContainer/SubViewport/Camera2D
	
	submarine_camera.limit_left = map_left_limit
	submarine_camera.limit_right = map_right_limit
	submarine_camera.limit_top = map_top_limit
	submarine_camera.limit_bottom = map_bottom_limit
	
func _process(delta: float) -> void:
	pass
	
