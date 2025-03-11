/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = app.findCollectionByNameOrId("pbc_31468549712")

  // update collection data
  unmarshal({
    "name": "ingredients_master"
  }, collection)

  return app.save(collection)
}, (app) => {
  const collection = app.findCollectionByNameOrId("pbc_31468549712")

  // update collection data
  unmarshal({
    "name": "ingredients"
  }, collection)

  return app.save(collection)
})
