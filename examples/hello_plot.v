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

	mut app := plt.new_app(title: 'Multiple Plots')
	app.scatter(x, y, mut plt.PlotOptions{})
	app.line(x, y1, mut plt.PlotOptions{})
	app.show()

	plt.l_info('MAIN END')
}
