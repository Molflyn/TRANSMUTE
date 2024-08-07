class_name Potion
extends RigidBody3D

@export var shard_lifetime : float = 5

func _on_body_entered(_body:Node):
	explode()

func explode():
	if $Potion.visible == true and $Potion_Fractured.visible == false:
		$Potion.queue_free()
		$Potion_Fractured.visible = true

		await get_tree().create_timer(shard_lifetime).timeout
		queue_free()