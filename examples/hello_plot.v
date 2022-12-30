module main

import vplotlib as vpl
import gx
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

	vpl.l_info('MAIN START')

	mut fig := vpl.new_figure(title: 'Multiple Plots')
	fig.scatter(x, y, mut vpl.PlotOptions{})
	fig.line(x, y1, mut vpl.PlotOptions{})
	fig.line(x, y, mut vpl.PlotOptions{line_color: gx.red})
	fig.show()

	vpl.l_info('MAIN END')
}
