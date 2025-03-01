/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = app.findCollectionByNameOrId("pbc_3146854971")

  // update collection data
  unmarshal({
    "name": "user_ingredients"
  }, collection)

  return app.save(collection)
}, (app) => {
  const collection = app.findCollectionByNameOrId("pbc_3146854971")

  // update collection data
  unmarshal({
    "name": "ingredients"
  }, collection)

  return app.save(collection)
})
