extends Node2D

const MIN_FISH_SPEED = 350
const MAX_FISH_SPEED = 500
const MAX_FISH = 10
const MAX_EELS = 1
var money_fish_scene = preload("res://money_fish.tscn")
var eel_scene = preload("res://eel.tscn")
var paths = []
var active_money_fish = []
var active_eels = []
var oxygen_bar

func spawn_money_fish():
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
	
func spawn_eel():
	var eel = eel_scene.instantiate()
	var path_follow = PathFollow2D.new()
	path_follow.z_index = 2
	$Path2D_4.add_child(path_follow)
	path_follow.add_child(eel)
	add_child(path_follow)
	active_eels.append(path_follow)
	
	
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	paths.append($Path2D_1)
	paths.append($Path2D_2)
	paths.append($Path2D_3)
	$money_fish_spawn_timer.start()
	$eel_spawn_timer.start()
	oxygen_bar = get_parent().get_node("oxygen_bar")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for i in range(len(active_money_fish)-1, -1, -1):
		var curr_fish = active_money_fish[i]
		var money_fish_scene = curr_fish.get_child(0)
		if (money_fish_scene.in_bubble):
			active_money_fish.remove_at(i)
			curr_fish.queue_free()
			continue
		var curr_fish_speed = curr_fish.get_meta("speed")
		curr_fish.progress += curr_fish_speed * delta
		if curr_fish.progress_ratio >= 1:
			active_money_fish.remove_at(i)
			curr_fish.queue_free()
			
	for i in range(len(active_eels)-1, -1, -1):
		var curr_eel = active_eels[i]
		var curr_eel_scene = curr_eel.get_child(0)
		if (curr_eel_scene.hit_sub):
			oxygen_bar.value -= 10
			active_eels.remove_at(i)
			curr_eel.queue_free()
			continue
		curr_eel.progress += MAX_FISH_SPEED * 2 * delta
		if curr_eel.progress_ratio >= 1:
			active_eels.remove_at(i)
			curr_eel.queue_free()
	

func _on_money_fish_spawn_timer_timeout() -> void:
	if len(active_money_fish) > MAX_FISH:
		return
	spawn_money_fish()

func _on_eel_spawn_timer_timeout() -> void:
	if len(active_eels) > MAX_EELS:
		return
	spawn_eel()
