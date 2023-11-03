# iTour



Przygotowane na podstawie : https://www.hackingwithswift.com/quick-start/swiftdata/swiftdata-tutorial-building-a-complete-project



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

## Pobieranie danych



Kiedy już zaprojektujesz modele SwiftData i wstrzykniesz je do swojej aplikacji SwiftUI, używając modyfikatora `modelContainer()`, kolejnym krokiem jest stworzenie kodu SwiftUI do odczytywania obiektów modelu i ich odpowiedniego wyświetlenia.

Zacznij od otwarcia pliku ContentView.swift i dodania linii `import SwiftData` na początku, aby zaimportować cały kod SwiftData, którego potrzebujemy.

Następnie dodaj tę nową właściwość do struktury ContentView:

```swift
@Query var destinations: [Destination]
```

To używa makra `@Query`, aby odczytać wszystkie obiekty Destination zarządzane przez SwiftData. Na razie nie mamy jeszcze żadnych miejsc docelowych, więc ta tablica będzie pusta, ale to naprawimy później.

`@Query` jest naprawdę inteligentne: załaduje wszystkie miejsca docelowe od razu, gdy widok się pojawi, ale także monitoruje bazę danych pod kątem zmian. W ten sposób, kiedykolwiek zostanie dodany, usunięty lub zmieniony obiekt Destination, właściwość `destinations` również zostanie zaktualizowana.

Wskazówka: Jeśli wcześniej korzystałeś z Core Data, to jest odpowiednik opakowania `@FetchRequest`.

Ponieważ wszystkie obiekty modelu SwiftData automatycznie dostosowują się do protokołu `Identifiable`, możemy od razu napisać pewien kod SwiftUI, aby pokazać wszystkie nasze miejsca docelowe na liście:

```swift
NavigationStack {
    List {
        ForEach(destinations) { destination in
            VStack(alignment: .leading) {
                Text(destination.name)
                    .font(.headline)

                Text(destination.date.formatted(date: .long, time: .shortened))
            }
        }
    }
    .navigationTitle("iTour")
}
```

Wskazówka: Moglibyśmy użyć `List(destinations)` zamiast Listy plus ForEach, ale potrzebujemy ForEach, aby dodać obsługę przeciągania do usunięcia później.

Jak wcześniej wspomniałem, ta lista będzie pusta, ponieważ nie stworzyliśmy jeszcze żadnych miejsc docelowych. Oczywiście chcemy, aby użytkownik mógł dodać własne miejsca docelowe, gdy aplikacja będzie gotowa, ale na razie możemy zrobić sobie małe skróty i dodać kilka danych próbkowych.

Umieść to poniżej modyfikatora `navigationTitle()`:

```swift
.toolbar {
    Button("Add Samples", action: addSamples)
}
```

Teraz dodaj tę metodę, którą uruchomi:

```swift
func addSamples() {
    let rome = Destination(name: "Rome")
    let florence = Destination(name: "Florence")
    let naples = Destination(name: "Naples")

    modelContext.insert(rome)
    modelContext.insert(florence)
    modelContext.insert(naples)
}
```

To tworzy instancje naszego modelu Destination, ale Swift ostrzeże nas, że nie są one używane – tworzymy je, ale nie mówimy SwiftData, aby je przechowywał.

Aby to zrobić, musimy zrozumieć ważne pojęcie SwiftData, które nazywa się kontekstem modelu (model context). Kontekst modelu ma za zadanie śledzenie wszystkich obiektów, które są obecnie używane przez naszą aplikację. Nie są to wszystkie obiekty, ponieważ byłoby to niesamowicie nieefektywne ładować wszystko od razu. Zamiast tego, to tylko obiekty, które aktualnie aktywnie używamy.

Kiedy wcześniej używaliśmy modyfikatora `modelContainer()`, został on również utworzony dla nas kontekst modelu i umieszczony w środowisku SwiftUI do użytku. Ten automatyczny kontekst modelu zawsze działa na głównym aktorze Swifta, więc jest bezpieczny do użycia z naszym interfejsem użytkownika.

Musimy uzyskać dostęp do tego kontekstu modelu, aby dodać nasze obiekty do przechowywania SwiftData, i możemy użyć właściwości `@Environment` do uzyskania tego dostępu. Dodaj tę właściwość do ContentView:

```swift
@Environment(\.modelContext) var modelContext
```

Teraz możemy wstawić nasze nowe obiekty Destination do kontekstu modelu, dodając te trzy linie na końcu `addSamples()`:

```swift
modelContext.insert(rome)
modelContext.insert(florence)
modelContext.insert(naples)
```

