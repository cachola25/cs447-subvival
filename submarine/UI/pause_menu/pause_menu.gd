extends Control

func resume():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("RESET")
	
func paused():
	get_tree().paused  = true
	$AnimationPlayer.play("blur")
	
func testEsc():
	if Input.is_action_just_pressed("escape"):
		if not get_tree().paused:
			paused()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("RESET")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	testEsc()


func _on_resume_pressed() -> void:
	resume()

func _on_help_pressed() -> void:
	get_tree().paused = true
	
	var help_menu = load("res://menu_scenes/help_menu/help_scene.tscn").instantiate()
	help_menu.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	add_child(help_menu)
func _on_quit_pressed() -> void:
	get_tree().quit()
