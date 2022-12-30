module vplotlib

import time

pub const (
	version = '0.1.0'
)

pub fn l_info(s string) {
	println('INFO ${time.now()} : ${s}')
}