Uruchom aplikację ponownie, a następnie naciśnij "Add Samples". Powinieneś zobaczyć nowe miejsca docelowe na naszej liście – działa! Co więcej, jeśli wrócisz do Xcode i ponownie naciśniesz Cmd+R, aby ponownie uruchomić aplikację, z

obaczysz, że one tam nadal są, ponieważ SwiftData automatycznie je dla nas zachował.

To zachowanie automatycznego zapisywania jest domyślnie włączone: zaraz po zakończeniu działania naszego kodu przycisku, SwiftData zapisuje wszystkie nasze zmiany w swoim stałym przechowywaniu, dzięki czemu nasze dane zawsze są bezpieczne.

## Dodawanie, modyfikowanie i usuwanie rekordów

Po zdefiniowaniu modelu danych w SwiftData i używaniu `@Query` do jego odczytu, a następnie umieszczeniu wynikowej tablicy w jakimś układzie SwiftUI, następnym krokiem jest dodanie interfejsu użytkownika, który pozwoli użytkownikowi tworzyć, edytować i usuwać obiekty SwiftData, zamiast polegać na danych próbkowych.

Najprostszym z tych zadań jest usuwanie, więc zaczniemy od tego. Możesz usunąć dowolny obiekt z SwiftData, przekazując go do metody `delete()` swojego kontekstu modelu.

W naszym kodzie używaliśmy ForEach do iteracji przez wszystkie miejsca docelowe zwrócone przez nasze zapytanie SwiftData, więc możemy teraz napisać ten sam rodzaj metody usuwania, jaki użylibyśmy dla dowolnej tablicy danych z SwiftUI.

Dodaj tę metodę do ContentView:

```swift
func deleteDestinations(_ indexSet: IndexSet) {
    for index in indexSet {
        let destination = destinations[index]
        modelContext.delete(destination)
    }
}
```

Teraz dodaj ten modyfikator do ForEach:

```swift
.onDelete(perform: deleteDestinations)
```

Następnym najłatwiejszym zadaniem jest edytowanie danych, co oznacza stworzenie nowego widoku SwiftUI z różnymi opcjami:

- Pola tekstowe do edycji tekstu dla właściwości name i details miejsca docelowego.
- Data picker do dostosowania daty i godziny wizyty.
- Picker do dostosowania priorytetu.

Jeśli umieścimy wszystko to w widoku Form, otrzymamy świetny układ domyślnie.

Naciśnij teraz Cmd+N, aby stworzyć nowy widok SwiftUI, i nazwij go EditDestinationView.

Ten widok musi wiedzieć, które miejsce docelowe zostało wybrane. Jeśli chcielibyśmy tylko odczytać właściwości z naszego miejsca docelowego, moglibyśmy dodać właściwość EditDestinationView w ten sposób:

```swift
var destination: Destination
```

Ale tutaj odczytywanie właściwości z miejsca docelowego to za mało – musimy być w stanie powiązać je z widokami SwiftUI, takimi jak TextField i Picker, aby użytkownik mógł je naprawdę edytować.

Zamiast tego musimy użyć właściwości o nazwie `@Bindable`, która może tworzyć powiązania z dowolnym obiektem SwiftData. To zostało zbudowane dla obserwacji Swift, która została wprowadzona w iOS 17, ale ponieważ SwiftData opiera się na obserwacji, działa równie dobrze tutaj.

Więc dodaj właściwość w ten sposób:

```swift
@Bindable var destination: Destination
```

Teraz, po dodaniu właściwości do EditDestinationView, nasza struktura podglądu nie będzie już działać. Co gorsza, nie możemy po prostu stworzyć tymczasowego obiektu Destination w podglądzie, ponieważ SwiftData nie będzie wiedzieć, gdzie go utworzyć – nie ma aktywnego kontenera modelu ani kontekstu wokół.

Aby to naprawić, musimy ręcznie utworzyć kontener modelu, a zrobimy to w bardzo szczególny sposób: ponieważ to jest kod podglądu z danymi przykładowymi, stworzymy kontener w pamięci, aby wszelkie obiekty podglądowe, które tworzymy, nie były zapisywane, a zamiast tego były tylko tymczasowe.

To wymaga czterech kroków:

1. Utworzenie niestandardowego obiektu ModelConfiguration, aby określić, że chcemy przechowywania w pamięci.
2. Użycie go do utworzenia kontenera modelu.
3. Utworzenie przykładowego obiektu Destination zawierającego dane próbkowe. Ten obiekt zostanie automatycznie utworzony wewnątrz kontenera modelu, który właśnie stworzyliśmy.
4. Przesłanie tego przykładowego obiektu i naszego kontenera modelu do EditDestinationView, a następnie zwrócenie go wszystkiego.

