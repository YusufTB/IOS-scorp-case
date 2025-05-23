📱 Projenin Genel Amacı

Bu iOS projesi, Scorp Case adıyla bir case study uygulaması olarak geliştirilmiş. Amaç, sahte bir API simülasyonu üzerinden kullanıcı (Person) listesini çekmek ve bu verileri bir UITableView'da göstermek. Kullanıcılar veriyi çekebilir, tabloyu yenileyebilir ve işlemler sırasında durumlara göre feedback (toast mesaj, loading animasyonu) alabilir.

🔧 Teknik Olarak Neler Yapıldı?

1. MVVM Mimarisi Kullanımı
Kodlar Model-View-ViewModel (MVVM) mimarisine uygun şekilde ayrılmış:

2. DataSource Simülasyonu
DataSource sınıfı, gerçek bir backend yerine kullanılmak üzere oluşturulmuş sahte bir veri sağlayıcısıdır. Bu sınıf:

Rastgele isimlerden kişi (Person) listesi üretir (PeopleGen)
Verileri parça parça döndürür (pagination benzeri next mantığı)
Ara sıra hata döndürür (error simulation)
Bekleme süreleri (delay) içerir (yüksek ve düşük gecikme simülasyonları)
Sahte "backend bug" davranışlarını da simüle eder (aynı kişiyi ekleme, boş sonuç döndürme vs.)
Bu sayede gerçek dünyadaki API davranışları test edilebiliyor.

3. MainViewModel
API çağrısını yönetir (getData(requestType:))
delegate aracılığıyla ViewController'a başarı veya hata bilgisi gönderir
isLoading ve inserted flag’leri ile yükleme durumu ve tekrar eden verileri kontrol eder


4. MainViewController
UITableView ile kullanıcı listesini gösterir
5 saniyelik zorunlu bekleme süresi olan bir pull-to-refresh mekanizması içerir
Veriler güncellendikçe kullanıcıya "toast" bildirimi veya loading spinner ile bilgi verir
Listenin sonuna gelindiğinde otomatik olarak daha fazla veri getirir (infinite scroll mantığı)

5. Helper Extension
UIViewController+Extension.swift dosyasında 2 yardımcı fonksiyon var:

showActivityIndicator() / hideActivityIndicator() → loading spinner gösterir/gizler
showToast(message:) → ekranın alt kısmında kısa mesaj gösterir
Bu fonksiyonlar tüm UIViewController alt sınıfları tarafından kolayca çağrılabilir.

6. RandomUtils & PeopleGen
RandomUtils: Rastgele sayı üretimi ve olasılık hesapları yapar (örneğin hata üretmek için %5 ihtimal gibi).
PeopleGen: Türk isim ve soyisimlerinden rastgele "Full Name" üretir.

7. Pagination Mantığı
Backend simülasyonu bir next parametresi ile çalışıyor. ViewModel bu next değerini kontrol ederek bir sonraki verileri çeker. Yeni kişiler tabloya eklenir, önceki kişiler tekrar eklenmez.

8. Hata ve Toast Mesajları
API hatalarında handleError(_:) çağrılır.
Kullanıcıya özel toast mesajları ile bilgi verilir:
“Loading in progress”
“You cannot refresh before 5 seconds have passed”


✅ Kullanılan Teknolojiler
Swift 5
UIKit
MVVM Mimari Deseni
Dummy API Simülasyonu (Mock)
UIRefreshControl (pull-to-refresh)
AutoLayout (manual constraints)
