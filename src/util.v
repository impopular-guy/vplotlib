module vplotlib

import time
import math

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

fn get_fraction(n int) []f64 {
	mut frac := []f64{}
	mut sum := f64(0)
	for i := 0; i < n; i++ {
		h := math.round_sig(1.0 / f64(n), 3)
		frac << h
		sum += h
	}
	frac[0] += math.round_sig(1.0 - sum, 3)
	return frac
}

fn get_ticks_frac(n int) []f32 {
	frac := get_fraction(n + 1)
	mut ticks := []f32{}
	ticks << f32(frac[0])
	for i := 1; i < n; i++ {
		ticks << f32(ticks.last() + frac[i])
	}
	return ticks
}
