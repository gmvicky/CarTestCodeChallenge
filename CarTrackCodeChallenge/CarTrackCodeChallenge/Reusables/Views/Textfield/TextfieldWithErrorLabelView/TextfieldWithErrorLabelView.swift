import UIKit
import Combine

class TextfieldWithErrorLabelView: UIView, ViewCoderLoadable {
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var textfieldImageView: UIImageView?
    @IBOutlet weak var textfield: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    func bind(to inputObject: InputObject, cancelBag: CancellableBag, viewControllerRootView: UIView? = nil) {
        
        textfield.bindText(to: inputObject.textSubject, cancelBag: cancelBag)
        
        let error = inputObject.errors
            .map { $0.last?.errorType.errorDescription }
            .eraseToAnyPublisher()
        
        errorLabel.bindText(to: error, cancelBag: cancelBag, viewControllerRootView: viewControllerRootView)
    }
    
    // MARK: - Private
    
    private func commonInit() {
        setUpLoadableView()
    }
}
