/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = app.findCollectionByNameOrId("pbc_31468549712")

  // update field
  collection.fields.addAt(3, new Field({
    "cascadeDelete": false,
    "collectionId": "pbc_638208807",
    "hidden": false,
    "id": "relation4162046887",
    "maxSelect": 1,
    "minSelect": 0,
    "name": "measurement_id",
    "presentable": false,
    "required": false,
    "system": false,
    "type": "relation"
  }))

  // update field
  collection.fields.addAt(4, new Field({
    "cascadeDelete": false,
    "collectionId": "pbc_4283963026",
    "hidden": false,
    "id": "relation105650625",
    "maxSelect": 1,
    "minSelect": 0,
    "name": "ingredient_category_id",
    "presentable": false,
    "required": false,
    "system": false,
    "type": "relation"
  }))

  return app.save(collection)
}, (app) => {
  const collection = app.findCollectionByNameOrId("pbc_31468549712")

  // update field
  collection.fields.addAt(3, new Field({
    "cascadeDelete": false,
    "collectionId": "pbc_638208807",
    "hidden": false,
    "id": "relation4162046887",
    "maxSelect": 1,
    "minSelect": 0,
    "name": "measurement_master_id",
    "presentable": false,
    "required": false,
    "system": false,
    "type": "relation"
  }))

  // update field
  collection.fields.addAt(4, new Field({
    "cascadeDelete": false,
    "collectionId": "pbc_4283963026",
    "hidden": false,
    "id": "relation105650625",
    "maxSelect": 1,
    "minSelect": 0,
    "name": "ingredients_categories_master_id",
    "presentable": false,
    "required": false,
    "system": false,
    "type": "relation"
  }))

  return app.save(collection)
})
