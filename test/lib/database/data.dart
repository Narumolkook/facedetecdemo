import 'package:postgres/postgres.dart';

void main(List<String> argument) async {
  var connection = PostgreSQLConnection(
    'localhost',
    5433,
    "database_01",
    username: "postgres",
    password: "097096"
    );
  await connection.open();

  print('Connected to Postgres database...');

  await connection.close();
}
