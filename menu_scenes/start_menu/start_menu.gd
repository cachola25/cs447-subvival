extends Node2D

@onready var start_bg = $StartTextureButton/start_bg
@onready var quit_bg = $QuitTextureButton/quit_bg

var changeState = false
#var style
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_texture_button_button_down() -> void:
	#get_tree().change_scene(load("res://level.tscn"))
	var game_scene = load("res://ocean/ocean_2.tscn").instantiate()
	get_tree().root.get_child(0).queue_free()
	get_tree().root.add_child(game_scene)

func _on_quit_texture_button_button_down() -> void:
	get_tree().quit()

func style_button(panel: Panel, color: Color, width: int) -> void:
	var style = panel.get_theme_stylebox("panel").duplicate()
	style.bg_color = color
	style.set_border_width_all(width)
	panel.add_theme_stylebox_override("panel",style)
	
func _on_start_texture_button_mouse_entered() -> void:
	style_button(start_bg, Color(0.5,0.5,0.5), 3) 

func _on_quit_texture_button_mouse_entered() -> void:
	style_button(quit_bg, Color(0.5,0.5,0.5), 3)

func _on_start_texture_button_mouse_exited() -> void:
	style_button(start_bg, Color(0,0,0), 0)

func _on_quit_texture_button_mouse_exited() -> void:
	style_button(quit_bg, Color(0,0,0), 0)
