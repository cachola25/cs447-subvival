extends Area2D

const shark_scene = preload("res://enemy_fish/shark/shark.tscn")

var submarine_in_area = false
@onready var submarine_instance = get_parent().get_node("submarine")
var curr_num_shark = 0
var is_first_spawn = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_shark():
	var shark_instance = shark_scene.instantiate()
	var transform_position = Transform2D()
	var spawn_pos = submarine_instance.global_position
	var min_distance = 600
	while spawn_pos.distance_to(submarine_instance.global_position) < min_distance:
		var randX = randi_range(-2000,2000)
		var randY = randi_range(-2000,2000)
		spawn_pos = submarine_instance.global_position + Vector2(randX,randY)
	
	transform_position.origin = spawn_pos
	var SHARK_SPEED = get_parent().get_meta("SHARK_SPEED")
	var SHARK_DAMAGE = get_parent().get_meta("SHARK_DAMAGE")
	shark_instance.connect("despawned", _on_shark_despawned)
	shark_instance.connect("hit_sub", _on_hit_sub)
	shark_instance.connect("hit_by_torpedo", _on_hit_by_torpedo)
	add_child(shark_instance)
	shark_instance.start(transform_position, 
		submarine_instance.global_position, SHARK_SPEED, SHARK_DAMAGE)
	shark_instance.get_node("AnimatedSprite2D").play("shark_swim")
	curr_num_shark += 1
	if is_first_spawn:
		$CollisionShape2D.scale = Vector2(4.5,4.5)
		is_first_spawn = false
	
func _on_body_entered(body: Node2D) -> void:
	submarine_in_area = true
func _on_body_exited(body: Node2D) -> void:
	submarine_in_area = false
func _on_hit_sub():
	get_parent().get_node("shark_bite").play()
	get_parent().get_node("sub_damaged").play()
func _on_hit_by_torpedo():
	if not "shark" in submarine_instance.defeated_enemy_fish:
		submarine_instance.defeated_enemy_fish["shark"] = true
	submarine_instance.set_meta("killed_new_fish_type", "shark")
	submarine_instance.emit_signal("killed_new")
func _on_shark_despawned():
	curr_num_shark -= 1
func _on_spawn_delay_timer_timeout() -> void:
	if (submarine_in_area && curr_num_shark < get_parent().get_meta("MAX_SHARK_IN_AREA")):
		spawn_shark()
