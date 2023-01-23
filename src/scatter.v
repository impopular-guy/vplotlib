module vplotlib

// import gg
import gx
import ui

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
	x            []f32
	y            []f32
	s            []f32
	has_size_arr bool
	size         f32
	marker       MarkerType
	color        gx.Color
	x_lim        []f32
	y_lim        []f32
}

fn validate_scatter_params[T](p ScatterParams[T]) {
	if p.x.len != p.y.len {
		panic('Length of `x` and `y` must be equal')
	}
	if p.s.len > 0 && p.s.len != p.x.len {
		panic('Length of `s` and `x` must be equal')
	}
	if p.size < 1 {
		panic('`size` must be greater or equal to 1')
	}
}

pub fn scatter[T](params ScatterParams[T]) ScatterPlot {
	validate_scatter_params[T](params)

	// init
	x := to_f32_array(params.x)
	y := to_f32_array(params.y)
	has_size_arr := params.s.len == x.len
	plot := ScatterPlot{
		x: x
		y: y
		s: params.s
		has_size_arr: has_size_arr
		size: params.size
		marker: params.marker
		color: params.color
		x_lim: find_axis_lims(x)
		y_lim: find_axis_lims(y)
	}
	l_info('ADDED PLOT: ${typeof(plot).name}')
	return plot
}

fn (plot ScatterPlot) draw(d ui.DrawDevice, c &ui.CanvasLayout, fig &SubFigure) {
	match plot.marker {
		.circle {
			for i, xi in plot.x {
				x, y := fig.norm_xy(xi, plot.y[i], c.width, c.height)
				mut s := plot.size
				if plot.has_size_arr {
					s = plot.s[i]
				}
				c.draw_device_circle_filled(d, x, y, s / 2, plot.color)
			}
		}
		.square {
			for i, xi in plot.x {
				x, y := fig.norm_xy(xi, plot.y[i], c.width, c.height)
				mut s := plot.size
				if plot.has_size_arr {
					s = plot.s[i]
				}
				c.draw_device_rect_filled(d, x - s / 2, y - s / 2, s, s, plot.color)
			}
		}
	}
}