Do tej pory nie musieliśmy wykonywać kroków 1 i 2, ponieważ wszystko było już obsługiwane przez modyfikator `modelContainer()` w iTourApp.swift, ale teraz musimy to zrobić ręcznie, abyśmy mogli utworzyć obiekt Destination do przekazania do widoku.

Zmodyfikuj swój kod podglądu w ten sposób:

```swift
#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Destination.self, configurations: config)

        let example = Destination(name: "Przykładowe miejsce docelowe", details: "Przykładowe szczegóły znajdują się tutaj i będą automatycznie rozszerzać się wertykalnie podczas ich edycji.")
        return EditDestinationView(destination: example)
            .modelContainer(container)
    } catch {
        fatalError("Nie udało się utworzyć kontenera modelu.")
    }
}
```

Ważne: Jeśli próbujesz utworzyć instancję modelu SwiftData i nie ma już dostępnego kontenera modelu, twój podgląd po prostu ulegnie awarii. Bądź ostrożny!

To znaczy, że twój projekt kompiluje się teraz poprawnie, więc możemy teraz wypełnić ciało widoku `EditDestinationView`. Jest to zwykły kod SwiftUI - nie ma pojęcia, że czyta i zapisuje informacje wspierane przez SwiftData.

Zastąp domyślną właściwość `body` tym kodem:

```swift
Form {
    TextField("Name", text: $destination.name)
    TextField("Details", text: $destination.details, axis: .vertical)
    DatePicker("Date", selection: $destination.date)

    Section("Priority") {
        Picker("Priority", selection: $destination.priority) {
            Text("Meh").tag(1)
            Text("Maybe").tag(2)
            Text("Must").tag(3)
        }
        .pickerStyle(.segmented)
    }
}
.navigationTitle("Edit Destination")
.navigationBarTitleDisplayMode(.inline)
```

I teraz powinniśmy móc wrócić do ContentView i umożliwić nawigację dla naszych próbkowych danych. Oznacza to umieszczenie NavigationLink wokół zawartości naszego ForEach, jak poniżej:

```swift
ForEach(destinations) { destination in
    NavigationLink(value: destination)  {
        VStack(alignment: .leading) {
            Text(destination.name)
                .font(.headline)

            Text(destination.date.formatted(date: .long, time: .shortened))
        }
    }
}
```

A następnie dodaj modyfikator `navigationDestination()` poniżej `navigationTitle()`, więc SwiftUI wie, że ma przejść do naszego nowego widoku edycji, gdy zostanie wybrane miejsce docelowe:

```swift
.navigationDestination(for: Destination.self, destination: EditDestinationView.init)
```

To wszystko powinno działać poprawnie: teraz możemy dodawać i usuwać próbne dane, a także wybierać jedno z nich, aby zobaczyć widok szczegółowy.

To wszystko! Możesz teraz spróbować używać aplikacji, a zauważysz, że wszelkie zmiany, które wykonasz, są automatycznie stosowane do naszych danych i zapisywane - nie musimy robić niczego poza zmianą wartości, a SwiftData zajmuje się resztą.

Teraz, gdy edycja działa, dodawanie nowych miejsc docelowych jest łatwe: możemy po prostu wstawić nowe miejsce docelowe do naszego kontekstu modelu, a następnie od razu przynieść je do edycji.

Oznacza to wprowadzenie kilku małych zmian, zaczynając od przechowywania ścieżki naszego NavigationStack. Przechowywanie tego w stanie pozwala nam dynamicznie dostosować to, co jest wyświetlane w naszym stosie - możemy natychmiastowo wyświetlić ekran edycji programowo, zaraz po dodaniu nowego miejsca docelowego.

Zacznij od tej właściwości w ContentView:

```swift
@State private var path = [Destination]()
```

Po drugie, musimy przypisać to do naszego NavigationStack, tak jak poniżej:

```swift
NavigationStack(path: $path) {
```

Po trzecie, potrzebujemy metody w ContentView, która tworzy nowe miejsce docelowe, dodaje je do naszego kontekstu modelu, a następnie umieszcza je w naszej nowej właściwości `navPath`, aby od razu uruchomić edycję:

```swift
func addDestination() {
    let destination = Destination()
    modelContext.insert(destination)
    path = [destination]
}
```

I na koniec potrzebujemy kolejnego przycisku w naszym pasku narzędziowym, takiego jak poniżej:

```swift
Button("Add Destination", systemImage: "plus", action: addDestination)
```

