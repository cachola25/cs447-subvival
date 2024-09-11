extends Control

func resume():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")
	
func paused():
	get_tree().paused  = true
	$AnimationPlayer.play("blur")
	
func testEsc():
	if Input.is_action_just_pressed("escape") and get_tree().paused == false:
		paused()
	elif Input.is_action_just_pressed("escape") and get_tree().paused == true:
		resume()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("RESET")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	testEsc()


func _on_resume_pressed() -> void:
	resume()


func _on_help_pressed() -> void:
	resume()


func _on_quit_pressed() -> void:
	get_tree().quit()
