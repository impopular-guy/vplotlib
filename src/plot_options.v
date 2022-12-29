module vplotlib

pub struct PlotOptions {
pub mut:
	height int    = 600
	width  int    = 600
	title  string = 'Plot'

	x_lim []f32 = [f32(-10), 10]
	y_lim []f32 = [f32(-10), 10]
}