Gotowe! Wypróbuj to - dodaj kilka innych miejsc docelowych według własnego wyboru, a powinieneś zauważyć, że automatycznie pojawiają się one w naszej głównej liście.

Wskazówka: Teraz możesz usunąć przycisk i metodę do dodawania danych próbkowych, ponieważ już ich nie potrzebujemy.



## Sortowanie

Najprostszym sposobem sortowania zapytań SwiftData jest przekazanie dodatkowych opcji do makra @Query.

Na przykład, możemy chcieć przechowywać miejsca docelowe alfabetycznie według ich nazwy, więc używamy:

```swift
@Query(sort: \Destination.name)
```

Lub możemy sortować według priorytetu w kolejności malejącej w ten sposób:

```swift
@Query(sort: \Destination.priority, order: .reverse) var destinations: [Destination]
```

To obsługuje tylko jedną właściwość, ale jeśli potrzebujesz więcej niż jednej - jeśli chcesz sortować według priorytetu malejąco, a następnie według nazwy rosnąco, na przykład, musisz użyć tablicy SortDescriptor:

```swift
@Query(sort: [SortDescriptor(\Destination.priority, order: .reverse), SortDescriptor(\Destination.name)]) var destinations: [Destination]
```

W tej tablicy możesz mieć tyle sort descriptors, ile chcesz, a SwiftData będzie je przetwarzać jeden po drugim.

To podejście działa świetnie, gdy znasz swoją kolejność sortowania podczas kompilacji, ale bardzo często chcesz, aby użytkownik mógł sortować swoje dane według własnych preferencji.

To wymaga znacznie więcej pracy, ponieważ właściwości utworzone za pomocą @Query nie mają żadnej prostej właściwości `sortOrder`, której możemy użyć. Zamiast tego musisz przenieść swoją własność @Query o jeden poziom w hierarchii SwiftUI - musisz umieścić ją w podwidoku, gdzie można wstrzyknąć sortowanie za pomocą inicjalizatora widoku.

Pierwszym krokiem jest utworzenie nowego widoku SwiftUI o nazwie DestinationListingView i dodanie mu linii importu SwiftData na początku.

Następnie musimy przenieść pewien kod z ContentView do DestinationListingView:

- Właściwość `destinations`.
- Całą listę, ale nie jej modyfikatory.
- Metodę `deleteDestinations()`.
Powinieneś także skopiować właściwość środowiska dla modelContext do DestinationListingView - powinna być skopiowana, a nie przeniesiona, ponieważ potrzebujemy jej w obu miejscach.

W końcu umieść DestinationListingView tam, gdzie była Lista w ContentView, tak jak poniżej:

```swift
NavigationStack(path: $path) {
    DestinationListingView()
        .navigationDestination(for: Destination.self, destination: EditDestinationView.init)
        .navigationTitle("iTour")
        .toolbar {
            Button("Add Destination", systemImage: "plus", action: addDestination)
        }
}
```

Wszystko, co zrobiliśmy, to trochę przesunąć kod, co oznacza, że aplikacja będzie wyglądać identycznie podczas uruchamiania. Jednakże, ponieważ DestinationListingView jest podwidokiem ContentView, teraz możemy przesyłać wartości do niego, aby kontrolować zapytanie SwiftData.

To wymaga pięciu kroków:

1. Utworzenie jakiegoś miejsca do przechowywania bieżącego sortowania użytkownika.
2. Utworzenie interfejsu użytkownika do dostosowywania tego sortowania na podstawie ustawień użytkownika.
3. Poinformowanie DestinationListingView, że musi być utworzone z pewnego rodzaju sortowania.
4. Zaktualizowanie podglądu, aby przekazać przykładowe sortowanie.
5. Przekazanie sortowania do DestinationListingView podczas tworzenia.

Przejdziemy przez te kroki krok po kroku.

Po pierwsze, dodaj tę właściwość do ContentView, która będzie zawierać bieżący porządek sortowania z sensowną wartością domyślną:

```swift
@State private var sortOrder = SortDescriptor(\Destination.name)
```

Po drugie, utworzymy przycisk menu w naszym pasku narzędziowym, który pozwoli użytkownikowi przełączać się między różnymi porządkami sortowania. Dodaj to do paska narzędzi w ContentView:

```swift
Menu("Sort", systemImage: "arrow.up.arrow.down") {
    Picker("Sort", selection: $sortOrder) {
        Text("Name")
            .tag(SortDescriptor(\Destination.name))

        Text("Priority")
            .tag(SortDescriptor(\Destination.priority, order: .reverse))

        Text("Date")
            .tag(SortDescriptor(\Destination.date))
    }
    .pickerStyle(.inline)
}
```

