extends Node3D

func _ready():
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(_delta):
    if Input.is_action_just_pressed("ui_cancel"):
        if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
            Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
        elif Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
            Input.mouse_mode = Input.MOUSE_MODE_CAPTURED