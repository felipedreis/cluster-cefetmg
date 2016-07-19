import sys
import time

def foo():
	for i in range(0, 100):
		for j in range(0, 100):
			for k in range(0, 100):
				for l in range(0, 25):
					print i + j + k + l

	time.sleep(120)

print (sys.version)
foo()

