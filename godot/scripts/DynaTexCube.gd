extends DisplayedItem

class_name DynaTexCube

export var _size: float

func _ready():
	if _size < 0.1:
		_size = 0.1
	
	var r = _size / 2.0
	
	var vertices = PoolVector3Array([
		Vector3(-r, r, -r),
		Vector3(r, r, -r),
		Vector3(-r, r, -r),
		Vector3(-r, r, r),
		Vector3(r, r, r),
		Vector3(r, r, -r),
		Vector3(-r, r, -r),
		Vector3(-r, -r, -r),
		Vector3(-r, -r, r),
		Vector3(r, -r, r),
		Vector3(r, -r, -r),
		Vector3(-r, -r, -r),
		Vector3(-r, -r, -r),
		Vector3(r, -r, -r),
	])
	
	var one_third = 1.0 / 3.0
	var two_thirds = 2.0 / 3.0
	
	var uvs = PoolVector2Array([
		Vector2(0.25, 0.0),
		Vector2(0.5, 0.0),
		Vector2(0.0, one_third),
		Vector2(0.25, one_third),
		Vector2(0.5, one_third),
		Vector2(0.75, one_third),
		Vector2(1.0, one_third),
		Vector2(0.0, two_thirds),
		Vector2(0.25, two_thirds),
		Vector2(0.5, two_thirds),
		Vector2(0.75, two_thirds),
		Vector2(1.0, two_thirds),
		Vector2(0.25, 1.0),
		Vector2(0.5, 1.0)
	])
	
	var indexes = PoolIntArray([
		0, 1, 3,  # Top face
		4, 3, 1,
		2, 3, 7,  # Left face
		8, 7, 3,
		3, 4, 8,  # Front face
		9, 8, 4,
		4, 5, 9,  # Right face
		10, 9, 5,
		5, 6, 10,  # Back face
		11, 10, 6,
		8, 9, 12,  # Bottom face
		13, 12, 9
	])
	
	var arrays = []
	arrays.resize(ArrayMesh.ARRAY_MAX)
	arrays[ArrayMesh.ARRAY_VERTEX] = vertices
	arrays[ArrayMesh.ARRAY_TEX_UV] = uvs
	arrays[ArrayMesh.ARRAY_INDEX] = indexes
	
	var array_mesh = ArrayMesh.new()
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	mesh = array_mesh
