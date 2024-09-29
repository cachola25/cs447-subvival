extends Node2D

class_name ocean

const MAP_SCALE_X = 8
const MAP_SCALE_Y = 8

@onready var submarine_instance = $submarine
@onready var octopus_scene = preload("res://enemy_fish/octopus/octopus.tscn")
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
	DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_MAXIMIZED)
	$background_music.play(2)
	map_right_limit = $background.size.x
	map_bottom_limit = $background.size.y
	
	map_right_limit *= MAP_SCALE_X
	map_bottom_limit *= MAP_SCALE_Y
	submarine_camera = submarine_instance.get_node("Camera2D")
	
	submarine_camera.limit_left = map_left_limit
	submarine_camera.limit_right = map_right_limit
	submarine_camera.limit_top = map_top_limit
	submarine_camera.limit_bottom = map_bottom_limit
	
	submarine_instance.connect("start_boss_fight", _on_start_boss_fight)
	for child in get_children():
		if child.name.begins_with("eel_spawn_area"):
			eel_spawn_areas.append(child)
	
	_on_start_boss_fight()
	
func _process(delta: float) -> void:
	set_meta("SUBMARINE_POSITION", $submarine.global_position)
	
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

func _on_start_boss_fight():
	var octopus_instance = octopus_scene.instantiate()
	var transform_position = Transform2D()
	var spawn_pos = submarine_instance.global_position
	var min_distance = 600
	while spawn_pos.distance_to(submarine_instance.global_position) < min_distance:
		var randX = randi_range(-2000,2000)
		var randY = randi_range(-2000,2000)
		spawn_pos = submarine_instance.global_position + Vector2(randX,randY)
	
	transform_position.origin = spawn_pos
	add_child(octopus_instance)
	octopus_instance.start(transform_position, 
		submarine_instance.global_position, octopus_instance.SPEED, octopus_instance.DAMAGE_DEALT)
	octopus_instance.get_node("AnimatedSprite2D").play("octopus_swim")
	
func _on_player_alive_time_timeout() -> void:
	update_eel_metadata()
