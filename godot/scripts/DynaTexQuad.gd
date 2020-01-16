extends DisplayedItem

class_name DynaTexQuad

export var _size: float

func _ready():
	if _size < 0.1:
		_size = 0.1
	
	var r = _size / 2.0
	
	var vertices = PoolVector3Array([
		Vector3(-r, r, 0.0),  # Index 0, left top vertex
		Vector3(r, r, 0.0),  # Index 1, right top vertex
		Vector3(-r, -r, 0.0),  # Index 2, left bottom vertex
		Vector3(r, -r, 0.0)  # Index 3, right bottom vertex
	])
	
	var uvs = PoolVector2Array([
		Vector2(0.0, 0.0),  # Index 0, left top vertex
		Vector2(1.0, 0.0),  # Index 1, right top vertex
		Vector2(0.0, 1.0),  # Index 2, left bottom vertex
		Vector2(1.0, 1.0)  # Index 3, right bottom vertex
	])
	
	var indexes = PoolIntArray([
		0, 1, 2,  # Top left triangle
		3, 2, 1  # Bottom right triangle
	])
	
	var arrays = []
	arrays.resize(ArrayMesh.ARRAY_MAX)
	arrays[ArrayMesh.ARRAY_VERTEX] = vertices
	arrays[ArrayMesh.ARRAY_TEX_UV] = uvs
	arrays[ArrayMesh.ARRAY_INDEX] = indexes
	
	var array_mesh = ArrayMesh.new()
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	mesh = array_mesh
