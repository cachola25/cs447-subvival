extends Control

@onready var submarine_scene = get_parent().get_parent()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	submarine_scene.connect(
		"discovered_new", _on_discovered_new
	)

func _on_discovered_new():
	var fish_type = submarine_scene.get_meta("discovered_new_fish_type")
	var new_fish_node = get_node(fish_type)
	var comp_img_str = "res://art/Fish/" + fish_type + "_comp.png"
	new_fish_node.texture = load(comp_img_str)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
