class ProductModel {
  final int id;
  final String name;
  final String description;
  final String price;
  final String regularPrice;
  final String salePrice;
  final List<String> imageUrls;
  final List<String> categories;
  final List<int> categoryIds;
  final List<Map<String, dynamic>> attributes;
  final List<String> colors; // New field for colors
  final String dateCreated;
  final bool onSale;
  final int stockQuantity;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.regularPrice,
    required this.salePrice,
    required this.imageUrls,
    required this.categories,
    required this.categoryIds,
    required this.attributes,
    required this.colors, // Add colors to the constructor
    required this.dateCreated,
    required this.onSale,
    required this.stockQuantity,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    var imageUrls =
        (json['images'] as List?)
            ?.map((img) => img['src'] as String)
            .toList() ??
        [];

    var categories =
        (json['categories'] as List?)
            ?.map((cat) => cat['name'] as String)
            .toList() ??
        [];

    var categoryIds =
        (json['categories'] as List?)
            ?.map((cat) => cat['id'] as int)
            .toList() ??
        [];

    var attributes =
        (json['attributes'] as List?)
            ?.map(
              (attr) => {
                'id': attr['id'],
                'name': attr['name'],
                'slug': attr['slug'],
                'position': attr['position'],
                'visible': attr['visible'],
                'variation': attr['variation'],
                'options': List<String>.from(attr['options'] ?? []),
              },
            )
            .toList() ??
        [];

    List<String> colors = [];
    for (var attr in attributes) {
      if (attr['name'] == 'لون') {
        colors = List<String>.from(attr['options'] ?? []);
        break;
      }
    }

    return ProductModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: json['price']?.toString() ?? '0',
      regularPrice: json['regular_price']?.toString() ?? '',
      salePrice: json['sale_price']?.toString() ?? '',
      imageUrls: imageUrls,
      categories: categories,
      categoryIds: categoryIds,
      attributes: attributes,
      colors: colors,
      dateCreated: json['date_created'] ?? '',
      onSale: json['on_sale'] ?? false,
      stockQuantity: json['stock_quantity'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'regular_price': regularPrice,
      'sale_price': salePrice,
      'date_created': dateCreated,
      'on_sale': onSale,
      'stock_quantity': stockQuantity,
      'images': imageUrls.map((url) => {'src': url}).toList(),
      'categories': List.generate(
        categories.length,
        (index) => {'name': categories[index], 'id': categoryIds[index]},
      ),
      'attributes':
          attributes.map((attr) {
            return {
              'id': attr['id'],
              'name': attr['name'],
              'slug': attr['slug'],
              'position': attr['position'],
              'visible': attr['visible'],
              'variation': attr['variation'],
              'options': attr['options'],
            };
          }).toList(),
      'colors': colors,
    };
  }
}

class CartProductModel {
  final int id;
  final String name;
  final String price;

  final List<String> imageUrls;

  final List<String> categories;
  final List<int> categoryIds;
  int quantity; // Quantity for the cart

  CartProductModel({
    required this.id,
    required this.name,
    required this.price,

    required this.imageUrls,

    required this.categories,
    required this.categoryIds,
    this.quantity = 1,
  });

  // fromJson method
  factory CartProductModel.fromJson(Map<String, dynamic> json) {
    return CartProductModel(
      id: json['id'],
      name: json['name'],
      price: json['price'],

      imageUrls: List<String>.from(json['imageUrls']),

      categories: List<String>.from(json['categories']),
      categoryIds: List<int>.from(json['categoryIds']),
      quantity: json['quantity'] ?? 1, // Default quantity is 1 if not present
    );
  }

  // toJson method (optional, if you need to convert it back to JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'imageUrls': imageUrls,
      'categories': categories,
      'categoryIds': categoryIds,
      'quantity': quantity,
    };
  }

  // CopyWith method for CartProductModel
  CartProductModel copyWith({
    int? id,
    String? name,
    String? price,
    int? stockQuantity,
    List<String>? imageUrls,
    String? permalink,
    String? sku,
    String? type,
    List<String>? categories,
    List<int>? categoryIds,
    int? quantity,
  }) {
    return CartProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,

      imageUrls: imageUrls ?? this.imageUrls,

      categories: categories ?? this.categories,
      categoryIds: categoryIds ?? this.categoryIds,
      quantity: quantity ?? this.quantity,
    );
  }
}
