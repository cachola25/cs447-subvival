extends Area2D

var MAX_FISH = 15
var triggerfish_scene = preload("res://triggerfish.tscn")
var paths = []
var active_triggerfish = [] # Array of PathFollow2D nodes that have the fish swimming
var submarine_in_area = false

func spawn_triggerfish():
	var random_path = paths[randi() % paths.size()]
	var triggerfish_instance = triggerfish_scene.instantiate()
	var path_follow = PathFollow2D.new()
	triggerfish_instance.get_node("AnimatedSprite2D").play("triggerfish_swim")
	random_path.add_child(path_follow)
	path_follow.add_child(triggerfish_instance)
	path_follow.progress_ratio = randf()
	path_follow.set_meta("speed",
	randf_range(triggerfish_instance.MIN_SPEED, triggerfish_instance.MAX_SPEED))
	active_triggerfish.append(path_follow)
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
	for i in range(len(active_triggerfish) - 1, -1 , -1):
		var triggerfish_pathfollow = active_triggerfish[i]
		var triggerfish_pathfollow_scene = triggerfish_pathfollow.get_child(0)
		if (triggerfish_pathfollow_scene.in_bubble):
			active_triggerfish.remove_at(i)
			triggerfish_pathfollow.queue_free()
			continue
		var speed = triggerfish_pathfollow.get_meta("speed")
		triggerfish_pathfollow.progress += speed *  delta
		if triggerfish_pathfollow.progress_ratio >= 1:
			active_triggerfish.remove_at(i)
			triggerfish_pathfollow.queue_free()

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
	if (submarine_in_area and len(active_triggerfish) < MAX_FISH):
		spawn_triggerfish()