Po trzecie, musimy dodać inicjalizator do DestinationListingView, aby akceptować sortowanie miejsca docelowego, które zostanie użyte w jego zapytaniu. Ponieważ próbujemy zmienić samo zapytanie, a nie tablicę danych, które zostały zwrócone, musimy użyć nazwy właściwości z podkreśleniem, tak jak poniżej:

```swift
init(sort: SortDescriptor<Destination>) {
    _destinations = Query(sort: [sort])
}
```

Po czwarte, musimy zaktualizować kod podglądu, aby przekazać przykładową opcję sortowania:

```swift
#Preview {
    DestinationListingView(sort: SortDescriptor(\Destination.name))
}
```

I wreszcie, musimy dostosować ContentView, aby przekazywał wartość sortowania do DestinationListing

View, tak jak poniżej:

```swift
DestinationListingView(sort: sortOrder)
```

Cała ta praca przeniosła kolejność sortowania o jeden poziom wyżej z DestinationListingView, co oznacza, że możemy teraz kontrolować ją dynamicznie.

## Filtrowanie wyników

Filtrowanie w SwiftData odbywa się za pomocą predykatów: testu, który może być zastosowany, aby zdecydować, czy obiekty powinny pojawić się w rezultującej tablicy, czy nie. Robi się to za pomocą specjalnego makra #Predicate, które przyjmuje kod Swift, który piszemy, i przekształca go na filtry, które podstawowa baza danych może zrozumieć.

Porada: Jeśli wcześniej korzystałeś z Core Data, #Predicate jest podobne do NSPredicate. Główna różnica polega na tym, że #Predicate jest sprawdzane pod kątem typów podczas kompilacji, ale nie ma odpowiednika NSCompoundPredicate w tym przypadku.

Spróbujmy kilku przykładowych predykatów. Na przykład, możemy powiedzieć, że nasza aplikacja nie powinna pokazywać żadnych miejsc docelowych o niskim priorytecie:

```swift
init(sort: SortDescriptor<Destination>) {
    _destinations = Query(filter: #Predicate {
        $0.priority >= 2
    }, sort: [sort])
}
```

Jak widzisz, przekazujemy #Predicate zamknięcie, które bierze jeden obiekt z zapytania i stosuje do niego test. W tym przypadku obiekt ma priorytet co najmniej 2?

Możemy także napisać predykat, który pokazuje tylko miejsca docelowe, które są nadchodzące w naszej podróży, ignorując te, które są starsze niż aktualna data. Nie możemy odczytać Date.now wewnątrz makra #Predicate, ale jeśli najpierw utworzymy lokalną kopię, to będzie działać dobrze. Nasz predykat wyglądałby więc tak:

```swift
init(sort: SortDescriptor<Destination>) {
    let now = Date.now

    _destinations = Query(filter: #Predicate {
        $0.date > now
    }, sort: [sort])
}
```

To są oba interesujące przypadki, ale w tym projekcie będziemy używać predykatu, który pozwala użytkownikowi wyszukiwać konkretne miejsca docelowe, używając modyfikatora searchable() SwiftUI.

Ponieważ to się zmieni podczas pracy aplikacji, określenie dynamicznego filtra jest takie samo jak dynamiczne określenie kolejności sortowania: musimy utworzyć stan w ContentView, a następnie przekazać go do inicjalizatora EditDestinationView.

To wymaga czterech kroków, zaczynając od dodania nowego stanu w ContentView, aby przechowywać aktualny tekst wyszukiwania użytkownika:

```swift
@State private var searchText = ""
```

Następnie musimy powiązać to z modyfikatorem searchable(), więc dodaj to obok navigationTitle() w ContentView:

```swift
.searchable(text: $searchText)
```

Po trzecie, musimy zaktualizować inicjalizator DestinationListingView, aby akceptować ciąg wyszukiwania i używać go jako predykat zapytania:

```swift
init(sort: SortDescriptor<Destination>, searchString: String) {
    _destinations = Query(filter: #Predicate {
        if searchString.isEmpty {
            return true
        } else {
            return $0.name.localizedStandardContains(searchString)
        }
    }, sort: [sort])
}
```

Uwaga: localizedStandardContains() jest prawie zawsze najlepszym sposobem na przeprowadzanie wyszukiwań ciągów znaków widocznych dla użytkownika. Jeśli używasz metody contains() zwykłej, otrzymasz wyszukiwanie z uwzględnieniem wielkości liter.

Upewnij się, że przesyłasz przykładowe wyszukiwanie do swojego podglądu, nawet jeśli to tylko pusty ciąg znaków:

