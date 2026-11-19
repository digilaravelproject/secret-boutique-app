import 'package:the_secret_boutique/core/constants/app_images.dart';
import 'package:the_secret_boutique/data/models/address_model.dart';
import 'package:the_secret_boutique/data/models/category_model.dart';
import 'package:the_secret_boutique/data/models/product_model.dart';

class ShopRepository {
  // Categories matching boutique catalog
  static final List<CategoryModel> categories = [
    const CategoryModel(
      id: 'cat_bras',
      name: 'Bras',
      subtitle: 'Comfort & Allure',
      imageUrl: AppImages.categoryBras,
      subCategories: ['All', 'Strappy & Cage', 'Underwire Sets', 'Kiss Print', 'Bow & Heart'],
    ),
    const CategoryModel(
      id: 'cat_panties',
      name: 'Panties',
      subtitle: 'Soft & Breathable',
      imageUrl: AppImages.categoryPanties,
      subCategories: ['All', 'Chain Thongs', 'Cage Cutout', 'Lace Briefs', 'Leopard Trim'],
    ),
    const CategoryModel(
      id: 'cat_shapewear',
      name: 'One Piece',
      subtitle: 'Hosiery & Bodystockings',
      imageUrl: AppImages.categoryShapewear,
      subCategories: ['All', 'Bodystockings', 'Fishnet Jumpsuits', 'Cutout Suits', 'Butterfly Mini'],
    ),
    const CategoryModel(
      id: 'cat_swimwear',
      name: 'Swimwear',
      subtitle: 'Beach Ready',
      imageUrl: AppImages.categorySwimwear,
      subCategories: ['All', 'Bikini Briefs', 'High Waist', 'Lace-Up Briefs', 'Textured'],
    ),
    const CategoryModel(
      id: 'cat_lingerie_sets',
      name: 'Lingerie Sets',
      subtitle: 'Sensual 2-Piece Sets',
      imageUrl: AppImages.categoryLingerieSets,
      subCategories: ['All', 'Satin Bow Sets', 'Rhinestone Sets', 'Babydoll Chemise'],
    ),
    const CategoryModel(
      id: 'cat_nightwear',
      name: 'Nightwear',
      subtitle: 'Relax in Luxury',
      imageUrl: AppImages.categoryNightwear,
      subCategories: ['All', 'Babydolls', 'Satin Crop Sets', 'Suspender Sets', 'Sheer Robes'],
    ),
    const CategoryModel(
      id: 'cat_activewear',
      name: 'Bodysuits',
      subtitle: 'Move & Flatter',
      imageUrl: AppImages.categoryActivewear,
      subCategories: ['All', 'Halter Suits', 'Mesh Jumpsuits', 'Sleeveless'],
    ),
    const CategoryModel(
      id: 'cat_others',
      name: 'Accessories',
      subtitle: 'Chains & Charms',
      imageUrl: AppImages.categoryOthers,
      subCategories: ['All', 'Waist Chains', 'Garter Straps', 'Silicone Enhancers'],
    ),
  ];

