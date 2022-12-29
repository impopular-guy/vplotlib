module main

import vplotlib as plt
import rand

fn main() {
	mut x := []int{}
	mut y := []int{}
	for i in 0 .. 10 {
		x << i + 10
		y << rand.int()
	}

	mut po := plt.PlotOptions{
		title: 'Line Plot'
	}
	plt.l_info('MAIN START')
	plt.line(x, y, mut po)
	plt.l_info('MAIN END')
}
