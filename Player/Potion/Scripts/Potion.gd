class_name Potion
extends RigidBody3D

func _on_body_entered(_body:Node):
	queue_free()

func explode():
	pass