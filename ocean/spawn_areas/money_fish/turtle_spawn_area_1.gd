extends Area2D

var MAX_FISH = 15
var turtle_scene = preload("res://money_fish/turtle/turtle.tscn")
var paths = []
var active_turtles = [] # Array of PathFollow2D nodes that have the fish swimming
var submarine_in_area = false

func spawn_turtle():
	var random_path = paths[randi() % paths.size()]
	var turtle_instance = turtle_scene.instantiate()
	var path_follow = PathFollow2D.new()
	turtle_instance.get_node("AnimatedSprite2D").play("turtle_swim")
	random_path.add_child(path_follow)
	path_follow.add_child(turtle_instance)
	path_follow.progress_ratio = randf()
	path_follow.set_meta("speed",
	randf_range(turtle_instance.MIN_SPEED, turtle_instance.MAX_SPEED))
	active_turtles.append(path_follow)
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
	for i in range(len(active_turtles) - 1, -1 , -1):
		var turtle_pathfollow = active_turtles[i]
		var turtle_pathfollow_scene = turtle_pathfollow.get_child(0)
		if (turtle_pathfollow_scene.in_bubble):
			active_turtles.remove_at(i)
			turtle_pathfollow.queue_free()
			continue
		var speed = turtle_pathfollow.get_meta("speed")
		turtle_pathfollow.progress += speed *  delta
		if turtle_pathfollow.progress_ratio >= 1:
			active_turtles.remove_at(i)
			turtle_pathfollow.queue_free()

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
	if (submarine_in_area and len(active_turtles) < MAX_FISH):
		spawn_turtle()
