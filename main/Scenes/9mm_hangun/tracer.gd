extends MeshInstance3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _init(pos1, pos2) -> void:
	var drawMesh = ImmediateMesh.new()
	mesh = drawMesh
	drawMesh.surface_begin(Mesh.PRIMITIVE_LINES, material_override)
	drawMesh.surface_add_vertex(pos1)
	drawMesh.surface_add_vertex(pos2)
	drawMesh.surface_end()
func _process(delta: float) -> void:
	pass
