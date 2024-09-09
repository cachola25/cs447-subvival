extends CharacterBody2D

######################################
# Currently only used to declare the 
# class name and keep track of if 
# the eel hit the submarine and other
# actions need to be taken
# An eel should only collide with and do:
#		- submarine -> deal damage and exit from scene
######################################

class_name eel
var hit_sub = false

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass
