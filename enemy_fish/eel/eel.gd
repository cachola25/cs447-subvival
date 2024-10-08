extends enemy_fish

######################################
# Currently only used to declare the 
# class name and keep track of if 
# the eel hit the submarine and other
# actions need to be taken
# An eel should only collide with and do:
#		- submarine -> deal damage and exit from scene
######################################

class_name eel

@onready var explosion_sound = preload("res://submarine/torpedo/explosion.tscn")

var SPEED
var DAMAGE_DEALT
signal despawned
signal hit_sub
signal hit_by_torpedo

var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
var submarine_scene


func start(_transform, submarine_position, _SPEED, _DAMAGE_DEALT):
	global_transform = _transform
	var direction = (submarine_position - global_position).normalized()
	SPEED = _SPEED
	DAMAGE_DEALT = _DAMAGE_DEALT
	velocity = direction * SPEED
	enemy_fish_type = "eel"
	submarine_scene = get_parent().get_parent().get_node("submarine")

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
		if not body.died:
			body.get_node("AnimatedSprite2D").play("damage_taken")
			body.get_node("CanvasLayer/health_bar").value -= (DAMAGE_DEALT - body.ARMOR)
			emit_signal("hit_sub")
		emit_signal("despawned")
		queue_free()
	elif body is torpedo:
		get_tree().current_scene.add_child(explosion_sound.instantiate())
		body.get_node("AnimatedSprite2D").play("exploding")
		emit_signal("hit_by_torpedo")
		emit_signal("despawned")
		queue_free()

func _on_timer_timeout() -> void:
	emit_signal("despawned")
	queue_free()
