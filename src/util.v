module vplotlib

import time

pub fn l_info(s string) {
	println('INFO ${time.now()} : ${s}')
}

fn to_f32_array[T](x []T) []f32 {
	mut x_new := []f32{}
	for xi in x {
		x_new << f32(xi)
	}
	return x_new
}

fn find_axis_lims(x []f32) []f32 {
	mut x_min := x[0]
	mut x_max := x[0]
	for xi in x {
		if xi < x_min {
			x_min = xi
		}
		if xi > x_max {
			x_max = xi
		}
	}
	return [x_min, x_max]
}
