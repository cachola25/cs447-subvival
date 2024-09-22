extends Area2D

class_name swordfish

var SPEED = 0
var DAMAGE_DEALT
var ocean_scene
var hit_sub = false
signal despawned

var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
var thrusting = false
var thrust_factor = 2.0


func start(_transform, submarine_position, _SPEED, _DAMAGE_DEALT):
	global_transform = _transform
	var direction = (submarine_position - global_position).normalized()
	SPEED = _SPEED
	DAMAGE_DEALT = _DAMAGE_DEALT
	velocity = direction * SPEED
	ocean_scene = get_tree().root.get_child(0)

func _physics_process(delta):
	rotation = velocity.angle()
	var target_position = ocean_scene.get_meta("SUBMARINE_POSITION")
	var distance_to_target = global_position.distance_to(target_position)
	if distance_to_target < 500 and not thrusting:
		thrusting = true
			
	if not hit_sub:
		position += SPEED * Vector2.RIGHT.rotated(rotation) * delta
	look_at(target_position)
	position = position.move_toward(target_position, SPEED * delta)
	position = position.move_toward(target_position, SPEED * delta)

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body is submarine:
		body.get_node("AnimatedSprite2D").play("damage_taken")
		body.get_node("CanvasLayer/health_bar").value -= (DAMAGE_DEALT - body.ARMOR)
		hit_sub = true
		emit_signal("despawned")
		queue_free()

func _on_timer_timeout() -> void:
	emit_signal("despawned")
	queue_free()
