import 'package:flutter/material.dart';
import 'package:pro1/models/self_product.dart';

class MenuItem {
  String title;
  IconData icon;
  MenuItem(this.icon, this.title);
}

List background = [Colors.black87, Colors.deepPurple, Colors.black];
List background2 = [Colors.white10, Colors.grey[800], Colors.grey[900]];
List circle1 = [Colors.blueAccent, Colors.red, Colors.purple];
List<String> cool = const [
  "Transactions",
  "Add Product",
  "Update Product",
  "Sales Report",
  "Coming Soon"
];
List<Icon> icons = const [
  Icon(Icons.monetization_on),
  Icon(Icons.add_circle),
  Icon(Icons.update),
  Icon(Icons.report),
  Icon(Icons.slow_motion_video)
];

class Product {
  int counter;
  SelfProduct selfProduct;
  Product({int counter, SelfProduct selfProduct}) {
    this.counter = counter;
    this.selfProduct = selfProduct;
  }
}

final List<MenuItem> menuItemList = [
  MenuItem(Icons.home, 'Home'),
  MenuItem(Icons.shop, 'Scanner'),
  MenuItem(Icons.search, 'Search'),
  MenuItem(Icons.settings, 'Settings'),
];

class Notification {
  String message;
  int price;
  String messageType;
  Notification(String message, String messageType, int price) {
    this.message = message;
    this.price = price;
    this.messageType = messageType;
  }
}

List<Notification> notification = [
  new Notification(
      "Lorem ipsum dolor sit amet consectetur adipiscing, elit nibh imperdiet pretium volutpat leo auctor, curae quis justo taciti turpis. Enim suspendisse nulla aenean placerat primis vulputate blandit malesuada est penatibus ad, tempus nibh a ligula diam felis mollis feugiat egestas torquent. Augue convallis nulla posuere diam dictumst pharetra facilisi justo, litora erat et rhoncus est quisque nostra ad, quam faucibus etiam libero id odio non.",
      "confirmation",
      7),
  new Notification(
      "Lorem ipsum dolor sit amet consectetur adipiscing elit non dictumst morbi, suscipit facilisis magna nibh eros velit euismod leo.",
      "none",
      8),
  new Notification(
      "Lorem ipsum dolor sit amet consectetur adipiscing elit euismod porttitor, nam etiam taciti class fames tortor vel ultrices, diam ornare sed nisi mi facilisis curae molestie. Dui potenti at suspendisse volutpat, venenatis odio dictumst.",
      "aggrement",
      9)
];

List<String> shopTypeList = [
  'Select shop type',
  'Grocesory-store',
  'Pharmacy-store'
];

List<String> citiesList = [
  'Select your city',
  'Abbottabad',
  'Abdul Hakim',
  'Aliabad',
  'Alpurai',
  'Athmuqam',
  'Attock City',
  'Awaran',
  'Badin',
  'Bagh',
  'Bahawalnagar',
  'Bahawalpur',
  'Bannu',
  'Barkhan',
  'Batgram',
  'Bhakkar',
  'Chakwal',
  'Chaman',
  'Charsadda',
  'Chilas',
  'Chiniot',
  'Chitral',
  'Dadu',
  'Daggar',
  'Dainyor',
  'Dalbandin',
  'Dasu',
  'Dera Allahyar',
  'Dera Bugti',
  'Dera Ghazi Khan',
  'Dera Ismail Khan',
  'Dera Murad Jamali',
  'Eidgah',
  'Faisalabad',
  'Gakuch',
  'Gandava',
  'Ghotki',
  'Gilgit',
  'Gojra',
  'Gujranwala',
  'Gujrat',
  'Gwadar',
  'Hafizabad',
  'Hangu',
  'Haripur',
  'Harunabad',
  'Hasilpur',
  'Hassan Abdal',
  'Hujra Shah Muqim',
  'Hyderabad City',
  'Islamabad',
  'Jacobabad',
  'Jalalpur Jattan',
  'Jamshoro',
  'Jaranwala',
  'Jhang City',
  'Jhelum',
  'Kabirwala',
  'Kalat',
  'Kamalia',
  'Kandhkot',
  'Karachi',
  'Karak',
  'Kasur',
  'Khairpur Mir’s',
  'Khanewal',
  'Khanpur',
  'Kharan',
  'Kharian',
  'Khushab',
  'Khuzdar',
  'Khuzdar',
  'Kohat',
  'Kohlu',
  'Kot Addu',
  'Kotli',
  'Kulachi',
  'Kundian',
  'Lahore',
  'Lakki',
  'Lala Musa',
  'Larkana',
  'Leiah',
  'Lodhran',
  'Loralai',
  'Malakand',
  'Mandi Bahauddin',
  'Mandi Burewala',
  'Mansehra',
  'Mardan',
  'Mastung',
  'Matiari',
  'Mian Channun',
  'Mianwali',
  'Mingaora',
  'Mirpur Khas',
  'Multan',
  'Muridke',
  'Musa Khel Bazar',
  'Muzaffarabad',
  'Muzaffargarh',
  'Nankana Sahib',
  'Narowal',
  'Naushahro Firoz',
  'Nawabshah',
  'New Mirpur',
  'Nowshera',
  'Okara',
  'Pakpattan',
  'Panjgur',
  'Parachinar',
  'Pattoki',
  'Peshawar',
  'Pishin',
  'Qila Saifullah',
  'Quetta',
  'Rahimyar Khan',
  'Rajanpur',
  'Rawala Kot',
  'Rawalpindi',
  'Risalpur Cantonment',
  'Saddiqabad',
  'Sahiwal',
  'Saidu Sharif',
  'Sanghar',
  'Sargodha',
  'Shahdad Kot',
  'Shakargarh',
  'Shekhupura',
  'Shikarpur',
  'Sialkot City',
  'Sibi',
  'Sukkur',
  'Swabi',
  'Tando Allahyar',
  'Tando Muhammad Khan',
  'Tank',
  'Thatta',
  'Timargara',
  'Toba Tek Singh',
  'Turbat',
  'Umarkot',
  'Upper Dir',
  'Uthal',
  'Vihari',
  'Zhob',
  'Ziarat'
];
