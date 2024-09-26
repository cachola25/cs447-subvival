extends Area2D

class_name shark

var SPEED = 0
var DAMAGE_DEALT
var ocean_scene
signal hit_sub
signal despawned

var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO

func start(_transform, submarine_position, _SPEED, _DAMAGE_DEALT):
	global_transform = _transform
	var direction = (submarine_position - global_position).normalized()
	SPEED = _SPEED
	DAMAGE_DEALT = _DAMAGE_DEALT
	velocity = direction * SPEED
	ocean_scene = get_tree().root.get_child(0)

func _physics_process(delta):
	var submarine_position = ocean_scene.get_meta("SUBMARINE_POSITION")
	if global_position.distance_to(submarine_position) <= 1500:
		if not $near_sub.playing:
			print("playing")
			$near_sub.play()
	else:
		if $near_sub.playing:
			print("stopping")
			$near_sub.stop()
	var direction = (submarine_position - global_position).normalized()
	velocity = direction * SPEED
	rotation = velocity.angle()
	position += SPEED * Vector2.RIGHT.rotated(rotation) * delta
	look_at(submarine_position)

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body is submarine:
		body.get_node("AnimatedSprite2D").play("damage_taken")
		body.get_node("CanvasLayer/health_bar").value -= (DAMAGE_DEALT - body.ARMOR)
		emit_signal("hit_sub")
		emit_signal("despawned")
		queue_free()
	elif body is torpedo:
		print("Shark hit by torpedo")
		body.queue_free()
		emit_signal("despawned")
		queue_free()

func _on_timer_timeout() -> void:
	pass
	#emit_signal("despawned")
	#queue_free()
