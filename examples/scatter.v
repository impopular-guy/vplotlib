module main

import vplotlib as plt

fn main() {
	mut x := []int{}
	mut y := []int{}
	for i in 0 .. 10 {
		x << i
		y << i * i
	}

	mut po := plt.PlotOptions{
		title: 'Scatter Plot'
	}
	plt.l_info('MAIN START')
	plt.scatter(x, y, po)
	plt.l_info('MAIN END')
}
