#######################################################################################
# Grace O'Connell Biomechanics Lab, UC Berkeley Department of Mechanical
# Engineering - Etchverry 2162
#
# Given the disc point cloud distribution, this program generates a geometric mesh
# representation and exports the data as an .stl file
#
#######################################################################################

# import statements
import sys
import numpy as np
import open3d as o3d

# input arguments:
npy_file = sys.argv[1]
stl_file = sys.argv[2]

# loading point cloud:
points = np.load(npy_file)

# open3D processing:
pcd = o3d.geometry.PointCloud()
pcd.points = o3d.utility.Vector3dVector(points)
pcd.estimate_normals(search_param=o3d.geometry.KDTreeSearchParamHybrid(radius=1.0, max_nn=30))

# poisson reconstruction:
mesh, _ = o3d.geometry.TriangleMesh.create_from_point_cloud_poisson(pcd, depth=9)

# visualizing geometric mesh contruction:
mesh.compute_vertex_normals()
mesh.paint_uniform_color([0.6, 0.6, 0.8])  # Light blue

pcd = o3d.geometry.PointCloud()
pcd.points = o3d.utility.Vector3dVector(points)
pcd.paint_uniform_color([1.0, 0.0, 0.0])  # Red

o3d.visualization.draw_geometries([mesh, pcd], mesh_show_back_face=True)

# saving to STL
o3d.io.write_triangle_mesh(stl_file, mesh)
