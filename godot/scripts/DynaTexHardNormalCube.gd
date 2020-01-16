extends DisplayedItem

class_name DynaTexHardNormalCube

export var _size: float

func _ready():
	if _size < 0.1:
		_size = 0.1
	
	var r = _size / 2.0
	
	var vertices = PoolVector3Array([
		Vector3(-r, r, -r),  # Top face
		Vector3(r, r, -r),
		Vector3(-r, r, r),
		Vector3(r, r, r),
		
		Vector3(-r, r, -r),  # Left face
		Vector3(-r, r, r),
		Vector3(-r, -r, -r),
		Vector3(-r, -r, r),
		
		Vector3(-r, r, r),  # Front face
		Vector3(r, r, r),
		Vector3(-r, -r, r),
		Vector3(r, -r, r),
		
		Vector3(r, r, r),  # Right face
		Vector3(r, r, -r),
		Vector3(r, -r, r),
		Vector3(r, -r, -r),
		
		Vector3(r, r, -r),  # Back face
		Vector3(-r, r, -r),
		Vector3(r, -r, -r),
		Vector3(-r, -r, -r),
		
		Vector3(-r, -r, r),  # Bottom face
		Vector3(r, -r, r),
		Vector3(-r, -r, -r),
		Vector3(r, -r, -r)
	])
	
	var normals = PoolVector3Array([
		Vector3.UP,  # Top face
		Vector3.UP,
		Vector3.UP,
		Vector3.UP,
		
		Vector3.LEFT,  # Left face
		Vector3.LEFT,
		Vector3.LEFT,
		Vector3.LEFT,
		
		Vector3.BACK,  # Front face
		Vector3.BACK,
		Vector3.BACK,
		Vector3.BACK,
		
		Vector3.RIGHT,  # Right face
		Vector3.RIGHT,
		Vector3.RIGHT,
		Vector3.RIGHT,
		
		Vector3.FORWARD,  # Back face
		Vector3.FORWARD,
		Vector3.FORWARD,
		Vector3.FORWARD,
		
		Vector3.DOWN,  # Bottom face
		Vector3.DOWN,
		Vector3.DOWN,
		Vector3.DOWN
	])
	
	var one_third = 1.0 / 3.0
	var two_thirds = 2.0 / 3.0
	
	var uvs = PoolVector2Array([
		Vector2(0.25, 0.0),  # Top face
		Vector2(0.5, 0.0),
		Vector2(0.25, one_third),
		Vector2(0.5, one_third),
		
		Vector2(0.0, one_third),  # Left face
		Vector2(0.25, one_third),
		Vector2(0.0, two_thirds),
		Vector2(0.25, two_thirds),
		
		Vector2(0.25, one_third),  # Front face
		Vector2(0.5, one_third),
		Vector2(0.25, two_thirds),
		Vector2(0.5, two_thirds),
		
		Vector2(0.5, one_third),  # Right face
		Vector2(0.75, one_third),
		Vector2(0.5, two_thirds),
		Vector2(0.75, two_thirds),
		
		Vector2(0.75, one_third),  # Back face
		Vector2(1.0, one_third),
		Vector2(0.75, two_thirds),
		Vector2(1.0, two_thirds),
		
		Vector2(0.25, two_thirds),  # Bottom face
		Vector2(0.5, two_thirds),
		Vector2(0.25, 1.0),
		Vector2(0.5, 1.0),
	])
	
	var indexes = PoolIntArray([
		0, 1, 2,  # Top face
		3, 2, 1,
		4, 5, 6,  # Left face
		7, 6, 5,
		8, 9, 10,  # Front face
		11, 10, 9,
		12, 13, 14,  # Right face
		15, 14, 13,
		16, 17, 18,  # Back face
		19, 18, 17,
		20, 21, 22,  # Bottom face
		23, 22, 21
	])
	
	var arrays = []
	arrays.resize(ArrayMesh.ARRAY_MAX)
	arrays[ArrayMesh.ARRAY_VERTEX] = vertices
	arrays[ArrayMesh.ARRAY_NORMAL] = normals
	arrays[ArrayMesh.ARRAY_TEX_UV] = uvs
	arrays[ArrayMesh.ARRAY_INDEX] = indexes
	
	var array_mesh = ArrayMesh.new()
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	mesh = array_mesh
