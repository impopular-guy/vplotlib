# VPlotLib

Plotting library for V, inspired by Python's `matplotlib`

### Quick example:

```v
import vplotlib as vpl
import gx

fn main() {
	x, x1, y, y1, s := ... // inputs

	mut fig := vpl.figure(title: 'Multiple Plots')
	fig.add(
		plots: [
			vpl.line( x: x1, y: y1 ),
			vpl.line( x: x, y: y, color: gx.green, line_type: .dashed ),
			vpl.scatter( x: x, y: y, s: s, color: gx.red ),
			vpl.scatter( x: x1, y: y1, s: s, color: gx.cyan, marker: .square ),
		]
	)
	fig.show()
}
```

![vplotlib_Screenshot 2022-12-31 004456](https://user-images.githubusercontent.com/34854740/210175649-f5a709b4-12cb-4fe9-ae69-aa9678611124.png)

