extends Node2D

@onready var quit_bg = $quit_button/quit_bg

var changeState = false
#var style
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func style_button(panel: Panel, color: Color, width: int) -> void:
	var style = panel.get_theme_stylebox("panel").duplicate()
	style.bg_color = color
	style.set_border_width_all(width)
	panel.add_theme_stylebox_override("panel",style)

func _on_quit_button_mouse_entered() -> void:
	style_button(quit_bg, Color(0.5,0.5,0.5), 3)


func _on_quit_button_mouse_exited() -> void:
	style_button(quit_bg, Color(0,0,0), 0)

func _on_quit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://menu_scenes/start_menu/start_menu.tscn")
