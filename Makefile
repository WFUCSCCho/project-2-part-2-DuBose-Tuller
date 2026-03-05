sequential:
	nvcc -o blur blur.cu

clean:
	rm -f blur *.o