class_name Potion
extends Node3D

@export_flags_3d_physics var frag_col_layer : int = 1
@export_flags_3d_physics var frag_col_mask : int = 1

func _on_potion_rb_body_entered(body:Node):
	explode()

func explode():
	var parent = get_parent()
	queue_free()

	for child in $Potion_Fractured.get_children():
		if child is MeshInstance3D:
			var frag : Fragment = preload("res://Player/Potion/Fragment.tscn").instantiate()
			frag.init_from_mesh(child)
			frag.collision_layer = frag_col_layer
			frag.collision_mask = frag_col_mask
			parent.add_child(frag)
