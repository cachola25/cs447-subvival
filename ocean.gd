extends Node2D

class_name ocean

const MAP_SCALE_X = 10
const MAP_SCALE_Y = 10

@onready var submarine = $submarine
var map_left_limit = 0
var map_right_limit
var map_top_limit = 0
var map_bottom_limit
var submarine_camera
var minimap_camera

var eel_spawn_areas = []
var update_damage_flag = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$background.z_index = 0
	map_right_limit = $background.size.x
	map_bottom_limit = $background.size.y
	map_right_limit *= MAP_SCALE_X
	map_bottom_limit *= MAP_SCALE_Y
	submarine_camera = submarine.get_node("Camera2D")
	
	submarine_camera.limit_left = map_left_limit
	submarine_camera.limit_right = map_right_limit
	submarine_camera.limit_top = map_top_limit
	submarine_camera.limit_bottom = map_bottom_limit
	
	for child in get_children():
		if child.name.begins_with("eel_spawn_area"):
			eel_spawn_areas.append(child)
	
func _process(delta: float) -> void:
	pass
	
func update_eel_metadata():
	var updated_speed = get_meta("EEL_SPEED") + 100
	var updated_max_in_area = get_meta("MAX_EELS_IN_AREA") + 2
	var updated_damage = get_meta("EEL_DAMAGE") + 1
	
	if updated_speed <= 2000:
		set_meta("EEL_SPEED", updated_speed)
	if updated_max_in_area <= 50:
		set_meta("MAX_EELS_IN_AREA", updated_max_in_area)
	if update_damage_flag % 3 == 0:
		set_meta("EEL_DAMAGE", updated_damage)
	
	for spawn_area in eel_spawn_areas:
		var timer = spawn_area.get_node("spawn_delay_timer")
		var curr_wait_time = timer.wait_time
		if (curr_wait_time - 0.1 <= 0.5):
			break
		timer.wait_time -= 0.1

func _on_player_alive_time_timeout() -> void:
	update_eel_metadata()
