extends DisplayedItem

class_name DynaRippleSurface

export var _size: float
export var _resolution: int
export var _ripple_speed: float

var _arrays
var _array_mesh
var _time_count

func _ready():
	if _size < 0.1:
		_size = 0.1
	
	if _resolution < 1:
		_resolution = 1
	
	_time_count = 0.0
	
	var vertices_count = (_resolution + 1) * (_resolution + 1)
	
	var vertices = PoolVector3Array()
	vertices.resize(vertices_count)
	
	var normals = PoolVector3Array()
	normals.resize(vertices_count)
	
	var uvs = PoolVector2Array()
	uvs.resize(vertices_count)
	
	var vertex_index = 0
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
	
	_arrays = []
	_arrays.resize(ArrayMesh.ARRAY_MAX)
	_arrays[ArrayMesh.ARRAY_VERTEX] = vertices
	_arrays[ArrayMesh.ARRAY_NORMAL] = normals
	_arrays[ArrayMesh.ARRAY_TEX_UV] = uvs
	_arrays[ArrayMesh.ARRAY_INDEX] = indexes
	
	_update_vertices_and_normals()
	
	_array_mesh = ArrayMesh.new()
	_array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, _arrays)
	mesh = _array_mesh

func _process(delta):
	_time_count += delta * _ripple_speed
	_update_vertices_and_normals()
	_array_mesh.surface_remove(0)
	_array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, _arrays)

func _update_vertices_and_normals():
	var dxz = 1.0 / float(4 * _resolution)
	
	var vertex_index = 0
	var rate_x
	var rate_z
	var vx
	var vz
	var x
	var z = 0
	while z <= _resolution:
		rate_z = float(z) / float(_resolution)
		x = 0
		while x <= _resolution:
			rate_x = float(x) / float(_resolution)
			
			_arrays[ArrayMesh.ARRAY_VERTEX][vertex_index] = _surface_position(rate_x, rate_z)
			
			vx = _surface_position(rate_x + dxz, rate_z) - _surface_position(rate_x - dxz, rate_z)
			vz = _surface_position(rate_x, rate_z + dxz) - _surface_position(rate_x, rate_z - dxz)
			_arrays[ArrayMesh.ARRAY_NORMAL][vertex_index] = vz.cross(vx).normalized()
			
			vertex_index += 1
			x += 1
		z += 1

func _rate_x_by_index(vertex_index):
	return float(vertex_index % (_resolution + 1)) / float(_resolution)

func _rate_z_by_index(vertex_index):
	return float(vertex_index / (_resolution + 1)) / float(_resolution)

func _surface_position(rate_x, rate_z):
	var dx = rate_x - 0.5
	var dz = rate_z - 0.5
	var dist = sqrt(dx * dx + dz * dz)
	
	return Vector3(
		dx * _size,
		(0.05 * _size) * sin(dist * 30.0 - _time_count),
		dz * _size
	)
