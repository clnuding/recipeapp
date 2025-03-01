import 'package:pocketbase/pocketbase.dart';

final pb = PocketBase('http://127.0.0.1:8090');

// Entry point for the script.
Future<void> main() async {
  // Authenticate as admin using the _superusers collection.
  // Replace these credentials with your actual admin email and password.
  try {
    final adminAuthResponse = await pb.collection("_superusers")
        .authWithPassword('cl.nuding@icloud.com', 'passwort12345');
    print("Authenticated as admin: ${adminAuthResponse.token}");
  } catch (e) {
    print("Admin authentication failed: $e");
    return;
  }

  // Define the "recipes" collection.
  final Map<String, dynamic> collectionData = {
    "name": "recipes", // use lowercase names
    "type": "base", // base collection type
    "fields": [
      {
        "name": "UserID",
        "type": "relation",
        "required": false,
        "unique": false,
        "options": {
          "collectionId": "_pb_users_auth_", // built-in users collection
          "cascadeDelete": false,
          "maxSelect": 1
        }
      },
      {
        "name": "name",
        "type": "text",
        "required": true,
        "unique": false,
        "options": {
          "min": 1,
          "max": 100,
          "pattern": ""
        }
      },
      {
        "name": "description",
        "type": "text",
        "required": false,
        "unique": false,
        "options": {
          "min": 0,
          "max": 500,
          "pattern": ""
        }
      },
      {
        "name": "portions",
        "type": "number",
        "required": false,
        "unique": false,
        "options": {
          "min": 1,
          "max": null
        }
      }
    ],
    "listRule": "",
    "viewRule": "",
    "createRule": "",
    "updateRule": "",
    "deleteRule": ""
  };

  // Create the collection using the PocketBase API.
  try {
    final createdCollection = await pb.collections.create(body: collectionData);
    print("Recipes collection created successfully: $createdCollection");
  } catch (e) {
    print("Error creating recipes collection: $e");
  }
}
