module vplotlib

pub struct PlotOptions {
pub mut:
	height int    = 600
	width  int    = 600
	title  string = 'Plot'

	x_lim []f32 = [f32(-10), 10]
	y_lim []f32 = [f32(-10), 10]

	pad_x f32 = 10
	pad_y f32 = 10
}

fn (po PlotOptions) norm_x(x f32) f32 {
	return po.pad_x + (po.width - 2 * po.pad_x) * (x - po.x_lim[0]) / (po.x_lim[1] - po.x_lim[0])
}

fn (po PlotOptions) norm_y(y f32) f32 {
	return po.height - po.pad_y +
		(2 * po.pad_y - po.height) * (y - po.y_lim[0]) / (po.y_lim[1] - po.y_lim[0])
}
