#include <iostream>
#include <cuda_runtime.h>
#include <thrust/device_vector.h>

__global__ void cuda_VectorFill(unsigned int *a,
																int sz) {
	int idx = blockIdx.x * blockDim.x + threadIdx.x;
	a[idx] = idx;
}

void cu_vectorFill()
{
	// Some stuff we need to perform timings
	int sz = 1000000;

	thrust::device_vector<unsigned int> a(sz);
	thrust::fill(a.begin(), a.end(), 0);

	unsigned int *a_devPtr = thrust::raw_pointer_cast(&a[0]);

	int threadsPerBlock = 1024;
	int nBlocks = sz / threadsPerBlock + 1;
	if((sz % threadsPerBlock) > 0) {
		nBlocks += 1;
	}
	
	cuda_VectorFill<<< threadsPerBlock, nBlocks >>>(a_devPtr, sz);

	cudaThreadSynchronize();

	std::cout << "Filled vector: ";
	thrust::copy(a.begin(), a.end(), std::ostream_iterator<unsigned int>(std::cout, " "));
	std::cout << "\nVector fill of " << sz << " elements on the GPU finished successfully!" << "\n";
}

