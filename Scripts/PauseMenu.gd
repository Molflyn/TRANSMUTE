extends Control

func _process(_delta):
	if self.visible == false:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	if Input.is_action_just_pressed("ui_cancel"):
		if self.visible == false:
			self.visible = true
		else:
			self.visible = false

func _on_reload_button_pressed():
	get_tree().reload_current_scene()

func _on_draw_aim_button_pressed():
	pass