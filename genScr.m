function genScr(R, L)
  
  mkdir(['./R', num2str(R, "%5.3f")]);
  ScrName = ['./R', num2str(R, "%5.3f"), '/', 'scrGenIcem', num2str(R), '.rpl'];
  
  scrp = fopen(ScrName, 'w');
  
  
  R = 0.01; L = 10;
  np = [
  0, 0.0, R  ;
  1, 1.0, R  ;
  2, 0.0, R+L;
  3, 1.0, R+L;
  ]';
  
  fprintf(scrp, 'ic_point {} GEOM pnt.%02d %.3f,%.3f,0.0\n', np);
  
  fprintf(scrp, 'ic_curve point GEOM crv.00 {pnt.00 pnt.01}\n');
  fprintf(scrp, 'ic_curve point GEOM crv.01 {pnt.01 pnt.03}\n');
  fprintf(scrp, 'ic_curve point GEOM crv.02 {pnt.03 pnt.02}\n');
  fprintf(scrp, 'ic_curve point GEOM crv.03 {pnt.00 pnt.02}\n');
  
  fprintf(scrp, 'ic_surface 2-4crvs GEOM srf.00 {0.01 {crv.03 crv.02 crv.01 crv.00}}\n');
  
  fprintf(scrp, 'ic_geo_set_part curve crv.02 SIDE 0\n');
  fprintf(scrp, 'ic_geo_set_part curve crv.00 INSIDE 0\n');
  fprintf(scrp, 'ic_geo_set_part curve crv.01 TOP 0\n');
  fprintf(scrp, 'ic_geo_set_part curve crv.03 BOTTOM 0\n');
  
  fprintf(scrp, 'ic_hex_surface_blocking -inherited -mapped -min_edge 0.0 -show_progress\n');
  
  fprintf(scrp, 'ic_hex_find_comp_curve crv.02\n');
  fprintf(scrp, 'ic_hex_set_edge_projection 12 13 0 1 crv.02\n');
  fprintf(scrp, 'ic_hex_find_comp_curve crv.01\n');
  fprintf(scrp, 'ic_hex_set_edge_projection 13 14 0 1 crv.01\n');
  fprintf(scrp, 'ic_hex_find_comp_curve crv.00\n');
  fprintf(scrp, 'ic_hex_set_edge_projection 15 14 0 1 crv.00\n');
  fprintf(scrp, 'ic_hex_find_comp_curve crv.03\n');
  fprintf(scrp, 'ic_hex_set_edge_projection 12 15 0 1 crv.03\n');
  
  fprintf(scrp, 'ic_hex_set_mesh 12 15 n 125 h1rel 0.0 h2rel 0.0005 r1 1.1 r2 1.1 lmax 1e+10 exp2 copy_to_parallel unlocked\n');
  fprintf(scrp, 'ic_hex_set_mesh 15 14 n 250 h1rel 0.0 h2rel 0.0000 r1 1.1 r2 1.1 lmax 1e+10 exp1 copy_to_parallel unlocked\n');
  
  fprintf(scrp, 'ic_hex_create_mesh GEOM SIDE INSIDE TOP BOTTOM proj 2 dim_to_mesh 3\n');
  
  fprintf(scrp, 'ic_hex_write_file ./hex.uns GEOM SIDE INSIDE TOP BOTTOM proj 2 dim_to_mesh 2 no_boco\n');
  fprintf(scrp, 'ic_uns_load ./hex.uns 3 0 {} 1\n');
  fprintf(scrp, 'ic_uns_update_family_type visible {INSIDE GEOM BOTTOM SIDE ORFN TOP} {!NODE !LINE_2 QUAD_4} update 0\n');
  fprintf(scrp, 'ic_boco_solver \n');
  fprintf(scrp, 'ic_boco_clear_icons \n');
  
  fprintf(scrp, 'ic_boco_solver {ANSYS Fluent}\n');
  fprintf(scrp, 'ic_solution_set_solver {ANSYS Fluent} 1\n');
  fprintf(scrp, 'ic_boco_save ./temp.fluentAnsys.fbc\n');
  fprintf(scrp, 'ic_boco_save_atr ./temp.fluentAnsys.atr\n');
  fprintf(scrp, 'ic_exec {C:/Program Files/ANSYS Inc/v191/icemcfd/win64_amd/icemcfd/output-interfaces/fluent6} -dom ./hex.uns -b ./temp.fluentAnsys.fbc -dim2d ./fluent\n');
  
  fclose(scrp);
  
  end