extends Area2D

const eel_scene = preload("res://enemy_fish/eel/eel.tscn")

var submarine_in_area = false
var submarine_instance
var curr_num_eel = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	submarine_instance = get_parent().get_node("submarine")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_eel():
	var eel_instance = eel_scene.instantiate()
	var transform_position = Transform2D()
	var spawn_pos = submarine_instance.global_position
	var min_distance = 600
	while spawn_pos.distance_to(submarine_instance.global_position) < min_distance:
		var randX = randi_range(-1500,1500)
		var randY = randi_range(-1500,1500)
		spawn_pos = submarine_instance.global_position + Vector2(randX,randY)
	
	transform_position.origin = spawn_pos
	var EEL_SPEED = get_parent().get_meta("EEL_SPEED")
	var EEL_DAMAGE = get_parent().get_meta("EEL_DAMAGE")
	eel_instance.connect("despawned", _on_eel_despawned)
	eel_instance.connect("hit_sub", _on_hit_sub)
	add_child(eel_instance)
	eel_instance.start(transform_position, 
		submarine_instance.global_position, EEL_SPEED, EEL_DAMAGE)
	eel_instance.get_node("AnimatedSprite2D").play("eel_swim")
	curr_num_eel += 1

func _on_hit_sub():
	get_parent().get_node("electric_shock").play(1.8)
	get_parent().get_node("sub_damaged").play()
func _on_body_entered(body: Node2D) -> void:
	submarine_in_area = true
func _on_body_exited(body: Node2D) -> void:
	submarine_in_area = false
func _on_eel_despawned():
	curr_num_eel -= 1
func _on_spawn_delay_timer_timeout() -> void:
	if (submarine_in_area && curr_num_eel < get_parent().get_meta("MAX_EEL_IN_AREA")):
		spawn_eel()