```swift
DestinationListingView(sort: SortDescriptor(\Destination.name), searchString: "")
```

I wreszcie, musimy edytować sposób tworzenia DestinationListingView w ContentView, aby przekazać zarówno aktualny porządek sortowania, jak i ciąg wyszukiwania:

```swift
DestinationListingView(sort: sortOrder, searchString: searchText)
```

Teraz mamy dynamiczne filtrowanie!





## Relacje



Do tej pory mieliśmy prosty model danych zawierający kolekcję miejsc docelowych. Aby ukończyć aplikację, zaktualizujemy go, tak aby każde miejsce docelowe miało listę miejsc, które użytkownicy chcą tam odwiedzić, na przykład, gdy odwiedzają Rzym, chcą zobaczyć Koloseum, Forum Rzymskie, Watykan, itp.

W `SwiftData` nazywa się to relacją: każde miejsce docelowe ma wiele miejsc do odwiedzenia. Zamiast próbować wcisnąć wszystkie miejsca do jednego obiektu miejsca docelowego, możemy stworzyć osobny model Sight, a następnie powiedzieć `SwiftData`, że nasz pierwotny model `Destination` ma tablicę miejsc - `SwiftData` zajmie się połączeniem ich dla nas.

Aby zacząć, utwórz nowy plik Swift o nazwie Sight.swift, dodaj import dla `SwiftData`, a następnie dodaj do niego ten kod:

```swift
@Model
class Sight {
    var name: String

    init(name: String) {
        self.name = name
    }
}
```

Przechowuje tylko pojedynczy kawałek danych, którym jest nazwa miejsca - później możesz dodać do niego więcej, na przykład śledząc, czy użytkownik już je odwiedził.

Teraz możemy wrócić do modelu `Destination` i dodać tam nową właściwość:

```swift
var sights = [Sight]()
```

Dodanie tej właściwości wystarczy, aby powiedzieć SwiftData, że każde miejsce docelowe ma wiele miejsc z nim powiązanych. Nasz pierwotny model nie miał tej relacji, ale to nic złego: przy następnym uruchomieniu aplikacji SwiftData automatycznie zaktualizuje swoją bazę danych, aby uwzględnić tę zmianę, nie wymagając dodatkowej pracy z naszej strony. Nazywa się to migracją i pozwala na stopniową aktualizację i dostosowywanie naszych modeli w czasie.

Oczywiście musimy dodać sposób, aby użytkownicy mogli wymieniać miejsca do odwiedzenia dla każdego miejsca docelowego, a najprostszym podejściem jest pokazanie osobnej sekcji w naszym widoku z polem tekstowym na nowe nazwy miejsc.

Po pierwsze, dodaj tę nową właściwość do `EditDestinationView`:

```swift
@State private var newSightName = ""
```

To śledzi to, co użytkownik wpisuje jako nową nazwę miejsca.

Po drugie, dodaj nową metodę, która przekształca newSightName w rzeczywisty obiekt Sight, a następnie dodaje go do naszej istniejącej listy miejsc naszego miejsca docelowego:

```swift
func addSight() {
    guard newSightName.isEmpty == false else { return }

    withAnimation {
        let sight = Sight(name: newSightName)
        destination.sights.append(sight)
        newSightName = ""
    }
}
```

I teraz możemy dodać nową sekcję do formularza, przechodząc przez wszystkie istniejące miejsca i dodając miejsce na nowe miejsca poniżej:

```swift
Section("Sights") {
    ForEach(destination.sights) { sight in
        Text(sight.name)
    }

    HStack {
        TextField("Add a new sight in \(destination.name)", text: $newSightName)

        Button("Add", action: addSight)
    }
}
```

Zauważ, jak możemy uzyskać dostęp do destination.sights bezpośrednio? Relacje są ładowane leniwie przez `SwiftData`, co oznacza, że będzie ładować miejsca dla miejsca docelowego tylko wtedy, gdy są one faktycznie używane. Oznacza to, że `DestinationListingView` ładowane są tylko te dane, które naprawdę są mu potrzebne, co pomaga zapewnić, że nasz kod pozostaje szybki i lekki w użyciu pamięci

.

Teraz, zanim zakończymy tę relację, chcę wprowadzić jedną małą zmianę. Otóż teraz mamy mały problem: jeśli użytkownik zdecyduje, że nie chce odwiedzać dodanego przez siebie miejsca, co powinno się stać z wszystkimi miejscami, które dodał do tego miejsca?

