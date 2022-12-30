module main

import vplotlib as plt
import rand

fn main() {
	mut x := []int{}
	mut y := []int{}
	mut y1 := []int{}
	for i in 0 .. 10 {
		x << i + 10
		y << rand.int()
		y1 << rand.int()
	}

	plt.l_info('MAIN START')

	mut fig := plt.new_figure(title: 'Multiple Plots')
	fig.scatter(x, y, mut plt.PlotOptions{})
	fig.line(x, y1, mut plt.PlotOptions{})
	fig.show()

	plt.l_info('MAIN END')
}
