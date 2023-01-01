module vplotlib

import gg
import gx

pub enum MarkerType {
	circle
	square
}

pub struct ScatterParams[T] {
mut:
	x      []T
	y      []T
	s      []f32
	size   int        = 6
	marker MarkerType = .circle
	color  gx.Color   = gx.blue
}

struct ScatterPlot {
	x        []f32
	y        []f32
	s        []f32
	size_arr bool
	size     f32
	marker   MarkerType
	color    gx.Color
	x_lim    []f32
	y_lim    []f32
}

pub fn scatter[T](params ScatterParams[T]) ScatterPlot {
	// check len(x) == len(y)

	// init
	x := to_f32_array(params.x)
	y := to_f32_array(params.y)
	size_arr := params.s.len == x.len
	plot := ScatterPlot{
		x: x
		y: y
		s: params.s
		size_arr: size_arr
		size: params.size
		marker: params.marker
		color: params.color
		x_lim: find_axis_lims(x)
		y_lim: find_axis_lims(y)
	}
	l_info('ADDED PLOT: ${typeof(plot).name}')
	return plot
}

fn (plot ScatterPlot) draw(ctx &gg.Context, fig &Figure) {
	match plot.marker {
		.circle {
			for i, xi in plot.x {
				x := fig.norm_x(xi)
				y := fig.norm_y(plot.y[i])
				mut s := plot.size
				if plot.size_arr {
					s = plot.s[i]
				}
				ctx.draw_circle_filled(x, y, s / 2, plot.color)
			}
		}
		.square {
			for i, xi in plot.x {
				x := fig.norm_x(xi)
				y := fig.norm_y(plot.y[i])
				mut s := plot.size
				if plot.size_arr {
					s = plot.s[i]
				}
				ctx.draw_rect_filled(x - s / 2, y - s / 2, s, s, plot.color)
			}
		}
	}
}
