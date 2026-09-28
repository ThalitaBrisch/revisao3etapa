import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/usuario.dart';
import '../models/pedido.dart';

class BancoService {
  static final BancoService _instance = BancoService._internal();

  factory BancoService() => _instance;

  BancoService._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final caminho = join(
      await getDatabasesPath(),
      'the_bear.db',
    );

    return await openDatabase(
      caminho,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE usuarios (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT NOT NULL,
            email TEXT NOT NULL UNIQUE,
            senha TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE pedidos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            cliente TEXT NOT NULL,
            prato TEXT NOT NULL,
            quantidade INTEGER NOT NULL,
            valor_unitario REAL NOT NULL,
            total REAL NOT NULL,
            classificacao TEXT NOT NULL,
            status TEXT NOT NULL
          )
        ''');
      },
    );
  }

  // =========================
  // USUÁRIOS
  // =========================

  Future<int> inserirUsuario(Usuario usuario) async {
    final db = await database;

    return await db.insert(
      'usuarios',
      usuario.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<Usuario?> autenticar(
    String email,
    String senha,
  ) async {
    final db = await database;

    final resultado = await db.query(
      'usuarios',
      where: 'email = ? AND senha = ?',
      whereArgs: [email, senha],
      limit: 1,
    );

    if (resultado.isEmpty) {
      return null;
    }

    return Usuario.fromMap(resultado.first);
  }

  // =========================
  // PEDIDOS
  // =========================

  Future<int> inserirPedido(Pedido pedido) async {
    final db = await database;

    return await db.insert(
      'pedidos',
      pedido.toMap(),
    );
  }

  Future<List<Pedido>> listarPedidos() async {
    final db = await database;

    final resultado = await db.query(
      'pedidos',
      orderBy: 'id DESC',
    );

    return resultado
        .map((map) => Pedido.fromMap(map))
        .toList();
  }

  Future<int> finalizarPedido(int id) async {
    final db = await database;

    return await db.update(
      'pedidos',
      {'status': 'Finalizado'},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> excluirPedido(int id) async {
    final db = await database;

    return await db.delete(
      'pedidos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
