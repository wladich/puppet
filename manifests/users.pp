account { 'w':
    ssh_key => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCm8Q9CjpBH0jBjSZyZKyy/ruPevvroxc1xBCt/EWXY/V1ujXwKTPuUeNnOZBS+cBD/npSlYT8OlyhLg+WEcujltBCsa1S2WodYU/J+xRCfVwJiAOpee2B1Ilyx/1LRBD1Gts40RqGvR/kUreSJAVJwFE8d0Fft6Uh2lxRJ54nYjcVq7e7zFCnEtt98tYg1+0b08GMSgtq3ZEWXctNWlDCUoqW06fsMDg2tTXW60Y5pxjh+OFXk0L/kyEeTSVTymew7i8EI2RZ2yVmo82n/VP2SoE1iN18OLqmKSRjyVG7iIcPd1sW+0Tl9MmlgBnPM3UylCGvHRhmxOuwHRQm6YJcP',
}

sudo::conf { 'w':
    content  => "w ALL=(ALL) NOPASSWD: ALL",
}