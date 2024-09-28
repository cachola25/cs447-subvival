extends Control

@onready var submarine_scene = get_parent().get_parent()
var can_display = false
signal killedFish

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	submarine_scene.connect(
		"killed_new", _on_killed_new
	)
	pass

func _on_killed_new():
	if not can_display:
		return
	var fish_type = submarine_scene.get_meta("killed_new_fish_type")
	var new_fish_node = get_node(fish_type)
	var comp_img_str = "res://assets/art/GUI/compendium/" + fish_type + "_comp.png"
	new_fish_node.texture = load(comp_img_str)
	#emit_signal("killedFish")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