`SwiftData` lubi grać na pewno, więc w tej sytuacji usunięcie miejsca docelowego pozostawi jego miejsca nietknięte, ale tylko ukryte przed widokiem. Czasami to jest dokładnie to, czego chcesz, ale tutaj doprowadzi to do bałaganu, ponieważ nie ma możliwości wyszukiwania miejsc, które nie są przypisane do miejsc docelowych.

W tej sytuacji musimy podać `SwiftData` trochę dodatkowych wskazówek: powiemy mu, że gdy usuwamy miejsce docelowe, powinno także usuwać wszystkie miejsca, które do niego należą.

Aby to zrobić, musimy dołączyć makro @Relationship do właściwości sights, tak jak to:

```swift
@Relationship(deleteRule: .cascade) var sights = [Sight]()
```

Reguła kasowania cascade oznacza "gdy usuwamy ten obiekt, usuń również wszystkie jego miejsca" - dokładnie to, czego chcemy.



Ten wprowadzający projekt został zaprojektowany, aby nauczyć Cię absolutnych podstaw korzystania z SwiftData. Poznałeś modele, kontenery modeli, konteksty modeli, zapytania, deskryptory sortowania, predykaty, relacje i wiele więcej.

Każde z tych zagadnień ma znacznie większą moc niż ta pokazana w małym samouczku, ale mam nadzieję, że docenisz, jak potężne jest SwiftData i jak łatwo zarządzać nawet skomplikowanymi danymi.

Reszta tej książki jest poświęcona prezentowaniu znacznie większej mocy SwiftData, ale pamiętaj, że będzie ona nadal rosnąć i rozwijać się w przyszłości.

Jeśli chcesz zobaczyć moją wersję ukończonego tego projektu, możesz ją znaleźć tutaj na GitHubie: https://github.com/twostraws/iTour.

Wyzwania:
Jednym z najlepszych sposobów nauki jest pisanie własnego kodu tak często, jak to możliwe, więc oto trzy sposoby, w jakie powinieneś przetestować swoją nową wiedzę, aby upewnić się, że w pełni rozumiesz, co się dzieje:

1. Dodaj obsługę przeciągania (swipe) do usuwania miejsc wartych odwiedzenia.
2. Użyj tablicy deskryptorów sortowania do zainicjowania widoku DestinationListingView, gdzie pierwsze sortowanie będzie wyborem użytkownika, a drugie sensowną alternatywą - na przykład datą przyjazdu, a następnie nazwą.
3. Dodaj drugie menu wyboru w pasku narzędzi w widoku ContentView, pozwalające użytkownikowi przełączać się między wyświetlaniem wszystkich miejsc, a tylko tymi, które są przyszłe.





## Wyzwanie 1: Dodaj przeciąganie do usunięcia miejsc

Pierwszym wyzwaniem jest dodanie funkcji przeciągania do usunięcia miejsc, podobnie jak mamy to dla celów podróży. To wyzwanie wydaje się być łatwe, ale w praktyce nie jest – SwiftData ma bardzo precyzyjny pomysł na to, jak powinno to działać, i jeśli tego nie uszanujesz, napotkasz problemy.

*nalezy dodać w `EditDestinationView` do pętli foreach modyfikator on delete i wywołać w nim funkcję usuwającą*

Modyfikator:

```swift
Section("Sights") {
  ForEach(destination.sights) { sight in
                               Text(sight.name)
                              }
  .onDelete(perform: deleteSight)
```

kod funkcji:

```swift
private func deleteSight(indexSet: IndexSet) {
  indexSet.forEach { index in
                    let sight = destination.sights[index]
                    destination.sights.remove(at: index)
                   }
}
```



Spróbujmy teraz, abyś mógł zobaczyć, co mam na myśli.

Otwórz plik EditDestinationView.swift i dodaj tę właściwość do struktury naszego widoku:

```swift
@Environment(\.modelContext) private var modelContext
```

Teraz dodaj podobną metodę do tej, którą użyliśmy do usuwania celów podróży:

```swift
func deleteSights(_ indexSet: IndexSet) {
    for index in indexSet {
        let sight = destination.sights[index]
        modelContext.delete(sight)
    }
}
```

Teraz możemy przypiąć to do pętli `ForEach`, która służy do wyświetlania miejsc, tak jak poniżej:

```swift
ForEach(destination.sights) { sight in
    Text(sight.name)
}
.onDelete(perform: deleteSights)
```

Uruchom teraz projekt i przetestuj to. Powinieneś znaleźć, że możesz swobodnie przeciągać, aby usunąć miejsca, a jeśli zamkniesz aplikację i ponownie ją uruchomisz, miejsca znikną.

