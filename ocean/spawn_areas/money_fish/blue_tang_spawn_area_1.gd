extends Area2D

var MAX_FISH = 15
var blue_tang_scene = preload("res://money_fish/blue_tang/blue_tang.tscn")
var paths = []
var active_blue_tang = [] # Array of PathFollow2D nodes that have the fish swimming
var submarine_in_area = false

func spawn_blue_tang():
	var random_path = paths[randi() % paths.size()]
	var blue_tang_instance = blue_tang_scene.instantiate()
	var path_follow = PathFollow2D.new()
	blue_tang_instance.get_node("AnimatedSprite2D").play("blue_tang_swim")
	random_path.add_child(path_follow)
	path_follow.add_child(blue_tang_instance)
	path_follow.progress_ratio = randf()
	path_follow.set_meta("speed",
	randf_range(blue_tang_instance.MIN_SPEED, blue_tang_instance.MAX_SPEED))
	active_blue_tang.append(path_follow)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is Path2D:
			paths.append(child)

func _on_luck_updated(luck):
	MAX_FISH = MAX_FISH + (MAX_FISH * luck)
	$spawn_timer.wait_time -= 0.2
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for i in range(len(active_blue_tang) - 1, -1 , -1):
		var blue_tang_pathfollow = active_blue_tang[i]
		var blue_tang_pathfollow_scene = blue_tang_pathfollow.get_child(0)
		if (blue_tang_pathfollow_scene.in_bubble):
			active_blue_tang.remove_at(i)
			blue_tang_pathfollow.queue_free()
			continue
		var speed = blue_tang_pathfollow.get_meta("speed")
		blue_tang_pathfollow.progress += speed *  delta
		if blue_tang_pathfollow.progress_ratio >= 1:
			active_blue_tang.remove_at(i)
			blue_tang_pathfollow.queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body is submarine:
		submarine_in_area = true
		body.get_node("CanvasLayer").get_node("upgrade_menu").connect(
			"luck_updated", _on_luck_updated, body.LUCK
		)
func _on_body_exited(body: Node2D) -> void:
	if body is submarine:
		submarine_in_area = false
func _on_spawn_timer_timeout() -> void:
	if (submarine_in_area and len(active_blue_tang) < MAX_FISH):
		spawn_blue_tang()
