/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = app.findCollectionByNameOrId("pbc_31468549712")

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
}, (app) => {
  const collection = app.findCollectionByNameOrId("pbc_31468549712")

  // update field
  collection.fields.addAt(4, new Field({
    "cascadeDelete": false,
    "collectionId": "pbc_4283963026",
    "hidden": false,
    "id": "relation105650625",
    "maxSelect": 1,
    "minSelect": 0,
    "name": "ingredients_category_master_id",
    "presentable": false,
    "required": false,
    "system": false,
    "type": "relation"
  }))

  return app.save(collection)
})
