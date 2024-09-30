extends SubViewport

@onready var camera = $Camera2D
@onready var submarine_scene = get_parent().get_parent().get_parent()
@onready var ocean_scene = get_tree().root.get_child(0)

func _physics_process(delta: float) -> void:
	var target_position = submarine_scene.global_position
	var viewport_size = camera.get_viewport().get_visible_rect().size / camera.zoom
	var half_viewport_size = viewport_size / 2.0
	var clamped_x = clamp(target_position.x, 
		ocean_scene.map_left_limit + half_viewport_size.x,
		ocean_scene.map_right_limit - half_viewport_size.x)
	var clamped_y = clamp(target_position.y,
		ocean_scene.map_top_limit + half_viewport_size.y,
		ocean_scene.map_bottom_limit - half_viewport_size.y)
	camera.position = Vector2(clamped_x,clamped_y)
