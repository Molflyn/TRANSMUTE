class_name Fragment
extends RigidBody3D

@export var lifetime : float = 30

func _ready():
    await get_tree().create_timer(lifetime).timeout
    queue_free()

func init_from_mesh(source : MeshInstance3D):
    global_transform = source.global_transform

    var mesh_instance : MeshInstance3D = source.duplicate()
    add_child(mesh_instance)

    $CollisionShape3D.shape = source.mesh.create_convex_shape()