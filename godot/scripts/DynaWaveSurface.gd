extends DisplayedItem

class_name DynaWaveSurface

export var _size: float
export var _resolution: int

func _ready():
	if _size < 0.1:
		_size = 0.1
	
	if _resolution < 1:
		_resolution = 1
	
	var vertices_count = (_resolution + 1) * (_resolution + 1)
	
	var vertices = PoolVector3Array()
	vertices.resize(vertices_count)
	
	var rate_x
	var rate_z
	var vertex_index = 0
	while vertex_index < vertices_count:
		rate_x = _rate_x_by_index(vertex_index)
		rate_z = _rate_z_by_index(vertex_index)
		vertices[vertex_index] = _surface_position(rate_x, rate_z)
		
		vertex_index += 1
	
	var normals = PoolVector3Array()
	normals.resize(vertices_count)
	
	var dxz = 1.0 / float(4 * _resolution)
	var vx
	var vz
	vertex_index = 0
	while vertex_index < vertices_count:
		rate_x = _rate_x_by_index(vertex_index)
		rate_z = _rate_z_by_index(vertex_index)
		vx = _surface_position(rate_x + dxz, rate_z) - _surface_position(rate_x - dxz, rate_z)
		vz = _surface_position(rate_x, rate_z + dxz) - _surface_position(rate_x, rate_z - dxz)
		normals[vertex_index] = vz.cross(vx).normalized()
		
		vertex_index += 1
	
	var uvs = PoolVector2Array()
	uvs.resize(vertices_count)
	
	vertex_index = 0
	while vertex_index < vertices_count:
		uvs[vertex_index] = Vector2(_rate_x_by_index(vertex_index), _rate_z_by_index(vertex_index))
		vertex_index += 1
	
	var indexes = PoolIntArray()
	indexes.resize(_resolution * _resolution * 6)
	
	var index_index = 0
	var base_index
	var x
	var z = 0
	while z < _resolution:
		x = 0
		while x < _resolution:
			base_index = z * (_resolution + 1) + x
			
			indexes[index_index] = base_index
			indexes[index_index + 1] = base_index + 1
			indexes[index_index + 2] = base_index + _resolution + 1
			indexes[index_index + 3] = base_index + _resolution + 2
			indexes[index_index + 4] = base_index + _resolution + 1
			indexes[index_index + 5] = base_index + 1
			
			index_index += 6
			x += 1
		z += 1
	
	var arrays = []
	arrays.resize(ArrayMesh.ARRAY_MAX)
	arrays[ArrayMesh.ARRAY_VERTEX] = vertices
	arrays[ArrayMesh.ARRAY_NORMAL] = normals
	arrays[ArrayMesh.ARRAY_TEX_UV] = uvs
	arrays[ArrayMesh.ARRAY_INDEX] = indexes
	
	var array_mesh = ArrayMesh.new()
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	mesh = array_mesh

func _rate_x_by_index(vertex_index):
	return float(vertex_index % (_resolution + 1)) / float(_resolution)

func _rate_z_by_index(vertex_index):
	return float(vertex_index / (_resolution + 1)) / float(_resolution)

func _surface_position(rate_x, rate_z):
	return Vector3(
		(rate_x - 0.5) * _size,
		(0.1 * _size) * sin((rate_x + rate_z) * 10.0),
		(rate_z - 0.5) * _size
	)
