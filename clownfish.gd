extends CharacterBody2D

######################################
# Currently only used to declare the 
# class name and keep track of if 
# the fish got captured and other
# actions need to be taken
# A money fish should only collide with and do:
#		- bubble -> get captured and exit scene
#					since bubble.gd will handle 
#					post capture actions
######################################
class_name clownfish

const MIN_SPEED = 500
const MAX_SPEED = 1000
const VALUE = 1

var in_bubble = false

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	pass
