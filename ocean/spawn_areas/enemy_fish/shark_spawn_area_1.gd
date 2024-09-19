extends Area2D

const shark_scene = preload("res://enemy_fish/shark/shark.tscn")

var submarine_in_area = false
var submarine_instance
var curr_num_shark = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	submarine_instance = get_parent().get_node("submarine")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_shark():
	var shark_instance = shark_scene.instantiate()
	var transform_position = Transform2D()
	var spawn_pos = submarine_instance.global_position
	var min_distance = 600
	while spawn_pos.distance_to(submarine_instance.global_position) < min_distance:
		var randX = randi_range(-1500,1500)
		var randY = randi_range(-1500,1500)
		spawn_pos = submarine_instance.global_position + Vector2(randX,randY)
	
	transform_position.origin = spawn_pos
	var SHARK_SPEED = get_parent().get_meta("SHARK_SPEED")
	var SHARK_DAMAGE = get_parent().get_meta("SHARK_DAMAGE")
	shark_instance.connect("despawned", _on_shark_despawned)
	add_child(shark_instance)
	shark_instance.start(transform_position, 
		submarine_instance.global_position, SHARK_SPEED, SHARK_DAMAGE)
	shark_instance.get_node("AnimatedSprite2D").play("shark_swim")
	curr_num_shark += 1
	
func _on_body_entered(body: Node2D) -> void:
	submarine_in_area = true
func _on_body_exited(body: Node2D) -> void:
	submarine_in_area = false
func _on_shark_despawned():
	curr_num_shark -= 1
func _on_spawn_delay_timer_timeout() -> void:
	if (submarine_in_area && curr_num_shark < get_parent().get_meta("MAX_SHARK_IN_AREA")):
		spawn_shark()
