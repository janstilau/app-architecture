import Foundation

class Recording: Item, Codable {
	override init(name: String, uuid: UUID) {
		super.init(name: name, uuid: uuid)
	}
	
	var fileURL: URL? {
		return store?.fileURL(for: self)
	}
	override func deleted() {
		store?.removeFile(for: self) //  如果是录音的话, 先进行音频文件的删除, 然后是内存的逻辑关系的删除.
		super.deleted()
	}

	enum RecordingKeys: CodingKey { case name, uuid }
	
	required init(from decoder: Decoder) throws {
		let c = try decoder.container(keyedBy: RecordingKeys.self)
		let uuid = try c.decode(UUID.self, forKey: .uuid)
		let name = try c.decode(String.self, forKey: .name)
		super.init(name: name, uuid: uuid)
	}

	func encode(to encoder: Encoder) throws {
		var c = encoder.container(keyedBy: RecordingKeys.self)
		try c.encode(name, forKey: .name)
		try c.encode(uuid, forKey: .uuid)
	}
}