Jednakże, jest pewien problem: jeśli usuniesz miejsce, wrócisz do listy celów podróży, a następnie wybierzesz ten sam cel podróży ponownie, aplikacja ulegnie awarii.

Kluczowy jest fakt, że nasze miejsca nie mają dwukierunkowego związku z ich celami podróży. Dlatego jeśli po prostu wywołamy `modelContext.delete(someSight)`, napotkamy problemy – lista miejsc celu podróży nie zostanie zaktualizowana, dopóki aplikacja nie zostanie ponownie uruchomiona, więc SwiftData będzie próbować uzyskać dostęp do pamięci, która została zniszczona.

Aby być całkowicie pewnym, że obiekt zostaje poprawnie zniszczony, ważne jest wywołanie na nim `delete()`, a także usunięcie go z tablicy. Więc kod powinien wyglądać tak:

```swift
func deleteSights(_ indexSet: IndexSet) {
    for index in indexSet {
        let sight = destination.sights[index]
        modelContext.delete(sight)
    }

    destination.sights.remove(atOffsets: indexSet)
}
```

Będziemy się temu przyglądać bardziej szczegółowo w bonusowych wyzwaniach!

## Wyzwanie 2: Użyj tablicy deskryptorów sortowania

Drugim wyzwaniem jest dostosowanie sortowania tak, aby zawsze używało tablicy deskryptorów sortowania: tego, którego użytkownik wybrał, wraz z sensownym drugim domyślnym. Jeśli użytkownik wybierze sortowanie według daty przybycia, dodamy jako drugi deskryptor sortowania nazwę, aby rozstrzygać ewentualne remisy.

To zadanie jest dość łatwe, ponieważ mamy już większość pracy wykonanej. Wymaga pięciu kroków, z których tylko ostatni wymaga pracy, która nie polega tylko na dodawaniu lub usuwaniu nawiasów kwadratowych:

1. Zmodyfikuj inicjalizator DestinationListingView, aby akceptował tablicę deskryptorów sortowania.
2. Przekaż tę tablicę do inicjalizatora Query.
3. Zmień kod podglądu DestinationListingView, aby przekazać tablicę.
4. Zmień właściwość sortOrder w ContentView, aby była to tablica deskryptorów sortowania.
5. Dostosuj każdy z tagów w wyborze ContentView, aby dostarczać wybrane tablice sortowania.

Przejdźmy teraz przez te kroki.

Po pierwsze, zmień inicjalizator, aby akceptował tablicę, umieszczając nawiasy kwadratowe wokół istniejącego parametru SortDescriptor:

```swift
init(sort: [SortDescriptor<Destination>], searchString: String) {
```

Po drugie, zmień inicjalizator Query, aby przekazać tę tablicę bezpośrednio, usuwając nawiasy kwadratowe wokół sort:

```swift
}, sort: sort)
```

Po trzecie, zmień podgląd, aby przekazać tablicę zawierającą aktualną wartość, ponownie dodając nawiasy kwadratowe wokół aktualnej wartości SortDescriptor:

```swift
DestinationListingView(sort: [SortDescriptor(\Destination.name)], searchString: "")
```

Po czwarte, w ContentView, dodaj nawiasy kwadratowe wokół domyślnej wartości właściwości sortOrder, tworząc z niej tablicę:

```swift
@State private var sortOrder = [SortDescriptor(\Destination.name)]
```

Pozostaje tylko ostatnie zadanie, które polega na zdecydowaniu, jakie deskryptory sortowania powinny być przekazywane. To zależy od ciebie, ale dostarczę kilka sugestii:

```swift
Picker("Sortuj", selection: $sortOrder) {
    Text("Nazwa")
        .tag([
            SortDescriptor(\Destination.name),
            SortDescriptor(\Destination.date),
        ])

    Text("Priorytet")
        .tag([
            SortDescriptor(\Destination.priority, order: .reverse),
            SortDescriptor(\Destination.name),
        ])

    Text("Data")
        .tag([
            SortDescriptor(\Destination.date),
            SortDescriptor(\Destination.name),
        ])
}
.pickerStyle(.inline)
```

To jest niewielka zmiana, ale pomaga uczynić naszą aplikację trochę bardziej przewidywalną – gdy ktoś sortuje według priorytetu, prawdopodobnie będzie miał kilka celów podróży w jednej grupie, więc dodatkowy deskryptor sortowania po nazwie pomaga utrzymać porządek.

**Ważne: Teraz, gdy utworzyliśmy tablice dla tych różnych elementów wyboru, powinieneś skopiować tablicę przypisaną do tagu "Nazwa" do domyślnej wartości sortOrder, aby poprawny element był zaznaczony na początku.**
