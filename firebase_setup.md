# 🔥 Configuração do Firebase para Potea Edu

Este guia explica como configurar o Firebase para o aplicativo Potea Edu.

## 📋 Pré-requisitos

- Conta Google
- Projeto Flutter configurado
- Android Studio ou VS Code

## 🚀 Passo a Passo

### 1. Criar Projeto no Firebase Console

1. Acesse [Firebase Console](https://console.firebase.google.com/)
2. Clique em "Criar projeto"
3. Digite o nome: `potea-edu`
4. Ative o Google Analytics (opcional)
5. Clique em "Criar projeto"

### 2. Configurar Authentication

1. No menu lateral, clique em "Authentication"
2. Clique em "Começar"
3. Configure os provedores:
   - **Email/Senha**: Ativar
   - **Google**: Ativar (opcional)
   - **Apple**: Ativar (opcional)

### 3. Configurar Firestore Database

1. No menu lateral, clique em "Firestore Database"
2. Clique em "Criar banco de dados"
3. Escolha "Modo de teste" para desenvolvimento
4. Selecione a localização mais próxima
5. Clique em "Ativar"

### 4. Configurar Storage

1. No menu lateral, clique em "Storage"
2. Clique em "Começar"
3. Escolha "Modo de teste" para desenvolvimento
4. Selecione a localização mais próxima
5. Clique em "Concluir"

### 5. Configurar Cloud Messaging

1. No menu lateral, clique em "Cloud Messaging"
2. Clique em "Ativar"
3. Configure as notificações push

### 6. Adicionar Aplicativo Android

1. Clique no ícone Android
2. Digite o package name: `com.potea.edu`
3. Digite o apelido: `Potea Edu Android`
4. Clique em "Registrar app"
5. Baixe o arquivo `google-services.json`
6. Coloque em `android/app/`

### 7. Adicionar Aplicativo iOS

1. Clique no ícone iOS
2. Digite o bundle ID: `com.potea.edu`
3. Digite o apelido: `Potea Edu iOS`
4. Clique em "Registrar app"
5. Baixe o arquivo `GoogleService-Info.plist`
6. Coloque em `ios/Runner/`

## 📁 Estrutura de Dados Firestore

### Coleção: `users`

```json
{
  "id": "string",
  "name": "string",
  "email": "string",
  "userType": "student|teacher|admin",
  "photoUrl": "string?",
  "phoneNumber": "string?",
  "dateOfBirth": "timestamp?",
  "gender": "string?",
  "classId": "string?",
  "subjects": ["string"],
  "createdAt": "timestamp",
  "updatedAt": "timestamp",
  "isActive": "boolean"
}
```

### Coleção: `classes`

```json
{
  "id": "string",
  "name": "string",
  "description": "string",
  "teacherId": "string",
  "studentIds": ["string"],
  "subjectIds": ["string"],
  "maxStudents": "number",
  "academicYear": "string",
  "semester": "string",
  "startDate": "timestamp",
  "endDate": "timestamp",
  "createdAt": "timestamp",
  "updatedAt": "timestamp",
  "isActive": "boolean"
}
```

### Coleção: `subjects`

```json
{
  "id": "string",
  "name": "string",
  "description": "string",
  "classId": "string",
  "teacherId": "string",
  "credits": "number",
  "code": "string",
  "topics": ["string"],
  "createdAt": "timestamp",
  "updatedAt": "timestamp",
  "isActive": "boolean"
}
```

### Coleção: `activities`

```json
{
  "id": "string",
  "title": "string",
  "description": "string",
  "type": "assignment|exam|project|presentation|quiz|homework|lab|other",
  "subjectId": "string",
  "classId": "string",
  "createdBy": "string",
  "dueDate": "timestamp",
  "createdAt": "timestamp",
  "updatedAt": "timestamp",
  "attachments": ["string"],
  "assignedStudentIds": ["string"],
  "status": "pending|inProgress|submitted|graded|completed|cancelled",
  "maxScore": "number",
  "instructions": "string",
  "isGroupActivity": "boolean"
}
```

### Coleção: `grades`

```json
{
  "id": "string",
  "studentId": "string",
  "subjectId": "string",
  "activityId": "string",
  "classId": "string",
  "score": "number",
  "maxScore": "number",
  "comments": "string?",
  "gradedBy": "string",
  "gradedAt": "timestamp",
  "createdAt": "timestamp",
  "updatedAt": "timestamp",
  "status": "pending|graded|reviewed|disputed"
}
```

### Coleção: `messages`

```json
{
  "id": "string",
  "senderId": "string",
  "receiverId": "string",
  "content": "string",
  "type": "text|image|document|audio|video|location|contact|system",
  "timestamp": "timestamp",
  "isRead": "boolean",
  "attachmentUrl": "string?",
  "attachmentName": "string?",
  "status": "sending|sent|delivered|read|failed",
  "replyToId": "string?"
}
```

### Coleção: `notifications`

```json
{
  "id": "string",
  "title": "string",
  "message": "string",
  "type": "general|activity|grade|announcement|reminder|event|message|system",
  "senderId": "string",
  "recipientIds": ["string"],
  "targetId": "string?",
  "createdAt": "timestamp",
  "readAt": "timestamp?",
  "isRead": "boolean",
  "priority": "low|normal|high|urgent",
  "data": "map?",
  "imageUrl": "string?",
  "actionUrl": "string?"
}
```

### Coleção: `events`

```json
{
  "id": "string",
  "title": "string",
  "description": "string",
  "startDate": "timestamp",
  "endDate": "timestamp",
  "createdBy": "string",
  "attendees": ["string"],
  "location": "string?",
  "type": "general|exam|assignment|meeting|holiday|activity|presentation|other",
  "isAllDay": "boolean",
  "color": "string?",
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

## 🔐 Regras de Segurança Firestore

### Regras para `users`

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read: if request.auth != null && (request.auth.uid == userId || resource.data.userType == 'admin');
      allow write: if request.auth != null && request.auth.uid == userId;
      allow create: if request.auth != null;
    }
  }
}
```

### Regras para `classes`

```javascript
match /classes/{classId} {
  allow read: if request.auth != null && (
    resource.data.teacherId == request.auth.uid ||
    request.auth.uid in resource.data.studentIds ||
    get(/databases/$(database)/documents/users/$(request.auth.uid)).data.userType == 'admin'
  );
  allow write: if request.auth != null && (
    resource.data.teacherId == request.auth.uid ||
    get(/databases/$(database)/documents/users/$(request.auth.uid)).data.userType == 'admin'
  );
}
```

## 📱 Configuração no Código

### 1. Inicializar Firebase

```dart
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
```

### 2. Configurar Authentication

```dart
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential?> signInWithEmailAndPassword(
    String email,
    String password
  ) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password
      );
    } catch (e) {
      print('Erro no login: $e');
      return null;
    }
  }
}
```

### 3. Configurar Firestore

```dart
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createUser(UserModel user) async {
    await _db.collection('users').doc(user.id).set(user.toMap());
  }

  Stream<List<UserModel>> getUsers() {
    return _db.collection('users')
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UserModel.fromMap(doc.data()))
            .toList());
  }
}
```

## 🚨 Problemas Comuns

### 1. Erro de SHA-1

- Adicione o SHA-1 do seu projeto no Firebase Console
- Use `keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android`

### 2. Erro de Package Name

- Verifique se o package name no `android/app/build.gradle` está correto
- Deve ser igual ao configurado no Firebase

### 3. Erro de Dependências

- Execute `flutter clean` e `flutter pub get`
- Verifique se as versões das dependências Firebase são compatíveis

## 📚 Recursos Adicionais

- [Documentação Firebase Flutter](https://firebase.flutter.dev/)
- [Firebase Console](https://console.firebase.google.com/)
- [Firebase Pricing](https://firebase.google.com/pricing)
- [Firebase Support](https://firebase.google.com/support)

## 🔒 Segurança

- Nunca exponha suas chaves de API
- Use regras de segurança adequadas
- Monitore o uso da API
- Configure alertas de custo
- Faça backup regular dos dados

---

**⚠️ Importante**: Este é um guia de desenvolvimento. Para produção, configure regras de segurança mais restritivas e monitore o uso dos recursos.

