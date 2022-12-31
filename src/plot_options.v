module vplotlib

pub struct PlotOptions {
pub mut:
	// globally applied params
	height int    = 600
	width  int    = 600
	title  string = 'Plot'
	// axes limits
	x_lim []f32
	y_lim []f32
	// padding for graph from window border. Should be a value between 0 and 1
	pad_x f32 = 0.12
	pad_y f32 = 0.12
	// padding for axis from win border. [0,1]
	axis_pad_x f32 = 0.1
	axis_pad_y f32 = 0.1
}

fn (po PlotOptions) norm_x(x f32) f32 {
	n_x := (x - po.x_lim[0]) / (po.x_lim[1] - po.x_lim[0])
	return po.pad_x * po.width + (po.width - 2 * po.pad_x * po.width) * n_x
}

fn (po PlotOptions) norm_y(y f32) f32 {
	n_y := (y - po.y_lim[0]) / (po.y_lim[1] - po.y_lim[0])
	return po.height - po.pad_y * po.height + (2 * po.pad_y * po.height - po.height) * n_y
}

fn (mut po PlotOptions) update_lims(x_lim []f32, y_lim []f32) {
	if po.x_lim.len == 0 {
		po.x_lim = x_lim
		po.y_lim = y_lim
		return
	}
	if x_lim[0] < po.x_lim[0] {
		po.x_lim[0] = x_lim[0]
	}
	if x_lim[1] > po.x_lim[1] {
		po.x_lim[1] = x_lim[1]
	}
	if y_lim[0] < po.y_lim[0] {
		po.y_lim[0] = y_lim[0]
	}
	if y_lim[1] > po.y_lim[1] {
		po.y_lim[1] = y_lim[1]
	}
}
