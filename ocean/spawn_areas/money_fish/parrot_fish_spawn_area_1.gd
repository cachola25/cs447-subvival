extends Area2D

var MAX_FISH = 15
var parrot_fish_scene = preload("res://money_fish/parrot_fish/parrot_fish.tscn")
var paths = []
var active_parrot_fishs = [] # Array of PathFollow2D nodes that have the fish swimming
var submarine_in_area = false

func spawn_parrot_fish():
	var random_path = paths[randi() % paths.size()]
	var parrot_fish_instance = parrot_fish_scene.instantiate()
	var path_follow = PathFollow2D.new()
	parrot_fish_instance.get_node("AnimatedSprite2D").play("parrot_fish_swim")
	random_path.add_child(path_follow)
	path_follow.add_child(parrot_fish_instance)
	path_follow.progress_ratio = randf()
	path_follow.set_meta("speed",
	randf_range(parrot_fish_instance.MIN_SPEED, parrot_fish_instance.MAX_SPEED))
	active_parrot_fishs.append(path_follow)
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
	for i in range(len(active_parrot_fishs) - 1, -1 , -1):
		var parrot_fish_pathfollow = active_parrot_fishs[i]
		var parrot_fish_pathfollow_scene = parrot_fish_pathfollow.get_child(0)
		if (parrot_fish_pathfollow_scene.in_bubble):
			active_parrot_fishs.remove_at(i)
			parrot_fish_pathfollow.queue_free()
			continue
		var speed = parrot_fish_pathfollow.get_meta("speed")
		parrot_fish_pathfollow.progress += speed *  delta
		if parrot_fish_pathfollow.progress_ratio >= 1:
			active_parrot_fishs.remove_at(i)
			parrot_fish_pathfollow.queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body is submarine:
		submarine_in_area = true
		var ug_menu = body.get_node("CanvasLayer").get_node("upgrade_menu")
		if not ug_menu.is_connected("luck_updated", _on_luck_updated):
			body.get_node("CanvasLayer").get_node("upgrade_menu").connect(
				"luck_updated", _on_luck_updated, body.LUCK
			)
func _on_body_exited(body: Node2D) -> void:
	if body is submarine:
		submarine_in_area = false
func _on_spawn_timer_timeout() -> void:
	if (submarine_in_area and len(active_parrot_fishs) < MAX_FISH):
		spawn_parrot_fish()
