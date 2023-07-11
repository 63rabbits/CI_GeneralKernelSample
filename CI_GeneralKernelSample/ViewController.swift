import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // get source image
        let inputUiImage = UIImage(named: "kerokero")!      // get the image in assets.
        let inputCiImage = CIImage(image: inputUiImage)!    // convert to CIImage



        // filter
        let filter = MyFilter()
        filter.inputImage = inputCiImage
        let outputCiImage = filter.outputImage!


        // view
        let outputUiImage = UIImage(ciImage: outputCiImage)
        imageView.image = outputUiImage

    }

}

class MyFilter: CIFilter {

    private let kernel: CIKernel

    var inputImage: CIImage?

    override init() {
        let url = Bundle.main.url(forResource: "default", withExtension: "metallib")!
        let data = try! Data(contentsOf: url)
        kernel = try! CIKernel(functionName: "flipAndColorShift", fromMetalLibraryData: data)
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var outputImage : CIImage? {
        guard let inputImage = inputImage else { return nil }
        return kernel.apply(
                extent: inputImage.extent,
                roiCallback: { (index, rect) in return rect },
                arguments: [inputImage]
            )
    }
}
