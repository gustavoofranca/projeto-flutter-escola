import 'dart:convert';
import 'package:http/http.dart' as http;

/// Serviço para consumo da API JSONPlaceholder
class ApiService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';
  
  static const Duration _timeout = Duration(seconds: 10);

  /// Busca lista de posts
  static Future<List<Post>> getPosts() async {
    try {
      final response = await http
          .get(
            Uri.parse('$_baseUrl/posts'),
            headers: {
              'Content-Type': 'application/json',
            },
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Post.fromJson(json)).toList();
      } else {
        throw ApiException(
          'Erro ao buscar posts: ${response.statusCode}',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Erro de conexão: $e', 0);
    }
  }

  /// Busca um post específico por ID
  static Future<Post> getPost(int id) async {
    try {
      final response = await http
          .get(
            Uri.parse('$_baseUrl/posts/$id'),
            headers: {
              'Content-Type': 'application/json',
            },
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return Post.fromJson(jsonData);
      } else {
        throw ApiException(
          'Erro ao buscar post: ${response.statusCode}',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Erro de conexão: $e', 0);
    }
  }

  /// Busca lista de usuários
  static Future<List<User>> getUsers() async {
    try {
      final response = await http
          .get(
            Uri.parse('$_baseUrl/users'),
            headers: {
              'Content-Type': 'application/json',
            },
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => User.fromJson(json)).toList();
      } else {
        throw ApiException(
          'Erro ao buscar usuários: ${response.statusCode}',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Erro de conexão: $e', 0);
    }
  }

  /// Busca comentários de um post
  static Future<List<Comment>> getPostComments(int postId) async {
    try {
      final response = await http
          .get(
            Uri.parse('$_baseUrl/posts/$postId/comments'),
            headers: {
              'Content-Type': 'application/json',
            },
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Comment.fromJson(json)).toList();
      } else {
        throw ApiException(
          'Erro ao buscar comentários: ${response.statusCode}',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Erro de conexão: $e', 0);
    }
  }

  /// Cria um novo post
  static Future<Post> createPost(CreatePostRequest request) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/posts'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: json.encode(request.toJson()),
          )
          .timeout(_timeout);

      if (response.statusCode == 201) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return Post.fromJson(jsonData);
      } else {
        throw ApiException(
          'Erro ao criar post: ${response.statusCode}',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Erro de conexão: $e', 0);
    }
  }
}

/// Modelo de Post
class Post {
  final int id;
  final int userId;
  final String title;
  final String body;

  Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      title: json['title'] ?? '',
      body: json['body'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'body': body,
    };
  }
}

/// Modelo de User
class User {
  final int id;
  final String name;
  final String username;
  final String email;
  final String phone;
  final String website;
  final Address address;
  final Company company;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    required this.website,
    required this.address,
    required this.company,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      website: json['website'] ?? '',
      address: Address.fromJson(json['address'] ?? {}),
      company: Company.fromJson(json['company'] ?? {}),
    );
  }
}

/// Modelo de Address
class Address {
  final String street;
  final String suite;
  final String city;
  final String zipcode;

  Address({
    required this.street,
    required this.suite,
    required this.city,
    required this.zipcode,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'] ?? '',
      suite: json['suite'] ?? '',
      city: json['city'] ?? '',
      zipcode: json['zipcode'] ?? '',
    );
  }
}

/// Modelo de Company
class Company {
  final String name;
  final String catchPhrase;
  final String bs;

  Company({
    required this.name,
    required this.catchPhrase,
    required this.bs,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      name: json['name'] ?? '',
      catchPhrase: json['catchPhrase'] ?? '',
      bs: json['bs'] ?? '',
    );
  }
}

/// Modelo de Comment
class Comment {
  final int id;
  final int postId;
  final String name;
  final String email;
  final String body;

  Comment({
    required this.id,
    required this.postId,
    required this.name,
    required this.email,
    required this.body,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] ?? 0,
      postId: json['postId'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      body: json['body'] ?? '',
    );
  }
}

/// Request para criar post
class CreatePostRequest {
  final String title;
  final String body;
  final int userId;

  CreatePostRequest({
    required this.title,
    required this.body,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'userId': userId,
    };
  }
}

/// Exceção personalizada para erros de API
class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException(this.message, this.statusCode);

  @override
  String toString() {
    return 'ApiException: $message (Status: $statusCode)';
  }
}