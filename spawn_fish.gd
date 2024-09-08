extends Node2D

const MIN_FISH_SPEED = 350
const MAX_FISH_SPEED = 500
const MAX_FISH = 10
var money_fish_scene = preload("res://money_fish.tscn")
var paths = []
var active_money_fish = []

func spawn_fish():
	var random_path = paths[randi() % paths.size()]
	var money_fish = money_fish_scene.instantiate()
	var path_follow = PathFollow2D.new()
	path_follow.z_index = 2
	random_path.add_child(path_follow)
	path_follow.add_child(money_fish)
	add_child(path_follow)
	path_follow.progress_ratio = randf()
	path_follow.set_meta("speed", randf_range(MIN_FISH_SPEED, MAX_FISH_SPEED))
	active_money_fish.append(path_follow)
	
	
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	paths.append($Path2D_1)
	paths.append($Path2D_2)
	paths.append($Path2D_3)
	$money_fish_spawn_timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for i in range(len(active_money_fish)-1, -1, -1):
		var curr_fish = active_money_fish[i]
		var curr_fish_speed = curr_fish.get_meta("speed")
		curr_fish.progress += curr_fish_speed * delta
		if curr_fish.progress_ratio >= 1:
			active_money_fish.remove_at(i)
			curr_fish.queue_free()

func _on_money_fish_spawn_timer_timeout() -> void:
	if not len(active_money_fish) <= MAX_FISH:
		return
	spawn_fish()
