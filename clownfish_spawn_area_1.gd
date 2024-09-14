extends Area2D

const MAX_FISH = 15
var clownfish_scene = preload("res://clownfish.tscn")
var paths = []
var active_clownfish = [] # Array of PathFollow2D nodes that have the fish swimming
var submarine_in_area = false

func spawn_clownfish():
	var random_path = paths[randi() % paths.size()]
	var clownfish_instance = clownfish_scene.instantiate()
	var path_follow = PathFollow2D.new()
	clownfish_instance.get_node("AnimatedSprite2D").play("clownfish_swim")
	random_path.add_child(path_follow)
	path_follow.add_child(clownfish_instance)
	path_follow.progress_ratio = randf()
	path_follow.set_meta("speed",
	randf_range(clownfish_instance.MIN_SPEED, clownfish_instance.MAX_SPEED))
	active_clownfish.append(path_follow)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is Path2D:
			paths.append(child)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for i in range(len(active_clownfish) - 1, -1 , -1):
		var clownfish_pathfollow = active_clownfish[i]
		var clownfish_pathfollow_scene = clownfish_pathfollow.get_child(0)
		if (clownfish_pathfollow_scene.in_bubble):
			active_clownfish.remove_at(i)
			clownfish_pathfollow.queue_free()
			continue
		var speed = clownfish_pathfollow.get_meta("speed")
		clownfish_pathfollow.progress += speed *  delta
		if clownfish_pathfollow.progress_ratio >= 1:
			active_clownfish.remove_at(i)
			clownfish_pathfollow.queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body is submarine:
		submarine_in_area = true
func _on_body_exited(body: Node2D) -> void:
	if body is submarine:
		submarine_in_area = false
func _on_spawn_timer_timeout() -> void:
	if (submarine_in_area and len(active_clownfish) < MAX_FISH):
		spawn_clownfish()
