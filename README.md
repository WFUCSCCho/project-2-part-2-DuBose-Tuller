**Project 2 (Part 2): In the Interest of Time**

*Due: 3/5/2026 @ 12pm (noon)*

![FAJ7fXgWUAIQKMd](https://github.com/user-attachments/assets/525429f8-4361-48cf-9cdc-c922eb2f30b5)


**Topics**
  * NVIDIA Threads Architecture
  * CUDA Events
  * File I/O
  * Parallel Algorithm Analysis

**Background**

During class, we discussed how to implement an image blurring subroutine.  We also discussed several metrics for measuring parallel algorithm performance.

**Part 2: Image Blur**

You are given a working program that blurred an image. Apply the program to several bmp images of different sizes and graph how its performance varies with system size. Modify the program using shared memory to improve its performance and compare how its performance varies with system size as compared to the original program.

Write a brief description of the strategy you employed to improve the performance of the blur program. You will not be graded on how much your strategy improved the performance or even whether performance improved. All I am looking for here is that you gave it some thought and you were able to reason out a strategy.

**Functional Requirements**

* Command Line Argument: The program must use a command line argument that corresponds to filename.

* Error Handling: You must check for:
  * The appropriate number of command line arguments.
  * Appropriate error messages must be issued for failures, followed by a graceful exit.

**Performance Analyses**
To analyze the relative performances of the CPU vs. GPU implementations of your image blurring algorithms, you will compute the time it takes to complete an image blurring function/kernel call.  

Hint: In the execution of your GPU implementation, for accurate timing information, you must call the kernel twice because the GPU initialization takes time that is unrelated to the algorithm.


**Project Submission**

Part 2 of your project will be submitted via GitHub and the link to your repository will be submitted on Canvas.

* Compilation: Any program that does not compile or lacks correctly constructed Makefiles will not be graded.
* Comments and Style: Significant code blocks must be commented. Use recognizable variable names and avoid acronyms. Poorly commented or difficult-to-follow code may result in a lack of assistance.

**Pledged Work Policy** 
You may only seek aid from the course professor or explicitly specified assistants. Tutors are not permitted. You may discuss only basic C/C++ syntax with others. Any other discussions of the project are strictly prohibited.Your code and implementation must be the product of your own work.


## Blur Kernel with Shared Memory
My idea to improve performance via shared block memory was to load all of the data needed by the block into a shared array `ds_img_block`, which the parts of the image corresponding to a block and the pixed beyond it with radius `BLUR_SIZE`. The primary challenge with this approach is that each thread would be responsible for loading more than one item into the shared memory. If we want to ensure no overlap and high efficiency, then we need to divide the pixels to be loaded evenly among all threads. This is acheived via linearization of all the pixels in the block + border portion of the image. The main `for` loop iterates over all pixel to be loaded by the block of threads, skipping by the number of threads in the block, and offset by the thread's linear ID.

After the data is loaded into shared memory, the computation phase is largely unchanged from the original code. Below are the timing results comparing the two methods on a handful of images.

| Method | Image | Time (ms)|
| ---   | ---     | ---  |
| Naive | `meme0` | 3.22 |
| Naive | `meme1` | 2.07 |
| Naive | `snow`  | 2.92 |
| Naive | `grumpy`| 2.87 |
| Tiled | `meme0` | 4.31 |
| Tiled | `meme1` | 2.88 |
| Tiled | `snow`  | 3.55 |
| Tiled | `grumpy`| 3.36 |

Below are the dimensions of each image:

| Image   | Height | Width | Total Pixels |
| ---     | :---:  | :---: | :---:        |
| `meme0` | 1166   | 1027  | 1,197,482    |
| `meme1` | 405    | 562   | 227,610      |
| `snow`  | 768    | 1024  | 786,432      |
| `grumpy`| 800    | 800   | 640,000      |


Unfortunately, this tiling method results in a slight slowdown, although the percentage difference decreases with larger images.  Perhaps this method might be useful for large images or for equivalent input data.