  // Products with high-res boutique photography
  static final List<ProductModel> products = [
    // ----------------- BRAS & BRA SETS -----------------
    const ProductModel(
      id: 'p1',
      name: 'Rhinestone Cage Bra & Panty Set',
      categoryId: 'cat_bras',
      categoryName: 'Bras',
      subCategory: 'Strappy & Cage',
      price: 699,
      originalPrice: 999,
      discountPercent: 30,
      rating: 4.9,
      reviewCount: 14210,
      imageUrl: AppImages.braBlackRhinestone,
      images: [
        AppImages.braBlackRhinestone,
        AppImages.braKissPrintMesh,
        AppImages.modelDetail,
        AppImages.categoryLingerieSets,
      ],
      description:
          'Dazzling black caged underwire bra adorned with sparkling rhinestone accents and matching geometric cutout strap panty.',
      sizes: ['32B', '34B', '36B', '38B'],
      colors: [
        ProductColorOption(name: 'Midnight Black', colorValue: 0xFF1A1A1A),
      ],
      isBestSeller: true,
      isFeatured: true,
    ),
    const ProductModel(
      id: 'p2',
      name: 'Kiss Print Sheer Mesh Bra & Thong',
      categoryId: 'cat_bras',
      categoryName: 'Bras',
      subCategory: 'Kiss Print',
      price: 599,
      originalPrice: 849,
      discountPercent: 29,
      rating: 4.8,
      reviewCount: 9340,
      imageUrl: AppImages.braKissPrintMesh,
      images: [
        AppImages.braKissPrintMesh,
        AppImages.braRedSatinBow,
        AppImages.braPinkHeartWire,
        AppImages.modelBrunette,
      ],
      description:
          'Playful and romantic white semi-sheer mesh bra featuring crimson lipstick kiss prints, underwire support, and matching string thong.',
      sizes: ['32B', '34B', '36B', '38B'],
      colors: [
        ProductColorOption(name: 'White Lips', colorValue: 0xFFF5F5F5),
      ],
      isBestSeller: true,
      isFeatured: true,
    ),
    const ProductModel(
      id: 'p3',
      name: 'Count The Stars Satin Bow Bra Set',
      categoryId: 'cat_bras',
      categoryName: 'Bras',
      subCategory: 'Bow & Heart',
      price: 649,
      originalPrice: 899,
      discountPercent: 27,
      rating: 4.9,
      reviewCount: 11250,
      imageUrl: AppImages.braRedSatinBow,
      images: [
        AppImages.braRedSatinBow,
        AppImages.braPinkHeartWire,
        AppImages.luxuryGift,
        AppImages.braBlackRhinestone,
      ],
      description:
          'Sultry open-cup frame bra with dual ruby-red satin ribbon bows and matching low-rise bow g-string thong.',
      sizes: ['32', '34', '36', '38'],
      colors: [
        ProductColorOption(name: 'Ruby Red', colorValue: 0xFFB30B30),
      ],
      isBestSeller: true,
      isFeatured: true,
    ),
    const ProductModel(
      id: 'p4',
      name: 'Heart To Heart Glitter Underwire Set',
      categoryId: 'cat_bras',
      categoryName: 'Bras',
      subCategory: 'Bow & Heart',
      price: 549,
      originalPrice: 799,
      discountPercent: 31,
      rating: 4.7,
      reviewCount: 6810,
      imageUrl: AppImages.braPinkHeartWire,
      images: [
        AppImages.braPinkHeartWire,
        AppImages.braBlackRhinestone,
        AppImages.braKissPrintMesh,
        AppImages.pantyLeopardBow,
      ],
      description:
          'Flirty baby pink sheer underwire bra with sparkling glitter heart cup patches and matching satin heart thong.',
      sizes: ['32B', '34B', '36B', '38B'],
      colors: [
        ProductColorOption(name: 'Baby Pink', colorValue: 0xFFFFB6C1),
      ],
      isBestSeller: false,
      isFeatured: true,
    ),

    // ----------------- ONE PIECE HOSIERY / BODYSTOCKINGS -----------------
    const ProductModel(
      id: 'h1',
      name: 'Butterfly Cutout Mini Dress & Sleeves',
      categoryId: 'cat_shapewear',
      categoryName: 'One Piece',
      subCategory: 'Butterfly Mini',
      price: 799,
      originalPrice: 1199,
      discountPercent: 33,
      rating: 4.9,
      reviewCount: 18450,
      imageUrl: AppImages.hosieryBlackButterfly,
      images: [
        AppImages.hosieryBlackButterfly,
        AppImages.hosieryBlackLeopard,
        AppImages.hosieryLilacCutout,
        AppImages.hosieryRedFishnet,
      ],
      description:
          'Intricate butterfly knit fishnet one-piece dress with front criss-cross cutout and matching separate arm sleeves.',
      sizes: ['Free Size (Fits S - XL)'],
      colors: [
        ProductColorOption(name: 'Jet Black', colorValue: 0xFF121212),
      ],
      isBestSeller: true,
      isFeatured: true,
    ),
    const ProductModel(
      id: 'h2',
      name: 'Lilac Cutout Thigh Bodystocking',
      categoryId: 'cat_shapewear',
      categoryName: 'One Piece',
      subCategory: 'Cutout Suits',
      price: 699,
      originalPrice: 999,
      discountPercent: 30,
      rating: 4.8,
      reviewCount: 7890,
      imageUrl: AppImages.hosieryLilacCutout,
      images: [
        AppImages.hosieryLilacCutout,
        AppImages.hosieryRedFishnet,
        AppImages.hosieryBlackButterfly,
        AppImages.hosieryBlackLeopard,
      ],
      description:
          'Lavender floral lace sleeveless bodystocking with thigh-high cutout suspension styling and geometric fishnet paneling.',
      sizes: ['Free Size (Fits S - XL)'],
      colors: [
        ProductColorOption(name: 'Lilac Purple', colorValue: 0xFFB39DDB),
      ],
      isBestSeller: false,
      isFeatured: true,
    ),
    const ProductModel(
      id: 'h3',
      name: 'Leopard Lace Full Body Jumpsuit',
      categoryId: 'cat_shapewear',
      categoryName: 'One Piece',
      subCategory: 'Bodystockings',
      price: 899,
      originalPrice: 1299,
      discountPercent: 30,
      rating: 4.9,
      reviewCount: 21400,
      imageUrl: AppImages.hosieryBlackLeopard,
      images: [
        AppImages.hosieryBlackLeopard,
        AppImages.hosieryBlackButterfly,
        AppImages.hosieryRedFishnet,
        AppImages.hosieryLilacCutout,
      ],
      description:
          'Long sleeve form-fitting full bodystocking jumpsuit featuring sheer leopard spots woven into delicate stretch jacquard lace.',
      sizes: ['Free Size (Fits S - XXL)'],
      colors: [
        ProductColorOption(name: 'Midnight Black', colorValue: 0xFF151515),
      ],
      isBestSeller: true,
      isFeatured: true,
    ),
    const ProductModel(
      id: 'h4',
      name: 'Crimson Fishnet Open Jumpsuit',
      categoryId: 'cat_shapewear',
      categoryName: 'One Piece',
      subCategory: 'Fishnet Jumpsuits',
      price: 749,
      originalPrice: 1099,
      discountPercent: 31,
      rating: 4.8,
      reviewCount: 13200,
      imageUrl: AppImages.hosieryRedFishnet,
      images: [
        AppImages.hosieryRedFishnet,
        AppImages.hosieryLilacCutout,
        AppImages.hosieryBlackLeopard,
        AppImages.hosieryBlackButterfly,
      ],
      description:
          'Sultry wine crimson long-sleeve fishnet bodystocking with diamond cage cutout front and leg floral embellishments.',
      sizes: ['Free Size (Fits S - XL)'],
      colors: [
        ProductColorOption(name: 'Wine Crimson', colorValue: 0xFF8A0B3C),
      ],
      isBestSeller: true,
      isFeatured: true,
    ),

    // ----------------- PANTIES -----------------
    const ProductModel(
      id: 'p8',
      name: 'Gold Chain Star Charm Thong',
      categoryId: 'cat_panties',
      categoryName: 'Panties',
      subCategory: 'Chain Thongs',
      price: 299,
      originalPrice: 399,
      discountPercent: 25,
      rating: 4.8,
      reviewCount: 16200,
      imageUrl: AppImages.pantyChainThong,
      images: [
        AppImages.pantyChainThong,
        AppImages.pantyCageLace,
        AppImages.pantyScallopedBrief,
        AppImages.pantyLeopardBow,
      ],
      description:
          'Sultry black velvet micro thong adorned with delicate metallic gold waist chain and dangling star charms.',
      sizes: ['S', 'M', 'L', 'XL'],
      colors: [
        ProductColorOption(name: 'Gold Black', colorValue: 0xFF1C1C1C),
      ],
      isBestSeller: true,
      isFeatured: false,
    ),
    const ProductModel(
      id: 'p9',
      name: 'Strappy Cage Cutout Lace Panty',
      categoryId: 'cat_panties',
      categoryName: 'Panties',
      subCategory: 'Cage Cutout',
      price: 349,
      originalPrice: 449,
      discountPercent: 22,
      rating: 4.9,
      reviewCount: 8940,
      imageUrl: AppImages.pantyCageLace,
      images: [
        AppImages.pantyCageLace,
        AppImages.pantyScallopedBrief,
        AppImages.pantyChainThong,
        AppImages.pantyLeopardBow,
      ],
      description:
          'Exquisite multi-strap cage cutout waist thong with delicate bow accent and sheer floral lace embroidery.',
      sizes: ['S', 'M', 'L', 'XL'],
      colors: [
        ProductColorOption(name: 'Midnight Black', colorValue: 0xFF1C1C1C),
      ],
      isBestSeller: true,
      isFeatured: true,
    ),
    const ProductModel(
      id: 'p10',
      name: 'Scalloped Floral Lace Brief',
      categoryId: 'cat_panties',
      categoryName: 'Panties',
      subCategory: 'Lace Briefs',
      price: 329,
      originalPrice: 429,
      discountPercent: 23,
      rating: 4.7,
      reviewCount: 11200,
      imageUrl: AppImages.pantyScallopedBrief,
      images: [
        AppImages.pantyScallopedBrief,
        AppImages.pantyLeopardBow,
        AppImages.pantyCageLace,
        AppImages.pantyChainThong,
      ],
      description:
          'Double-band cutout hipster brief in eyelash French lace and sheer polka dot mesh with central metallic O-ring.',
      sizes: ['S', 'M', 'L', 'XL'],
      colors: [
        ProductColorOption(name: 'Black Lace', colorValue: 0xFF151515),
      ],
      isBestSeller: false,
      isFeatured: true,
    ),
    const ProductModel(
      id: 'p11',
      name: 'Leopard Trim Bow Lace Thong',
      categoryId: 'cat_panties',
      categoryName: 'Panties',
      subCategory: 'Leopard Trim',
      price: 369,
      originalPrice: 499,
      discountPercent: 26,
      rating: 4.9,
      reviewCount: 7850,
      imageUrl: AppImages.pantyLeopardBow,
      images: [
        AppImages.pantyLeopardBow,
        AppImages.pantyChainThong,
        AppImages.pantyScallopedBrief,
        AppImages.pantyCageLace,
      ],
      description:
          'Champagne sheer lace triangle thong with playful leopard print skinny strap and satin bow tie.',
      sizes: ['S', 'M', 'L', 'XL'],
      colors: [
        ProductColorOption(name: 'Champagne Leopard', colorValue: 0xFFF3E5AB),
      ],
      isBestSeller: true,
      isFeatured: true,
    ),

    // ----------------- NIGHTWEAR -----------------
    const ProductModel(
      id: 'n1',
      name: 'Red Lace Cut-Out Halter Babydoll',
      categoryId: 'cat_nightwear',
      categoryName: 'Nightwear',
      subCategory: 'Babydolls',
      price: 1349,
      originalPrice: 3449,
      discountPercent: 60,
      rating: 4.9,
      reviewCount: 15420,
      imageUrl: AppImages.nightwearRedLaceCutout,
      images: [
        AppImages.nightwearRedLaceCutout,
        AppImages.nightwearRedBabydoll,
        AppImages.nightwearWineCorset,
        AppImages.nightwearPurpleSheerStocking,
      ],
      description:
          'Passionate scarlet red lace halter cut-out chemise with floral scalloped trims and plunging back silhouette.',
      sizes: ['S', 'M', 'L', 'XL'],
      colors: [
        ProductColorOption(name: 'Scarlet Red', colorValue: 0xFFC2185B),
      ],
      isBestSeller: true,
      isFeatured: true,
    ),
    const ProductModel(
      id: 'n2',
      name: 'Wine Satin Crop Top & Shorts Set',
      categoryId: 'cat_nightwear',
      categoryName: 'Nightwear',
      subCategory: 'Satin Crop Sets',
      price: 849,
      originalPrice: 2349,
      discountPercent: 63,
      rating: 4.8,
      reviewCount: 9140,
      imageUrl: AppImages.nightwearWineSatinShorts,
      images: [
        AppImages.nightwearWineSatinShorts,
        AppImages.nightwearPurpleSatin,
        AppImages.nightwearRedSheerRobe,
        AppImages.nightwearRedLaceCutout,
      ],
      description:
          'Silky smooth wine burgundy satin sleepwear cami top with lace hem ruffle and matching ruffled tap shorts.',
      sizes: ['S', 'M', 'L', 'XL'],
      colors: [
        ProductColorOption(name: 'Wine Burgundy', colorValue: 0xFF5D082C),
      ],
      isBestSeller: true,
      isFeatured: false,
    ),
    const ProductModel(
      id: 'n3',
      name: 'Purple Sheer Babydoll & Stockings',
      categoryId: 'cat_nightwear',
      categoryName: 'Nightwear',
      subCategory: 'Suspender Sets',
      price: 1599,
      originalPrice: 3999,
      discountPercent: 60,
      rating: 4.9,
      reviewCount: 8230,
      imageUrl: AppImages.nightwearPurpleSheerStocking,
      images: [
        AppImages.nightwearPurpleSheerStocking,
        AppImages.nightwearRedSheerRobe,
        AppImages.nightwearWineCorset,
        AppImages.nightwearRedBabydoll,
      ],
      description:
          'Royal purple underwire lace corset babydoll with integrated garter suspenders, satin side ribbons, and sheer stockings.',
      sizes: ['32', '34', '36', '38'],
      colors: [
        ProductColorOption(name: 'Royal Purple', colorValue: 0xFF512DA8),
      ],
      isBestSeller: true,
      isFeatured: true,
    ),
    const ProductModel(
      id: 'n4',
      name: 'Elegant Red Sheer Robe & Slip Set',
      categoryId: 'cat_nightwear',
      categoryName: 'Nightwear',
      subCategory: 'Sheer Robes',
      price: 1449,
      originalPrice: 2999,
      discountPercent: 51,
      rating: 4.8,
      reviewCount: 6510,
      imageUrl: AppImages.nightwearRedSheerRobe,
      images: [
        AppImages.nightwearRedSheerRobe,
        AppImages.nightwearRedLaceCutout,
        AppImages.nightwearPurpleSheerStocking,
        AppImages.nightwearWineSatinShorts,
      ],
      description:
          'Breathtaking crimson sheer chiffon kimono robe with bell sleeves, strappy back tie chemise, and matching satin waistband.',
      sizes: ['S', 'M', 'L', 'XL'],
      colors: [
        ProductColorOption(name: 'Crimson Red', colorValue: 0xFFB71C1C),
      ],
      isBestSeller: false,
      isFeatured: true,
    ),

    // ----------------- SWIMWEAR -----------------
    const ProductModel(
      id: 's1',
      name: 'Vilamoura Tropical Floral Bikini Brief',
      categoryId: 'cat_swimwear',
      categoryName: 'Swimwear',
      subCategory: 'Bikini Briefs',
      price: 456,
      originalPrice: 699,
      discountPercent: 34,
      rating: 4.7,
      reviewCount: 5410,
      imageUrl: AppImages.swimwearFloralRed,
      images: [
        AppImages.swimwearFloralRed,
        AppImages.swimwearBlackLeaf,
        AppImages.swimwearWhiteFloral,
        AppImages.swimwearPinkTextured,
      ],
      description:
          'Vibrant red tropical botanic print swim brief with wrap crossover waistband and cheeky hip coverage.',
      sizes: ['S', 'M', 'L', 'XL'],
      colors: [
        ProductColorOption(name: 'Tropical Red', colorValue: 0xFFD32F2F),
      ],
      isBestSeller: true,
      isFeatured: true,
    ),
    const ProductModel(
      id: 's2',
      name: 'Luna Bay High Waist Leaf Brief',
      categoryId: 'cat_swimwear',
      categoryName: 'Swimwear',
      subCategory: 'High Waist',
      price: 549,
      originalPrice: 849,
      discountPercent: 35,
      rating: 4.8,
      reviewCount: 7120,
      imageUrl: AppImages.swimwearBlackLeaf,
      images: [
        AppImages.swimwearBlackLeaf,
        AppImages.swimwearWhiteFloral,
        AppImages.swimwearFloralRed,
        AppImages.swimwearPinkTextured,
      ],
      description:
          'Sculpting high-waisted black swim bottom with terracotta palm leaf motifs and decorative front sash belt.',
      sizes: ['S', 'M', 'L', 'XL'],
      colors: [
        ProductColorOption(name: 'Midnight Leaf', colorValue: 0xFF212121),
      ],
      isBestSeller: false,
      isFeatured: true,
    ),
    const ProductModel(
      id: 's3',
      name: 'Savaneta Side Lace-Up Bikini Brief',
      categoryId: 'cat_swimwear',
      categoryName: 'Swimwear',
      subCategory: 'Lace-Up Briefs',
      price: 499,
      originalPrice: 749,
      discountPercent: 33,
      rating: 4.9,
      reviewCount: 9680,
      imageUrl: AppImages.swimwearWhiteFloral,
      images: [
        AppImages.swimwearWhiteFloral,
        AppImages.swimwearPinkTextured,
        AppImages.swimwearBlackLeaf,
        AppImages.swimwearFloralRed,
      ],
      description:
          'White floral meadow swim hipster featuring adjustable multi-crisscross side lace-up cords and tassel ties.',
      sizes: ['S', 'M', 'L', 'XL'],
      colors: [
        ProductColorOption(name: 'Floral White', colorValue: 0xFFFAFAFA),
      ],
      isBestSeller: true,
      isFeatured: false,
    ),
    const ProductModel(
      id: 's4',
      name: 'Bazaruto Hot Pink Textured Brief',
      categoryId: 'cat_swimwear',
      categoryName: 'Swimwear',
      subCategory: 'Textured',
      price: 429,
      originalPrice: 649,
      discountPercent: 33,
      rating: 4.6,
      reviewCount: 4320,
      imageUrl: AppImages.swimwearPinkTextured,
      images: [
        AppImages.swimwearPinkTextured,
        AppImages.swimwearFloralRed,
        AppImages.swimwearWhiteFloral,
        AppImages.swimwearBlackLeaf,
      ],
      description:
          'Neon hot pink jacquard waffle-textured swim brief offering flattering moderate coverage and full lining.',
      sizes: ['S', 'M', 'L', 'XL'],
      colors: [
        ProductColorOption(name: 'Hot Pink', colorValue: 0xFFE91E63),
      ],
      isBestSeller: false,
      isFeatured: true,
    ),

    // ----------------- LINGERIE SETS -----------------
    const ProductModel(
      id: 'l1',
      name: 'Crimson Sheer Ruffle Babydoll Set',
      categoryId: 'cat_lingerie_sets',
      categoryName: 'Lingerie Sets',
      subCategory: 'Babydoll Chemise',
      price: 799,
      originalPrice: 1199,
      discountPercent: 33,
      rating: 4.9,
      reviewCount: 12450,
      imageUrl: AppImages.nightwearRedBabydoll,
      images: [
        AppImages.nightwearRedBabydoll,
        AppImages.nightwearWineCorset,
      ],
      description:
          'Romantic tiered frill babydoll with plunging scalloped neckline and matching crimson G-string thong.',
      sizes: ['32', '34', '36', '38'],
      colors: [
        ProductColorOption(name: 'Crimson Red', colorValue: 0xFF8A0B3C),
      ],
      isBestSeller: true,
      isFeatured: true,
    ),
    const ProductModel(
      id: 'l2',
      name: 'Wine Sheer Lace Corset Chemise',
      categoryId: 'cat_lingerie_sets',
      categoryName: 'Lingerie Sets',
      subCategory: 'Babydoll Chemise',
      price: 849,
      originalPrice: 1249,
      discountPercent: 32,
      rating: 4.8,
      reviewCount: 8430,
      imageUrl: AppImages.nightwearWineCorset,
      images: [
        AppImages.nightwearWineCorset,
        AppImages.braRedSatinBow,
      ],
      description:
          'Delicate burgundy underwire corset slip with scalloped handkerchief mesh hem and adjustable satin straps.',
      sizes: ['32', '34', '36', '38'],
      colors: [
        ProductColorOption(name: 'Wine Burgundy', colorValue: 0xFF6D0833),
      ],
      isBestSeller: true,
      isFeatured: true,
    ),
  ];

