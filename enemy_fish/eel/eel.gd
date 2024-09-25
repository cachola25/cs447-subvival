extends Area2D

######################################
# Currently only used to declare the 
# class name and keep track of if 
# the eel hit the submarine and other
# actions need to be taken
# An eel should only collide with and do:
#		- submarine -> deal damage and exit from scene
######################################

class_name eel

var SPEED
var DAMAGE_DEALT
signal despawned
signal hit_sub

var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO


func start(_transform, submarine_position, _SPEED, _DAMAGE_DEALT):
	global_transform = _transform
	var direction = (submarine_position - global_position).normalized()
	SPEED = _SPEED
	DAMAGE_DEALT = _DAMAGE_DEALT
	velocity = direction * SPEED

func _physics_process(delta):
	velocity += acceleration * delta
	velocity = velocity.limit_length(SPEED)
	rotation = velocity.angle()
	position += velocity * delta

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
		print("Eel hit by torpedo")
		body.queue_free()
		emit_signal("despawned")
		queue_free()

func _on_timer_timeout() -> void:
	emit_signal("despawned")
	queue_free()
