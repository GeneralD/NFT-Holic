import Foundation

struct Metadata: Encodable {
	/// This is the URL to the image of the item.
	/// Can be just about any type of image (including SVGs, which will be cached into PNGs by OpenSea),
	/// and can be IPFS URLs or paths. We recommend using a 350 x 350 image.
	let image: URL

	///	This is the URL that will appear below the asset's image on OpenSea and will allow users to leave OpenSea and view the item on your site.
	let externalURL: URL

	/// A human readable description of the item. Markdown is supported.
	let description: String

	/// Name of the item.
	let name: String

	/// These are the attributes for the item, which will show up on the OpenSea page for the item.
	let attributes: Attribute

	/// Background color of the item on OpenSea. Must be a six-character hexadecimal without a pre-pended #.
	let backgroundColor: String

	enum CodingKeys: String, CodingKey {
		case image
		case externalURL = "external_url"
		case description
		case name
		case attributes
		case backgroundColor = "background_color"
	}

	/// - SeeAlso: [Document](https://docs.opensea.io/docs/metadata-standards#attributes)
	enum Attribute: Encodable {
		case simple(value: String)
		case stringLabel(traitType: String, value: String)
		case dateLabel(traitType: String, value: Date)
		case numberLabel(traitType: String, value: NumericValue)
		case boostNumber(traitType: String, value: NumericValue, maxValue: NumericValue)
		case boostPercentage(traitType: String, value: NumericValue)
		case rankedNumber(traitType: String, value: NumericValue)

		enum NumericValue: ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral {
			case int(_: Int)
			case float(_: Float)

			init(integerLiteral value: Int) {
				self = .int(value)
			}
			init(floatLiteral value: Float) {
				self = .float(value)
			}
		}

		enum CodingKeys: String, CodingKey {
			case traitType = "trait_type"
			case displayType = "display_type"
			case value
			case maxValue = "max_value"
		}

		func encode(to encoder: Encoder) throws {
			var container = encoder.container(keyedBy: CodingKeys.self)
			switch self {
			case let .simple(value):
				try container.encode(value, forKey: .value)

			case let .stringLabel(traitType, value):
				try container.encode(traitType, forKey: .traitType)
				try container.encode(value, forKey: .value)

			case let .dateLabel(traitType, value):
				try container.encode(traitType, forKey: .traitType)
				try container.encode(Int(value.timeIntervalSince1970), forKey: .value)
				try container.encode("date", forKey: .displayType)

			case let .numberLabel(traitType, value):
				try container.encode(traitType, forKey: .traitType)
				try container.encode("number", forKey: .displayType)
				try container.encode(value, forKey: .value)

			case let .boostNumber(traitType, value, maxValue):
				try container.encode(traitType, forKey: .traitType)
				try container.encode("boost_number", forKey: .displayType)
				try container.encode(value, forKey: .value)
				try container.encode(maxValue, forKey: .maxValue)

			case let .boostPercentage(traitType, value):
				try container.encode(traitType, forKey: .traitType)
				try container.encode("boost_percentage", forKey: .displayType)
				try container.encode(value, forKey: .value)

			case let .rankedNumber(traitType, value):
				try container.encode(traitType, forKey: .traitType)
				try container.encode(value, forKey: .value)
			}
		}
	}
}

extension KeyedEncodingContainer where Key == Metadata.Attribute.CodingKeys {
	mutating func encode(_ value: Metadata.Attribute.NumericValue, forKey key: Metadata.Attribute.CodingKeys) throws {
		switch value {
		case let .int(val):
			try encode(val, forKey: key)
		case let .float(val):
			try encode(val, forKey: key)
		}
	}
}