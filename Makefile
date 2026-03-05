blur:
	nvcc -o blur blur.cu

tiled: 
	nvcc -o blurTiled blurTiled.cu

clean:
	rm -f blur blurTiled *.o