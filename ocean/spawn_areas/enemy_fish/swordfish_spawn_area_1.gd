extends Area2D

const swordfish_scene = preload("res://enemy_fish/swordfish/swordfish.tscn")

@onready var submarine_instance = get_parent().get_node("submarine")
var submarine_in_area = false
var curr_num_swordfish = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_swordfish():
	var swordfish_instance = swordfish_scene.instantiate()
	var transform_position = Transform2D()
	var spawn_pos = submarine_instance.global_position
	var min_distance = 600
	while spawn_pos.distance_to(submarine_instance.global_position) < min_distance:
		var randX = randi_range(-1500,1500)
		var randY = randi_range(-1500,1500)
		spawn_pos = submarine_instance.global_position + Vector2(randX,randY)
	
	transform_position.origin = spawn_pos
	var SWORDFISH_SPEED = get_parent().get_meta("SWORDFISH_SPEED")
	var SWORDFISH_DAMAGE = get_parent().get_meta("SWORDFISH_DAMAGE")
	swordfish_instance.connect("despawned", _on_swordfish_despawned)
	swordfish_instance.connect("hit_sub", _on_hit_sub)
	swordfish_instance.connect("hit_by_torpedo", _on_hit_by_torpedo)
	add_child(swordfish_instance)
	swordfish_instance.start(transform_position, 
		submarine_instance.global_position, SWORDFISH_SPEED, SWORDFISH_DAMAGE)
	swordfish_instance.get_node("AnimatedSprite2D").play("swordfish_swim")
	curr_num_swordfish += 1
	
func _on_body_entered(body: Node2D) -> void:
	submarine_in_area = true
func _on_body_exited(body: Node2D) -> void:
	submarine_in_area = false
func _on_hit_sub():
	get_parent().get_node("swordfish_hit").play()
	get_parent().get_node("sub_damaged").play()
func _on_hit_by_torpedo():
	if not "swordfish" in submarine_instance.defeated_enemy_fish:
		submarine_instance.defeated_enemy_fish["swordfish"] = true
		get_parent().get_node("log_enemy_fish").play()
	submarine_instance.set_meta("killed_new_fish_type", "swordfish")
	submarine_instance.emit_signal("killed_new")
func _on_swordfish_despawned():
	curr_num_swordfish -= 1
func _on_spawn_delay_timer_timeout() -> void:
	if (submarine_in_area && curr_num_swordfish < get_parent().get_meta("MAX_SWORDFISH_IN_AREA")):
		spawn_swordfish()