  static final List<AddressModel> addresses = [
    const AddressModel(
      id: 'addr_1',
      tag: 'Home',
      recipientName: 'Awantika Yadav',
      phone: '+91 98765 43210',
      street: '123, Green Park',
      city: 'Lucknow',
      state: 'Uttar Pradesh',
      pincode: '226010',
      isDefault: true,
    ),
    const AddressModel(
      id: 'addr_2',
      tag: 'Work',
      recipientName: 'Awantika Yadav',
      phone: '+91 98765 43210',
      street: '404, Tech Park, Hazratganj',
      city: 'Lucknow',
      state: 'Uttar Pradesh',
      pincode: '226001',
      isDefault: false,
    ),
  ];

  Future<List<CategoryModel>> getCategories() async {
    return categories;
  }

  Future<List<ProductModel>> getProducts({String? categoryId}) async {
    if (categoryId != null && categoryId.isNotEmpty) {
      return products.where((p) => p.categoryId == categoryId).toList();
    }
    return products;
  }

  Future<List<ProductModel>> getBestSellers() async {
    return products.where((p) => p.isBestSeller).toList();
  }

  Future<List<ProductModel>> getFeaturedProducts() async {
    return products.where((p) => p.isFeatured).toList();
  }

  Future<List<ProductModel>> searchProducts(String query) async {
    final lower = query.toLowerCase().trim();
    if (lower.isEmpty) return products;
    return products.where((p) {
      return p.name.toLowerCase().contains(lower) ||
          p.categoryName.toLowerCase().contains(lower) ||
          p.subCategory.toLowerCase().contains(lower) ||
          p.description.toLowerCase().contains(lower);
    }).toList();
  }

  Future<ProductModel?> getProductById(String id) async {
    try {
      return products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<List<AddressModel>> getAddresses() async {
    return addresses;
  }
}
