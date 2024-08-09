class_name Fracture
extends RigidBody3D

var lifetime : float = 5

func create_frag(fragment : MeshInstance3D):
	var mesh_instance : MeshInstance3D = fragment.duplicate()
	add_child(mesh_instance)
	$CollisionShape3D.shape = fragment.mesh.create_convex_shape()
