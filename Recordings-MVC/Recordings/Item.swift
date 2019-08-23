import Foundation

class Item {
	let uuid: UUID
	private(set) var name: String // private(set) 表示这个属性只能在类内设值, 类外不能修改
	init(name: String, uuid: UUID) {
		self.name = name
		self.uuid = uuid
		self.store = nil
	}
	
	
	weak var store: Store?
	weak var parent: Folder? {
		didSet {
			store = parent?.store
		}
	}
	
	func setName(_ newName: String) {
		name = newName
		if let p = parent {
			let (oldIndex, newIndex) = p.reSort(changedItem: self)
			store?.save(self, userInfo: [Item.changeReasonKey: Item.renamed, Item.oldValueKey: oldIndex, Item.newValueKey: newIndex, Item.parentFolderKey: p])
		}
	}
	
	// item 如果被删除, 仅仅是 parent 的置空处理, 而 parent 中的集合操作, 是放在另外一端, 个人感觉不太好, 何不在这里也一并修改了另一端的内容..
	func deleted() {
		parent = nil
	}
	
	var uuidPath: [UUID] {
		var path = parent?.uuidPath ?? []
		path.append(uuid)
		return path
	}
	
	func item(atUUIDPath path: ArraySlice<UUID>) -> Item? {
		guard let first = path.first, first == uuid else { return nil }
		return self
	}
}

/**
	这里, 定义 key 的方式要比 oc 好, OC 只能定义字符串, 虽然在相应的文件中定义, 但是终究是全局字符串而没有和类进行了挂钩.
*/
extension Item {
	static let changeReasonKey = "reason"
	static let newValueKey = "newValue"
	static let oldValueKey = "oldValue"
	static let parentFolderKey = "parentFolder"
	static let renamed = "renamed"
	static let added = "added"
	static let removed = "removed"
}

