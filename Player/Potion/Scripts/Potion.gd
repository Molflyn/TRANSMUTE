class_name Potion
extends Node3D

func _on_potion_rb_body_entered(_body:Node):
	explode()

func explode():
	$PotionRB.queue_free()

	for child in $Potion_Fractured.get_children():
		if child is MeshInstance3D:
			var frag : Fracture = preload("res://Player/Potion/Fracture.tscn").instantiate()
			frag.create_frag(child)
			add_child(frag)
