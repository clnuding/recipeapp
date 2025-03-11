/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = app.findCollectionByNameOrId("pbc_638208807")

  // update collection data
  unmarshal({
    "name": "measurements_master"
  }, collection)

  return app.save(collection)
}, (app) => {
  const collection = app.findCollectionByNameOrId("pbc_638208807")

  // update collection data
  unmarshal({
    "name": "measurements"
  }, collection)

  return app.save(collection)
})
