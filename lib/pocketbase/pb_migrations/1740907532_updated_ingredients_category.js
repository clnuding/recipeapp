/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = app.findCollectionByNameOrId("pbc_4283963026")

  // update collection data
  unmarshal({
    "name": "ingredients_categories_master"
  }, collection)

  return app.save(collection)
}, (app) => {
  const collection = app.findCollectionByNameOrId("pbc_4283963026")

  // update collection data
  unmarshal({
    "name": "ingredients_category"
  }, collection)

  return app.save(collection)
})
