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
	submarine_instance.connect("update_enemy_fish_metadata", _on_update_enemy_fish_metadata)
	for child in get_children():
		if child.name.begins_with("eel_spawn_area"):
			eel_spawn_areas.append(child)
	
	
func _process(delta: float) -> void:
	set_meta("SUBMARINE_POSITION", $submarine.global_position)
	
func _on_update_enemy_fish_metadata():
	var updated_eel_speed = get_meta("EEL_SPEED") + 100
	var updated_eel_max_in_area = get_meta("MAX_EEL_IN_AREA") + 2
	var updated_eel_damage = get_meta("EEL_DAMAGE") + 1
	
	set_meta("EEL_SPEED", updated_eel_speed)
	set_meta("MAX_EEL_IN_AREA", updated_eel_max_in_area)
	set_meta("EEL_DAMAGE", updated_eel_damage)
	
	var updated_swordfish_speed = get_meta("SWORDFISH_SPEED") + 100
	var updated_swordfish_max_in_area = get_meta("MAX_SWORDFISH_IN_AREA") + 1
	var updated_swordfish_damage = get_meta("SWORDFISH_DAMAGE") + 3
	
	set_meta("SWORDFISH_SPEED", updated_swordfish_speed)
	set_meta("MAX_SWORDFISH_IN_AREA", updated_swordfish_max_in_area)
	set_meta("SWORDFISH_DAMAGE", updated_swordfish_damage)
	
	var updated_shark_damage = get_meta("SHARK_DAMAGE") + 15
	set_meta("SHARK_DAMAGE", updated_shark_damage)

func _on_start_boss_fight():
	$background_music.stop()
	$start_boss_fight.play()


func _on_start_boss_fight_finished() -> void:
	var octopus_instance = octopus_scene.instantiate()
	octopus_instance.connect("defeated", _on_octopus_defeated)
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
	$boss_fight_music.play()

func _on_octopus_defeated():
	$boss_fight_music.stop()
	$background_music.play(1.0)
	$eel_spawn_area_1.queue_free()
	$swordfish_spawn_area_1.queue_free()
	$shark_spawn_area_1.queue_free()
	$octopus_death.play()
	
func _on_octopus_death_finished() -> void:
	$end_of_game.start()

func _on_end_of_game_timeout() -> void:
	get_tree().change_scene_to_file("res://menu_scenes/victory_screen/victory_screen.tscn")
