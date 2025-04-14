# tugas2ppb

5025221301 - Muhammad Farras Arif Fadhila

Flutter + ObjectBox CRUD <br>
Proyek ini adalah aplikasi CRUD (Create, Read, Update, Delete) sederhana menggunakan Flutter dan ObjectBox sebagai local database. Aplikasi ini memungkinkan pengguna menambahkan, membaca, memperbarui, dan menghapus data Person yang disimpan secara lokal di perangkat.

## 1. person.dart – Membuat Entity ObjectBox
```
@Entity()
class Person {
  int id;
  final String name;

  Person({this.id = 0, this.name = 'no name'});
}
```
Penjelasan:
- @Entity() menandakan bahwa Person adalah entitas yang akan disimpan ke database ObjectBox.

- id berfungsi sebagai primary key. Nilai default 0 artinya ObjectBox akan otomatis mengisi dengan ID yang tersedia.

- name adalah field utama yang akan kita gunakan dalam inputan user.

## 2. objectbox.dart – Inisialisasi ObjectBox
```
class ObjectBox {
  final Store store;
  ObjectBox._create(this.store);

  static Future<ObjectBox> create() async {
    var dir = await getApplicationDocumentsDirectory();
    Store store = await openStore(directory: p.join(dir.path, 'objectbox_crud'));
    return ObjectBox._create(store);
  }
}
```
Penjelasan:
- Store adalah representasi database lokal.

- Kita simpan datanya di direktori aplikasi menggunakan getApplicationDocumentsDirectory().

- File database akan otomatis disimpan di folder 'objectbox_crud'.

## 3a. main.dart 
```
late Store store;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();  
  store = (await ObjectBox.create()).store;    
  runApp(const MainApp());
}
```
Penjelasan:
- WidgetsFlutterBinding.ensureInitialized() wajib dipanggil sebelum kode async di main().

- store menyimpan koneksi ke database ObjectBox, di-load secara asynchronous saat aplikasi dimulai.

### 3b.  Class MainApp 
#### -> Menyimpan dan Mengambil Data
```
personBox = store.box<Person>();
people = personBox.getAll();
```
Penjelasan:
- box<Person>() digunakan untuk mengakses tabel Person.

- getAll() mengambil seluruh data dan ditampilkan menggunakan ListView.builder.

#### ->  Fungsi Create
```
personBox.put(Person(name: inputController.text));
```
Penjelasan:
- put() digunakan untuk menyimpan data ke database.

- Jika ID tidak diberikan, ObjectBox akan otomatis menambahkan ID baru.

#### -> Fungsi Read
```
void _refreshData() {
  setState(() {
    people = personBox.getAll();
  });
} 
```
Penjelasan:
- Memperbarui tampilan berdasarkan data terkini dari database.

#### -> Fungsi Delete 
```
int id = int.tryParse(inputController.text) ?? 0;
personBox.remove(id);
```
Penjelasan: 
- Menghapus data berdasarkan ID yang diketik user.

#### -> Fungsi Delete All
```
Future<void> deleteAll() async {
  personBox.removeAll(); // Hapus data dari box
  store.close(); // Tutup store

  final dir = Directory('${Directory.current.path}/objectbox');
  if (await dir.exists()) {
    await dir.delete(recursive: true); // Hapus file database
  }

  store = (await ObjectBox.create()).store; // Buat store ulang
  personBox = store.box<Person>(); // Koneksi ulang box
  _refreshData(); // Refresh tampilan
}
```
Penjelasan:
- Digunakan untuk menghapus semua data dan reset autoincrement ID seperti baru.

- Mirip seperti migrate:fresh di Laravel.

#### -> State Internal (_MainAppState)
```
final TextEditingController inputController = TextEditingController();
late Box<Person> personBox;
List<Person> people = [];
```
Penjelasan:
- inputController → menangani input teks dari pengguna.

- personBox → kotak/tabel untuk menyimpan entitas Person.

- people → list yang ditampilkan di UI.

#### -> Menampilkan daftar data 
```
ListView.builder(
  shrinkWrap: true,
  itemCount: people.length,
  itemBuilder: (context, index) {
    final person = people[index];
    return ListTile(
      title: Text('${person.id} - ${person.name}'),
    );
  },
) 
```
Penjelasan: 
- Menggunakan ListTile untuk tampilan baris per baris.

## 🔄 Siklus Aplikasi CRUD
- User masukkan nama → klik Create

- Data disimpan ke ObjectBox → ditampilkan langsung ke UI

- User ingin ubah → masukkan format id-nama → klik Update

- Hapus data tertentu → ketik id → klik Delete

- Hapus semua dan reset → klik 🗑️ Delete All

## SIMULASI APLIKASI

### Create 
<img width="249" alt="image" src="https://github.com/user-attachments/assets/76f1bf67-8ddb-4539-95fc-4849d86f8886" />

## Update
<img width="245" alt="image" src="https://github.com/user-attachments/assets/1800b504-7940-42f0-b09f-708c719efade" />

## Delete 
<img width="248" alt="image" src="https://github.com/user-attachments/assets/b743233b-20f1-4a44-a90c-517375558bc0" /><br>
- List ke 1 berhasil terhapus

## Delete All
<img width="246" alt="image" src="https://github.com/user-attachments/assets/36bb2c8f-99a5-41b6-a70b-0cc09c3f4417" /><br>
- Semua data berhasil dihapus dan apabila dibuat data baru akan mengulangi id dari 1 <br>

<img width="242" alt="image" src="https://github.com/user-attachments/assets/13810ced-477b-462a-b81f-cf85adf167c4" />






