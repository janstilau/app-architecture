import Foundation

final class Store {
	static let changedNotification = Notification.Name("StoreChanged") // 共有的一个通知名.
	static private let documentDirectory = try! FileManager.default.url(for: .libraryDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
	/**
	这应该是 swift 中, 单例的最简单的写法, static let 一个变量, 然后下面的 init 要用 fileprivate 进行修饰.
	
	*/
	static let shared = Store(url: documentDirectory)
	
	let baseURL: URL?
	var placeholder: URL?
	private(set) var rootFolder: Folder
	
	let storeLocationName = "store.json"
	
	fileprivate init(url: URL?) {
		self.baseURL = url
		self.placeholder = nil
		
		if let url = url,
			let data = try? Data(contentsOf: url.appendingPathComponent(storeLocationName)),
			let folder = try? JSONDecoder().decode(Folder.self, from: data)
		{
			self.rootFolder = folder
		} else {
			self.rootFolder = Folder(name: "", uuid: UUID())
		}
		
		self.rootFolder.store = self
	}
	
	func fileURL(for recording: Recording) -> URL? {
		return baseURL?.appendingPathComponent(recording.uuid.uuidString + ".m4a") ?? placeholder
	}
	
	/**
	整个 app 的音乐, 其实都是存放在了一个目录下的, 然后用一个 json 文件, 存储里面的层级信息, 所以在里面, 是用的 uuid 做唯一标识.
	因为文件在同一个目录下, 所以 UUID 为名, 防止冲突.
	*/
	func save(_ notifying: Item, userInfo: [AnyHashable: Any]) {
		if let url = baseURL, let data = try? JSONEncoder().encode(rootFolder) {
			// 这里, 每次修改数据之后, 整体写入一份数据. 这里的数据, 仅仅是 json 文件的数据而已.
			try! data.write(to: url.appendingPathComponent(storeLocationName))
		}
		// 然后发送通知, 通知页面的更新.
		NotificationCenter.default.post(name: Store.changedNotification, object: notifying, userInfo: userInfo)
	}
	
	func item(atUUIDPath path: [UUID]) -> Item? {
		return rootFolder.item(atUUIDPath: path[0...])
	}
	
	func removeFile(for recording: Recording) {
		if let url = fileURL(for: recording), url != placeholder {
			_ = try? FileManager.default.removeItem(at: url)
		}
	}
}

