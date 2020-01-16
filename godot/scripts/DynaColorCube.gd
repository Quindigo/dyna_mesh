extends DisplayedItem

class_name DynaColorCube

export var _size: float

func _ready():
	if _size < 0.1:
		_size = 0.1
	
	var r = _size / 2.0
	
	var vertices = PoolVector3Array([
		Vector3(-r, r, -r),  # Index 0, left top back vertex
		Vector3(r, r, -r),  # Index 1, right top back vertex
		Vector3(-r, r, r),  # Index 2, left top front vertex
		Vector3(r, r, r),  # Index 3, right top front vertex
		Vector3(-r, -r, -r),  # Index 4, left bottom back vertex
		Vector3(r, -r, -r),  # Index 5, right bottom back vertex
		Vector3(-r, -r, r),  # Index 6, left bottom front vertex
		Vector3(r, -r, r)  # Index 7, right bottom front vertex
	])
	
	var colors = PoolColorArray([
		Color(0.0, 1.0, 0.0, 1.0),  # Green
		Color(1.0, 1.0, 0.0, 1.0),  # Yellow
		Color(0.0, 1.0, 1.0, 1.0),  # Cyan
		Color(1.0, 1.0, 1.0, 1.0),  # White
		Color(0.0, 0.0, 0.0, 1.0),  # Black
		Color(1.0, 0.0, 0.0, 1.0),  # Red
		Color(0.0, 0.0, 1.0, 1.0),  # Blue
		Color(1.0, 0.0, 1.0, 1.0)  # Magenta
	])
	
	var indexes = PoolIntArray([
		0, 1, 2,  # Top face
		3, 2, 1,
		0, 2, 4,  # Left face
		6, 4, 2,
		2, 3, 6,  # Front face
		7, 6, 3,
		3, 1, 7,  # Right face
		5, 7, 1,
		1, 0, 5,  # Back face
		4, 5, 0,
		6, 7, 4,  # Bottom face
		5, 4, 7
	])
	
	var arrays = []
	arrays.resize(ArrayMesh.ARRAY_MAX)
	arrays[ArrayMesh.ARRAY_VERTEX] = vertices
	arrays[ArrayMesh.ARRAY_COLOR] = colors
	arrays[ArrayMesh.ARRAY_INDEX] = indexes
	
	var array_mesh = ArrayMesh.new()
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	mesh = array_mesh
