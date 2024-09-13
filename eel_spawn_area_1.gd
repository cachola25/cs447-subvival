extends Area2D

const eel_scene = preload("res://eel.tscn")
const MAX_EELs = 3

var submarine_in_area = false
var submarine
var curr_num_eels = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	submarine = get_parent().get_node("submarine")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_eel():
	var eel_instance = eel_scene.instantiate()
	var transform_position = Transform2D()
	var spawn_pos = submarine.global_position
	var min_distance = 300
	while spawn_pos.distance_to(submarine.global_position) < min_distance:
		var randX = randi_range(-1000,1000)
		var randY = randi_range(-1000,1000)
		spawn_pos = submarine.global_position + Vector2(randX,randY)
	
	transform_position.origin = spawn_pos
	eel_instance.connect("despawned", _on_eel_despawned)
	eel_instance.connect("hit_sub", _on_hit_sub)
	eel_instance.start(transform_position, submarine.global_position)
	eel_instance.get_node("AnimatedSprite2D").play("eel_swim")
	add_child(eel_instance)
	curr_num_eels += 1
	
func _on_body_entered(body: Node2D) -> void:
	submarine_in_area = true
func _on_body_exited(body: Node2D) -> void:
	submarine_in_area = false
func _on_eel_despawned():
	curr_num_eels -= 1
func _on_hit_sub():
	var oxygen_bar = get_parent().get_node("CanvasLayer/oxygen_bar")
	oxygen_bar.value -= 5
func _on_spawn_delay_timer_timeout() -> void:
	if (submarine_in_area && curr_num_eels <= MAX_EELs):
		spawn_eel()
