# VPlotLib

Plotting library for V, inspired by Python's `matplotlib`

### Quick example:

```v
import vplotlib as vpl

fn main() {
	x, x1, y, y1 := ... // inputs

	mut fig := vpl.new_figure(title: 'Multiple Plots')
	fig.scatter(x, y, mut vpl.PlotOptions{})
	fig.line(x1, y1, mut vpl.PlotOptions{})
	fig.line(x, y, mut vpl.PlotOptions{ line_color: gx.red, line_type: .dashed })
	fig.show()
}
```