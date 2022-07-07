import 'package:hive_flutter/hive_flutter.dart';
import 'package:lichi_test/domain/model/user.dart';

import '../../data/news/news_bloc.dart';
import '../model/news.dart';

class NewsRepository {
  static const String boxName = "newsBox";
  final Box<NewsModel> newsBox;
  static NewsRepository? _newsRepository;

  NewsRepository._(this.newsBox);

  static Future<NewsRepository> getNewsRepository() async {
    if (_newsRepository != null) {
      return _newsRepository!;
    }

    Box<NewsModel> newsBox;
    if (Hive.isBoxOpen(boxName)) {
      newsBox = Hive.box(boxName);
    } else {
      newsBox = await Hive.openBox(boxName);
      if (newsBox.isEmpty) {
        newsBox.addAll([
          NewsModel(
              image:
                  "https://ds-assets.cdn.devapps.ru/Cyt96UOW7mrcIyhryxbaLCggdyKe.png",
              title: "Анонсирован первый в мире ноутбук с процессором RISC-V",
              body: """
Компания DeepComputing объявила о готовящемся релизе лэптопа ROMA с необычным аппаратным обеспечением. Он построен на базе процессора с архитектурой RISC-V и ориентирован в первую очередь на разработчиков ПО. В своей рекламной кампании производитель делает особую ставку на NFT-технологии и платформу Web3.
DeepComputing
Согласно пресс-релизу компании, новинка будет построена на базе четырёхъядерного CPU (модель не указывается), оснащена 16 ГБ оперативной памяти LPDDR4X и твердотельным накопителем на 256 ГБ. Вендор заявляет о совместимости ноутбука с большинством операционных систем Linux, а также о наличии графического процессора и отдельного ИИ-блока для ускорения задач в области разработки софта.
«Собственная компиляция RISC-V — это важная веха. Платформа ROMA будет полезна разработчикам, которые хотят протестировать своё программное обеспечение, изначально работающее на RISC-V. И должно быть легко перенести код, разработанный на этой платформе, во встроенные системы», — заявил Марк Химельштейн, главный технический директор RISC-V International.
Разработчики ноутбука отмечают, что новинка будет поставляться с предустановленным криптовалютным кошельком, а первые покупатели получат в подарок уникальный NFT и гравировку со своим именем или названием организации на корпусе устройства. Более подробно ознакомиться с новинкой можно на сайте производителя. Цена и дата начала продаж ноутбука будут объявлены позднее.
""",
              comments: [],
              favorite: [],
              date: DateTime.now()),
          NewsModel(
              image:
                  "https://ds-assets.cdn.devapps.ru/Cyt94QInioGz2DCJvYehz2FrboRQBu.jpg",
              title:
                  "AYN LOKI Zero — «Switch на минималках» с процессором Athlon",
              body: """
Серия портативных игровых консолей бренда AYN пополнилась ещё одной новинкой. От представленных ранее устройств модель LOKI Zero отличается более доступной ценой: она рассчитана на потоковый гейминг и запуск ретро-игр, благодаря чему обходится скромными техническими характеристиками.
AYN LOKI Zero
«Сердцем» бюджетной приставки стал двухъядерный AMD Athlon Silver 3050e с четырьмя потоками исполнения и встроенной графикой Radeon RX Vega 3. Объём оперативной памяти устройства (DDR4-2400) составляет 4 или 8 ГБ, а встроенного eMMC-накопителя — 64 ГБ, при этом имеется возможность установки дополнительного SSD в слот М.2 2230. За автономность консоли отвечает аккумулятор ёмкостью 40,5 Втч.
AYN LOKI Zero оснащается 6-дюймовым IPS-дисплеем с разрешением 1280x720 пикселей. Дополняют список характеристик модули Wi-Fi 5 и Bluetooth 4.2, слот для карт microSD, 3,5-мм аудиоразъём, а также порт USB 3.2 Type-C, гироскоп и датчик Холла. Розничная цена новинки составит 249, но по условиям предзаказа консоль временно доступна за 199 на сайте производителя. Старт продаж запланирован на 4 квартал 2022 года.
""",
              comments: [],
              favorite: [],
              date: DateTime.now())
        ]);
      }
    }

    return NewsRepository._(newsBox);
  }

  Future<Iterable> getIDs({Sort? sort}) async {
    if (sort == null) {
      return Future(() => newsBox.keys.toList().reversed);
    }

    List<NewsModel> news = newsBox.values.toList();
    if (sort == Sort.favorite) {
      news.sort(
          (a, b) {
            return b.favorite.length - a.favorite.length;
          },
        );
      return news.map((e) => e.key);
    }

    if (sort == Sort.date) {
      news.sort(
          (a, b) {
            if (a.date.isBefore(a.date)) {
              return -1;
            }
            return 1;
          },
        );
      return news.map((e) => e.key);
    }
    return Future(() => newsBox.keys);
  }

  Future<Iterable> getIDsFavoriteUser(UserModel user) async {
    List<NewsModel> news = newsBox.values.toList();

    return Future(() => news
        .where((element) => element.favorite.contains(user.key))
        .map((e) => e.key));
  }

  Future<NewsModel> getNews(dynamic id) async {
    return Future.delayed(const Duration(seconds: 1), () => newsBox.get(id)!);
  }
}
