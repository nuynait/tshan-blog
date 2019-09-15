---
title: Lag When Setting Image To UIImageView
date: 2018-03-02
tags:
desc:
---

I haven’t touch the code for Mapsted Navigation for iOS a long time, and after I refactor the code I open the app, I notice that there is a significant lag when scroll in building list. End up it caused by assign image to an `UIImageView`.

<!--more-->

## How I Narrow Down The Issue
 I start to look down on where it gets lag. I found out that the lag happens in this function.  This function is inside a cell, so it is called every time a cell is drawing.

```swift
  func redrawImageMask(image: UIImage) {
    DispatchQueue.global(qos: .background).async {
      let maskedImage = image.maskImage(width: MNBuildingListTableViewController.CELL_ROW_WIDTH*2, height: MNBuildingListTableViewController.CELL_SELECTED_ROW_HEIGHT*2)

      DispatchQueue.main.async {
        self.imageMask.image = maskedImage
      }
    }
  }
```

First I thought its the masking that cause the issue, but for masking image, I am doing it in the background,  which should not cause the lag. Then I commented the mask and I found out that it is still lag, so the problem happen at the time when assign image to the `UIImageView`.

> A little note here: previously, the lag happens every time when a cell gets reuse. After I commented the mask, the lag only happens when it first uses the cell. I guess this is because lag happens on assign the image, the reason for it only lag the first time is because it is not changing the image (masking the image) every time cell gets redraw so when assign the image with the same image, it does not lag anymore.  

```swift
DispatchQueue.main.async {
  self.imageMask.image = maskedImage
}
```

## My Solution
Here is how I solve this issue. I wrote a function helper inside `UIImage` extension. In `Swift`

```swift
extension UIImage {
  /**
   * Use this function to decompress the image.
   * Please run this function in a background thread to avoid occupy main thread.
   * The reason for this function is to avoid lag when assign to image view
   * https://stackoverflow.com/a/10818917/2581637
   */
  func decompress() -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(size, false, scale)
    draw(at: .zero)
    let new: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return new
  }
}

// To use this function
DispatchQueue.global(qos: .background).async {
  let newImage = image.decompressed()
  DispatchQueue.main.async {
    self.imageMask.image = newImage
  }
}

```


## Solution From Stackoverflow
[Here](https://stackoverflow.com/a/10818917/2581637) is a very useful link that provide helpful answers. Below is the mirror version of the answer in case link gets removed. Credit to  [@fumoboy007](https://stackoverflow.com/users/815742/fumoboy007).

EDIT 2: Here is a Swift version that contains a few improvements. (Untested.)
https://gist.github.com/fumoboy007/d869e66ad0466a9c246d

- - - -
EDIT: Actually, I believe all that is necessary is the following. (Untested.)

``` objective-c
- (void)loadImageNamed:(NSString *)name {
	dispatch_async(self.dispatchQueue, ^{
		// Determine path to image depending on scale of device's screen,
		// fallback to 1x if 2x is not available
		NSString *pathTo1xImage = [[NSBundle mainBundle] pathForResource:name ofType:@"png"];
		NSString *pathTo2xImage = [[NSBundle mainBundle] pathForResource:[name stringByAppendingString:@"@2x"] ofType:@"png"];

		NSString *pathToImage = ([UIScreen mainScreen].scale == 1 || !pathTo2xImage) ? pathTo1xImage : pathTo2xImage;

		UIImage *image = [[UIImage alloc] initWithContentsOfFile:pathToImage];    
        // Decompress image
      if (image) {
          UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);    
          [image drawAtPoint:CGPointZero];
          image = UIGraphicsGetImageFromCurrentImageContext();
          UIGraphicsEndImageContext();
      }
		// Configure the UI with pre-decompressed UIImage
    	dispatch_async(dispatch_get_main_queue(), ^{
    		self.image = image;
    	});
	});
}
```
- - - -

ORIGINAL ANSWER: It turns out that it wasn't `self.image = image;` directly. The UIImage image loading methods don't decompress and process the image data right away; they do it when the view refreshes its display. So the solution was to go a level lower to Core Graphics and decompress and process the image data myself. The new code looks like the following.

``` objective-c
- (void)loadImageNamed:(NSString *)name {
	dispatch_async(self.dispatchQueue, ^{
		// Determine path to image depending on scale of device's screen,
		// fallback to 1x if 2x is not available
		NSString *pathTo1xImage = [[NSBundle mainBundle] pathForResource:name ofType:@"png"];
 		NSString *pathTo2xImage = [[NSBundle mainBundle] pathForResource:[name stringByAppendingString:@"@2x"] ofType:@"png"];
 		NSString *pathToImage = ([UIScreen mainScreen].scale == 1 || !pathTo2xImage) ? pathTo1xImage : pathTo2xImage;

 		UIImage *uiImage = nil;

 		if (pathToImage) {
 			// Load the image
 			CGDataProviderRef imageDataProvider = CGDataProviderCreateWithFilename([pathToImage fileSystemRepresentation]);
 			CGImageRef image = CGImageCreateWithPNGDataProvider(imageDataProvider, NULL, NO, kCGRenderingIntentDefault);

 			// Create a bitmap context from the image's specifications
 			// (Note: We need to specify kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little
 			// because PNGs are optimized by Xcode this way.)
 			CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
 			CGContextRef bitmapContext = CGBitmapContextCreate(
						NULL,
						CGImageGetWidth(image),
						CGImageGetHeight(image),
						CGImageGetBitsPerComponent(image),
						CGImageGetWidth(image) * 4,
						colorSpace,
						kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little);

 			// Draw the image into the bitmap context
 			CGContextDrawImage(bitmapContext, CGRectMake(0, 0, CGImageGetWidth(image), CGImageGetHeight(image)), image);

          //  Extract the decompressed image
 			CGImageRef decompressedImage = CGBitmapContextCreateImage(bitmapContext);


  			// Create a UIImage
  			uiImage = [[UIImage alloc] initWithCGImage:decompressedImage];


  			// Release everything
  			CGImageRelease(decompressedImage);
  			CGContextRelease(bitmapContext);
 			CGColorSpaceRelease(colorSpace);
  			CGImageRelease(image);
  			CGDataProviderRelease(imageDataProvider);
  		}


  		// Configure the UI with pre-decompressed UIImage
  		dispatch_async(dispatch_get_main_queue(), ^{
  			self.image = uiImage;
  		});
  	});
}
```
