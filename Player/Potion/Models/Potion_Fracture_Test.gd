extends Node3D

func _unhandled_input(_event):
	if Input.is_action_just_pressed("ui_accept"):
		print("action pressed!")
		explode()

func explode():
	for child in $Potion_Fractured.get_children():
		if child is MeshInstance3D:
			var frag : Fracture = preload("res://Player/Potion/Fracture.tscn").instantiate()
			frag.create_frag(child)
			add_child(frag)