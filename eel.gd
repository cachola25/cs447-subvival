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

const SPEED = 500
const DAMAGE_DEALT = 5
signal despawned
signal hit_sub

var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO

func start(_transform, submarine_position):
	global_transform = _transform
	var direction = (submarine_position - global_position).normalized()
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
		body.get_node("CanvasLayer/oxygen_bar").value -= DAMAGE_DEALT
		emit_signal("despawned")
		queue_free()

func _on_timer_timeout() -> void:
	emit_signal("despawned")
	queue_free() 
