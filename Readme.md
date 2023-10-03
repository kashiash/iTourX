# iTour



Najlepszym sposobem na rozpoczęcie każdego nowego projektu jest zdefiniowanie modelu danych, ponieważ po poprawnej jego implementacji reszta aplikacji zazwyczaj płynie łatwo. W SwiftData wszystkie nasze modele są tworzone za pomocą kodu – możemy pożegnać się z interfejsem użytkownika do edycji modeli Core Data w Xcode, ponieważ teraz wszystko jest opisane w czystym Swift.

W projekcie tym stworzymy prosty model, aby opisać jedno miejsce docelowe (Destination). Stwórz nowy plik Swift o nazwie Destination.swift i dodaj do niego ten kod:

```swift
class Destination {
    var name: String
    var details: String
    var date: Date
    var priority: Int

    init(name: String = "", details: String = "", date: Date = Date(), priority: Int = 2) {
        self.name = name
        self.details = details
        self.date = date
        self.priority = priority
    }
}
```

Tak, to jest klasa, tak samo jak mieliśmy to w przypadku Core Data. To celowe, ponieważ pomimo że jesteśmy wielkimi fanami struktur w Swift, nadal potrzebujemy sposobu na współdzielenie danych między różnymi częściami naszej aplikacji, a klasy służą do tego celu.

Ponieważ jest to klasa, musimy dostarczyć dla niej inicjalizatora. Jeśli zaczniesz wpisywać „init” w klasie, edytor powinien podpowiedzieć ci uzupełnienie pełnego inicjalizatora. Powinieneś otrzymać coś takiego:

```swift
init(name: String = "", details: String = "", date: Date = Date(), priority: Int = 2) {
    self.name = name
    self.details = details
    self.date = date
    self.priority = priority
}
```

Jestem zwolennikiem podawania wartości domyślnych wszędzie tam, gdzie ma to sens. Tworząc nowe, puste miejsce docelowe, wszystkie wartości powinny być puste, poza priorytetem, któremu domyślnie nadamy wartość 2 – nie niski, nie wysoki, po prostu po środku.

Teraz przyszła pora na wprowadzenie `SwiftData`. Wymaga to dokładnie trzech kroków:

1. Dodaj import `SwiftData` na początku zarówno pliku Destination.swift, jak i iTourApp.swift.
2. Dodaj makro @Model przed klasą Destination.
3. Dodaj ten modyfikator do Twojego WindowGroup w pliku iTourApp.swift: `.modelContainer(for: Destination.self)`.

To wszystko: te trzy zmiany, które są wszystkie trywialne, dają nam kompletny stos `SwiftData`.

Pierwszy krok polega tylko na dodaniu importu w dwóch plikach, dzięki czemu będziemy mieli dostęp do wszystkich funkcji `SwiftData`. Drugi krok jest bardzo interesujący.

Makro @Model informuje SwiftData, że chcemy mieć możliwość ładowania i zapisywania obiektów Destination za pomocą bazy danych SwiftData. To dodaje wiele funkcji za kulisami, dzięki którym SwiftData może wykrywać zmiany w poszczególnych właściwościach obiektu Destination i zapewnia, że są one automatycznie zapisywane. Dodatkowo robi inteligentne rzeczy, takie jak leniwe ładowanie danych, aby oszczędzić pamięć.

Co do modyfikatora modelContainer(), informuje on `SwiftData`, że chcemy:

1. Utworzyć magazyn dla naszego obiektu Destination lub go załadować, jeśli został utworzony wcześniej.
2. Używać tego magazynu do przechowywania wszystkich naszych danych wewnątrz grupy okna, czyli naszej całej aplikacji.

Jeśli kiedykolwiek korzystałeś z Core Data, ten kontener modelu jest równoważny NSPersistentContainer, ale także działa jako NSPersistentCloudKitContainer, jeśli masz iCloud włączony dla swojej aplikacji.

Możesz teraz uruchomić aplikację, ale nie zobaczysz jeszcze wiele, ponieważ nie napisaliśmy jeszcze żadnego kodu interfejsu użytkownika. Zróbmy to teraz...