import Foundation

/**
 一个非常非常简单的 model. 在这个 model 里面, 仅仅只有一个 value 值. value 注册监听, 在有了新值之后, 会发送通知. 然后会引起其他的数据刷新的操作.
 */
class Model {
	static let textDidChange = Notification.Name("textDidChange")
	static let textKey = "text"
	
	var value: String {
		didSet {
			NotificationCenter.default.post(name: Model.textDidChange, object: self, userInfo: [Model.textKey: value])
		}
	}
    
	init(value: String) {
		self.value = value
	}
}
