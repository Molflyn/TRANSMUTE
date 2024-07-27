extends Node

@onready var draw_debug : MeshInstance3D = $MeshInstance3D

@export var use_debug_draw : bool = true

func _physics_process(_delta):
    _clear_lines()
    
func _clear_lines():
    if draw_debug.mesh is ImmediateMesh:
        draw_debug.mesh.clear_surfaces()

func _draw_line(point_a : Vector3, point_b : Vector3, thickness : float = 2.0, colour : Color = Color.BLACK):
    if not use_debug_draw or point_a.is_equal_approx(point_b):
        return
    
    if draw_debug.mesh is ImmediateMesh:
        draw_debug.mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLE_STRIP)
        draw_debug.mesh.surface_set_color(colour)

        var scale_factor : float = 100.0

        var dir = point_a.direction_to(point_b)
        var EPISILON = 0.00001

        # Draw Cube Line
        var normal = Vector3(-dir.y, dir.x, 0).normalized() \
            if (abs(dir.x) + abs(dir.y) > EPISILON) \
            else Vector3(0, -dir.z, dir.y).normalized()
        normal *= thickness / scale_factor

        var vertices_strip_order = [4, 5, 0, 1, 2, 5, 6, 4, 7, 0, 3, 2, 7, 6]
        var local_b = (point_a - point_b)

        # Calculates Line Mesh At Origin
        for v in range(14):
            var vertex = normal if \
                vertices_strip_order[v] < 4 else \
                normal + local_b
            var final_vert = vertex.rotated(dir,
                PI * (0.5 * (vertices_strip_order[v] % 4) + 0.25 ))
            # Offset To Real Position
            final_vert += point_a
            draw_debug.mesh.surface_add_vertex(final_vert)
        
        draw_debug.mesh.surface_end()

func _draw_line_relative(point_a : Vector3, point_b : Vector3, thickness : float = 2.0, colour : Color = Color.BLACK):
    _draw_line(point_a, point_a+point_b, thickness, colour)

func _draw_line_thickpointy(point_a : Vector3, point_b : Vector3, thickness : float = 2.0, colour : Color = Color.BLACK):
    if not use_debug_draw or point_a.is_equal_approx(point_b):
        return
    
    if draw_debug.mesh is ImmediateMesh:
        draw_debug.mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLE_STRIP)
        draw_debug.mesh.surface_set_color(colour)

        var scale_factor : float = 100.0

        var dir = point_a.direction_to(point_b)
        var EPISILON = 0.00001

        # Draw Cube Line
        var normal = Vector3(-dir.y, dir.x, 0).normalized() \
            if (abs(dir.x) + abs(dir.y) > EPISILON) \
            else Vector3(0, -dir.z, dir.y).normalized()
        normal *= thickness / scale_factor

        var vertices_strip_order = [4, 5, 0, 1, 2, 5, 6, 4, 7, 0, 3, 2, 7, 6]
        var local_b = (point_a - point_b)

        # Calculates Line Mesh At Origin
        for v in range(14):
            var vertex = normal if \
                vertices_strip_order[v] < 4 else \
                normal / 3.0 + local_b
            var final_vert = vertex.rotated(dir,
                PI * (0.5 * (vertices_strip_order[v] % 4) + 0.25 ))
            # Offset To Real Position
            final_vert += point_a
            draw_debug.mesh.surface_add_vertex(final_vert)
        
        draw_debug.mesh.surface_end()

func _draw_line_thickpointy_relative(point_a : Vector3, point_b : Vector3, thickness : float = 2.0, colour : Color = Color.BLACK):
    _draw_line_thickpointy(point_a, point_a+point_b, thickness, colour)