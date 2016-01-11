#Image Inpainting Project: ETH Computational Intelligence Lab 2015

This file describes matlab files that we used to obtain our results,
together with instructions for how can they be reproduced.

I. File List
------------
*buildDictionary.m: Returns a prebuild matrix 'dictionary.mat' or builds a twice 			   overcomplete DCT of supplied dimension if such matrix is not found

*dictionary.mat:    Our dictionary obtained with K-SVD algorithm

*get_degrees:	   Takes image mask M in 2-D image form and counts for each pixel the 			   number of its neighbours in mask

*inPainting.m:	   Perform the actual inpainting of the image

*OMP.m:		   Our implementation of the Orthogonal Matching Pursuit

*overDCTdict.m:	   Computes overcomplete Discrete Cosine Transform of supplied dimensions

*overlap_col2im.m:  Recombines overlapping (d x d) patches into an image reconstruction 			   weighting them by their signal-to-noise ration

*overlap_im2col.m:  Extracts (d x d) patches from image I after every 'overlap' pixels

*peel_mask.m:	   Removes boundary pixel layer from the mask

*SMP.m:		   Performs sequential mask peeling inpainting algorithm, as described in 		   our paper


II. Reproducing results
-----------------------

Anyone wishing to reproduce our results should use the default parameter values specified in the files. To reconstruct a single channel image, one needs to perform the following. Represent the grayscale image as a matrix I in [0,1] range and get a binary mask matrix of size(I) with zeros at missing pixels. Now execute:
	
	1. I_mask = I;
	2. I_mask(mask == 0) = 0;
	3. I_rec = inPainting(I_mask, mask);

The reconstructed image is single channel a matrix I_rec in [0,1] range of the same size as I.

III. Authors
------------

Filippini Luca Teodoro, Department of Computer Science, ETH Zurich, 8092 Zurich, Switzerland. E-mail: fteodoro@student.ethz.ch

Porvaznik Michal, Department of Computer Science, ETH Zurich, 8092 Zurich, Switzer-
land. E-mail: pmichal@student.ethz.ch

Trujic Milos, Department of Computer Science, ETH Zurich, 8092 Zurich, Switzerland. E-mail: mtrujic@student.ethz.ch
